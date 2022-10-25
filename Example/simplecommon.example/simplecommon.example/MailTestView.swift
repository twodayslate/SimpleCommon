import SwiftUI
import MessageUI

import SimpleCommon

struct MailTestView: View {
    @State var showSheet: Bool = false
    @State var showFullScreenCover: Bool = false
    @State var show = false
    @State var subject = "Test Subject"
    @State var result: Result<MFMailComposeResult, Error>?

    var composeView: some View {
        MailView(
            result: $result,
            subject: subject,
            toReceipt: ["to@me.com", "to@you.com"]
        )
    }

    var body: some View {
        VStack {
#if targetEnvironment(simulator)
            Text("This will not work in the simulator")
#endif
            if !MFMailComposeViewController.canSendMail() {
                Text("Unable to send mail!")
            }
            Spacer()
            TextField("Subject", text: $subject)
            Button {
                if MFMailComposeViewController.canSendMail() {
                    showSheet.toggle()
                }
            } label: {
                Text("Show Sheet")
            }
            Button {
                if MFMailComposeViewController.canSendMail() {
                    showFullScreenCover.toggle()
                }
            } label: {
                Text("Show FullScreenCover")
            }
            Button {
                show.toggle()
            } label: {
                Text("Show")
            }
            Spacer()
            HStack {
                Text("Result:")
                switch result {
                case .none:
                    Text("None")
                case .some(let wrapped):
                    switch wrapped {
                    case .failure(let error):
                        Text("Error: \(error.localizedDescription)")
                    case .success(let composeResult):
                        Text("Success")
                        switch composeResult {
                        case .cancelled:
                            Text("Cancelled")
                        case .failed:
                            Text("Failed")
                        case .saved:
                            Text("Saved")
                        case .sent:
                            Text("Sent")
                        @unknown default:
                            Text("Unknown")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showSheet, content: {
            composeView
        })
        .fullScreenCover(isPresented: $showFullScreenCover) {
            composeView
        }
        .composeMail(isPresented: $show, result: $result, subject: subject)
    }
}
