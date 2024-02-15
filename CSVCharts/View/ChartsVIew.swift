//
//  ChartsVIew.swift
//  CSVCharts
//
//  Created by Anton on 14.02.24.
//

import SwiftUI
import Charts

struct ChartsView: View {
    @ObservedObject var viewModel = ChartsViewModel()
    @State private var scale: CGFloat = 1.0
    @State private var selectedColor: ChartColor = .blue
    @State private var showMedian = false
    
    @State private var chartColor: Color = .blue
    @State private var chartStyle = true
    let yScale = 5
    
    // Выбор bacground color
    
    var body: some View {
        
        let minDate = viewModel.minimumData
        let maxDate = viewModel.maximumDate
        let minHour = viewModel.minimumHour
        let maxHour = viewModel.maximumHour

        VStack(spacing: 10) {
            Chart(viewModel.chartsModels) { data in
                Plot {
                    LineMark(x: .value("Date", data.date), y: .value("Hour", data.hour))
                        .lineStyle(.init(lineWidth: 3))
                        .interpolationMethod(.cardinal)
                    
                }
                .symbol(.circle)
                
                
                if showMedian {
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
            .foregroundStyle(chartColor)
            .scaleEffect(1)
            .chartXScale(domain: minDate...maxDate)
            .chartYScale(domain: (minHour-yScale)...(maxHour+yScale))
            .chartPlotStyle { area in
                area.background(.green.opacity(0.2))
            }
            
            picker()
                .padding(.vertical)
            
            Button(action: {
                showMedian.toggle()
            }, label: {
                Text("Показать медиану")
            })
            .buttonStyle(.bordered)
            
            Button(action: {
                print("Data from ChartModel: \(viewModel.chartsModels)")
            }, label: {
                Text("Показать данные")
            })
            .buttonStyle(.bordered)
            
            Button(action: {
                viewModel.importCSV()
            }, label: {
                Text("Добавить CSV файл")
            })
            .buttonStyle(.bordered)
            
            Button(action: {
                viewModel.chartsModels.removeAll()
            }, label: {
                Text("Удалить данные")
            })
            .buttonStyle(.bordered)
        }
        .padding()
    }
    
    func picker() -> some View {
        Picker("Pick color", selection: $selectedColor) {
            ForEach(ChartColor.allCases, id: \.self) { color in
                switch color {
                case .green:
                    Text("Green").tag(ChartColor.green)
                case .blue:
                    Text("Blue").tag(ChartColor.blue)
                case .yellow:
                    Text("Yellow").tag(ChartColor.yellow)
                }
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .onChange(of: selectedColor) { newColor in
            switch newColor {
            case .green:
                chartColor = .green
            case .blue:
                chartColor = .blue
            case .yellow:
                chartColor = .yellow
            }
        }
    }
}

#Preview {
    ChartsView()
}

enum ChartColor: String, CaseIterable {
    case green = "Green"
    case blue = "Blue"
    case yellow = "Yellow"
}
