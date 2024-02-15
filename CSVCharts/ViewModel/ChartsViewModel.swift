//
//  ChartsViewModel.swift
//  CSVCharts
//
//  Created by Anton on 14.02.24.
//

import SwiftUI
import MobileCoreServices

class ChartsViewModel: NSObject, ObservableObject, UIDocumentPickerDelegate {
    
    @Published var chartsModels: [ChartsModel] = []
    @Published var testData = ChartsModel.tests
    @Published var chartName: String = ""
    @Published var chartColor: Color = .blue
    @Published var chartBackgroundPicker: Color = .green.opacity(0.2)
    @Published var showMedian = false
    @Published var chartStyle = true
    
    
    func importCSV() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeCommaSeparatedText)], in: .import)
        documentPicker.delegate = self
        UIApplication.shared.windows.first?.rootViewController?.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            print("No file selected")
            return
        }
        
        do {
            let data = try Data(contentsOf: selectedFileURL)
            let csvString = String(data: data, encoding: .utf8)
            decodeCSV(csvString: csvString)
            print("I can read CSV")
            print("CSV: \(csvString)")
        } catch {
            print("Error: \(error)")
        }
    }
    
    func decodeCSV(csvString: String?) {
        guard let csvString = csvString else { return }
        let rows = csvString.components(separatedBy: .newlines)
        for row in rows {
            let columns = row.components(separatedBy: ";")
            guard columns.count >= 2 else { continue }
            if let date = columns.first, let hour = Int(columns[1]) {
                let chartModel = ChartsModel(date: date, hour: hour)
                chartsModels.append(chartModel)
                print("Successfully decoded CSV row: Date: \(date), Hour: \(hour)")
                print("Data: \(date)")
                print("Date in model:\(chartModel.date)")
                print("Hour in model:\(chartModel.hour)")
            }
        }
    }

    var minimumData: Date {
        return chartsModels.first?.date ?? Date.now
    }
    
    var maximumDate: Date {
        return chartsModels.last?.date ?? Date.now
    }
    
    var minimumHour: Int {
        return chartsModels.map { $0.hour }.min() ?? 0
    }
    
    var maximumHour: Int {
        return chartsModels.map { $0.hour }.max() ?? 0
    }
    
    var medianHour: Double? {
        guard !chartsModels.isEmpty else { return nil }
        
        let sortedHours = chartsModels.map { Double($0.hour) }.sorted()
        let count = sortedHours.count
        
        if count % 2 == 0 {
            let middleIndex = count / 2
            return (sortedHours[middleIndex - 1] + sortedHours[middleIndex]) / 2
        } else {
            let middleIndex = count / 2
            return sortedHours[middleIndex]
        }
    }
}
