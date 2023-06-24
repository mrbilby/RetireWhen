//
//  ContentView.swift
//  RetireWhen
//
//  Created by James Bailey on 02/06/2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var moneyBank = MoneyBank()
    @ObservedObject var influences = Influences()

    @State private var newMoneyTitle = ""
    @State private var newMoneyType = ""
    @State private var newMoneyAmount: Float = 0.0
    @State private var newMoneyGrowth: Float = 0.0
    
    //@State private var addNewMoney = false
    @State private var moneyToEdit: Monies? // Moved into ContentView
    @State private var addOrEditMoney = false
    @State private var editMoney = false
    @State private var checkInstructions = false
    var totalValue: Float {
        moneyBank.money.reduce(0.0) { result, money in
            return money.regularity == "Lump" ? result + money.amount : result
        }
    }
    
    var futureValues: [Float] {
        moneyBank.money.flatMap { money -> [Float] in
            if money.regularity == "Lump" {
                return [money.amount * pow((1 + (money.growth / 100) / 12), 12 * Float(influences.targetYears))]
            } else if money.regularity == "Monthly" {
                return (1...12*influences.targetYears).map { month in
                    money.amount * pow((1 + (money.growth / 100) / 12), Float(month))
                }
            }
            return []
        }
    }
    
    var totalFutureValue: Float {
        futureValues.reduce(0, +)
    }
    var totalFutureValueInflated: Float {
        return totalFutureValue / pow(1 + Float((Float(influences.inflation) / 100)), Float(influences.targetYears))
    }
    
    
    var body: some View {

        NavigationView {
            List {
                Section(header:
                    VStack {
                        Text("RetireWhen")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()
                        HStack {
                            Text("% Inflation Assumed:")
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            TextField("Enter inflation rate", value: $influences.inflation, formatter: NumberFormatter())
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .frame(width: 30, height: 30, alignment: .leading)

                            Spacer()
                            Text("# Years Invested:")
                                
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            TextField("Enter years", value: $influences.targetYears, formatter: NumberFormatter())
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .frame(width: 30, height: 30, alignment: .leading)
                        }
                        .padding(.horizontal)
                    Text("Future position")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()

                    VStack(alignment: .leading) {

                        HStack {
                            Text("Total lump investments: ")
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(totalValue, specifier: "%.2f")")
                        }

                        HStack {
                            Text("Future position: ")
                                .fontWeight(.bold)
                            Spacer()
                            Text(" \(totalFutureValue, specifier: "%.2f")")
                        }

                        HStack {
                            Text("Inflation adjusted: ")
                                .fontWeight(.bold)
                            Spacer()
                            Text(" \(totalFutureValueInflated, specifier: "%.2f")")
                        }
                    }
                    .padding(.horizontal)

                        Text("Current positions: ")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.top)
                        
                    }

                )
                {
                    Text("Lump sums: ")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.top)
                    ForEach(moneyBank.money.indices, id: \.self) { index in
                        if moneyBank.money[index].regularity == "Lump" {
                            HStack {
                                Text(moneyBank.money[index].title)
                                    .font(.headline)
                                Spacer()
                                Text("\(moneyBank.money[index].amount, specifier: "%.2f")")
                                    .font(.body)
                            }
                            .padding(.horizontal)
                            .onTapGesture {
                                self.moneyToEdit = self.moneyBank.money[index]
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.editMoney = true
                                }
                            }
                        }
                    }
                    .onDelete(perform: removeMoney)
                    Text("Monthly: ")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.top)
                    ForEach(moneyBank.money.indices, id: \.self) { index in
                        if moneyBank.money[index].regularity == "Monthly" {
                            HStack {
                                Text(moneyBank.money[index].title)
                                    .font(.headline)
                                Spacer()
                                Text("\(moneyBank.money[index].amount, specifier: "%.2f")")
                                    .font(.body)
                            }
                            .padding(.horizontal)
                            .onTapGesture {
                                self.moneyToEdit = self.moneyBank.money[index]
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.editMoney = true
                                }
                            }
                        }
                    }
                    .onDelete(perform: removeMoney)
                }
                
                
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        moneyToEdit = nil // This should now be in scope
                        addOrEditMoney = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        checkInstructions = true
                    }) {
                        Text("Instructions")
                    }
                }
            }
            

            .sheet(isPresented: $addOrEditMoney, onDismiss: { moneyToEdit = nil }) {
                AddMonies(moneyBank: moneyBank)
            }
            .sheet(isPresented: $editMoney, onDismiss: { moneyToEdit = nil }) {
                EditMoney(moneyToEdit: $moneyToEdit, moneyBank: moneyBank)
            }
            .sheet(isPresented: $checkInstructions) {
                InstructionsView()
            }
            
        }
        .onTapGesture {
            self.endEditing()
        }

        
    }
    
    
    
    func removeMoney(at offsets: IndexSet) {
        moneyBank.money.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let moneyBank = MoneyBank()
        let influences = Influences()
        // Add necessary data to your objects
        
        ContentView(moneyBank: moneyBank, influences: influences)
    }
}
