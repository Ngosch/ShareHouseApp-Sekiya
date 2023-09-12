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
        
        // タイトルを設定
        self.title = "拠点詳細"
        
        // テーブルビューにセルのクラスを登録
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "detailCell")
        
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
            if let propertyData = snapshot.value as? [String: String] {
                self.propertyDetails = [
                    "拠点名: \(propertyData["name"] ?? "不明")",
                    "住所: \(propertyData["address"] ?? "不明")",
                    "説明: \(propertyData["description"] ?? "不明")",
                    "設備: \(propertyData["facilities"] ?? "不明")"
                ]
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
        cell.textLabel?.text = propertyDetails[indexPath.row]
        return cell
    }
}
