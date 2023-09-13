//
//  PropertyDetailViewController.swift
//  ShareHouseApp
//
//  Created by Ngos on 2023/09/11.
//

import UIKit
import FirebaseDatabase  // Firebase Realtime Databaseを使用するためのインポート
import FirebaseStorage  // Firebase Storageを使用するためのインポート


class PropertyDetailViewController: UITableViewController {
    
    // 物件の画像名を保持するプロパティ
    var selectedPropertyImageName: String?
    
    // 物件の詳細情報を保持するデータモデル
    var propertyDetails: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 以下の2行を追加
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100  // これは適切な推定値に変更できます
        
        // タイトルを設定
        self.title = "拠点詳細"
        
        // テーブルビューにセルのクラスを登録
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "detailCell")
        
        // Firebase Realtime Databaseから物件の詳細情報と画像ファイル名を取得
        fetchPropertyDetailsFromFirebase()
        
        // 選択された物件の画像をテーブルヘッダーとして設定
        if let imageName = selectedPropertyImageName {
            let storageRef = Storage.storage().reference(withPath: "House/\(imageName).jpg")
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error getting download URL: \(error)")
                    return
                }
                if let url = url {
                    let headerImageView = UIImageView()
                    headerImageView.sd_setImage(with: url as URL) // URL型として明示的にキャスト
                    headerImageView.contentMode = .scaleAspectFill
                    headerImageView.clipsToBounds = true
                    headerImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
                    self.tableView.tableHeaderView = headerImageView
                }
            }
        }
        
        
        // ナビゲーションバーの右上に予約ボタンを追加
        let reserveButton = UIBarButtonItem(title: "予約", style: .plain, target: self, action: #selector(reserveButtonTapped))
        navigationItem.rightBarButtonItem = reserveButton
        
        // Firebase Realtime Databaseから物件の詳細情報を取得
        fetchPropertyDetailsFromFirebase()
    }
    
    // Firebase Realtime Databaseから物件の詳細情報を取得するメソッド
    private func fetchPropertyDetailsFromFirebase() {
        guard let imageName = selectedPropertyImageName else { return }
        let propertyId = imageName.replacingOccurrences(of: "House", with: "property").replacingOccurrences(of: ".jpg", with: "")
        let ref = Database.database().reference(withPath: "properties/\(propertyId)")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let propertyData = snapshot.value as? [String: Any] {
                self.propertyDetails = [
                    "拠点名: \(propertyData["name"] as? String ?? "不明")",
                    "住所: \(propertyData["address"] as? String ?? "不明")",
                    "説明: \(propertyData["description"] as? String ?? "不明")",
                    "設備: \(propertyData["facilities"] as? String ?? "不明")"
                ]
                
                // Firebase Storageから画像を取得
                if let imageNameFromDB = propertyData["image"] as? String {
                    let storageRef = Storage.storage().reference(withPath: "House/\(imageNameFromDB)")
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            print("Error getting download URL: \(error)")
                            return
                        }
                        if let url = url {
                            let headerImageView = UIImageView()
                            headerImageView.sd_setImage(with: url as URL) // URL型として明示的にキャスト
                            headerImageView.contentMode = .scaleAspectFill
                            headerImageView.clipsToBounds = true
                            headerImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
                            self.tableView.tableHeaderView = headerImageView
                        }
                    }
                }
                
                self.tableView.reloadData()  // テーブルビューを更新
            }
        }
    }
    
    // 予約ボタンがタップされたときのアクション
    @objc func reserveButtonTapped() {
        // 予約画面への遷移のコードをここに書く
        let reservationViewController = ReservationViewController() // 予約画面のViewControllerを仮定
        navigationController?.pushViewController(reservationViewController, animated: true)
    }
    
    // MARK: - UITableView DataSource & Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return propertyDetails.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        
        // 以下の行を追加
        cell.textLabel?.numberOfLines = 0
        
        cell.textLabel?.text = propertyDetails[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 住所のセルがタップされた場合
        if indexPath.row == 1, let address = propertyDetails[indexPath.row].split(separator: ":").last?.trimmingCharacters(in: .whitespaces) {
            openGoogleMaps(with: address)
        }
        tableView.deselectRow(at: indexPath, animated: true)  // セルの選択を解除
    }

    func openGoogleMaps(with address: String) {
        if let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: "comgooglemaps://?q=\(encodedAddress)") {
                // Google Mapsアプリがインストールされている場合
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Google Mapsアプリがインストールされていない場合、WebブラウザでGoogle Mapsを開く
                    if let webURL = URL(string: "https://www.google.com/maps/search/?api=1&query=\(encodedAddress)") {
                        UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }

}
