//
//  ChartsVIew.swift
//  CSVCharts
//
//  Created by Anton on 14.02.24.
//

import SwiftUI
import Charts


// Сделать наведение по графику

struct ChartsView: View {
    @ObservedObject var viewModel: ChartsViewModel
    let scaleY = 5
    
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
            .chartYScale(domain: (minHour-scaleY)...(maxHour+scaleY))
            .chartPlotStyle { area in
                area.background(viewModel.chartBackgroundPicker)
            }
            
            HStack(alignment: .firstTextBaseline) {
                Text("Выберите цвет графика")
                Spacer()
                colorPicker(type: .chartColor)
            }
            
            HStack(alignment: .firstTextBaseline) {
                Text("Выберите цвет заливки")
                Spacer()
                colorPicker(type: .chartBackgroundColor)
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
    
    func colorPicker(type: ColorPickerType) -> some View {
        Picker("", selection: type == .chartColor ? $viewModel.chartColor : $viewModel.chartBackgroundPicker) {
            ForEach(ColorOption.allCases, id: \.self) { colorOption in
                let color = colorOption.color
                let tag: Color = type == .chartColor ? color : color.opacity(0.2)
                Text(colorOption.name).tag(tag)
            }
        }
        .pickerStyle(.menu)
    }
}

#Preview {
    ChartsView(viewModel: ChartsViewModel())
}





