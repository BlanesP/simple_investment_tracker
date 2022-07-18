//
//  View+cornerRadius.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 5/6/22.
//

import SwiftUI

private extension LocalizedStringKey {
    static var done: Self { "Done" }
    static var errorTitle: Self { "Ups!" }
    static var errorMsg: Self { "Something went wrong. Please try again." }
    static var ok: Self { "Ok" }
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

    func errorAlert(isPresented: Binding<Bool>,
                    errorTitle: LocalizedStringKey = .errorTitle,
                    errorMsg: LocalizedStringKey = .errorMsg,
                    btnText: LocalizedStringKey = .ok,
                    btnAction: @escaping SimplePerform = {}) -> some View {
        self
            .alert(errorTitle, isPresented: isPresented) {
                Button(btnText, action: btnAction)
            } message: {
                Text(errorMsg)
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
