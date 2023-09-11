//
//  ReservationViewController.swift
//  ShareHouseApp
//
//  Created by Ngos on 2023/09/11.
//

import UIKit
import FSCalendar

class ReservationViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    // FSCalendarのインスタンスを作成
    let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "予約"
        
        // FSCalendarのデリゲートとデータソースを設定
        calendar.delegate = self
        calendar.dataSource = self
        
        // FSCalendarをビューに追加
        view.addSubview(calendar)
        
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendar.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    // FSCalendarのデリゲートとデータソースメソッドを追加（必要に応じて）
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("選択された日付: \(date)")
    }
    
    // 予約可能な日付を色付けする場合のメソッド
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        // ここで予約可能な日付を指定し、その日付の色を返す
        // 例: 予約可能な日付の配列を持っている場合、その日付に対して特定の色を返す
        return nil
    }
}
