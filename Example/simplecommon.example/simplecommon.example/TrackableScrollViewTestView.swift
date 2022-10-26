import SwiftUI

import SimpleCommon

struct TrackableScrollViewTestView: View {
    @State var offset: CGFloat = .zero
    @State var showIndicator = true
    @State var dontScrollIfFits = false
    @State var axis = Axis.Set.vertical.rawValue
    var body: some View {
        TrackableScrollView(
            Axis.Set(rawValue: axis),
            showIndicators: showIndicator,
            dontScrollIfContentFits: dontScrollIfFits,
            contentOffset: $offset
        ) {
            VStack {
                Toggle(isOn: $showIndicator, label: { Text("Show indicator") })
                Toggle(isOn: $dontScrollIfFits, label: { Text("Don't scroll if content fits")})
                Picker("Axis", selection: $axis) {
                    Text("Horizontal")
                        .tag(Axis.Set.horizontal.rawValue)
                    Text("Vertical")
                        .tag(Axis.Set.vertical.rawValue)
                }
                Text("\(offset)")
            }
            .padding()
        }
    }
}
