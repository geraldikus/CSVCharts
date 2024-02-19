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
    let scaleY = 5
    @State private var currentValue: ChartsModel?
    
    var body: some View {
        
        VStack(spacing: 10) {
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
                
                if let currentValue, currentValue.id == data.id {
                    RuleMark(x: .value("", currentValue.date))
                        .foregroundStyle(Color.black.opacity(0.3))
                        .annotation(position: .top,
                                    spacing: 10,
                                    overflowResolution: .init(x:.fit(to: .chart),
                                                              y: .disabled)) {
                            selection()
                        }
                }
            }
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(viewModel.chartColor)
            .scaleEffect(1)
            .chartXScale(domain: viewModel.minimumData...viewModel.maximumDate)
            .chartYScale(domain: (viewModel.minimumHour-scaleY)...(viewModel.maximumHour+scaleY))
            .chartPlotStyle { area in
                area.background(viewModel.chartBackgroundPicker)
            }
            .chartOverlay { chartProxy in
                GeometryReader { geometryProxy in
                    Rectangle()
                        .fill(.clear).contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    let location = value.location
                                    if let date: Date = chartProxy.value(atX: location.x) {
                                        let calendar = Calendar.current
                                        let year = calendar.component(.year, from: date)
                                        let month = calendar.component(.month, from: date)
                                        let day = calendar.component(.day, from: date)
                                        let hour = calendar.component(.hour, from: date)
                                        let minute = calendar.component(.minute, from: date)
                                        let second = calendar.component(.second, from: date)
                                        
                                        if let currentItem = viewModel.chartsModels.first(where: { item in
                                            calendar.component(.year, from: item.date) == year &&
                                            calendar.component(.month, from: item.date) == month &&
                                            calendar.component(.day, from: item.date) == day &&
                                            calendar.component(.hour, from: item.date) == hour &&
                                            calendar.component(.minute, from: item.date) == minute &&
                                            calendar.component(.second, from: item.date) == second
                                        }) {
                                            currentValue = currentItem
                                        }
                                    }
                                })
                                .onEnded { value in
                                    self.currentValue = nil
                                }
                        )
                }
            }
            Text("\(viewModel.chartName)")
                .font(.headline)

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

}

#Preview {
    ChartsView(viewModel: ChartsViewModel())
}

private extension ChartsView {
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
    
    func selection() -> some View {
        if let currentValue = currentValue {
            return AnyView(
                VStack {
                    Text("\(currentValue.date.formatted(.dateTime.day().month().hour().minute().second()))")
                    Text("\(currentValue.hour)")
                        .bold()
                }
                .padding(6)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }
}





