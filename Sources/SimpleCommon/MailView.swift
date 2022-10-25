import SwiftUI
import UIKit
import MessageUI

///https://stackoverflow.com/a/56785754/193772
public struct MailView: UIViewControllerRepresentable {

    @Binding var result: Result<MFMailComposeResult, Error>?
    @Environment(\.dismiss) private var dismiss
    var subject: String
    var toReceipt: [String]?

    public init(
        result: Binding<Result<MFMailComposeResult, Error>?>,
        subject: String,
        toReceipt: [String]? = nil
    ) {
        self._result = result
        self.subject = subject
        self.toReceipt = toReceipt
    }

    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var result: Result<MFMailComposeResult, Error>?
        var dismiss: DismissAction


        init(result: Binding<Result<MFMailComposeResult, Error>?>,
             dismiss: DismissAction) {
            _result = result
            self.dismiss = dismiss
        }

        public func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                DispatchQueue.main.async { [self] in
                    dismiss()
                }
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(result: $result, dismiss: dismiss)
    }

    public func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(toReceipt)
        vc.setSubject(subject)
        // Set CC, BCC, Body, Attachements
        return vc
    }

    public func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {
        // no-op
    }
}

struct MailComposeViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?

    var subject: String
    var recipients: [String]

    func body(content: Content) -> some View {
        //MFMailComposeViewController.canSendMail()
        content
            .sheet(isPresented: .init(get: {
            MFMailComposeViewController.canSendMail() && isPresented
        }, set: {
            isPresented = $0
        })) {
            MailView(result: $result, subject: subject, toReceipt: recipients)
        }
        .onChange(of: isPresented) { value in
            if value, !MFMailComposeViewController.canSendMail() {
                let error = NSError(domain: NSCocoaErrorDomain, code: NSFeatureUnsupportedError)
                result = .failure(error)
            }
        }
    }
}

public extension View {
    func composeMail(
        isPresented: Binding<Bool>,
        result: Binding<Result<MFMailComposeResult, Error>?>,
        subject: String,
        recipients: [String]? = []) -> some View {
        self.modifier(MailComposeViewModifier(isPresented: isPresented, result: result, subject: subject, recipients: recipients ?? []))
    }
}
