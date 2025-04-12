//
//  ContentView.swift
//  CaloriesBurnedCalc
//
//

import SwiftUI



struct ContentView: View {
    
    @State var ageString : String = ""
    @State var durationString : String = ""
    @State var bpmString : String = ""
    @State var weightString : String = ""
    @State var isTestosterone : Bool = false
    @State var isMetric : Bool = false
    @State var resultString : String = "Result goes here!"
    
    var body: some View {
        TabView() {
            Tab("Biometrics", systemImage: "heart.fill") {
                VStack {
                    HStack (alignment: .center) {
                        Spacer()
                        Text("Biometrics")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                    }.padding(.vertical, 40)
                    VStack (alignment: .center) {
                        Text("What is your age?")
                            .font(.title2)
                        TextField("24", text: $ageString)
                            .font(.title2)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color.secondary)
                            )
                        Text("What is your weight?")
                            .font(.title2)
                        TextField("160", text: $weightString)
                            .font(.title2)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color.secondary)
                            )
                    }
                    .padding(.vertical)
                    VStack {
                        Text("Is your weight in pounds or kilograms?")
                            .font(.title2)
                        Picker(selection: $isMetric, label: Text("")) {
                            Text("Kilograms (kg)").tag(true)
                            Text("Pounds (lb)").tag(false)
                        }.pickerStyle(.segmented)
                    }
                    .padding(.vertical)
                    VStack {
                        Text("What is your Primary Sex Hormone?")
                            .font(.title2)
                        Picker(selection: $isTestosterone,
                               label: Text("")) {
                            Text("Testosterone").tag(true)
                            Text("Estrogen").tag(false)
                        }.pickerStyle(.segmented)
                    }
                    Spacer()
                }
            }
            Tab("Session Data", systemImage: "gauge.badge.plus") {
                VStack {
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Exercise Session Data")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                    }.padding(.vertical, 50)
                    VStack {
                        Text("Time spent exercising (mins):")
                            .font(.title2)
                        TextField("15.0", text: $durationString)
                            .font(.title2)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color.secondary)
                            )
                        Text("Average heart rate (bpm):")
                            .font(.title2)
                        TextField("90.0", text: $bpmString)
                            .font(.title2)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color.secondary)
                            )
                    }
                    Spacer()
                }
            }
            Tab("Calculate", systemImage: "chart.pie.fill") {
                VStack {
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Preform Calculation?")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                    }.padding(.vertical, 75)
                    Text(self.resultString)
                        .font(.title)
                        .padding(.vertical, 175)
                    Button(action: {
                        guard var weight = Float(self.weightString) else {
                            self.resultString = "Your entered weight (and possibly other values) is/are invalid!"
                            return
                        }
                        guard let age = Float(self.ageString) else {
                            self.resultString = "Your entered age (and possibly other values) is/are invalid!"
                            return
                        }
                        guard let bpm = Float(self.bpmString) else {
                            self.resultString = "Your entered bpm (and possibly other values) is/are invalid!"
                            return
                        }
                        guard let duration = Float(self.durationString) else {
                            self.resultString = "Your entered exercise duration (and possibly other values) is/are invalid!"
                            return
                        }
                        var caloriesBurned : Float = 0.0
                        if (isMetric) {
                            // Calc assumes pounds, so we need to conv. from kg if that's the unit
                            weight = weight * 2.205
                        }
                        if (isTestosterone) {
                            // 'male' version of formula
                            let ageTerm : Float = age * 0.2017
                            let weightTerm : Float = weight * 0.09036
                            let bpmTerm : Float = bpm * 0.6309
                            let magicConstant : Float = 55.0969 //nice
                            caloriesBurned = (ageTerm - weightTerm + bpmTerm - magicConstant) * (duration / 4.184)
                        } else {
                            // 'female' version of formula
                            let ageTerm : Float = age * 0.074
                            let weightTerm : Float = weight * 0.05741
                            let bpmTerm : Float = bpm * 0.4472
                            let magicConstant : Float = 20.4022
                            caloriesBurned = (ageTerm - weightTerm + bpmTerm - magicConstant) * (duration / 4.184)
                        }
                        self.resultString = String(caloriesBurned) + " calories burned!"
                    },
                    label: {
                        Text("Calculate!")
                            .font(.title)
                            .italic()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(uiColor: .lightGray))
                            )
                    })
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
