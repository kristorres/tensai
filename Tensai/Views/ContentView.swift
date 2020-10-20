import SwiftUI

/// The content view.
struct ContentView: View {
    var body: some View {
        VStack {
            Text("🌎").font(.system(size: 100)).padding()
            Text("おはよう、世界！").font(.largeTitle).fontWeight(.black)
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
#endif
