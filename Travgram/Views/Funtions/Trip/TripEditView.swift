import SwiftUI
import SwiftData
import PhotosUI
import TipKit

struct TripEditView: View {
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) private var dismiss

    @Bindable var trip: Trip
    @State private var showPhotoPicker = false
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var images: [UIImage] = [] // Store images for display
    @State private var expensesNTD: Int = 0
    @State private var selectedCurrency: String = "USD"
    @State private var exchangeRate: Double = 1.0
    @State private var convertedExpenses: String = "0"

    var body: some View {
        NavigationStack {
            Form {
                // Edit Trip Details Section
                Section(header: Text("Edit Trip Details")) {
                    TextField("Trip Name", text: $trip.name)
                    TipView(TipManager.shared.tripNameTip) // Trip name tip
                    
                    DatePicker("Date and Time", selection: $trip.date, displayedComponents: [.date, .hourAndMinute])
                    Picker("Trip Type", selection: $trip.type) {
                        ForEach(TripType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }

                // Edit Expenses Section
                Section(header: Text("Expenses")) {
                    VStack {
                        HStack {
                            Text("Expenses: \(expensesNTD) NTD")
                            Spacer()
                            Text("Approximately \(convertedExpenses) \(selectedCurrency)")
                        }
                        Slider(value: Binding(
                            get: { Double(expensesNTD) },
                            set: { expensesNTD = Int($0) }
                        ), in: 1000...100000, step: 100)
                        .onChange(of: expensesNTD) { _ in
                            updateConvertedExpenses()
                        }
                    }
                    TipView(TipManager.shared.budgetTip) // Budget tip

                    Picker("Select Currency", selection: $selectedCurrency) {
                        ForEach(currencyList, id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
                    .onChange(of: selectedCurrency) { _ in
                        updateExchangeRate()
                    }
                }

                // Manage Photos Section
                Section(header: Text("Manage Photos")) {
                    TipView(TipManager.shared.photoTip) // Location-related tip
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(images, id: \.self) { image in
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .shadow(radius: 2)
                                    Button(action: {
                                        removeImage(image)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                            .padding(5)
                                    }
                                }
                            }
                        }
                    }
                    Button("Add Photos") {
                        showPhotoPicker = true
                    }
                }
            }
            .navigationTitle("Edit Trip")
            .navigationBarBackButtonHidden(true) // Hide the back button
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveChanges() }
                }
            }
            .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhotos, matching: .images)
            .onChange(of: selectedPhotos) { _ in
                loadSelectedPhotos()
            }
        }
        .onAppear {
            initializeView()
            TipManager.shared.configureTips() // Ensure TipKit is configured
        }
        .background(
            Image("airplane")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }

    private func initializeView() {
        expensesNTD = Int(trip.expenses)
        selectedCurrency = "USD"
        images = trip.photos.compactMap { UIImage(data: $0) }
        updateExchangeRate()
    }

    private func updateConvertedExpenses() {
        let convertedAmount = Double(expensesNTD) / exchangeRate
        convertedExpenses = String(format: "%.0f", convertedAmount)
    }

    private func updateExchangeRate() {
        let rates: [String: Double] = [
            "USD": 30.0, "EUR": 33.0, "JPY": 0.22, "GBP": 40.0,
            "CNY": 4.2, "CHF": 33.5, "CAD": 22.0, "AUD": 20.0,
            "NZD": 19.0, "HKD": 3.8
        ]
        exchangeRate = rates[selectedCurrency] ?? 30.0
        updateConvertedExpenses()
    }

    private func loadSelectedPhotos() {
        Task {
            for item in selectedPhotos {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    images.append(image)
                    trip.photos.append(data) // Add photo data to trip
                }
            }
        }
    }

    private func removeImage(_ image: UIImage) {
        if let index = images.firstIndex(of: image) {
            images.remove(at: index)
            trip.photos.remove(at: index) // Remove photo data from trip
        }
    }

    private func saveChanges() {
        trip.expenses = Double(expensesNTD)
        userManager.saveChanges()
        dismiss()
    }
}
