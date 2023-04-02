//
//  ContentView.swift
//  Dog Pics
//
//  Created by Lori Rothermel on 4/2/23.
//

import SwiftUI
import AVFAudio


struct ContentView: View {

    @State private var audioPlayer: AVAudioPlayer!
    @State private var selectedBreed: Breed = .affenpinscher
    @StateObject var dogVM = DogViewModel()
    
    
    enum Breed: String, CaseIterable {
        case affenpinscher, airedale, akita, australian, beagle, boxer, bulldog, bullterrier, cattledog, chihuahua,
             chow, collie, corgi, dachshund, dane, greyhound, havanese, hound, husky, mastiff, mountain, pinscher,
             pointer, pitbull, poodle, pug, pyrenees, retriever, ridgeback, rottweiler, setter, sharpei,
             sheepdog, spaniel, terrier, waterdog, weimaraner, whippet, wolfhound
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("🐶 Dog Pics!")
                    .font(Font.custom("Avenir Next Condensed", size: 60))
                    .bold()
                    .foregroundColor(.brown)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Spacer()
                                                
                AsyncImage(url: URL(string: dogVM.imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .shadow(radius: 15)
                        .animation(.default, value: image)
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                }
                .padding()
                
                
                Spacer()
                
                Button("Any Random Dog") {
                    dogVM.urlString = "https://dog.ceo/api/breeds/image/random"
                    Task {
                        await dogVM.getData()
                    }
                }  // Button
                .buttonStyle(.borderedProminent)
                .bold()
                .tint(.brown)
                .padding(.bottom)
                
                HStack {
                    Button("Show Breed") {
                        dogVM.urlString = "https://dog.ceo/api/breed/\(selectedBreed.rawValue)/images/random"
                        print("🤮🤮 dogVM.urlString -> \(dogVM.urlString)")
                        Task {
                            await dogVM.getData()
                        }  // Task
                    }  // Button
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .padding(.bottom)
                    
                    Picker("", selection: $selectedBreed) {
                        ForEach(Breed.allCases, id: \.self) { breed in
                            Text(breed.rawValue.capitalized)
                        }  // ForEach
                    }  // Picker
                }  // HStack
                .bold()
                .tint(.brown)
            }  // VStack
            .onAppear {
                playSound(soundName: "bark")
            }
        }  // NavigationStack
        
    }  // some View
    
    
    func playSound(soundName: String) {
        
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("🤬 Could not read file name \(soundName))")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("🤬 ERROR: \(error.localizedDescription) creating audioPlayer")
        }
    }  // End of playSound func
    
   
    
}  // ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
