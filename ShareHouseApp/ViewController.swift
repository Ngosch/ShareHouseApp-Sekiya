//
//  ViewController.swift
//  ShareHouseApp
//
//  Created by Ngos on 2023/09/11.
//

import UIKit
import FirebaseStorage
import SDWebImage
import FirebaseDatabase  // Firebase Realtime Databaseを使用するためのインポート
import Hero  // Heroをインポート

// 主要なホーム画面のViewController
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Interface Builderと連携するための検索バーのIBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Interface Builderと連携するためのテーブルビューのIBOutlet
    @IBOutlet weak var propertyTableView: UITableView!
    
    // Firebase Storageから取得した物件画像の数を保持するプロパティ
    var numberOfProperties: Int = 0
    
    // Firebase Realtime Databaseから取得した物件の情報を格納するプロパティ
    var properties: [[String: Any]] = []
    
    // ビューがメモリにロードされた後に呼ばれるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Heroアニメーションを有効にする
        self.hero.isEnabled = true
        self.navigationController?.hero.isEnabled = true  // この行を追加
        
        // 背景色を白に設定
        view.backgroundColor = .white
        
        // テーブルビューのデリゲートとデータソースをこのViewControllerに設定
        propertyTableView.delegate = self
        propertyTableView.dataSource = self
        
        // Auto Layoutの制約を設定
        setupLayout()
        
        // テーブルビューにカスタムセルのクラスを登録
        propertyTableView.register(PropertyTableViewCell.self, forCellReuseIdentifier: "PropertyCell")
        
        // Firebase Storageから物件画像の数を取得
        fetchNumberOfProperties()
        
        // Firebase Realtime Databaseから物件の情報を取得
        fetchPropertiesFromFirebase()
        
    }
    
    // Firebase Storageから物件画像の数を取得するメソッド
    private func fetchNumberOfProperties() {
        let storageRef = Storage.storage().reference(withPath: "House")
        storageRef.listAll { (result, error) in
            if let error = error {
                print("Error fetching number of properties: \(error)")
                return
            }
            if let result = result {
                self.numberOfProperties = result.items.count
                self.propertyTableView.reloadData() // テーブルビューを更新
            }
        }
    }
    
    // Firebase Realtime Databaseから物件の情報を取得するメソッド
    private func fetchPropertiesFromFirebase() {
        let ref = Database.database().reference().child("properties")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let propertiesData = snapshot.value as? [String: [String: Any]] {
                // キーの順番にソート
                let sortedProperties = propertiesData.sorted(by: { $0.key < $1.key })
                self.properties = sortedProperties.map { $0.value }
                
                self.numberOfProperties = self.properties.count
                self.propertyTableView.reloadData()  // テーブルビューを更新
            }
        }
    }
    
    
    // Auto Layoutの制約を設定するメソッド
    private func setupLayout() {
        // Interface BuilderでAuto Layoutの制約を設定する場合、このメソッドは不要です
        // 現在、このメソッドは空ですが、プログラムでレイアウトを設定する場合はここにコードを追加します
    }
    
    // MARK: - UITableView DataSource & Delegate
    
    // セクション内の行数を返すデータソースメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.count
    }
    
    // 各行のセルを返すデータソースメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("セルを設定: \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyCell", for: indexPath) as! PropertyTableViewCell
        
        // セルに物件名を設定
        if let propertyName = properties[indexPath.row]["name"] as? String {
            cell.propertyNameLabel.text = propertyName
        } else {
            cell.propertyNameLabel.text = "物件 \(indexPath.row + 1)"
        }
        
        // セルに物件の住所を設定
        if let propertyAddress = properties[indexPath.row]["address"] as? String {
            cell.propertyAddressLabel.text = propertyAddress
        } else {
            cell.propertyAddressLabel.text = "住所不明"
        }
        
        // Firebase Storageから画像をダウンロード
        if let imageName = properties[indexPath.row]["image"] as? String {
            let storageRef = Storage.storage().reference(withPath: "House/\(imageName)")
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error getting download URL: \(error)")
                    return
                }
                if let url = url {
                    cell.propertyImageView.sd_setImage(with: url) // SDWebImageを使用して画像を非同期にダウンロード
                }
            }
        }
        
        // タップジェスチャーの追加
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        cell.propertyImageView.addGestureRecognizer(tapGesture)
        cell.propertyImageView.isUserInteractionEnabled = true
        
        // 3. 新しいUILabelにテキストを設定
        // この例ではすべてのセルに"1000円/泊"と表示しますが、必要に応じて変更できます。
        cell.pricePerNightLabel.text = "1000円/泊"
        
        return cell
    }
    
    // 画像がタップされたときに呼ばれるメソッド
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        print("画像がタップされました")
        let detailViewController = PropertyDetailViewController()
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // 検索ボタンが押されたときのアクション
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        print("検索ボタンが押されました")
        // 検索処理をここに書く
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250 // 画像の高さ250 + ラベルの高さ30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("セルがタップされました: \(indexPath.row)")
        let detailViewController = PropertyDetailViewController()
        
        
        // 選択された物件の画像名をPropertyDetailViewControllerに渡す
        detailViewController.selectedPropertyImageName = "House\(indexPath.row + 1)"
        
        
        navigationController?.pushViewController(detailViewController, animated: true)
        
        // セルの選択状態を解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

// カスタムテーブルビューセル
class PropertyTableViewCell: UITableViewCell {
    
    // 新しいUIViewを追加
    let backgroundBlackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)  // 半透明の黒背景
        return view
    }()
    
    // 1. 新しいUILabelを追加
    let pricePerNightLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear  // 背景を透明に設定
        label.textColor = .white  // テキスト色を白に設定
        label.textAlignment = .right  // テキストを右寄せに設定
        label.text = "1000円/泊"
        return label
    }()
    
    // 物件の住所を表示するUILabel
    let propertyAddressLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear  // 背景を透明に設定
        label.textColor = .white  // テキスト色を白に設定
        label.textAlignment = .left  // テキストを左寄せに設定
        label.font = UIFont.systemFont(ofSize: 12)  // フォントサイズを14に設定
        return label
    }()
    
    // 物件の画像を表示するUIImageView
    let propertyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // 物件名を表示するUILabel
    let propertyNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear  // 背景を透明に設定
        label.textColor = .white  // テキスト色を白に設定
        label.textAlignment = .right  // テキストを右寄せに設定
        return label
    }()
    
    
    // カスタムセルの初期化
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // UIImageViewとUILabelをセルに追加
        addSubview(propertyImageView)
        
        // 新しいUIViewの制約を設定
        addSubview(backgroundBlackView)
        
        addSubview(propertyNameLabel) // この行をbackgroundBlackViewの後に移動
        addSubview(propertyAddressLabel)
        
        // Auto Layoutの制約を設定
        setupLayout()
        
        // セルの選択を無効にする
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Auto Layoutの制約を設定するメソッド
    private func setupLayout() {
        propertyImageView.translatesAutoresizingMaskIntoConstraints = false
        propertyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 新しいUIViewの制約を設定
        backgroundBlackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundBlackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundBlackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundBlackView.bottomAnchor.constraint(equalTo: propertyImageView.bottomAnchor),
            backgroundBlackView.heightAnchor.constraint(equalToConstant: 60)  // 物件名と物件住所のラベルの合計高さ
        ])
        
        addSubview(propertyAddressLabel)  // 住所ラベルをセルに追加
        
        propertyAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            propertyAddressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            propertyAddressLabel.bottomAnchor.constraint(equalTo: propertyImageView.bottomAnchor),
            propertyAddressLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            propertyImageView.topAnchor.constraint(equalTo: topAnchor),
            propertyImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            propertyImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            propertyImageView.heightAnchor.constraint(equalToConstant: 250), // 画像の高さを250に設定
            
            propertyNameLabel.leadingAnchor.constraint(equalTo: propertyAddressLabel.trailingAnchor, constant: 10),
            propertyNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            propertyNameLabel.bottomAnchor.constraint(equalTo: propertyImageView.bottomAnchor, constant: 0), // ラベルを画像の下部から10の距離で配置
            propertyNameLabel.heightAnchor.constraint(equalToConstant: 30)  // ラベルの高さを30に設定
        ])
        
        // UIImageViewとUILabelをセルに追加
        addSubview(pricePerNightLabel)
        
        pricePerNightLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pricePerNightLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            pricePerNightLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            pricePerNightLabel.bottomAnchor.constraint(equalTo: propertyNameLabel.topAnchor, constant: 5), // propertyNameLabelの上に5の距離で配置
            pricePerNightLabel.heightAnchor.constraint(equalToConstant: 30)  // ラベルの高さを30に設定
        ])
        propertyNameLabel.backgroundColor = .clear  // 背景を透明に設定
        propertyAddressLabel.backgroundColor = .clear  // 背景を透明に設定
    }
}
