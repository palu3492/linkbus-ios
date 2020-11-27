//
//  OnboardingView.swift
//  Linkbus
//
//  Created by Michael Carroll on 10/26/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack(alignment: .center) {
                //Spacer(minLength: 20)
                Spacer()

                TitleView()
                    .padding(.bottom, 50)
                //Spacer()

                InformationContainerView()
                

                Spacer(minLength: 100)

                Button(action: {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                }) {
                    Text("Continue")
                        .customButton()
                        .onTapGesture {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
            
            .frame(maxHeight: .infinity) // <- this
        
    }
}

struct TitleView: View {
    var body: some View {
        VStack {

            Text("Welcome to")
                .font(Font.custom("HelveticaNeue", size: 34))
                .fontWeight(.bold)
                //.customTitleText()

            Text("Linkbus")
                .font(Font.custom("HelveticaNeue", size: 34))
                .fontWeight(.bold)
                //.customTitleText()
                //.foregroundColor(.mainColor)
        }
    }
}

struct InformationContainerView: View {
    var body: some View {
        if #available(iOS 14.0, *) {
        VStack(alignment: .leading) {
            InformationDetailView(title: "Lightweight", subTitle: "Fast and lightweight app makes it easier than ever to view the bus schedule.", imageName: "bus.fill")

            InformationDetailView(title: "Accurate", subTitle: "Automatically pulls data from csbsju.edu to provide the most accurate and up-to-date schedule.", imageName: "clock")

            InformationDetailView(title: "Made by a Johnnie", subTitle: "Made by a Johnnie, for my fellow Johnnies and Bennies.", imageName: "AppIcon"
                                  )
        }
        .padding(.horizontal)
    }
    else {
        VStack(alignment: .leading) {
            InformationDetailView(title: "Lightweight", subTitle: "Fast and lightweight app makes it easier than ever to view the bus schedule.", imageName: "wind")

            InformationDetailView(title: "Accurate", subTitle: "Automatically pulls data from csbsju.edu to provide the most accurate and up-to-date schedule.", imageName: "clock")

            InformationDetailView(title: "Made by a Johnnie", subTitle: "Made by a Johnnie, for my fellow Johnnies and Bennies.", imageName: "AppIcon"
                                  )
        }
        .padding(.horizontal)
    }
}
}

struct InformationDetailView: View {
    var title: String = "title"
    var subTitle: String = "subTitle"
    var imageName: String = "car"

    var body: some View {
        Group() {
        HStack(alignment: .center) {
            if (imageName == "AppIcon"){
                Image(uiImage: UIImage(named: "Linkbus_transparent.png") ?? UIImage())
                    .resizable()
                    .frame(width: 40, height: 40)

            }
            else {
            Image(systemName: imageName)
                .font(.title)
                .foregroundColor(Color.mainColor)
                .padding()
                .accessibility(hidden: true)
                .scaledToFit()
                .frame(width: 40,height:40)
            }

            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .accessibility(addTraits: .isHeader)
                    //.padding(.bottom, 0.1)
            
                //Spacer(minLength: 1)

                Text(subTitle)
                    //.padding(.top, 0.1)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 5)
        }
        }
        .padding(.top)
        .padding(.horizontal, 5)
    }
}


//CUSTOM

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.headline)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.mainColor))
            .padding(.bottom)
    }
}

extension View {
    func customButton() -> ModifiedContent<Self, ButtonModifier> {
        return modifier(ButtonModifier())
    }
}

extension Text {
    func customTitleText() -> Text {
        self
            .fontWeight(.black)
            .font(.system(size: 36))
    }
}

extension Color {
    static var mainColor = Color(red:205 / 255, green:16 / 255, blue:65 / 255)
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
