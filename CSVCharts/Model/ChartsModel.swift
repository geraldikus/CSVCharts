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
    
    
    static let test = ChartsModel(date: "2023-11-15 11:40:19", hour: 128)
    
    static var tests: [ChartsModel] = [
            ChartsModel(date: "2023-11-15 11:40:19", hour: 120),
            ChartsModel(date: "2023-11-15 11:40:22", hour: 119),
            ChartsModel(date: "2023-11-15 11:40:24", hour: 117),
            ChartsModel(date: "2023-11-15 11:40:27", hour: 118),
            ChartsModel(date: "2023-11-15 11:40:30", hour: 117),
            ChartsModel(date: "2023-11-15 11:40:32", hour: 116),
            ChartsModel(date: "2023-11-15 11:40:35", hour: 114),
            ChartsModel(date: "2023-11-15 11:40:38", hour: 111),
            ChartsModel(date: "2023-11-15 11:40:41", hour: 109),
            ChartsModel(date: "2023-11-15 11:40:44", hour: 109),
            ChartsModel(date: "2023-11-15 11:40:47", hour: 110),
            ChartsModel(date: "2023-11-15 11:40:49", hour: 113),
            ChartsModel(date: "2023-11-15 11:40:52", hour: 113),
            ChartsModel(date: "2023-11-15 11:40:55", hour: 115),
            ChartsModel(date: "2023-11-15 11:40:58", hour: 114),
            ChartsModel(date: "2023-11-15 11:41:00", hour: 116),
            ChartsModel(date: "2023-11-15 11:41:03", hour: 118),
            ChartsModel(date: "2023-11-15 11:41:06", hour: 116),
            ChartsModel(date: "2023-11-15 11:41:09", hour: 117),
            ChartsModel(date: "2023-11-15 11:41:12", hour: 118),
            ChartsModel(date: "2023-11-15 11:41:15", hour: 119)
        ]
   
}

extension String {
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "GMT") // Установите правильную временную зону здесь
        dateFormatter.calendar = Calendar.current
        return dateFormatter.date(from: self)
    }
}

