import SwiftUI
import SwiftData
import CoreLocation
import MapKit
import UserNotifications
import TipKit

struct TripAddView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userManager: UserManager

    @State private var name: String = ""
    @State private var date: Date = Date()
    @State private var selectedType: TripType = .city
    @State private var notify: Bool = false
    @State private var notificationID: String? // To track notification for cancellation
    @State private var budgetNTD: Int = 15000
    @State private var selectedCurrency: String = "USD"
    @State private var exchangeRate: Double = 1.0
    @State private var convertedBudget: String = "500"

    @State private var latitude: Double = 25.033964
    @State private var longitude: Double = 121.564468
    @State private var placeName: String = "Location not selected"
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 25.033964, longitude: 121.564468),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var annotation: MapAnnotationItem?

    @State private var searchText: String = ""
    @State private var searchResults: [MKMapItem] = []
    var onTripAdded: (() -> Void)?

    var body: some View {
        NavigationStack {
            Form {
                // Basic Trip Details
                Section(header: Text("Trip Details")) {
                    TextField("Trip Name", text: $name)
                    TipView(TripNameTip()) // Display tip for trip name
                    DatePicker("Select Date & Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    Picker("Trip Type", selection: $selectedType) {
                        ForEach(TripType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }

                // Budget and Currency
                Section(header: Text("Budget & Currency")) {
                    VStack {
                        HStack {
                            Text("Budget: \(budgetNTD) NTD")
                            Spacer()
                            Text("Approx. \(convertedBudget) \(selectedCurrency)")
                        }
                        Slider(value: Binding(
                            get: { Double(budgetNTD) },
                            set: { budgetNTD = Int($0) }
                        ), in: 1000...100000, step: 100)
                        .onChange(of: budgetNTD) { _ in
                            convertCurrency()
                        }
                    }
                    TipView(BudgetTip()) // Display budget tip
                    Picker("Select Currency", selection: $selectedCurrency) {
                        ForEach(currencyList, id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
                    .onChange(of: selectedCurrency) { _ in
                        updateExchangeRate()
                    }
                }

                // Location Selection
                Section(header: Text("Select Location")) {
                    TipView(LocationTip()) // Display tip for trip name
                    TextField("Enter location name or address", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            searchLocation()
                        }

                    if !searchResults.isEmpty {
                        List(searchResults, id: \.self) { item in
                            Button {
                                selectLocation(item)
                            } label: {
                                Text(item.name ?? "Unknown location")
                            }
                        }
                        .frame(height: 150)
                    }

                    ZStack {
                        CustomMapView(region: $region, annotation: $annotation, onMapItemSelected: { item in
                            updateLocationDetails(from: item)
                        })
                        .frame(height: 300)

                        VStack {
                            Spacer()
                            Button(action: addAnnotationAtCenter) {
                                Text("Add Pin")
                                    .padding(8)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                                    .padding()
                            }
                        }
                    }

                    Text("Location Name: \(placeName)")
                        .foregroundColor(.gray)
                }

                // Other Options
                Section(header: Text("Other Options")) {
                    Toggle("Enable Notification", isOn: $notify)
                        .onChange(of: notify) { value in
                            if value {
                                scheduleNotification()
                            } else {
                                cancelNotification()
                            }
                        }
                }
            }
            .navigationTitle("Add Trip")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveTrip() }
                }
            }
        }
        .onAppear {
            updateExchangeRate()
        }
    }

    // MARK: - Notification Methods
    private func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Trip Reminder"
                content.body = "Your trip '\(name)' is about to start!"
                content.sound = .default

                let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

                let id = UUID().uuidString
                notificationID = id
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

                center.add(request)
            }
        }
    }

    private func cancelNotification() {
        guard let id = notificationID else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        notificationID = nil
    }

    // MARK: - Other Methods
    private func addAnnotationAtCenter() {
        annotation = MapAnnotationItem(
            id: UUID(),
            coordinate: region.center
        )
        latitude = region.center.latitude
        longitude = region.center.longitude
        updatePlaceName()
    }

    private func updateLocationDetails(from mapItem: MKMapItem) {
        let coordinate = mapItem.placemark.coordinate
        region.center = coordinate
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        placeName = mapItem.name ?? "Unknown location"
        annotation = MapAnnotationItem(id: UUID(), coordinate: coordinate)
    }

    private func searchLocation() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let items = response?.mapItems {
                searchResults = items
            } else {
                print("Location search failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    private func convertCurrency() {
        let convertedAmount = Double(budgetNTD) / exchangeRate
        convertedBudget = String(format: "%.0f", convertedAmount)
    }

    private func updateExchangeRate() {
        let rates: [String: Double] = [
            "USD": 30.0, "EUR": 33.0, "JPY": 0.22, "GBP": 40.0,
            "CNY": 4.2, "CHF": 33.5, "CAD": 22.0, "AUD": 20.0,
            "NZD": 19.0, "HKD": 3.8
        ]
        exchangeRate = rates[selectedCurrency] ?? 30.0
        convertCurrency()
    }

    private func selectLocation(_ mapItem: MKMapItem) {
        let coordinate = mapItem.placemark.coordinate
        region.center = coordinate
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        placeName = mapItem.name ?? "Unknown location"
        annotation = MapAnnotationItem(id: UUID(), coordinate: coordinate)
    }

    private func saveTrip() {
        if notify {
            scheduleNotification()
        }
        userManager.addTrip(
            name: name,
            date: date,
            type: selectedType,
            budget: Double(budgetNTD),
            expenses: 0.0,
            latitude: latitude,
            longitude: longitude
        )
        onTripAdded?()
        dismiss()
    }

    private func updatePlaceName() {
        reverseGeocode(latitude: latitude, longitude: longitude) { name in
            DispatchQueue.main.async {
                placeName = name ?? "Unknown location"
            }
        }
    }
}

let currencyList = [
    "USD", "EUR", "JPY", "GBP", "CNY", "CHF", "CAD", "AUD", "NZD", "HKD"
]

