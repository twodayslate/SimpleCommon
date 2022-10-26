import SwiftUI

/// Track the scroll offset
///
/// - SeeAlso: https://github.com/maxnatchanon/trackable-scroll-view
/// - SeeAlso: https://github.com/dkk/ScrollViewIfNeeded
public struct TrackableScrollView<Content>: View where Content: View {
    let axes: Axis.Set
    let showIndicators: Bool
    let dontScrollIfContentFits: Bool
    @Binding var contentOffset: CGFloat
    let content: () -> Content
    let preferenceKey: String

    @State var scrollViewSize: CGSize = .zero
    @State var contentSize: CGSize = .zero

    var scrollViewSizePreferenceKey: String {
        preferenceKey + "scrollViewSize"
    }
    var contentSizePreferenceKey: String {
        preferenceKey + "contentSize"
    }

    /// Creates a new instance that’s scrollable in the direction of the given axis and can show indicators while scrolling.
    /// - Parameters:
    ///   - axes: The scrollable axes of the scroll view.
    ///   - showIndicators: A value that indicates whether the scroll view displays the scrollable component of the content offset, in a way that’s suitable for the platform.
    ///   - preferenceKey: The unique base identifier for the preference keys used in this view
    ///   - dontScrollIfContentFits: A Boolean value indicating if scrolling should be disabled if the content fits inside the ScrollView
    ///   - contentOffset: A Binding to the content's offset value
    ///   - content: The scroll view’s content.
    public init(
        _ axes: Axis.Set = .vertical,
        showIndicators: Bool = true,
        id preferenceKey: String = "TrackableScrollViewPreferenceKey",
        dontScrollIfContentFits: Bool = false,
        contentOffset: Binding<CGFloat>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axes = axes
        self.showIndicators = showIndicators
        self._contentOffset = contentOffset
        self.content = content
        self.preferenceKey = preferenceKey
        self.dontScrollIfContentFits = dontScrollIfContentFits
    }

    var calculatedAxes: Axis.Set {
        if dontScrollIfContentFits, self.axes != [] {
            if axes == .vertical {
                return contentSize.height <= scrollViewSize.height ? [] : .vertical
            } else {
                return contentSize.width <= scrollViewSize.width ? [] : .horizontal
            }
        }

        return self.axes
    }

    public var body: some View {
        GeometryReader { outsideProxy in
            ScrollView(calculatedAxes, showsIndicators: self.showIndicators) {
                ZStack(alignment: self.axes == .vertical ? .top : .leading) {
                    GeometryReader { insideProxy in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: [self.preferenceKey: self.calculateContentOffset(fromOutsideProxy: outsideProxy, insideProxy: insideProxy)])
                    }
                    content()
                        .background {
                            GeometryReader { reader in
                                Color.clear
                                    .preference(key: GeometryReaderPreferenceKey.self, value: [contentSizePreferenceKey: reader])
                            }
                        }
                }
            }
            .background {
                GeometryReader { reader in
                    Color.clear
                        .preference(key: GeometryReaderPreferenceKey.self, value: [scrollViewSizePreferenceKey: reader])
                }
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                self.contentOffset = value[self.preferenceKey] ?? .zero
            }
            .onPreferenceChange(GeometryReaderPreferenceKey.self) { value in
                self.scrollViewSize = value[scrollViewSizePreferenceKey]?.size ?? .zero
                self.contentSize = value[contentSizePreferenceKey]?.size ?? .zero
            }
        }
    }

    private func calculateContentOffset(fromOutsideProxy outsideProxy: GeometryProxy, insideProxy: GeometryProxy) -> CGFloat {
        if axes == .vertical {
            return outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY
        } else {
            return outsideProxy.frame(in: .global).minX - insideProxy.frame(in: .global).minX
        }
    }
}

extension GeometryProxy: Equatable {
    public static func == (lhs: GeometryProxy, rhs: GeometryProxy) -> Bool {
        lhs.size == rhs.size && lhs.frame(in: .global) == rhs.frame(in: .global) && lhs.frame(in: .local) == rhs.frame(in: .local)
    }
}

struct GeometryReaderPreferenceKey: PreferenceKey {
    typealias Value = [String: GeometryProxy]

    static var defaultValue: [String: GeometryProxy] = [:]

    static func reduce(value: inout [String: GeometryProxy], nextValue: () -> [String: GeometryProxy]) {
        value.merge(nextValue()) { $1 }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = [String: CGFloat]

    static var defaultValue: [String: CGFloat] = [:]

    static func reduce(value: inout [String: CGFloat], nextValue: () -> [String: CGFloat]) {
        value.merge(nextValue()) { $1 }
    }
}
