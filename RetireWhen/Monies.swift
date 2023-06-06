//
//  Monies.swift
//  RetireWhen
//
//  Created by James Bailey on 02/06/2023.
//

import Foundation

struct Monies: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var title: String
    var type: String // what is the investment and any comments
    var amount: Float
    var growth: Float // how much will it grow
}

class Influences: ObservableObject, Codable {
    @Published var inflation = 0.02 {
        didSet {
            save()
        }
    }

    @Published var targetYears = 0 {
        didSet {
            save()
        }
    }

    enum CodingKeys: CodingKey {
        case inflation, targetYears
    }

    // Codable conformance
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        inflation = try container.decode(Double.self, forKey: .inflation)
        targetYears = try container.decode(Int.self, forKey: .targetYears)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(inflation, forKey: .inflation)
        try container.encode(targetYears, forKey: .targetYears)
    }
    init() {
        if let saved = UserDefaults.standard.data(forKey: "Influences") {
            let decoder = JSONDecoder()
            if let loaded = try? decoder.decode(Influences.self, from: saved) {
                self.inflation = loaded.inflation
                self.targetYears = loaded.targetYears
            }
        }
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "Influences")
        }
    }

}


class MoneyBank: ObservableObject {
    @Published var money: [Monies] {
        didSet {
            if let encoded = try? JSONEncoder().encode(money) {
                UserDefaults.standard.set(encoded, forKey: "Monies")
            }
        }
    }

    init() {

        if let saved = UserDefaults.standard.data(forKey: "Monies") {
            if let decoded = try? JSONDecoder().decode([Monies].self, from: saved) {
                money = decoded
                return
            }
        }

        money = []
    }
}
