import SwiftUI

/// A view that renders the content of the app.
struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
