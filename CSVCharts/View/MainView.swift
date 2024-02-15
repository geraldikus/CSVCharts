//
//  ContentView.swift
//  CSVCharts
//
//  Created by Anton on 14.02.24.
//

import SwiftUI
import MobileCoreServices

struct MainView: View {
    
    @ObservedObject var chartViewModel: ChartsViewModel
    @State private var navigateToChartsView = false
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center) {
                Text("Это приложение поможет вам перевести ваш файл CSV в красивый график.")
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                TextField("Введите название графика", text: $chartViewModel.chartName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                NavigationLink(destination: ChartsView(viewModel: chartViewModel), isActive: $navigateToChartsView) {
                    Button(action: {
                        navigateToChartsView = true
                    }) {
                        Text("Добавить имя")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(chartViewModel.chartName.isEmpty)
                }
            }
            .padding()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


#Preview {
    MainView(chartViewModel: ChartsViewModel())
}
