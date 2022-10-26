import SwiftUI

struct HorizontallyAlignedLabelStyle: LabelStyle {
    ///https://www.hackingwithswift.com/forums/swiftui/vertical-align-icon-of-label/3346
    @Environment(\.sizeCategory) var size

    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center) {
            if size >= .accessibilityMedium {
                configuration.icon
                    .frame(width: 80)
            } else {
                configuration.icon
                    .frame(width: 30)
            }
            configuration.title
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
public struct IconLabel: View {
    let iconBackgroundColor: Color
    let iconColor: Color
    let systemImage: String
    let image: Image?
    let imageName: String?
    let imageFile: String?
    let text: String
    let iconScale: CGFloat

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
        systemImage: String = "xmark.square",
        image: Image? = nil,
        imageName: String? = nil,
        imagePath: String? = nil,
        text: String,
        iconScale: Double = 0.6
    ) {
        self.iconBackgroundColor = iconBackgroundColor
        self.iconColor = iconColor
        self.systemImage = systemImage
        self.image = image
        self.imageName = imageName
        self.imageFile = imagePath
        self.text = text
        self.iconScale = iconScale
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
                        } else {
                            modified(image: Image(systemName: systemImage))
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
        .labelStyle(HorizontallyAlignedLabelStyle())
    }

    func modified(image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(CGSize(width: iconScale, height: iconScale))
            .foregroundColor(self.iconColor)
    }
}

struct IconLabel_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            IconLabel(text: "Hello")
            IconLabel(iconBackgroundColor: .blue, iconColor: .white, systemImage: "square", image: nil, text: "Hello Square @0.6", iconScale: 0.6)
            IconLabel(iconBackgroundColor: .blue, iconColor: .red, systemImage: "checkmark", image: nil, text: "Hello Checkmark @1.0", iconScale: 1.0)
        }
        .previewLayout(.sizeThatFits)
    }
}
