//
//  CustomTextfield.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 5/6/22.
//

import SwiftUI

struct CustomTextfield: View {

    let placeholder: LocalizedStringKey
    @Binding var text: String

    @State private var onEditingEnd: SimplePerform?

    init(
        placeholder: LocalizedStringKey,
        text: Binding<String>
    ) {
        self.placeholder = placeholder
        self._text = text
    }

    var body: some View {
        TextField(
            placeholder,
            text: $text,
            onEditingChanged: { editing in
                if !editing { onEditingEnd?() }
            }
        )
    }
}

//MARK: - Builders

extension CustomTextfield {
    func onEditingEnd(_ perform: @escaping SimplePerform) -> Self {
        var view = self
        view._onEditingEnd = State(initialValue: perform)
        return view
    }

    func styled(keyboardType: UIKeyboardType = .default) -> some View {
        self
            .keyboardType(keyboardType)
            .padding(.sizeNormal)
            .background(
                RoundedRectangle(cornerRadius: .sizeLarge)
                    .strokeBorder(Color.gray)
            )
    }
}

//MARK: - Previews

struct CustomTextfield_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextfield(placeholder: "Test...", text: .constant("A value"))
    }
}
