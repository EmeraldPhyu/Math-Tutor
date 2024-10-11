//
//  ContentView.swift
//  Math Tutor
//
//  Created by Emerald on 8/10/24.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
	
	@FocusState private var textFieldIsFocused: Bool
	@State private var textFieldIsDisabled = false
	@State private var guessButtonDisabled = false
	@State private var firstNumber = 0
	@State private var secondNumber = 0
	private let emojis = [
		"🍕", "🍎", "🍏", "🐵","👽", "🧠", "🧜🏽‍♀️", "🧙🏿‍♂️", "🥷", "🐶", "🐹", "🐣", "🦄", "🐝", "🦉", "🦋", "🦖", "🐙", "🦞","🐟","🦔","🐲", "🌻", "🌍", "🌈", "🍔", "🌮", "🍦","🍩","🍪"
	]
	@State private var firstNumberEmojis = ""
	@State private var secondNumberEmojis = ""
	@State private var answer = ""
	@State private var audioPlayer: AVAudioPlayer!
	@State private var message = ""
	@State private var correctAnswer = 0
   
	var body: some View {
        VStack {
					Spacer()
					
					Group {
						Text("\(firstNumberEmojis)")
						Text("+")
						Text("\(secondNumberEmojis)")
					}.font(.system(size: 80))
						.minimumScaleFactor(0.5)
						.multilineTextAlignment(.center)
						
					
					Spacer()
						Text("\(firstNumber) + \(secondNumber) =")
							.font(.largeTitle)
				
					TextField("", text: $answer)
						.font(.largeTitle)
						.fontWeight(.black)
						.frame(width: 70)
						.textFieldStyle(.roundedBorder)
						.overlay {
							RoundedRectangle(cornerRadius: 5)
								.stroke(.gray, lineWidth: 2)
						}
						.keyboardType(.numberPad)
						.multilineTextAlignment(.center)
						.focused($textFieldIsFocused)
						.disabled(textFieldIsDisabled)
					
					Button("Guess") {
						//dismiss keyboard
						textFieldIsFocused = false
						//check if answer if correct - play sound accordingly
						if checkAnswer(answer: answer){
							playSound(soundName: "correct")
							message = "Correct!"
						}else {
							playSound(soundName: "wrong")
							message = "Sorry, the correct answer is \(correctAnswer)"
							
						}
						
						textFieldIsDisabled = true
						guessButtonDisabled = true
								
					}.buttonStyle(.borderedProminent)
						.disabled(answer.isEmpty || guessButtonDisabled)
					 
					Text(message)
						.font(.largeTitle)
						.fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
						.multilineTextAlignment(.center)
						.foregroundColor(Int(answer) == correctAnswer ? .green : .red)
					if guessButtonDisabled {
						Button("Play Again"){
							//Reset
							textFieldIsDisabled = false
							guessButtonDisabled = false
							textFieldIsFocused = true
							answer = ""
							message = ""
							generateNewEquation()
						}
					}
					Spacer()
        }
				.padding()
				.onAppear(){
					generateNewEquation()
				}
    }
	func generateNewEquation(){
		firstNumber = Int.random(in: 1...10)
		secondNumber = Int.random(in: 1...10)
		firstNumberEmojis = String(repeating: emojis.randomElement()!, count: firstNumber)
		secondNumberEmojis = String(repeating: emojis.randomElement()!, count: secondNumber)
		
	}
	
	func checkAnswer(answer: String) -> Bool {
		correctAnswer = firstNumber + secondNumber
		if let answerValue = Int(answer) {
			if correctAnswer == answerValue {
				return true
			}
		}
		return false
	}
	
	func playSound(soundName: String) {
		guard let soundFile = NSDataAsset(name: soundName) else {
			print("Could not read file name \(soundName)")
			return
		}
		do {
			audioPlayer = try AVAudioPlayer(data: soundFile.data)
			audioPlayer.play()
		}
		catch {
			print("ERROR: \(error.localizedDescription) creating audioPLayer.")
		}
	}
	
//TODO:
	// 1. Add functions -, %, x 
	// 2. credit
//	<a target="_blank" href="https://icons8.com/icon/5qESUn5jAKfI/math">Math</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
}

#Preview {
    ContentView()
}
