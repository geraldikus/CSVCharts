//
//  ChartsVIew.swift
//  CSVCharts
//
//  Created by Anton on 14.02.24.
//

import SwiftUI
import Charts

struct ChartsView: View {
    @ObservedObject var viewModel: ChartsViewModel
    let yScale = 5
    
    // Выбор bacground color
    
    var body: some View {
        
        let minDate = viewModel.minimumData
        let maxDate = viewModel.maximumDate
        let minHour = viewModel.minimumHour
        let maxHour = viewModel.maximumHour

        VStack(spacing: 10) {
            Text("\(viewModel.chartName)")
                .font(.headline)
            Chart(viewModel.chartsModels) { data in
                Plot {
                    LineMark(x: .value("Date", data.date), y: .value("Hour", data.hour))
                        .lineStyle(.init(lineWidth: 3))
                        .interpolationMethod(.cardinal)
                    
                }
                .symbol(.circle)
                
                
                if viewModel.showMedian {
                    if let medianHour = viewModel.medianHour {
                        RuleMark(y: .value("Median", medianHour))
                            .foregroundStyle(.cyan)
                            .annotation(position: .top, alignment: .trailing) {
                                Text("Median: \(String(format:"%.2f", medianHour))")
                                    .font(.body.bold())
                                    .foregroundStyle(.purple)
                            }
                    }
                }
            }
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(viewModel.chartColor)
            .scaleEffect(1)
            .chartXScale(domain: minDate...maxDate)
            .chartYScale(domain: (minHour-yScale)...(maxHour+yScale))
            .chartPlotStyle { area in
                area.background(viewModel.chartBackgroundPicker)
            }
            
            HStack(alignment: .firstTextBaseline) {
                Text("Выберите цвет графика")
                Spacer()
                chartPicker()
            }
            
            HStack(alignment: .firstTextBaseline) {
                Text("Выберите цвет заливки")
                Spacer()
                chartBackgroundPicker()
            }
            
            Toggle(viewModel.showMedian ? "Убрать медиану" : "Показать медиану", isOn: $viewModel.showMedian)
            
            HStack {
                Button(action: {
                    viewModel.importCSV()
                }, label: {
                    Text("Добавить CSV файл")
                })
                .buttonStyle(.borderedProminent)
                
                Button(action: {
                    viewModel.chartsModels.removeAll()
                }, label: {
                    Text("Удалить данные")
                })
                .background(Color.red.opacity(0.7))
                .buttonStyle(.bordered)
                .foregroundStyle(Color.white)
                .cornerRadius(5)
            }
        }
        .padding()
    }
    
    func chartPicker() -> some View {
        Picker("", selection: $viewModel.chartColor) {
            ForEach(ChartColor.allCases, id: \.self) { color in
                switch color {
                case .green:
                    Text("Green").tag(Color.green)
                case .blue:
                    Text("Blue").tag(Color.blue)
                case .yellow:
                    Text("Yellow").tag(Color.yellow)
                }
            }
        }
        .pickerStyle(.menu)
    }
    
    func chartBackgroundPicker() -> some View {
        Picker("", selection: $viewModel.chartBackgroundPicker) {
            ForEach(ChartBackgroundColor.allCases, id: \.self) { color in
                switch color {
                case .green:
                    Text("Green").tag(Color.green.opacity(0.2))
                case .blue:
                    Text("Blue").tag(Color.blue.opacity(0.2))
                case .yellow:
                    Text("Yellow").tag(Color.yellow.opacity(0.2))
                }
            }
        }
    }
}

#Preview {
    ChartsView(viewModel: ChartsViewModel())
}

enum ChartColor: String, CaseIterable {
    case green = "Green"
    case blue = "Blue"
    case yellow = "Yellow"
}

enum ChartBackgroundColor: String, CaseIterable {
    case green = "Green"
    case blue = "Blue"
    case yellow = "Yellow"
}


