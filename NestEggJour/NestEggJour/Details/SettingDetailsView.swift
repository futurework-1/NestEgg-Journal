import SwiftUI

struct SettingDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var birdsManager: BirdsManager
    @ObservedObject var observationsManager: ObservationsManager
    @State private var showingClearAlert = false
    @State private var showingClearHistoryAlert = false
    @State private var showingSuccessMessage = false
    @State private var successMessageText = ""
    @State private var selectedTemperatureUnit: TemperatureUnit = .celsius
    @State private var selectedDistanceUnit: DistanceUnit = .kilometers
    var type: SettingsType
    
    var body: some View {
        ZStack {
            Image(.backImg)
                .resizable()
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(.backNavButton)
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    Spacer()
                    Text(type.rawValue)
                        .font(FontFamily.PlayfairDisplay.extraBoldItalic.swiftUIFont(size: 36))
                        .foregroundColor(.appBrown)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Circle()
                        .foregroundColor(.clear)
                        .frame(width: 40, height: 40)
                }
                .padding(.bottom, 30)
                
                switch type {
                case .units:
                    VStack(spacing: 30) {
                        // Temperature unit selection
                        HStack(spacing: 15) {
                            Button {
                                selectedTemperatureUnit = .celsius
                                saveTemperatureUnit()
                            } label: {
                                Text("°C")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(selectedTemperatureUnit == .celsius ? .white : .appBrown)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(selectedTemperatureUnit == .celsius ? Color.appBrown : Color.appLight)
                                    .cornerRadius(30)
                            }
                            
                            Button {
                                selectedTemperatureUnit = .fahrenheit
                                saveTemperatureUnit()
                            } label: {
                                Text("°F")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(selectedTemperatureUnit == .fahrenheit ? .white : .appBrown)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(selectedTemperatureUnit == .fahrenheit ? Color.appBrown : Color.appLight)
                                    .cornerRadius(30)
                            }
                        }
                        
                        // Distance unit selection
                        HStack(spacing: 15) {
                            Button {
                                selectedDistanceUnit = .kilometers
                                saveDistanceUnit()
                            } label: {
                                Text("Km")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(selectedDistanceUnit == .kilometers ? .white : .appBrown)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(selectedDistanceUnit == .kilometers ? Color.appBrown : Color.appLight)
                                    .cornerRadius(30)
                            }
                            
                            Button {
                                selectedDistanceUnit = .miles
                                saveDistanceUnit()
                            } label: {
                                Text("Miles")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(selectedDistanceUnit == .miles ? .white : .appBrown)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(selectedDistanceUnit == .miles ? Color.appBrown : Color.appLight)
                                    .cornerRadius(30)
                            }
                        }
                    }
                case .data:
                    VStack(spacing: 30) {
                        Button {
                            showingClearHistoryAlert = true
                        } label: {
                            Text("Clearing your history")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.appBrown)
                        }
                        
                        Button {
                            showingClearAlert = true
                        } label: {
                            Text("Clearing favorites")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.appBrown)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationBarBackButtonHidden()
            .onAppear {
                loadUnits()
            }
            
            // Custom alert overlay for clearing history
            if showingClearHistoryAlert {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showingClearHistoryAlert = false
                    }
                
                VStack(spacing: 20) {
                    Text("Are you sure you want to clear your observation history?")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.appBrown)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                    
                    HStack(spacing: 15) {
                        Button {
                            showingClearHistoryAlert = false
                        } label: {
                            Text("Cancel")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.red)
                                .cornerRadius(30)
                        }
                        
                        Button {
                            showingClearHistoryAlert = false
                            observationsManager.clearUserHistory()
                            showSuccessMessage(text: "Observation history has been successfully cleared")
                        } label: {
                            Text("Remove")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.green)
                                .cornerRadius(30)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(Color.appLight)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.appBrown.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 40)
            }
            
            // Custom alert overlay for clearing favorites
            if showingClearAlert {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showingClearAlert = false
                    }
                
                VStack(spacing: 20) {
                    Text("Are you sure you want to reset all progress?")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.appBrown)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                    
                    HStack(spacing: 15) {
                        Button {
                            showingClearAlert = false
                        } label: {
                            Text("Cancel")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.red)
                                .cornerRadius(30)
                        }
                        
                        Button {
                            showingClearAlert = false
                            birdsManager.clearAllProgress()
                            showSuccessMessage(text: "All favorites and studied data has been successfully deleted")
                        } label: {
                            Text("Remove")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.green)
                                .cornerRadius(30)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(Color.appLight)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.appBrown.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 40)
            }
            
            // Success message overlay
            if showingSuccessMessage {
                VStack {
                    Text(successMessageText)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.appBrown)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundColor(Color.appLight.opacity(0.95))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.appBrown.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
            }
        }
    }
    
    // MARK: - UserDefaults Methods
    private func saveTemperatureUnit() {
        UserDefaults.standard.set(selectedTemperatureUnit.rawValue, forKey: "SelectedTemperatureUnit")
    }
    
    private func saveDistanceUnit() {
        UserDefaults.standard.set(selectedDistanceUnit.rawValue, forKey: "SelectedDistanceUnit")
    }
    
    private func loadUnits() {
        // Load temperature unit
        if let savedTempUnit = UserDefaults.standard.string(forKey: "SelectedTemperatureUnit"),
           let tempUnit = TemperatureUnit(rawValue: savedTempUnit) {
            selectedTemperatureUnit = tempUnit
        }
        
        // Load distance unit
        if let savedDistUnit = UserDefaults.standard.string(forKey: "SelectedDistanceUnit"),
           let distUnit = DistanceUnit(rawValue: savedDistUnit) {
            selectedDistanceUnit = distUnit
        }
    }
    
    private func showSuccessMessage(text: String) {
        successMessageText = text
        showingSuccessMessage = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showingSuccessMessage = false
        }
    }
}

// MARK: - Unit Enums
enum TemperatureUnit: String, CaseIterable {
    case celsius = "celsius"
    case fahrenheit = "fahrenheit"
}

enum DistanceUnit: String, CaseIterable {
    case kilometers = "kilometers"
    case miles = "miles"
}

#Preview {
    SettingDetailsView(observationsManager: ObservationsManager(), type: .units)
        .environmentObject(BirdsManager())
}
