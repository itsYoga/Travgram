//
//  TripAddView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/25.
//

import SwiftUI
import SwiftData
import CoreLocation

struct TripAddView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userManager: UserManager

    @State private var name: String = ""
    @State private var date: Date = Date()
    @State private var selectedType: TripType = .city
    @State private var notify: Bool = false
    @State private var budget: Double = 5000
    @State private var expenses: Double = 0
    @State private var tripDates: Set<DateComponents> = []

    @StateObject private var locationManager = LocationManager() // For managing location

    var onTripAdded: (() -> Void)?

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("行程詳情")) {
                    TextField("行程名稱", text: $name)
                    DatePicker("日期與時間", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    Picker("行程類型", selection: $selectedType) {
                        ForEach(TripType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    Slider(value: $budget, in: 1000...10000, step: 500) {
                        Text("預算：\(Int(budget))元")
                    }
                }

                Section(header: Text("行程選項")) {
                    Toggle("是否需要提醒", isOn: $notify)
                    TextField("預估花費", value: $expenses, format: .currency(code: "USD"))
                        .keyboardType(.decimalPad)
                    MultiDatePicker("選擇多天日期", selection: $tripDates)
                }

                Section(header: Text("位置")) {
                    if locationManager.currentCity.isEmpty {
                        Text("正在取得位置...")
                            .foregroundColor(.gray)
                    } else {
                        Text("目前位置：\(locationManager.currentCity)")
                    }
                }
            }
            .navigationTitle("新增行程")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("儲存") { saveTrip() }
                }
            }
            .onAppear {
                locationManager.requestLocation()
            }
        }
    }

    private func saveTrip() {
        userManager.addTrip(name: name, date: date, type: selectedType, budget: budget, expenses: expenses)
        onTripAdded?()
        dismiss()
    }
}
