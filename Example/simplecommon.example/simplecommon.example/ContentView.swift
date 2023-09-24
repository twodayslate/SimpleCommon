//
//  ContentView.swift
//  simplecommon.example
//
//  Created by Zachary Gorak on 10/25/22.
//

import SwiftUI



struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Test Mail", destination: MailTestView())
                NavigationLink("Test Share Sheet", destination: ShareSheetTestView())
                NavigationLink("Test TrackableScrollView", destination: TrackableScrollViewTestView())
                NavigationLink("Test SimplePanel", destination: SimplePanelTestView())
                NavigationLink("Test Color", destination: ColorTestView())
                NavigationLink("Test AppIcon", destination: AppIcon())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
