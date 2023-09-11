//
//  ReservationViewController.swift
//  ShareHouseApp
//
//  Created by Ngos on 2023/09/11.
//

import UIKit

class ReservationViewController: UIViewController {
    
    // UIDatePickerを使用してカレンダーを表示
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let reserveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("予約する", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(reserveDate), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "予約"
        
        // カレンダーとボタンをビューに追加
        view.addSubview(datePicker)
        view.addSubview(reserveButton)
        
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            reserveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reserveButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20)
        ])
    }
    
    @objc func reserveDate() {
        let selectedDate = datePicker.date
        print("選択された日付: \(selectedDate)")
        
        // 予約処理をここに書く
        // 例: データベースに予約情報を保存するなど
    }
}
