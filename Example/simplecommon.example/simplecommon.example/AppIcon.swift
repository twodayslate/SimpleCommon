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

                icon?.thumbnail()

                HStack {
                    Text("AlternativeIconName")
                    Spacer()
                    Text("\(icon?.alternateIconName ?? "nil")")
                }

                HStack {
                    Text("assetnName")
                    Spacer()
                    Text("\(icon?.assetName ?? "nil")")
                }

                HStack {
                    Text("Bundle")
                    Spacer()
                    Text("\(icon?.bundle?.bundleIdentifier ?? "nil")")
                }
            }
        }
        .onAppear {
            SimpleAppIcon.allIcons.insert(.default)
        }
    }
}
