//
//  InvestmentHeader.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 7/7/22.
//

import SwiftUI

struct InvestmentHeader: View {

    let name: String
    let value: Float
    let contributed: Float

    var body: some View {
        VStack(alignment: .leading, spacing: .sizeSmall) {
            Text(name)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)

            Text(value.currencyFormatted())
                .font(.largeTitle)
                .foregroundColor(.white)

            growthView
                .padding(.top, .sizeSmall)
        }
        .padding(.horizontal, .sizeLarge)
        .padding(.bottom, .sizeLargeExtra)
        .background(Color.primaryColor)
    }

    var growthView: some View {
        HStack(spacing: .zero) {
            isPositive ? Image.arrowUp : Image.arrowDown

            Text(
                gains.currencyFormatted() + " (\(yield.percentageFormatted())"
            )
                .font(.title3)
                .bold()
        }
        .foregroundColor(isPositive ? .green : .red)
    }
}

//MARK: - Utils

extension InvestmentHeader {
    var gains: Float { value - contributed }
    var yield: Float { contributed > 0 ? gains / contributed : 0 }
    var isPositive: Bool { gains > 0 }
}

//MARK: - Previews

struct InvestmentHeader_Previews: PreviewProvider {
    static var previews: some View {
        InvestmentHeader(name: "Preview portfolio", value: 5000, contributed: 4000)
    }
}
