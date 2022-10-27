import SwiftUI

import SimpleCommon

struct ShareSheetTestView: View {
    @State var contents = "Something to share"
    @State var show = false
    var body: some View {
        TextField("Contents", text: $contents)
        Button {
            UIApplication.shared.dismissKeyboard()
        } label: {
            Text("Dismiss keyboard (UIApplication)")
        }
        Button(action: {show.toggle()}, label: {
            Text("Show")
        })
            .sheet(isPresented: $show) {
                SimpleShareSheetView(activityItems: [contents])
            }
    }
}
