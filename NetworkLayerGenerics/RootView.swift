//
//  RootView.swift
//  NetworkLayerGenerics
//
//  Created by Peter Kos on 7/27/24.
//

import SwiftUI

@MainActor
struct RootView: View {
    @State private var loginData: Login?

    var body: some View {
        Group {
            if let loginData {
                VStack {
                    Text("User **\(loginData.first_name) \(loginData.last_name)** logged in!")
                }
                .transition(.blurReplace)
            } else {
                Text("Loading...")
                    .transition(.blurReplace)
            }
        }
        .task {
            // There would be a bunch of Endpoint/Service code
            // that is omitted as an exercise for the reader :)
            let url = URL(string: "https://mock.endpts.io?ep_data_source=static&ep_body=%7B%0A++%22randomBackendDataWeNeedToUnwrap%22%3A+%22blah+blah%22%2C%0A++%22data%22%3A+%7B%0A++++%22id%22%3A+%225cf2bc99-2721-407d-8592-ba00fbdf302f%22%2C%0A++++%22first_name%22%3A+%22Lia%22%2C%0A++++%22last_name%22%3A+%22Moore%22%2C%0A++++%22username%22%3A+%22Judson.Kemmer52%22%2C%0A++++%22email%22%3A+%22Gregg_Beahan36%40yahoo.com%22%0A++%7D%0A%7D")!
            let result = await AppNetwork<Login>.get(url: url)

            switch result {
            case let .success(login):
                loginData = login
            case let .failure(error):
                print("Error: \(optional: error.fullDescription)")
            }
        }
    }
}

#Preview {
    RootView()
}
