import SwiftUI

import SimpleCommon

struct TrackableScrollViewTestView: View {
    @State var offset: CGFloat = .zero
    @State var showIndicator = true
    @State var axis = Axis.Set.vertical.rawValue
    var body: some View {
        TrackableScrollView(
            Axis.Set(rawValue: axis),
            showIndicators: showIndicator,
            contentOffset: $offset
        ) {
            VStack {
                Toggle(isOn: $showIndicator, label: { Text("Show indicator") })
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
