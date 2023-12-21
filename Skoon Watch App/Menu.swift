


import SwiftUI
import AVFoundation
import UserNotifications
import Foundation
//
//  CardButtonView.swift
//  counter3 Watch App
//
//  Created by taif on 21/12/2023.
//

import SwiftUI

struct Menu: View {
    let cardData = [
        ("Subhan Allah", Color.grey),
        ("Astaghfirullah", Color.grey),
        ("Alhamdulillah", Color.grey)
    ]

    @State private var currentIndex = 0
    @State private var offset: CGFloat = 0
    let cardWidth: CGFloat = 150 // Adjust the card width as needed
    let cardSpacing: CGFloat = 30 // Adjust the spacing between cards

    var body: some View {
        NavigationView {
            ZStack {
                Image("thkr1") // Replace "yourImageName" with your image asset name
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)

                ForEach(cardData.indices, id: \.self) { index in
                    CardButton(title: cardData[index].0, color: cardData[index].1)
                        .frame(width: cardWidth)
                        .offset(x: offset + CGFloat(index - currentIndex) * (cardWidth + cardSpacing))
                        .animation(.spring())
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    offset = gesture.translation.width
                                }
                                .onEnded { gesture in
                                    let newIndex = Int((offset + gesture.translation.width) / (cardWidth + cardSpacing))
                                    currentIndex = max(0, min(currentIndex - newIndex, cardData.count - 1))
                                    withAnimation {
                                        offset = 0
                                    }
                                }
                        )
                }
            }
        }
    }
}

struct CardButton: View {
    let title: String
    let color: Color

    var body: some View {
        NavigationLink(destination: ContentView()) {
            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 150, height: 150)
                    .foregroundColor(color)
                    .overlay(
                        Text(title)
                            .foregroundColor(.white)
                    )
            } .frame(width: 80 , height: 80)
            .padding(.trailing, 0) // Adjust the padding as needed
        }
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
