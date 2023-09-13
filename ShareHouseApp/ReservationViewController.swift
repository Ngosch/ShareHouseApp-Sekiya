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
    
    // 選択された日付範囲を表示するためのラベルを作成
    let selectedDateRangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "選択中"
        return label
    }()
    
    // FSCalendarのインスタンスを作成
    let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.allowsMultipleSelection = true // 複数選択を許可
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
        
        // ラベルをビューに追加
        view.addSubview(selectedDateRangeLabel)
        
        // ラベルのレイアウトを設定
        NSLayoutConstraint.activate([
            selectedDateRangeLabel.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 20),
            selectedDateRangeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            selectedDateRangeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
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
            calendar.select(date) // 日付を選択
        } else if endDate == nil {
            endDate = date
            if let start = startDate, let end = endDate, start > end {
                // 開始日が終了日より後の場合、選択を入れ替える
                swap(&startDate, &endDate)
            }
            
            // 選択された日付範囲を更新
            if let start = startDate, let end = endDate {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy年M月d日"
                selectedDateRangeLabel.text = "選択中 \(formatter.string(from: start))〜\(formatter.string(from: end))"
            } else if let start = startDate {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy年M月d日"
                selectedDateRangeLabel.text = "選択中 \(formatter.string(from: start))"
            } else {
                selectedDateRangeLabel.text = "選択中"
            }
            
            // 開始日から終了日までの日数を確認
            if let start = startDate, let end = endDate {
                let daysBetween = Calendar.current.dateComponents([.day], from: start, to: end).day!
                if daysBetween > 14 {
                    // 14日を超える場合、全ての選択を解除
                    calendar.deselect(startDate!)
                    calendar.deselect(endDate!)
                    startDate = nil
                    endDate = nil
                    return
                }
            }
            
            // 開始日から終了日までの日付を選択
            var dateToSelect = startDate!
            while dateToSelect <= endDate! {
                calendar.select(dateToSelect)
                dateToSelect = Calendar.current.date(byAdding: .day, value: 1, to: dateToSelect)!
            }
        } else {
            calendar.deselect(startDate!) // 既存の選択を解除
            if endDate != nil {
                calendar.deselect(endDate!)
            }
            startDate = date
            endDate = nil
            calendar.select(date) // 新しい日付を選択
        }
        print("選択された日付: \(date)")
    }
    
    
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if let start = startDate, let end = endDate {
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
