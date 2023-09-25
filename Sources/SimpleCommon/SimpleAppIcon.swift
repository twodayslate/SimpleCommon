import SwiftUI

public struct SimpleAppIcon: Sendable, Codable, Equatable, Hashable {
    /// The name of the icon the system displays for the app.
    /// - SeeAlso: ``UIApplication.shared.alternateIconName``
    public let alternateIconName: String?
    /// The name of the image resource to lookup, as well as the
    /// localization key with which to label the image.
    public let assetName: String
    ///  The bundle to search for the image resource and localization
    ///  content. If `nil`, SwiftUI uses the main `Bundle`. Defaults to `nil`.
    public let bundle: Bundle?

    enum Keys: CodingKey {
        case alternativeIconName
        case assetName
        case bundleIdentifier
        case bundlePath
        case bundleURL
        case classNameForBundle
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.alternateIconName = try container.decode(String?.self, forKey: .alternativeIconName)
        self.assetName = try container.decode(String.self, forKey: .assetName)
        if let bundleIdentifier = try container.decodeIfPresent(String.self, forKey: .bundleIdentifier) {
            self.bundle = Bundle(identifier: bundleIdentifier)
        } else if let path = try container.decodeIfPresent(String.self, forKey: .bundlePath) {
            self.bundle = Bundle(path: path)
        } else if let url = try container.decodeIfPresent(URL.self, forKey: .bundleURL) {
            self.bundle = Bundle(url: url)
        } else if let className = try container.decodeIfPresent(String.self, forKey: .classNameForBundle), let anyClass = NSClassFromString(className) {
            self.bundle = Bundle(for: anyClass)
        } else {
            self.bundle = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(alternateIconName, forKey: .alternativeIconName)
        try container.encode(assetName, forKey: .assetName)
        if let bundle, bundle != .main {
            if let bundleIdentifier = bundle.bundleIdentifier {
                try container.encode(bundleIdentifier, forKey: .bundleIdentifier)
            }
            try container.encode(bundle.bundlePath, forKey: .bundlePath)
            try container.encode(bundle.bundleURL, forKey: .bundleURL)
            if let principalClass = bundle.principalClass {
                let cString = class_getName(principalClass)
                let name = String(cString: cString)
                if !name.isEmpty {
                    try container.encode(name, forKey: .classNameForBundle)
                }
            }
        }
    }

    public init(alternateIconName: String?, assetName: String, bundle: Bundle? = nil) {
        self.alternateIconName = alternateIconName
        self.assetName = assetName
        self.bundle = bundle
    }

    public func thumbnail(size: CGFloat = 64) -> some View {
        image
            .resizable()
            .frame(width: size, height: size)
            .mask(
                Image(systemName: "app.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            )
    }

    public var image: Image {
        Image(assetName, bundle: bundle)
    }

    static public var allIcons = Set<SimpleAppIcon>()

    static public var current: SimpleAppIcon? {
        allIcons.filter {
            $0.alternateIconName == UIApplication.shared.alternateIconName
        }.first
    }

}

@MainActor
public class AppIconModel: ObservableObject {
    @Published public private(set) var icon = SimpleAppIcon.current

    public enum Errors: Error {
        case alternativeIconsNotSupported
    }

    public func set(_ icon: SimpleAppIcon) async throws {
        guard UIApplication.shared.supportsAlternateIcons else {
            throw Errors.alternativeIconsNotSupported
        }
        try await withCheckedThrowingContinuation { continuation in
            UIApplication.shared.setAlternateIconName(icon.alternateIconName) { error in
                if error == nil {
                    self.icon = icon
                    continuation.resume()
                } else {
                    self.reset()
                    continuation.resume(throwing: error!)
                }
            }
        }
    }

    func reset() {
        self.icon = SimpleAppIcon.current
    }

    func badSet(_ icon: SimpleAppIcon?) {
        guard let icon else {
            return
        }
        Task {
            try await set(icon)
        }
    }

}

private struct IconEnvironmentKey: EnvironmentKey {
    static let defaultValue: AppIconModel? = nil
}

extension EnvironmentValues {
    @MainActor public var simpleAppIcon: SimpleAppIcon? {
        get { self[IconEnvironmentKey.self]?.icon ?? AppIconModel().icon }
        set {
            self[IconEnvironmentKey.self]?.badSet(newValue)
        }
    }

    @MainActor public var simpleAppIconModel: AppIconModel? {
        get { self[IconEnvironmentKey.self] ?? AppIconModel() }
        set {
            self[IconEnvironmentKey.self] = newValue
        }
    }

}
