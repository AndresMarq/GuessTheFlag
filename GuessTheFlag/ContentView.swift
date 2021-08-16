//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Andres on 2021-06-16.
//

import SwiftUI

struct ContentView: View {
    //Accessibility labels
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = "0"
    @State private var numUserScore = 0
    
    @State private var animationAmount = [0.0, 0.0, 0.0]
    @State private var opacityAmount = [1.0, 1.0, 1.0]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                        .font(.title2)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0..<3) { number in Button(action: {
                    self.flagTapped(number)
                })
                {
                    Image(self.countries[number]).renderingMode(.original)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                        .shadow(color: .black, radius: 2)
                        .opacity(opacityAmount[number])
                        .rotation3DEffect(
                            .degrees(animationAmount[number]),
                            axis: (x: 0, y: 0, z: 1)
                        ).clipped()
                        .animation(.default)
                        .accessibility(label: Text(self.labels[self.countries[number], default: "Unknown flag"]))
                }
                }
                
                VStack {
                    Text("Your Score is:")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .font(.title2)
                    TextField("Score", text: $userScore)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .font(.title)
                }
            }
                Spacer()
            }
        
        .alert(isPresented: $showingScore, content: {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(userScore)"), dismissButton: .default(Text("Continue")) {
                self.askQuestions()
            })
        })
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            numUserScore = Int(userScore) ?? 0
            numUserScore += 1
            userScore = String(numUserScore)
            //animates correct flag
            animationAmount[number] += 360
            //makes other flags opaque
            let count = 0...2
            for val in count {
                if val != number {
                    opacityAmount[val] *= 0.25
                }
            }
            }
         else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
            opacityAmount = [0, 0, 0]
        }
        showingScore = true
    }
    
    func askQuestions() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        opacityAmount = [1.0, 1.0, 1.0]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
