//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Dechon Ryan on 4/23/24.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var tappedFlag = 3 // outside range of displayed flags
    
    @State private var rotationDegrees = 0.0
    @State private var opacityLevel = 1.0
    @State private var scaleLevel = 1.0
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var questionCounter = 0
    @State private var endingGame = false
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            
                            withAnimation(.linear) {
                                // tapped flag spin 360º on Y-axis
                                rotationDegrees += 360
                                // other 2 flags fade to 25% opacity and scale down to half size
                                opacityLevel *= 0.25
                                scaleLevel *= 0.75
                            }
                            
                        } label: {
                            FlagImage(countries: countries, number: number)
                        }
                        .rotation3DEffect(
                            .degrees(tappedFlag == number ? rotationDegrees : .zero), 
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .opacity(tappedFlag == number ? 1 : opacityLevel)
                        .scaleEffect(tappedFlag == number ? 1 : scaleLevel)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score).")
        }
        .alert("Game Over", isPresented: $endingGame) {
            Button("Reset", action: reset)
        } message: {
            Text("Your final score is \(score).")
            switch score {
            case 8:
                Text("Perfect!")
            case 6...7:
                Text("Well done.")
            case 5:
                Text("Could be better...")
            default:
                Text("Better luck next time...")
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        tappedFlag = number
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong!\nThat is the flag of \(countries[number])"
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionCounter += 1
        
        // reset values
        opacityLevel = 1
        scaleLevel = 1
        tappedFlag = 3
        
        if questionCounter == 8 {
            endingGame = true
        }
    }
    
    func reset() {
        score = 0
        questionCounter = 0
        endingGame = false
    }
}

#Preview {
    ContentView()
}


