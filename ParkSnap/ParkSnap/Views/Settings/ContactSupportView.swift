import SwiftUI

struct ContactSupportView: View {
    @State private var message = ""
    @State private var email = ""
    @State private var showSent = false

    var body: some View {
        Form {
            Section("Your Email") {
                TextField("email@example.com", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
            }

            Section("Message") {
                TextField("Describe your issue or feedback...", text: $message, axis: .vertical)
                    .lineLimit(3...8)
            }

            Section {
                Button("Send Feedback") {
                    sendFeedback()
                }
                .disabled(message.isEmpty || email.isEmpty)
            }
        }
        .navigationTitle("Contact Support")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Feedback Sent!", isPresented: $showSent) {
            Button("OK") { message = ""; email = "" }
        } message: {
            Text("Thank you for your feedback!")
        }
    }

    private func sendFeedback() {
        let subject = "ParkSnap Feedback"
        let body = "\(message)\n\nEmail: \(email)\niOS: \(UIDevice.current.systemVersion)"
        let encoded = "mailto:parksnap.support@zzoutuo.com?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        if let url = URL(string: encoded) {
            UIApplication.shared.open(url)
        }
        showSent = true
    }
}
