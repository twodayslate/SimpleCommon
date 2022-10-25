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
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
