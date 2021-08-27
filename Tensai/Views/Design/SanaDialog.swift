import SwiftUI

/// A dialog that provides critical information and asks for a decision.
struct SanaDialog<Content>: View where Content: View {
    
    /// The title of this dialog.
    private let title: String
    
    /// The closure to render the content of this dialog.
    private let content: () -> Content
    
    /// The primary action button.
    private let primaryButton: SanaDialogButton
    
    /// The secondary action button.
    private let secondaryButton: SanaDialogButton?
    
    /// Creates a dialog with the specified title, content, and action buttons.
    ///
    /// - Parameter title:           The title of the dialog.
    /// - Parameter content:         The closure to render the content of the
    ///                              dialog.
    /// - Parameter primaryButton:   The primary action button.
    /// - Parameter secondaryButton: The secondary action button. The default is
    ///                              `nil`.
    init(
        title: String,
        content: @escaping () -> Content,
        primaryButton: SanaDialogButton,
        secondaryButton: SanaDialogButton? = nil
    ) {
        self.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        self.content = content
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }
    
    var body: some View {
        SanaCard {
            VStack(spacing: 0) {
                header
                Divider()
                content()
                Divider()
                footer
            }
        }
    }
    
    /// The footer in this dialog.
    private var footer: some View {
        HStack {
            Spacer()
            if let secondaryButton = self.secondaryButton {
                SanaButton(
                    secondaryButton.title,
                    action: secondaryButton.action
                )
            }
            SanaButton(primaryButton.title, action: primaryButton.action)
        }
            .padding(DrawingConstants.footerPadding)
    }
    
    /// The header in this dialog.
    private var header: some View {
        HStack {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.ColorPalette.surface.contentColor)
            Spacer()
        }
            .padding()
    }
}

/// A button that represents an action in responding to a dialog.
struct SanaDialogButton {
    
    /// The title that is displayed on this button.
    let title: String
    
    /// The action to perform when a user taps on this button.
    let action: () -> Void
    
    /// Creates a dialog button with the specified title and action.
    ///
    /// - Parameter title:  The title that is displayed on the button.
    /// - Parameter action: The action to perform when a user taps on the
    ///                     button.
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
}

/// A struct that contains drawing constants.
fileprivate struct DrawingConstants {
    
    /// The padding in a dialog’s footer.
    static let footerPadding: CGFloat = 4
}

#if DEBUG
struct SanaDialog_Previews: PreviewProvider {
    static var previews: some View {
        SanaDialog(
            title: "Dialog Header",
            content: {
                VStack(alignment: .leading) {
                    ForEach(0 ..< 4) { index in
                        HStack {
                            Image(systemName: "star")
                                .foregroundColor(
                                    AppTheme.ColorPalette.primary.mainColor
                                )
                            Text("Item \(index + 1)")
                            Spacer()
                        }
                            .padding(.vertical, 4)
                    }
                }
                    .foregroundColor(AppTheme.ColorPalette.surface.contentColor)
                    .frame(maxWidth: .infinity)
                    .padding()
            },
            primaryButton: SanaDialogButton("Action 1") {},
            secondaryButton: SanaDialogButton("Action 2") {}
        )
            .frame(width: 320)
            .padding()
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
}
#endif
