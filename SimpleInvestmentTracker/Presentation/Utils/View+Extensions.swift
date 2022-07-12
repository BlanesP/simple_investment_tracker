//
//  View+cornerRadius.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 5/6/22.
//

import SwiftUI

private extension LocalizedStringKey {
    static var done: Self { "Done" }
}

//MARK: - Public methods

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        self
            .clipShape( RoundedCorner(radius: radius, corners: corners) )
    }

    func toolBarDone(action: @escaping SimplePerform) -> some View {
        self
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()

                    Button(.done, action: action)
                }
            }
    }
}

//MARK: - Components

fileprivate struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
