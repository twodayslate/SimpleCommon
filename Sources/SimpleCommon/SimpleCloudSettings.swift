import SwiftUI
#if canImport(CloudKitSyncMonitor)
import CloudKitSyncMonitor

public struct SimpleCloudSettings: View {
    @ObservedObject var syncMonitor = SyncMonitor.shared

    var body: some View {
        List {
            LabeledContent {
                Text(stateText(for: syncMonitor.setupState))
            } label: {
                Text("Setup State")
            }
            LabeledContent {
                Text(stateText(for: syncMonitor.exportState))
            } label: {
                Text("Export State")
            }

            LabeledContent {
                Text(stateText(for: syncMonitor.importState))
            } label: {
                Text("Import State")
            }

            Section("Errors") {
                if hasError {
                    if syncMonitor.notSyncing {
                        Text("Sync should be working, but isn't. Look for a badge on Settings or other possible issues.")
                    }
                    if syncMonitor.syncError {
                        if let e = syncMonitor.setupError {
                            Text("Unable to set up iCloud sync, changes won't be saved! \(e.localizedDescription)")
                        }
                        if let e = syncMonitor.importError {
                            Text("Import is broken: \(e.localizedDescription)")
                        }
                        if let e = syncMonitor.exportError {
                            Text("Export is broken - your changes aren't being saved! \(e.localizedDescription)")
                        }
                    }
                } else {
                    Text("No errors detected")
                }
            }
        }
        .navigationBarTitle("iCloud Status")
    }

    var hasError: Bool {
        syncMonitor.syncError || syncMonitor.notSyncing
    }

    fileprivate var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        return dateFormatter
    }()

    /// Returns a user-displayable text description of the sync state
    func stateText(for state: SyncMonitor.SyncState) -> String {
        switch state {
        case .notStarted:
            return "Not started"
        case .inProgress(started: let date):
            return "In progress since \(dateFormatter.string(from: date))"
        case let .succeeded(started: _, ended: endDate):
            return "Suceeded at \(dateFormatter.string(from: endDate))"
        case let .failed(started: _, ended: endDate, error: _):
            return "Failed at \(dateFormatter.string(from: endDate))"
        }
    }
}

#endif
