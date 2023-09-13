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
        
        title = "部屋選択"
        view.backgroundColor = .white
        
        // Firebaseから部屋の画像のファイル名を取得
        fetchRoomImages()
        
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
    }
    
    func fetchRoomImages() {
        let ref = Database.database().reference().child("properties")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let properties = snapshot.value as? [String: Any] else { return }
            for (propertyID, propertyData) in properties {
                if let propertyData = propertyData as? [String: Any],
                   let roomImagesData = propertyData["roomImages"] as? [String] {
                    // 2. 各物件のIDとそれに関連する部屋画像のリストをroomImages変数に保存
                    self.roomImages[propertyID] = roomImagesData
                }
            }
            self.collectionView.reloadData()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 各物件が所有する部屋の画像の数を返す
        return roomImages.keys.count * roomNumbers.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomCell", for: indexPath) as! RoomCell
        
        // 部屋番号を動的に生成
        let roomNumber = baseRoomNumbers[roomIndex]
        cell.roomNumberLabel.text = "部屋番号: \(roomNumber)"
        
        // 物件のインデックスと部屋のインデックスを計算
        let propertyIndex = indexPath.item / roomNumbers[0].count
        let roomIndex = indexPath.item % roomNumbers[0].count
        
        // 正しい物件の部屋画像を表示
        let propertyID = Array(roomImages.keys)[propertyIndex]
        if let imagesForProperty = roomImages[propertyID], roomIndex < imagesForProperty.count {
            let imageName = imagesForProperty[roomIndex]
            downloadImageFromFirebase(imageName: imageName, completion: { (image) in
                cell.roomImageView.image = image
            })
        }
        
        // 2. 部屋番号を新しいroomNumbers配列を使用して設定
        let roomNumber = roomNumbers[propertyIndex][roomIndex]
        cell.roomNumberLabel.text = "部屋番号: \(roomNumber)"
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
