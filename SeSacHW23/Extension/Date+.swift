//
//  Date+.swift
//  SeSacHW23
//
//  Created by 변정훈 on 2/4/25.
//

import Foundation

extension Date {
    func toDateDayString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 a hh시 mm분"
        let dateString = formatter.string(from: self)
        return dateString
    }
}
