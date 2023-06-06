//
//  InstructionsView.swift
//  RetireWhen
//
//  Created by James Bailey on 06/06/2023.
//

import SwiftUI

struct InstructionsView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Instructions")
                .font(.largeTitle)
                .padding(.bottom)
            Text("This app is to help you track your investments and see how they may grow. Growth is calculated monthly, inflation annually. If you have requests or suggestions you are welcome to email requests to the email address on the support page in the AppStore. This app is free to use with no ads. Nothing here is financial advice and all my code and formulas are open source should you wish to make your own version.")
                .font(.title2)
                .fontWeight(.regular)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
            Spacer()
        }
    }
}

struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
    }
}
