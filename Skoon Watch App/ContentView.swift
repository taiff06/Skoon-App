import SwiftUI
import AVFoundation
import UserNotifications

struct ContentView: View {
    @State private var count = 0
    @State private var showingResetConfirmation = false
    @State private var lastTapTime = Date()
    @State private var speechSynthesizer = AVSpeechSynthesizer()
    @State private var timer: Timer?
    @State private var hasSpoken = false

    var body: some View {
        
        ZStack{
            
    Image("thkr1") // Replace "yourImageName" with your image asset name
        .resizable()
        .aspectRatio(contentMode: .fill)
        .edgesIgnoringSafeArea(.all)
            
        VStack {
            
            Spacer().frame(height: 20)
            Text("Number of counts:")
                .font(.subheadline)
                .padding(.trailing, 40)
       
            Button(action: {
                // Increment the count when the button is tapped
                count += 1
                // Update the last tap time
                lastTapTime = Date()
                // Cancel the existing speech if any
                speechSynthesizer.stopSpeaking(at: .immediate)
                // Reset the timer
                resetTimer()
                // Reset the spoken flag
                hasSpoken = false
            }) {
                Text(" \(count)")
                    .font(.title)
                    .padding()
                //.background(Color.black)
                .foregroundColor(.white)
                    .cornerRadius(10)
            }.background(Color.black).cornerRadius(70)
            
            Button(action: {
                // Show the reset confirmation dialog
                showingResetConfirmation = true
            }) {
                Text("Start Again")
                    .font(.subheadline)
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                   // .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }.background(Color.black).cornerRadius(70)
            .alert(isPresented: $showingResetConfirmation) {
                Alert(
                    title: Text("Do you want to reset your counting ?"),
                    message: Text(""),
                    primaryButton: .default(Text("Yes")) {
                        // Reset the count when the user clicks "Yes"
                        count = 0
                    },
                    secondaryButton: .cancel(Text("No"))
                )
            }
            
            Spacer()
        }
        .onAppear {
            // Start the timer when the view appears
            startTimer()
            
            requestNotificationAuthorization()
        }
        }
    }
    func requestNotificationAuthorization() {
          UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
              if granted {
                  print("Notification authorization granted")
              } else {
                  print("Notification authorization denied")
              }
          }
      }

    func startTimer() {
        // Start a timer to check for inactivity every 10 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            // Calculate the time elapsed since the last tap
            let timeSinceLastTap = Date().timeIntervalSince(self.lastTapTime)
            if timeSinceLastTap >= 10 && !self.hasSpoken {
                // Speak out the number of taps
                self.speakTapsCount()
                // Set the flag to avoid repeated speaking
                self.hasSpoken = true
            }
        }
    }

    func resetTimer() {
        // Invalidate the existing timer and start a new one
        timer?.invalidate()
        startTimer()
        
        
        let content = UNMutableNotificationContent()
           content.title = "Inactivity Alert"
           content.body = "You haven't tapped in a while."

           let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 8, repeats: false)

           let request = UNNotificationRequest(identifier: "inactivityNotification", content: content, trigger: trigger)

           UNUserNotificationCenter.current().add(request) { error in
               if let error = error {
                   print("Error scheduling notification: \(error.localizedDescription)")
               } else {
                   print("Notification scheduled successfully")
               }
           }

    }

    func speakTapsCount() {
        let utterance = AVSpeechUtterance(string: "You have tapped \(count) times.")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(utterance)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
