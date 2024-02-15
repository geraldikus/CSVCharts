//
//  ContentView.swift
//  CSVCharts
//
//  Created by Anton on 14.02.24.
//

import SwiftUI
import MobileCoreServices

struct MainView: View {
    
    @ObservedObject var viewModel = MainViewModel()
    
    // Add textField with chart name
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center) {
                Text("Добавьте свой CSV файл.")
                    .font(.title)
                    .padding()
                HStack {
                    Button {
                        viewModel.importCSV()
                    } label: {
                        Text("Добавить")
                    }
                    .buttonStyle(.bordered)
                    NavigationLink {
                        ChartsView()
                    } label: {
                        Text("График")
                            .background()
                    }

                }
            }
            .padding()
        }
    }
    
    func navigateToChartsView() {
    }
}


#Preview {
    MainView()
}
