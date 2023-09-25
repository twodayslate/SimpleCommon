//
//  AppIcon.swift
//  simplecommon.example
//
//  Created by Zachary Gorak on 9/24/23.
//

import Foundation
import SwiftUI
import SimpleCommon

extension SimpleAppIcon {
    static let `default` = SimpleAppIcon(alternateIconName: nil, assetName: "AppIcon-thumb")
}

struct AppIcon: View {
    @Environment(\.simpleAppIcon) var icon

    var body: some View {
        List {
            Section("Current") {
                HStack {
                    Spacer()
                    icon?.thumbnail()
                    Spacer()
                }
                LabeledContent("alternativeIconName", value: "\(icon?.alternateIconName ?? "nil")")
                LabeledContent("assetnName", value: "\(icon?.assetName ?? "nil")")
                LabeledContent("bundle", value: "\(icon?.bundle?.bundleIdentifier ?? "nil")")
            }
        }
        .onAppear {
            SimpleAppIcon.allIcons.insert(.default)
        }
    }
}
