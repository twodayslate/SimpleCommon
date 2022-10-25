import SwiftUI

import SimpleCommon

struct ShareSheetTestView: View {
    @State var contents = "Something to share"
    @State var show = false
    var body: some View {
        TextField("Contents", text: $contents)
        Button(action: {show.toggle()}, label: {
            Text("Show")
        })
            .sheet(isPresented: $show) {
                ShareSheetView(activityItems: [contents])
            }
    }
}
