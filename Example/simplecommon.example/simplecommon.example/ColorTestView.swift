import SwiftUI
import UIKit

import SimpleCommon

struct ColorTestView: View {
    let customColor = UIColor.init(red: 158.0/255.0, green: 38.0/255.0, blue: 27.0/255.0, alpha: 1.0)
    @State var date = Date()
    var body: some View {
        List {
            Text("Custom color name: \(customColor.name ?? "Unknown")")
                .id(date)
        }
        .onAppear {
            UIColor.additionalNameMapping[customColor] = "Lobsters Red"
            date = Date()
        }
    }
}
