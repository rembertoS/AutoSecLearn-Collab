import SwiftUI

// MARK: - AlecView
// Entry point for Alec's tab in the app.
// This view simply delegates to CertListView, which handles
// all the navigation and content for the certificate recommendations section.
struct AlecView: View {
    var body: some View {
        CertListView()
    }
}
