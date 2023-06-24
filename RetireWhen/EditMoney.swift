//
//  EditMoney.swift
//  RetireWhen
//
//  Created by James Bailey on 05/06/2023.
//

import SwiftUI

import SwiftUI

struct EditMoney: View {
    @Environment(\.dismiss) var dismiss
    @Binding var moneyToEdit: Monies?
    @ObservedObject var moneyBank: MoneyBank

    @State private var newMoneyTitle = ""
    @State private var newMoneyType = ""
    @State private var newMoneyAmount: Float = 0.0
    @State private var newMoneyGrowth: Float = 0.0
    @State private var newRegularity = "Lump"
    let regularTypes = ["Lump", "Monthly"]

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Edit Money")
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
                    HStack {
                        Text("Regularity: ")
                            .fontWeight(.bold)
                        Spacer()
                        Picker("Regularity", selection: $newRegularity) {
                            ForEach(regularTypes, id: \.self) {
                                Text($0)
                            }

                        }
                        
                    }
                    .padding(.horizontal)
                    
                }
                .padding(.bottom)
                
                Button(action: {
                    if let money = moneyToEdit {
                        // Update existing Monies object
                        let index = moneyBank.money.firstIndex(where: {$0.id == money.id})
                        if let index = index {
                            moneyBank.money[index].title = newMoneyTitle
                            moneyBank.money[index].type = newMoneyType
                            moneyBank.money[index].amount = newMoneyAmount
                            moneyBank.money[index].growth = newMoneyGrowth
                            moneyBank.money[index].regularity = newRegularity
                            dismiss()

                        }
                    } else {
                        // Add new Monies object
                        let newMonies = Monies(title: newMoneyTitle, type: newMoneyType, amount: newMoneyAmount, growth: newMoneyGrowth, regularity: newRegularity)
                        moneyBank.money.append(newMonies)
                        dismiss()
                    }
                }) {
                    Text("Edit")
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
            .onAppear {
                if let money = moneyToEdit {
                    newMoneyTitle = money.title
                    newMoneyType = money.type
                    newMoneyAmount = money.amount
                    newMoneyGrowth = money.growth
                    newRegularity = money.regularity
                }
            }

        }
    }
}



struct EditMoney_Previews: PreviewProvider {
    static var previews: some View {
        AddMonies(moneyBank: MoneyBank())
    }
}


