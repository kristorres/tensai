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
        let viewName = "Content View"
        return Group {
            ContentView()
                .previewDevice("iPhone SE (1st generation)")
                .previewDisplayName("\(viewName) — iPhone SE 1")
            ContentView()
                .previewDevice("iPhone X")
                .previewDisplayName("\(viewName) — iPhone X")
            ContentView()
                .previewDevice("iPhone X")
                .preferredColorScheme(.dark)
                .previewDisplayName("\(viewName) — iPhone X (Dark Mode)")
            ContentView()
                .previewDevice("iPad Air (4th generation)")
                .previewDisplayName("\(viewName) — iPad Air 4")
        }
    }
}
#endif
