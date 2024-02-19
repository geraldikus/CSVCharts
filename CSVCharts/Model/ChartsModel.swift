//
//  ChartsModel.swift
//  CSVCharts
//
//  Created by Anton on 14.02.24.
//

import Foundation

struct ChartsModel: Identifiable {
    let id: UUID = UUID()
    let date: Date
    let hour: Int
    
    init(date: String, hour: Int) {
        self.date = date.convertToDate() ?? Date()
        self.hour = hour
    }
}

extension String {
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.calendar = Calendar.current
        return dateFormatter.date(from: self)
    }
}

