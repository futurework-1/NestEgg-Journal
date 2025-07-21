import SwiftUI

struct AddObservationView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var observationsManager: ObservationsManager
    
    @State private var title = ""
    @State private var selectedDate = Date()
    @State private var location = ""
    @State private var coordinates = ""
    @State private var description = ""
    @State private var showingDatePicker = false
    @State private var selectedImage = "image_1"
    @State private var hasSelectedImage = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    private var jsonDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    var body: some View {
        ZStack {
            Image(.backImg)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(.backNavButton)
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    Spacer()
                    Text("New note")
                        .font(FontFamily.PlayfairDisplay.extraBoldItalic.swiftUIFont(size: 36))
                        .foregroundColor(.appBrown)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Circle()
                        .foregroundColor(.clear)
                        .frame(width: 40, height: 40)
                }
                
                ScrollView {
                    VStack(spacing: 5) {
                        // Title Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(FontFamily.PlayfairDisplay.semiBold.swiftUIFont(size: 18))
                                .foregroundColor(.appBrown)
                            
                            TextField("Enter title", text: $title)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        // Date Field
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Date")
                                    .font(FontFamily.PlayfairDisplay.semiBold.swiftUIFont(size: 18))
                                    .foregroundColor(.appBrown)
                                
                                Spacer()
                                
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showingDatePicker.toggle()
                                    }
                                }) {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 20))
                                        .foregroundColor(.appBrown)
                                }
                            }
                            
                            if showingDatePicker {
                                VStack(spacing: 16) {
                                    HStack {
                                        Text(monthYearFormatter.string(from: selectedDate))
                                            .font(FontFamily.PlayfairDisplay.semiBold.swiftUIFont(size: 18))
                                            .foregroundColor(.appBrown)
                                        
                                        Spacer()
                                        
                                        Button("Done") {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                showingDatePicker = false
                                            }
                                        }
                                        .font(FontFamily.PlayfairDisplay.semiBold.swiftUIFont(size: 16))
                                        .foregroundColor(.appBrown)
                                    }
                                    
                                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .accentColor(.appBrown)
                                        .environment(\.colorScheme, .light)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .foregroundColor(Color.appLight.opacity(0.3))
                                )
                            } else {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showingDatePicker.toggle()
                                    }
                                }) {
                                    HStack {
                                        Text(dateFormatter.string(from: selectedDate))
                                            .foregroundColor(.appBrown)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(.appBrown.opacity(0.7))
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .foregroundColor(.clear)
                                    )
                                }
                            }
                        }
                        
                        // Location Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Location")
                                .font(FontFamily.PlayfairDisplay.semiBold.swiftUIFont(size: 18))
                                .foregroundColor(.appBrown)
                            
                            TextField("Enter location", text: $location)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        // Coordinates Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Coordinates")
                                .font(FontFamily.PlayfairDisplay.semiBold.swiftUIFont(size: 18))
                                .foregroundColor(.appBrown)
                            
                            TextField("Enter coordinates", text: $coordinates)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        // Description Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(FontFamily.PlayfairDisplay.semiBold.swiftUIFont(size: 18))
                                .foregroundColor(.appBrown)
                            
                            TextField("Enter description", text: $description)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        // Photo Field (placeholder)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Photo")
                                .font(FontFamily.PlayfairDisplay.semiBold.swiftUIFont(size: 18))
                                .foregroundColor(.appBrown)
                            
                            Button(action: {
                                selectRandomImage()
                            }) {
                                HStack {
                                    Image(systemName: "camera")
                                        .foregroundColor(.appBrown.opacity(0.7))
                                    Text("Add photo")
                                        .foregroundColor(.appBrown.opacity(0.7))
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .foregroundColor(Color.appLight.opacity(0.7))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.appBrown.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                            
                            if hasSelectedImage {
                                Image(selectedImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 250)
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.top, 20)
                }
                
                // ADD Button
                Button(action: addObservation) {
                    Text("ADD")
                        .font(FontFamily.PlayfairDisplay.semiBold.swiftUIFont(size: 24))
                        .foregroundColor(.appBrown)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundColor(Color.appLight)
                        )
                }
                .padding(.vertical, 20)
                .disabled(title.isEmpty || location.isEmpty)
                .opacity(title.isEmpty || location.isEmpty ? 0.6 : 1.0)
            }
            .padding(.horizontal)
            
        }
        .navigationBarBackButtonHidden()
    }
    
    private func addObservation() {
        let newObservation = Observation(
            title: title,
            location: location,
            coordinates: coordinates.isEmpty ? "0.0° N, 0.0° E" : coordinates,
            date: jsonDateFormatter.string(from: selectedDate),
            image: selectedImage,
            description: description
        )
        
        observationsManager.addObservation(newObservation)
        dismiss()
    }
    
    private func selectRandomImage() {
        let randomNumber = Int.random(in: 1...14)
        selectedImage = "image_\(randomNumber)"
        hasSelectedImage = true
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.clear)
            )
            .font(FontFamily.PlayfairDisplay.semiBold.swiftUIFont(size: 16))
            .foregroundColor(.appBrown)
    }
}

#Preview {
    AddObservationView(observationsManager: ObservationsManager())
} 
