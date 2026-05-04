import SwiftUI

struct NoteInputView: View {
    @Binding var note: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Note", systemImage: "note.text")
                    .font(.subheadline.bold())
                Spacer()
                if !note.trimmingCharacters(in: .whitespaces).isEmpty {
                    Button {
                        note = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }

            TextField("e.g. Near the elevator", text: $note)
                .textFieldStyle(.roundedBorder)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}
