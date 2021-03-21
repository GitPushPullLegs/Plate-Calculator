//
//  PlateView.swift
//  Plate Calculator WatchKit Extension
//
//  Created by Jose Aguilar on 3/20/21.
//

import SwiftUI

struct PlateView: View {

    @ObservedObject var model: PlateModel
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        GeometryReader { geometry in
            VStack() {
                HStack {
                    Button(action: model.toggleBar, label: {
                        Text(model.bars[model.currentBar].title)
                    })
                    .cornerRadius(1)
                    Picker(selection: $model.currentWeight, label: Text("Picker")) {
                        ForEach(Array(stride(from: 0, to: 1000, by: 5)), id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                    .onChange(of: model.currentWeight, perform: { value in
                        model.calculatePlates()
                    })
                    .labelsHidden()
                }
                LazyVGrid(columns: columns, alignment: .leading, spacing: 4) {
                    ForEach(0..<model.plates.count) { index in
                        PlateCell(plate: self.$model.plates[index])
                    }
                }
                .frame(maxHeight: geometry.size.height * 0.85)
            }
        }
        .ignoresSafeArea(edges: .bottom)

    }
}

struct PlateCell: View {
    @Binding var plate: Plate

    var body: some View {
        HStack {
            PlateCircle(plate: plate)
            Text(" x \(plate.count)")
                .foregroundColor(plate.isActive ? .white : Color.white.opacity(0.5))
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 33, maxHeight: 33)
        .background(Color.white.opacity(0.14))
        .cornerRadius(16.0)
        .onTapGesture {
            plate.isActive = !plate.isActive
            if !plate.isActive { plate.count = 0 }
        }
    }
}

struct PlateCircle: View {
    var plate: Plate

    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .foregroundColor(plate.isActive ? Color(plate.color).opacity(0.14) : .clear)
            Text(plate.displayWeight)
                .font(.headline)
                .foregroundColor(Color(plate.color))
        }
        .frame(width: 30, height: 30)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PlateView(model: PlateModel())

    }
}
