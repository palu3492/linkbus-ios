//
//  TestDatePick.swift
//  Linkbus
//
//  Created by Alex Palumbo on 9/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct SelectDate: View {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

    @State private var lbScheduleDate = Date()

    var body: some View {
        List {
            VStack {
                HStack(){
                    Spacer()
                    Text("Date is \(lbScheduleDate, formatter: dateFormatter)")
                    Spacer()
                    Button(action: {
                        print("Done")
                    }) {
                        Text("Done")
                            .fontWeight(.semibold)
                            .font(Font.custom("HelveticaNeue", size: 18))
                            .foregroundColor(Color.blue)
                    }
                    Spacer()
                }
                DatePicker("", selection: $lbScheduleDate, displayedComponents: .date)
            }
        }
        .navigationBarTitle(Text("Select Date"))
    }
}

//struct TestDatePick_Previews: PreviewProvider {
//    static var previews: some View {
//        TestDatePick()
//    }
//}
