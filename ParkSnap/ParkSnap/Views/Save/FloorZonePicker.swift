import SwiftUI

struct FloorZonePicker: View {
    @Binding var floor: Int
    @Binding var zone: String
    @Binding var spotNumber: String

    private let zones = ["A", "B", "C", "D", "E", "F", "G", "H"]
    private let floors = Array(-3...20)

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Label("Floor", systemImage: "building.2")
                    .font(.subheadline.bold())
                Spacer()
                Picker("Floor", selection: $floor) {
                    ForEach(floors, id: \.self) { f in
                        Text(f == 0 ? "G" : (f < 0 ? "B\(abs(f))" : "\(f)"))
                            .tag(f)
                    }
                }
                .pickerStyle(.menu)
            }

            HStack {
                Label("Zone", systemImage: "location.square")
                    .font(.subheadline.bold())
                Spacer()
                Picker("Zone", selection: $zone) {
                    Text("None").tag("")
                    ForEach(zones, id: \.self) { z in
                        Text(z).tag(z)
                    }
                }
                .pickerStyle(.segmented)
            }

            HStack {
                Label("Spot #", systemImage: "number")
                    .font(.subheadline.bold())
                Spacer()
                TextField("e.g. 42", text: $spotNumber)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                    .keyboardType(.numberPad)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}
