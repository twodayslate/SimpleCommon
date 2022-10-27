//
//  SafariActivity.swift
//  claw
//
//  Created by Zachary Gorak on 9/22/20.
//

import Foundation
import UIKit

/**
 An Open in Safari action for URLs
 */
public class SimpleSafariActivity: UIActivity {
    public override var activityImage: UIImage? {
        let largeConfig = UIImage.SymbolConfiguration(scale: .large)
        return UIImage(systemName: "safari", withConfiguration: largeConfig)
    }

    open override var activityTitle: String? {
        return "Open in Default Browser"
    }

    public override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for item in activityItems {
            if let url = item as? URL, UIApplication.shared.canOpenURL(url) {
                return true
            }
        }
        return false
    }

    var urls = [URL]()

    public override func prepare(withActivityItems activityItems: [Any]) {
        for item in activityItems {
            if let url = item as? URL, UIApplication.shared.canOpenURL(url) {
                urls.append(url)
            }
        }
    }

    public override func perform() {
        guard let url = urls.first else {
            self.activityDidFinish(false)
            return
        }

        UIApplication.shared.open(url, completionHandler: { status in
            self.activityDidFinish(status)
        })
    }
}
