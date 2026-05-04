import SwiftUI
import SwiftData
import CoreLocation

struct QuickSaveView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var locationService = LocationService()
    @State private var photoService = PhotoService()
    @State private var floor: Int = 1
    @State private var zone: String = ""
    @State private var spotNumber: String = ""
    @State private var note: String = ""
    @State private var showCamera = false
    @State private var showSuccess = false
    @State private var capturedImage: UIImage?
    @State private var isSaving = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let image = capturedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(alignment: .topTrailing) {
                                Button { capturedImage = nil } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(.white, .black.opacity(0.6))
                                }
                                .padding(8)
                            }
                    } else {
                        PhotoPlaceholderView()
                            .onTapGesture { showCamera = true }
                    }

                    FloorZonePicker(floor: $floor, zone: $zone, spotNumber: $spotNumber)

                    if !note.isEmpty || capturedImage != nil {
                        NoteInputView(note: $note)
                    } else {
                        Button {
                            note = " "
                        } label: {
                            Label("Add Note", systemImage: "note.text")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Spacer(minLength: 20)

                    Button {
                        saveParkingSpot()
                    } label: {
                        if isSaving {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        } else {
                            Label("Save My Spot", systemImage: "parkingsign.circle.fill")
                                .font(.title3.bold())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .disabled(isSaving)
                }
                .padding()
            }
            .navigationTitle("ParkSnap")
            .fullScreenCover(isPresented: $showCamera) {
                CameraView { image in
                    capturedImage = image
                }
            }
            .alert("Spot Saved!", isPresented: $showSuccess) {
                Button("OK") { }
            } message: {
                Text("Floor \(floor == 0 ? "G" : (floor < 0 ? "B\(abs(floor))" : "\(floor)"))\(zone.isEmpty ? "" : ", Zone \(zone)")")
            }
            .onAppear {
                if locationService.authorizationStatus == .notDetermined {
                    locationService.requestPermission()
                }
            }
        }
    }

    private func saveParkingSpot() {
        isSaving = true
        locationService.getCurrentLocation { location in
            let spot = ParkingSpot(
                timestamp: .now,
                latitude: location?.coordinate.latitude ?? 0,
                longitude: location?.coordinate.longitude ?? 0,
                hasGPSCoordinates: location != nil,
                floor: floor,
                zone: zone,
                spotNumber: spotNumber,
                note: note.trimmingCharacters(in: .whitespaces),
                photoData: capturedImage.flatMap { photoService.compressImage($0) }
            )
            modelContext.insert(spot)
            isSaving = false
            showSuccess = true

            capturedImage = nil
            note = ""
        }
    }
}
