import SwiftUI

struct HorizontallyAlignedLabelStyle: LabelStyle {
    ///https://www.hackingwithswift.com/forums/swiftui/vertical-align-icon-of-label/3346
    @Environment(\.sizeCategory) var size

    var style: any LabelStyle

    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center) {
            if size >= .accessibilityMedium {
                configuration.icon
                    .frame(width: 80)
            } else {
                configuration.icon
                    .frame(width: 30)
            }
            if !(style is IconOnlyLabelStyle) {
                configuration.title
            }
        }
    }
}

/// A standard label for user interface items, consisting of an app icon with a title.
///
/// This user interface component is very similiar to the labels used in Settings.app with
/// an application-like icon next to the label text
///
/// The icon will be searched for in the following order:
/// 1.  `image`
/// 2. `imagePath`
/// 3. `imageName`
/// 4. `systemImage`
public struct SimpleIconLabel<Content: View, S: StringProtocol>: View {
    let iconBackgroundColor: Color
    let iconColor: Color
    let systemImage: String?
    let image: Image?
    let imageName: String?
    let imageFile: String?
    let text: S
    let iconScale: CGFloat
    let view: () -> Content
    var labelStyle: any LabelStyle = TitleAndIconLabelStyle()

    /// Creates a label with an icon image and a title generated from a string.
    /// - Parameters:
    ///   - iconBackgroundColor: The icon's background color
    ///   - iconColor: The icon's foreground color
    ///   - systemImage: The system image name to use for the icon
    ///   - image: The image for the icon
    ///   - imageName: The image name for the icon
    ///   - imagePath: The image file path for the icon
    ///   - text: The label's text
    ///   - iconScale: The scale of the icon
    public init(
        iconBackgroundColor: Color = Color.accentColor,
        iconColor: Color = Color.white,
        systemImage: String? = nil,
        image: Image? = nil,
        imageName: String? = nil,
        imagePath: String? = nil,
        text: S,
        iconScale: Double = 0.6,
        @ViewBuilder view: @escaping () -> Content = { Color.clear }
    ) {
        self.iconBackgroundColor = iconBackgroundColor
        self.iconColor = iconColor
        self.systemImage = systemImage
        self.image = image
        self.imageName = imageName
        self.imageFile = imagePath
        self.text = text
        self.iconScale = iconScale
        self.view = view
    }

    public var body: some View {
        Label(
            title: {
                Text(text)
                    .foregroundColor(Color(UIColor.label))
            },
            icon: {
                Image(systemName: "app.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(self.iconBackgroundColor)
                    .overlay {
                        if let image = image {
                            modified(image: image)
                        }
                        else if let path = imageFile, let uiImage = UIImage(contentsOfFile: path) {
                            modified(image: Image(uiImage: uiImage))
                        }
                        else if let name = imageName {
                            modified(image: Image(name))
                        } else if let systemImage {
                            modified(image: Image(systemName: systemImage))
                        } else {
                            view()
                                .foregroundColor(iconColor)
                                .scaleEffect(CGSize(width: iconScale, height: iconScale))
                        }
                    }
                    .mask {
                        Image(systemName: "app.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.black)
                    }
            }
        )
        .labelStyle(HorizontallyAlignedLabelStyle(style: labelStyle))
    }

    func modified(image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(CGSize(width: iconScale, height: iconScale))
            .foregroundColor(self.iconColor)
    }

    /// Hides the title of this view.
    public func labelsHidden() -> Self {
        var _self = self
        _self.labelStyle = IconOnlyLabelStyle()
        return _self
    }
}

struct IconLabel_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            SimpleIconLabel(text: "Hello")
            SimpleIconLabel(iconBackgroundColor: .blue, iconColor: .white, systemImage: "square", image: nil, text: "Hello Square @0.6", iconScale: 0.6)
            SimpleIconLabel(iconBackgroundColor: .blue, iconColor: .red, systemImage: "checkmark", image: nil, text: "Hello Checkmark @1.0", iconScale: 1.0)
            SimpleIconLabel(iconBackgroundColor: .black, text: "Twitter", iconScale: 1.0) {
                Text("𝕏")
            }
            SimpleIconLabel(systemImage: "eye.slash", text: "Hidden")
                .labelsHidden()
        }
        .previewLayout(.sizeThatFits)
    }
}
