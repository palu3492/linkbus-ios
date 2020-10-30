//
//  OnboardingView.swift
//  Linkbus
//
//  Created by Michael Carroll on 10/26/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {

                Spacer()

                TitleView()
                Spacer(minLength: 30)

                InformationContainerView()

                Spacer(minLength: 60)

                Button(action: {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                }) {
                    Text("Continue")
                        .customButton()
                }
                .padding(.horizontal)
            }
        }
    }
}

struct TitleView: View {
    var body: some View {
        VStack {

            Text("Welcome to")
                .font(.title)
                .fontWeight(.semibold)
                //.customTitleText()

            Text("Linkbus")
                .font(.title)
                .fontWeight(.semibold)
                //.customTitleText()
                //.foregroundColor(.mainColor)
        }
    }
}

struct InformationContainerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            InformationDetailView(title: "Lightweight", subTitle: "Fast and lightweight app makes it easier than ever to view the bus schedule.", imageName: "bus.fill")

            InformationDetailView(title: "Always Accurate", subTitle: "Linkbus pulls data from CSB/SJU servers to provide the most accurate and up-to-date schedule. Any changes are immediately reflected in the app.", imageName: "minus.slash.plus")

            InformationDetailView(title: "Community", subTitle: "Made by a Johnnie, for all Johnnies and Bennies.", imageName: "cross"
                                  )
        }
        .padding(.horizontal)
    }
}

struct InformationDetailView: View {
    var title: String = "title"
    var subTitle: String = "subTitle"
    var imageName: String = "car"

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: imageName)
                .font(.title)
                .foregroundColor(.mainColor)
                .padding()
                .accessibility(hidden: true)
                .scaledToFit()
                .frame(width: 40,height:40)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                    .accessibility(addTraits: .isHeader)

                Text(subTitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.top)
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
    static var mainColor = Color(UIColor.systemRed)
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
