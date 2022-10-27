import SwiftUI

import SimpleCommon

extension SimplePanelStyle: CustomStringConvertible {
    public var description: String {
        switch self {
        case .close:
            return "Close"
        case .cancel: return "Cancel"
        case .save: return "Save"
        case .saveAndCancel: return "Save and Cancel"
        case .done: return "Done"
        }
    }
}

struct SimplePanelTestView: View {
    @State var style = SimplePanelStyle.close
    @State var show = false
    var body: some View {
        VStack {
            Picker(selection: $style, content: {
                ForEach(SimplePanelStyle.allCases) { style in
                    Text("\(style.description)")
                        .tag(style)
                }
            }, label: {
                Text("\(style.description)")
            })
            Button {
                show.toggle()
            } label: {
                Text("Show")
            }
        }
        .sheet(isPresented: $show, content: {
            SimplePanel(style: style) {
                Text("Hello World!")
            }
        })
    }
}
