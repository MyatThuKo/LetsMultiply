//
//  ContentView.swift
//  Let's Multiply
//
//  Created by Myat Thu Ko on 5/21/20.
//  Copyright © 2020 Myat Thu Ko. All rights reserved.
//

import SwiftUI

struct headerText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 15))
            .foregroundColor(.black)
            .multilineTextAlignment(.leading)
    }
}

struct circleText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 37))
            .frame(width: 80, height: 100)
            .background(LinearGradient(gradient: Gradient(colors: [.yellow, .orange, .yellow]), startPoint: .leading, endPoint: .bottom))
            .foregroundColor(.black)
            .clipShape(Circle())
    }
}

struct rectangleText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .padding()
            .font(.system(size: 25))
            .background(LinearGradient(gradient: Gradient(colors: [.yellow, .orange, .yellow]), startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.black)
            .clipShape(Rectangle())
            .cornerRadius(40)
    }
}


struct ContentView: View {
    
    //List of animals images
    @State private var animals = ["bear", "buffalo", "chicken", "cow", "dog", "elephant", "goat", "parrot", "penguin", "whale"].shuffled()
    
    //Alert
    @State private var gameStart = false
    @State private var showAnswer = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    //Animation
    @State private var animationAmount = 0.0
    @State private var wrongAttempt = 0.0
    
    //Questions and answers
    @State private var upToNumber = 10
    @State private var numberOfQuestions = ["5", "10", "20", "All"]
    @State private var amountSelected = 0
    @State private var number1 = 1
    @State private var number2 = 1
    @State private var correctAnswer = 0
    @State private var listOfAnswrs = [1, 2, 3, 4]
    @State private var scores = 0
    
    @State private var rounds = 0
    
    var randomNumber: Int {
        return Int.random(in: 1...144)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.pink, .orange, .yellow]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 30) {
                    Picker(selection: $amountSelected, label: Text("How many questions?")) {
                        ForEach(0..<numberOfQuestions.count) {
                            Text("\(self.numberOfQuestions[$0]) questions")
                        }
                    }
                    .background(LinearGradient(gradient: Gradient(colors: [.pink, .red, .pink]), startPoint: .leading, endPoint: .trailing))
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Stepper(value: $upToNumber, in: 1...12) {
                        Text("Up to \(upToNumber) numbers")
                    }
                    .background(LinearGradient(gradient: Gradient(colors: [.pink, .yellow, .pink]), startPoint: .leading, endPoint: .trailing))
                    .padding(5)
                    
                    rectangleText(text: "What is the answer of \(self.number1) * \(self.number2)?")
                    Spacer()
                    HStack(spacing: 10) {
                        ForEach(0..<4) {number in
                            Button(action: {
                                self.checkAnswer(number)
                            }) {
                                VStack(spacing: 10) {
                                    Image(self.animals[number])
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                    circleText(text: "\(self.listOfAnswrs[number])")
                                }
                            }
                        }
                    }
                    Spacer()
                    Spacer()
                    rectangleText(text: "Round \(self.rounds) \n Your score is \(scores).")
                        .multilineTextAlignment(.center)
                }
            }
            .navigationBarTitle("Let's Multiply", displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: startGame) {
                    Text("Start")
                        .foregroundColor(.black)
                        .frame(width: 75, height: 35)
                        .background(LinearGradient(gradient: Gradient(colors: [.yellow, .orange, .yellow]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(30)
                }
            )
        }
        .alert(isPresented: $showAnswer) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Continue")) {
                if self.rounds != Int(self.numberOfQuestions[self.amountSelected]) ?? self.upToNumber {
                    self.continueGame()
                }
                })
        }
    }
    
    func continueGame() {
        if gameStart {
            listOfAnswrs.removeAll()
            animals.shuffle()
            let maxNum = self.upToNumber
            
            self.number1 = Int.random(in: 1...maxNum)
            self.number2 = Int.random(in: 1...maxNum)
            self.correctAnswer = number1 * number2
            
            //inserting random numbers into listOfAnswers
            for _ in 1...3 {
                self.listOfAnswrs.append(randomNumber)
            }
            //inserting the correct answer
            self.listOfAnswrs.append(correctAnswer)
            
            //shuffle before sending back to the view
            listOfAnswrs.shuffle()
        }
    }
    
    func startGame() {
        gameStart.toggle()
        if gameStart {
            //empty the entire array to keep the size remain the same
            listOfAnswrs.removeAll()
            
            self.scores = 0
            self.rounds = 0
            let maxNum = self.upToNumber
            
            //to get the answer from the starting two numbers
            self.number1 = Int.random(in: 1...maxNum)
            self.number2 = Int.random(in: 1...maxNum)
            self.correctAnswer = number1 * number2
            
            //inserting random numbers into listOfAnswers
            for _ in 1...3 {
                self.listOfAnswrs.append(randomNumber)
            }
            //inserting the correct answer
            self.listOfAnswrs.append(correctAnswer)
            
            
            //shuffle before sending back to the view
            listOfAnswrs.shuffle()
            //to give random animals pictures
            animals.shuffle()
        }
    }
    
    func checkAnswer(_ number: Int) {
        if gameStart {
            self.rounds += 1
            
            if listOfAnswrs[number] == correctAnswer {
                scores += 1
                alertTitle = "Round \(self.rounds)"
                alertMessage = "Yay! Your answer is correct! Good Job!"
            } else {
                alertTitle = "Round \(self.rounds)"
                alertMessage = "Oops! Your answer is incorrect! \n Please Try Again!."
            }
            
            //Showing the end of the game status
            if self.rounds == Int(self.numberOfQuestions[self.amountSelected]) ?? self.upToNumber {
                alertTitle = "Finished!"
                alertMessage = "You have completed all \(Int(self.numberOfQuestions[self.amountSelected]) ?? self.upToNumber) questions.\n Please start the game again."
            }
            
        } else {
            alertTitle = "Invaild"
            alertMessage = "Please select the number of questions and start the game!"
        }
        showAnswer = true
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
