import SwiftUI
import UIKit

/// A wrapper view for presenting a view with pre-defined NavigationView leading and trailing items
///
/// Use ``SimplePanel`` to wrap a view inside a ``NavigationView`` with pre-defined
/// leading and trailing items. See ``SimplePanelStyle`` for a list of available styles.
public struct SimplePanel<Content>: View where Content: View {
    let style: SimplePanelStyle
    let leadingAction: (() async throws -> Void)?
    let trailingAction: (() async throws -> Void)?
    let content: () -> Content

    @Environment(\.dismiss) private var dismiss

    /// A content wrapper useful for sheets
    /// - Parameters:
    ///   - style: The panel's style
    ///   - leadingAction: The action for the leading navigation bar item
    ///   - trailingAction: The action for the trailing navigation bar item
    ///   - content: The content to show in the panel
    ///
    ///   If the action does not throw then the view will be dismissed
    public init(
        style: SimplePanelStyle = .close,
        leadingAction: ( () async throws -> Void)? = nil,
        trailingAction: (() async throws -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self.style = style
        self.leadingAction = leadingAction
        self.trailingAction = trailingAction
    }

    @ViewBuilder var trailingItem: some View {
        switch style {
        case .close:
            Image(systemName: "xmark.circle.fill")
            #if !os(tvOS)
                .foregroundColor(Color(UIColor.systemGray3))
            #endif
        case .save:
            Text("Save")
        case .saveAndCancel:
            Text("Save")
                .bold()
        case .cancel:
            Text("Cancel")
        case .done:
            Text("Done")
        }
    }

    @ViewBuilder var leadingItem: some View {
        switch style {
        case .saveAndCancel:
            Text("Cancel")
        default:
            EmptyView()
        }
    }

    @ViewBuilder var leadingButton: some View {
        Button(role: .cancel, action: {
            Task {
                do {
                    try await self.leadingAction?()
                    dismiss()
                } catch {
                    // no-op
                }
            }
        }, label: {
            leadingItem
        })
    }

    @ViewBuilder var trailingButton: some View {
        switch style {
        case .cancel:
            Button(role: .cancel) {
                doTrailingAction()
            } label: {
                trailingItem
            }
        case .close:
            Button {
                doTrailingAction()
            } label: {
                trailingItem
            }
            #if os(tvOS)
            .buttonStyle(.card)
            #endif
        default:
            Button {
                doTrailingAction()
            } label: {
                trailingItem
            }
        }
    }

    func doTrailingAction() {
        Task {
            do {
                try await trailingAction?()
                dismiss()
            } catch {
                // no-op
            }
        }
    }

    var hasLeading: Bool {
        style == .saveAndCancel
    }

    public var body: some View {
        NavigationView {
            if hasLeading {
                content()
                    .navigationBarItems(
                        leading: leadingButton,
                        trailing: trailingButton
                    )
            } else {
                content()
                    .navigationBarItems(
                        trailing: trailingButton
                    )
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(SimplePanelStyle.allCases) { style in
            SimplePanel(style: style) {
                Text("Hello World")
            }
        }
    }
}
