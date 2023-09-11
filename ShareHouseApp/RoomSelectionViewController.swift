//
//  RoomSelectionViewController.swift
//  ShareHouseApp
//
//  Created by Ngos on 2023/09/11.
//

import UIKit

class RoomSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let roomImages = ["Room1", "Room2", "Room3", "Room4"]
    let roomNumbers = ["101", "102", "103", "104"]
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomCell", for: indexPath) as! RoomCell
        cell.roomImageView.image = UIImage(named: roomImages[indexPath.item])
        cell.roomNumberLabel.text = "部屋番号: \(roomNumbers[indexPath.item])"
        cell.paymentButton.addTarget(self, action: #selector(goToPayment), for: .touchUpInside)
        return cell
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
