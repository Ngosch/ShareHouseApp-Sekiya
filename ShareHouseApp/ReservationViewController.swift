//
//  ReservationViewController.swift
//  ShareHouseApp
//
//  Created by Ngos on 2023/09/11.
//

import UIKit
import FSCalendar

class ReservationViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    // 選択された開始日と終了日を保持するプロパティ
    var startDate: Date?
    var endDate: Date?
    
    // FSCalendarのインスタンスを作成
    let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    // 部屋選択画面への遷移ボタンのインスタンスを作成
    let roomSelectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("部屋を選択", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToRoomSelection), for: .touchUpInside)
        return button
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
        
        // 遷移ボタンをビューに追加
        view.addSubview(roomSelectionButton)
        
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendar.heightAnchor.constraint(equalToConstant: 400),
            
            roomSelectionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            roomSelectionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            roomSelectionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            roomSelectionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // 部屋選択画面への遷移メソッド
    @objc func goToRoomSelection() {
        let roomSelectionVC = RoomSelectionViewController() // 部屋選択画面のViewControllerを仮定
        navigationController?.pushViewController(roomSelectionVC, animated: true)
    }
    
    // FSCalendarのデリゲートとデータソースメソッドを追加（必要に応じて）
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if startDate == nil {
            startDate = date
            endDate = nil
        } else if endDate == nil {
            endDate = date
            if let start = startDate, let end = endDate, start > end {
                // 開始日が終了日より後の場合、選択を入れ替える
                swap(&startDate, &endDate)
            }
        } else {
            startDate = date
            endDate = nil
        }
        calendar.reloadData() // カレンダーの再描画
        print("選択された日付: \(date)")
    }
    
    // 選択された範囲の日付をハイライト表示するメソッド
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if let start = startDate, let end = endDate {
            print("Start Date: \(start), End Date: \(end), Current Date: \(date)") // デバッグ用のログ

            if date.compare(start) == .orderedSame || date.compare(end) == .orderedSame {
                return .blue // 開始日と終了日の色
            } else if date.compare(start) == .orderedDescending && date.compare(end) == .orderedAscending {
                return .lightGray // 開始日と終了日の間の色
            }
        }
        return nil
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("Current page did change")
    }
    
}
