//
//  SimpleListRow.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 9/7/22.
//

import SwiftUI

private extension Color {
    static var shadowColor: Self { .black.opacity(0.2) }
}

//MARK: - Main View

struct SimpleListRow: View {

    let title: String
    let subtitle: String
    let showArrow: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: .sizeSmall) {
                Text(title)
                    .bold()

                Text(subtitle)
            }
            .padding(.leading, .sizeSmall)

            Spacer()

            if showArrow {
                Image.arrowRight
                    .padding(.trailing, .sizeSmall)
            }
        }
        .padding(.sizeMedium)
        .background(Color.secondaryColor)
        .cornerRadius(.sizeNormal)
        .shadow(color: .shadowColor, radius: .sizeSmall)
    }
}

struct SimpleListRow_Previews: PreviewProvider {
    static var previews: some View {
        SimpleListRow(title: "Title", subtitle: "Subtitle", showArrow: true)
    }
}
