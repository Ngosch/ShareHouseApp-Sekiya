//
//  PaymentViewController.swift
//  ShareHouseApp
//
//  Created by Ngos on 2023/09/11.
//

import UIKit
import CardPayments

class PaymentViewController: UIViewController {

    // お支払いボタン
    let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("お支払いへ", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(PaymentViewController.self, action: #selector(handlePayment), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "支払い"

        // ボタンをビューに追加
        view.addSubview(payButton)

        setupLayout()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            payButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            payButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            payButton.widthAnchor.constraint(equalToConstant: 200),
            payButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func handlePayment() {
        // PayPalの支払い処理をここに実装します。
        // 注意: 実際の支払い処理を実装するには、PayPalのドキュメントを参照し、
        // 必要な設定や認証を行う必要があります。
    }
}

