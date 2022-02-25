//
//  ContentView.swift
//  Shared
//
//  Created by Shayarneel Kundu on 2/10/22.
//

import SwiftUI

let xmin : Double = 75.0
let xmax : Double = 375
let ymin : Double = 150
let ymax : Double = 450

struct ContentView: View {
    
    @ObservedObject var neutronShielding = NeutronShielding()
    
    @State var randomWalk : [(lastxVal: Double, lastyVal: Double)] = [(lastxVal: 300, lastyVal: 300)]
    
    
    @State var box : [[(lastxVal: Double, lastyVal: Double)]] =
    [[(lastxVal: xmin, lastyVal: ymin),
                       (lastxVal: xmin, lastyVal: ymax),
                       (lastxVal: xmax, lastyVal: ymax),
                       (lastxVal: xmax, lastyVal: ymin),
                       (lastxVal: xmin, lastyVal: ymin)]]
     
    @State var particleNumString : String = "1000"
    @State var meanFreePathString : String = "50.0"
    @State var ElossString : String = "0.50"
    @State var EmaxString : String = "10"
    @State var numEscapedString : String = "0"
    
    var body: some View {
        HStack {
            VStack {
                
                VStack {
                    Text("Number of Particles")
                    TextField("", text: $particleNumString)
                        .frame(width: 100.0)
                }.padding()
                
                VStack {
                    Text("Mean Free Path")
                    TextField("Average distance Travelled per step", text: $meanFreePathString)
                        .frame(width: 100.0)
                }.padding()
                
                VStack {
                    Text("Maximum Energy")
                    TextField("Energy of incoming particles", text: $EmaxString)
                        .frame(width: 100.0)
                }.padding()
                
                VStack {
                    Text("Energy Loss")
                    TextField("Energy loss at each step", text: $ElossString)
                        .frame(width: 100.0)
                }.padding()
                
                VStack {
                    Text("Number Escaped")
                    TextField("Particles that elave th ebox", text: $numEscapedString)
                        .frame(width: 100.0)
                        .disabled(neutronShielding.enableButton == false)
                }.padding()
                
                // Buttons
                Button("Random Walk", action: self.calculate)
                    .padding()
                    .frame(width: 200.0)
                    .disabled(neutronShielding.enableButton == false)
                
                Button("Clear", action: self.clear)
                    .padding()
                    .frame(width: 200.0)
            }
            
            // Drawing
            drawingView(Layer1: $randomWalk, Layer2: $box)
                .padding()
                .aspectRatio(1, contentMode: .fit)
                .drawingGroup()
        }
    }
    
    func calculate() {
        
        neutronShielding.setButtonEnable(state: false)
        self.neutronShielding.objectWillChange.send()
        
        randomWalk.append(contentsOf: neutronShielding.MultipleWalks(numParticles: Int(particleNumString)!, meanFreePath: Double(meanFreePathString)!, Eloss: Double(ElossString)!, Emax: Double(EmaxString)!))
            
        
        numEscapedString = String(neutronShielding.numEscape)
        neutronShielding.setButtonEnable(state: true)
    }
    
    func clear() {
        neutronShielding.eraseData()
        numEscapedString = "0"
        randomWalk = [(lastxVal: 300, lastyVal: 300)]
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
