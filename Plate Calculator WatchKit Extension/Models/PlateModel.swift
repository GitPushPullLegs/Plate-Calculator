//
//  PlateModel.swift
//  Plate Calculator WatchKit Extension
//
//  Created by Jose Aguilar on 3/20/21.
//

import Foundation
import UIKit

struct Plate: Identifiable {
    let id = UUID()
    let weight: Double
    var color: UIColor
    var isActive: Bool = true

    var displayWeight: String {
        if weight == floor(weight) {
            return "\(Int(weight))"
        }
        return "\(weight)"
    }
    var count = 0

    mutating func updateCount(from weight: inout Double) {
        count = 0
        while weight - self.weight >= 0 {
            self.count += 1
            weight -= self.weight
        }
    }
}

struct Bar: Identifiable {
    let id = UUID()
    let weight: Int
    let title: String
}

class PlateModel: ObservableObject {
    @Published var bars: [Bar] = [
        Bar(weight: 45, title: "Barbell"), Bar(weight: 34, title: "Short"),
        Bar(weight: 20, title: "EZ"), Bar(weight: 75, title: "Trap"), Bar(weight: 0, title: "No Bar")
    ]

    @Published var plates: [Plate] = [
        Plate(weight: 55, color: UIColor.red), Plate(weight: 45, color: UIColor.blue),
        Plate(weight: 35, color: UIColor.yellow), Plate(weight: 25, color: UIColor.green),
        Plate(weight: 15, color: UIColor.white), Plate(weight: 10, color: UIColor.red),
        Plate(weight: 5, color: UIColor.blue), Plate(weight: 2.5, color: UIColor.yellow)
    ]

    @Published var currentBar: Int = 0
    @Published var currentWeight: Int = 0

    func toggleBar() {
        if currentBar == 4 {
            currentBar = 0
        } else {
            currentBar += 1
        }
        calculatePlates()
    }

    func calculatePlates() {
        var currWeight = Double(currentWeight - bars[currentBar].weight) / 2
        for index in 0..<plates.count {
            if plates[index].isActive {
                plates[index].updateCount(from: &currWeight)
            } else {
                plates[index].count = 0
            }
        }
    }
}
