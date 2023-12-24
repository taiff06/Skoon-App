
import SwiftUI
import AVFoundation
import UserNotifications
import Foundation

struct Card: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
}
struct Menu: View {
    let cards: [Card] = [
        Card(title: "Subhan Allah", color: .grey),
        Card(title: "Astaghfirullah", color: .grey),
        Card(title: "Alhamdulillah", color: .grey),
        // Add more cards as needed
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("thkr1") // Replace "yourImageName" with your image asset name
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer().frame(height: 20)
                    Text("The Daily Rosary")
                        .font(.body)
                        .padding(.trailing, 40)
                    
                    ScrollView(.horizontal) {
                        
                        HStack(spacing: 50){
                          //  Spacer().frame(width: 100)
                            ForEach(cards) { card in
                                NavigationLink(destination: ContentView()) {
                                    
                                    CardView(card: card)
                                }.frame(width: 180, height: 180).padding([.leading, .bottom])
                            }
                        }
                    }
                    

                }
            }
        }
    }
}

struct CardView: View {
    let card: Card
    
    var body: some View {
        RoundedRectangle(cornerRadius: 40)
            .frame(width: 180, height: 180)
            .foregroundColor(card.color)
            .overlay(
                Text(card.title)
                    .foregroundColor(.white)
            )
    
    }
}



struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
