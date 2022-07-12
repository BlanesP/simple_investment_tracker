//
//  CustomTextfield.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 5/6/22.
//

import SwiftUI

struct CustomTextfield: View {

    let placeholder: LocalizedStringKey
    let keyboardType: UIKeyboardType
    let onCommit: () -> Void
    let onEditingEnd: () -> Void

    @Binding var text: String

    init(
        placeholder: LocalizedStringKey,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        onCommit: @escaping () -> Void = {},
        onEditingEnd: @escaping () -> Void = {}
    ) {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.onCommit = onCommit
        self.onEditingEnd = onEditingEnd
    }

    var body: some View {
        TextField(
            placeholder,
            text: $text,
            onEditingChanged: { editing in
                if !editing { onEditingEnd() }
            },
            onCommit: onCommit
        )
        .keyboardType(keyboardType)
        .padding(.sizeNormal)
        .background(
            RoundedRectangle(cornerRadius: .sizeLarge)
                .strokeBorder(Color.gray)
        )
    }
}

struct CustomTextfield_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextfield(placeholder: "Test...", text: .constant("A value"))
    }
}
