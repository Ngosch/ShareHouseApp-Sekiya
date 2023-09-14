//
//  PaymentViewController.swift
//  ShareHouseApp
//
//  Created by Ngos on 2023/09/11.
//

import UIKit

class PaymentViewController: UIViewController {

    // 入力欄とラベル
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "氏名（カード記載）"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let cardNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "クレジットカード番号"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cardNumberTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let securityCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "セキュリティコード"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let securityCodeTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    // お支払いボタン
    let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("予約、お支払い確定", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePayment), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "支払い"

        // ラベルとテキストフィールドをビューに追加
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(cardNumberLabel)
        view.addSubview(cardNumberTextField)
        view.addSubview(securityCodeLabel)
        view.addSubview(securityCodeTextField)
        
        // ボタンをビューに追加
        view.addSubview(payButton)

        setupLayout()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cardNumberLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            cardNumberLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            cardNumberTextField.topAnchor.constraint(equalTo: cardNumberLabel.bottomAnchor, constant: 10),
            cardNumberTextField.leadingAnchor.constraint(equalTo: cardNumberLabel.leadingAnchor),
            cardNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            securityCodeLabel.topAnchor.constraint(equalTo: cardNumberTextField.bottomAnchor, constant: 20),
            securityCodeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            securityCodeTextField.topAnchor.constraint(equalTo: securityCodeLabel.bottomAnchor, constant: 10),
            securityCodeTextField.leadingAnchor.constraint(equalTo: securityCodeLabel.leadingAnchor),
            securityCodeTextField.widthAnchor.constraint(equalToConstant: 100),
            
            payButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            payButton.topAnchor.constraint(equalTo: securityCodeTextField.bottomAnchor, constant: 40),
            payButton.widthAnchor.constraint(equalToConstant: 200),
            payButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func handlePayment() {
        // ここで実際の支払い処理を実装することができます。
        // 現在は、ボタンがタップされたときに何も行われないようになっています。
        let alert = UIAlertController(title: "お知らせ", message: "現在、支払い機能は利用できません。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
