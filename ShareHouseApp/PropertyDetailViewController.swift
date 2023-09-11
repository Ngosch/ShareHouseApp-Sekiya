//
//  PropertyDetailViewController.swift
//  ShareHouseApp
//
//  Created by Ngos on 2023/09/11.
//

import UIKit

// 物件の詳細情報を表示するViewController
class PropertyDetailViewController: UITableViewController {
    
    // 物件の画像名を保持するプロパティ
    var selectedPropertyImageName: String?
    
    // 物件の詳細情報を保持する仮のデータモデル
    // これは後で実際のデータモデルに置き換えられます
    var propertyDetails: [String] = [
        "物件名: サンプル物件",
        "住所: 東京都中央区サンプル1-2-3",
        "価格: ¥100,000",
        "設備: Wi-Fi, 駐車場",
        "レビュー: ★★★★☆"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // タイトルを設定
        self.title = "物件詳細"
        
        // テーブルビューにセルのクラスを登録
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "detailCell")
        
        // 選択された物件の画像をテーブルヘッダーとして設定
        if let imageName = selectedPropertyImageName {
            let headerImageView = UIImageView(image: UIImage(named: imageName))
            headerImageView.contentMode = .scaleAspectFill
            headerImageView.clipsToBounds = true
            headerImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
            tableView.tableHeaderView = headerImageView
        }
        
        // ナビゲーションバーの右上に予約ボタンを追加
        let reserveButton = UIBarButtonItem(title: "予約", style: .plain, target: self, action: #selector(reserveButtonTapped))
        navigationItem.rightBarButtonItem = reserveButton
    
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
