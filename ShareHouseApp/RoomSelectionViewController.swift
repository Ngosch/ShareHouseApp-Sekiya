//
//  RoomSelectionViewController.swift
//  ShareHouseApp
//
//  Created by Ngos on 2023/09/11.
//

import UIKit
import Firebase
import FirebaseStorage


class RoomSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var selectedPropertyName: String?
    
    // 1. roomImages変数の型を変更
    var roomImages: [String: [String]] = [:]
    let baseRoomNumbers = ["101", "102", "103", "104"] // 基本の部屋番号
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectedPropertyNameLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.text = "選択中の拠点: 未選択"
            return label
        }()
        
        title = "部屋選択"
        view.backgroundColor = .white
        
        // Firebaseから部屋の画像のファイル名を取得
        fetchRoomImagesForSelectedProperty()  // この行を修正
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RoomCell.self, forCellWithReuseIdentifier: "RoomCell")
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        if let name = selectedPropertyName {
            selectedPropertyNameLabel.text = "選択中の拠点: \(name)"
        }
        
        view.addSubview(selectedPropertyNameLabel)
        
        // ラベルの制約を設定
        NSLayoutConstraint.activate([
            selectedPropertyNameLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -30),
            selectedPropertyNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            selectedPropertyNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func fetchRoomImagesForSelectedProperty() {
        guard let propertyName = selectedPropertyName else {
            print("No property name selected.")
            return
        }
        
        let ref = Database.database().reference().child("properties")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let properties = snapshot.value as? [String: Any] else { return }
            
            for (propertyKey, propertyData) in properties {
                if let propertyData = propertyData as? [String: Any],
                   let name = propertyData["name"] as? String,
                   name == propertyName,
                   let roomImagesData = propertyData["roomImages"] as? [String] {
                    // 特定の物件の部屋画像のリストをroomImages変数に保存
                    self.roomImages[propertyKey] = roomImagesData
                    
                    // どの物件のデータベースから情報を取得しているかをログに出力
                    print("Fetching data from property: \(propertyName)")
                }
            }
            self.collectionView.reloadData()
        })
    }
    
    
    
    // 追加: セクションの数を物件の数として返す
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return roomImages.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 合計で4部屋のみを表示
        return min(baseRoomNumbers.count, roomImages.values.flatMap { $0 }.count)
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomCell", for: indexPath) as! RoomCell
        
        // 部屋番号を動的に生成
        let roomNumber = baseRoomNumbers[indexPath.item]
        cell.roomNumberLabel.text = "部屋番号: \(roomNumber)"
        
        // 正しい物件の部屋画像を表示
        let allImages = roomImages.values.flatMap { $0 }
        if indexPath.item < allImages.count {
            let imageName = allImages[indexPath.item]
            downloadImageFromFirebase(imageName: imageName, completion: { (image) in
                cell.roomImageView.image = image
            })
        }
        
        cell.paymentButton.addTarget(self, action: #selector(goToPayment), for: .touchUpInside)
        return cell
    }
    
    // Firebase Storageから画像をダウンロードするメソッド
    func downloadImageFromFirebase(imageName: String, completion: @escaping (UIImage?) -> Void) {
        // "Room"ディレクトリの下の画像を参照するようにパスを修正
        let storageRef = Storage.storage().reference(withPath: "Room/\(imageName)")
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image from Firebase Storage: \(error.localizedDescription)")
                completion(nil)
            } else if let data = data {
                let image = UIImage(data: data)
                if image == nil {
                    print("Downloaded data could not be converted to an image.")
                } else {
                    // 画像の名前をログに出力
                    print("Downloaded image: \(imageName)")
                }
                completion(image)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    @objc func goToPayment() {
        print("お支払いへ遷移")
        // お支払い画面への遷移ロジック
        let paymentVC = PaymentViewController()
        navigationController?.pushViewController(paymentVC, animated: true)
    }
}

class RoomCell: UICollectionViewCell {
    
    let roomImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let roomNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let paymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("お支払いへ", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(roomImageView)
        addSubview(roomNumberLabel)
        addSubview(paymentButton)
        
        NSLayoutConstraint.activate([
            roomImageView.topAnchor.constraint(equalTo: topAnchor),
            roomImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            roomImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            roomImageView.heightAnchor.constraint(equalToConstant: 200),
            
            roomNumberLabel.topAnchor.constraint(equalTo: roomImageView.bottomAnchor, constant: 10),
            roomNumberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            paymentButton.topAnchor.constraint(equalTo: roomNumberLabel.bottomAnchor, constant: 10),
            paymentButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            paymentButton.widthAnchor.constraint(equalToConstant: 150),
            paymentButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
