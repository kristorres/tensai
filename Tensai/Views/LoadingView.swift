import SwiftUI

/// A view with a dark translucent background that shows a circular activity
/// indicator spinning indefinitely in its center.
struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.75).ignoresSafeArea()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(2)
        }
    }
}

#if DEBUG
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        DevicePreviewGroup(name: "Loading View", view: LoadingView())
    }
}
#endif
