import SwiftUI

/// The **root view** for *Tensai*.
struct RootView: View {
    var body: some View {
        VStack {
            Text("🌎").font(.system(size: 100)).padding()
            Text("おはよう、世界！").font(.largeTitle).fontWeight(.black)
        }
    }
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        let viewName = "Root View"
        return Group {
            RootView()
                .previewDevice("iPhone SE (1st generation)")
                .previewDisplayName("\(viewName) — iPhone SE 1")
            RootView()
                .previewDevice("iPhone X")
                .previewDisplayName("\(viewName) — iPhone X")
            RootView()
                .previewDevice("iPhone X")
                .preferredColorScheme(.dark)
                .previewDisplayName("\(viewName) — iPhone X (Dark Mode)")
            RootView()
                .previewDevice("iPad Air (4th generation)")
                .previewDisplayName("\(viewName) — iPad Air 4")
        }
    }
}
#endif
