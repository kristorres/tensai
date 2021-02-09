#if DEBUG
import SwiftUI

struct DevicePreviewGroup<Content>: View where Content: View {
    let name: String
    let view: Content
    var body: some View {
        Group {
            view
                .previewDevice("iPhone SE (1st generation)")
                .previewDisplayName("\(name) — iPhone SE 1")
            view
                .previewDevice("iPhone X")
                .previewDisplayName("\(name) — iPhone X")
            view
                .previewDevice("iPad Air (4th generation)")
                .previewDisplayName("\(name) — iPad Air 4")
        }
    }
}
#endif
