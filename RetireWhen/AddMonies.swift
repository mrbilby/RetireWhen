//
//  AddMonies.swift
//  RetireWhen
//
//  Created by James Bailey on 02/06/2023.
//

import SwiftUI

struct AddMonies: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var moneyBank: MoneyBank

    @State private var newMoneyTitle = ""
    @State private var newMoneyType = ""
    @State private var newMoneyAmount: Float = 0.0
    @State private var newMoneyGrowth: Float = 0.0
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Add New Money")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.gray)
                    .padding()

                VStack(alignment: .leading) {
                    TextField("Title", text: $newMoneyTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    TextView(text: $newMoneyType, placeholder: "Enter any comments here...")
                        .frame(height: 100) // set the height as required
                        .border(Color.gray, width: 0.2)
                        .padding(.horizontal)
                    HStack {
                        Text("Amount invested: ")
                            .fontWeight(.bold)
                        Spacer()
                        TextField("Amount", value: $newMoneyAmount, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100, alignment: .trailing)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("Growth percentage: ")
                            .fontWeight(.bold)
                        Spacer()
                        TextField("Growth", value: $newMoneyGrowth, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100, alignment: .trailing)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
                
                Button(action: {

                    let newMonies = Monies(title: newMoneyTitle, type: newMoneyType, amount: newMoneyAmount, growth: newMoneyGrowth)
                    moneyBank.money.append(newMonies)
                    dismiss()
                }) {
                    Text("Add")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                Spacer()
                Spacer()
            }

        }
    }
}



struct AddMonies_Previews: PreviewProvider {
    static var previews: some View {
        AddMonies(moneyBank: MoneyBank())
    }
}

