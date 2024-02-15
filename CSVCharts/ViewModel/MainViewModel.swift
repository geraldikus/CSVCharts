//
//  MainViewController.swift
//  CSVCharts
//
//  Created by Anton on 14.02.24.
//

import SwiftUI
import MobileCoreServices

//final class MainViewModel: NSObject, ObservableObject, UIDocumentPickerDelegate {
//    
//    @Published var chartsModels: [ChartsModel] = []
//    
//    func importCSV() {
//        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeCommaSeparatedText)], in: .import)
//        documentPicker.delegate = self
//        UIApplication.shared.windows.first?.rootViewController?.present(documentPicker, animated: true, completion: nil)
//    }
//    
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        guard let selectedFileURL = urls.first else {
//            print("No file selected")
//            return
//        }
//        
//        do {
//            let data = try Data(contentsOf: selectedFileURL)
//            let csvString = String(data: data, encoding: .utf8)
//            decodeCSV(csvString: csvString)
//            print("I can read CSV")
//            print("CSV: \(csvString)")
//        } catch {
//            print("Error: \(error)")
//            print("Cannot read CSV")
//        }
//    }
//    
//    func decodeCSV(csvString: String?) {
//        guard let csvString = csvString else { return }
//        let rows = csvString.components(separatedBy: "\n")
//        for row in rows {
//            let columns = row.components(separatedBy: ";") // Используйте ";" для разделения столбцов
//            // Проверяем, что строка содержит достаточно столбцов
//            guard columns.count >= 2 else { continue } // Пропускаем пустые строки или строки с недостаточным количеством столбцов
//            // Предполагаем, что дата находится в первом столбце, а час во втором
//            if let date = columns.first, let hour = Int(columns[1]) {
//                let chartModel = ChartsModel(date: date, hour: hour)
//                chartsModels.append(chartModel)
//                print("Successfully decoded CSV row: Date: \(date), Hour: \(hour)")
//                print("Data: \(date)")
//                print("Date in model:\(chartModel.date)")
//                print("Hour in model:\(chartModel.hour)")
//            }
//        }
//    }
//
//
//}

final class MainViewModel: NSObject, ObservableObject, UIDocumentPickerDelegate {
    
    @Published var chartsModels: [ChartsModel] = []
    
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
        } catch {
            print("Error: \(error)")
        }
    }
    
    func decodeCSV(csvString: String?) {
        guard let csvString = csvString else { return }
        let rows = csvString.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ";")
            guard columns.count >= 2 else { continue }
            if let date = columns.first, let hour = Int(columns[1]) {
                let chartModel = ChartsModel(date: date, hour: hour)
                chartsModels.append(chartModel)
            }
        }
    }
}

