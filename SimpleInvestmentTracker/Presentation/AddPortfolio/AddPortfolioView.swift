//
//  AddPortfolioView.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 27/4/22.
//

import SwiftUI

private extension CGFloat {
    static var cornerSize: Self { 20 }
    static var superLargePadding: Self { 32 }
}

private extension LocalizedStringKey {
    static var title: Self { "Add new portfolio" }
    static var subtitle: Self { "Let's make some money!" }
    static var name: Self { "Name..." }
    static var value: Self { "Value..." }
    static var contributed: Self { "Contributed so far..." }
    static var addPortfolio: Self { "Add portfolio" }
}

//MARK: - Main View

struct AddPortfolioView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject var viewModel: AddPortfolioViewModel

    @State private var name: String = ""
    @State private var value: String = ""
    @State private var contributed: String = ""

    @FocusState var isInputActive: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: .sizeMedium) {
            Text(.title)
                .foregroundColor(.white)
                .font(.title)
                .bold()
                .padding(.horizontal, .sizeLarge)

            Text(.subtitle)
                .foregroundColor(.white)
                .font(.title3)
                .padding([.horizontal, .bottom], .sizeLarge)

            contentView
                .background(Color.white)
                .cornerRadius(.cornerSize, corners: [.topLeft, .topRight])
                .edgesIgnoringSafeArea(.bottom)
        }
        .background(Color.primaryColor)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image.arrowLeft
                    .foregroundColor(.white)
            })
        )
        .onReceive(viewModel.viewState, perform: state)
    }

    var contentView: some View {
        VStack {
            ScrollView {
                formView
                    .padding(.horizontal, .sizeLarge)
                    .padding(.vertical, .superLargePadding)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()

                            Button("Done") {
                                isInputActive = false
                            }
                        }
                    }
            }

            addPortfolioView
        }
    }

    var formView: some View {
        VStack(spacing: .sizeLargeExtra) {

            CustomTextfield(placeholder: .name, text: $name)
                .focused($isInputActive)

            CustomTextfield(
                placeholder: .value,
                text: $value,
                keyboardType: .decimalPad,
                onEditingEnd: {
                    value = value.currencyFormatted
                }
            )
                .focused($isInputActive)

            CustomTextfield(
                placeholder: .contributed,
                text: $contributed,
                keyboardType: .decimalPad,
                onEditingEnd: {
                    contributed = contributed.currencyFormatted
                }
            )
                .focused($isInputActive)

            Spacer()

        }
    }

    var addPortfolioView: some View {
        Button { [weak viewModel] in
            viewModel?.trigger(
                input: .addPortfolioPressed(name: name, value: value, contributed: contributed)
            )
        } label: {
            Text(LocalizedStringKey.addPortfolio.toString().uppercased())
                .font(.headline)
                .padding(.horizontal, .sizeLarge)
                .padding(.vertical, .sizeLarge)
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(
                        cornerSize: CGSize(width: .sizeLargeExtra, height: .sizeLargeExtra)
                    )
                        .foregroundColor(.secondaryColor)
                )
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, .superLargePadding)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.white, .lightGray]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

// MARK: - Performs

private extension AddPortfolioView {
    func state(_ value: AddPortfolioViewModel.ViewState) {
        switch value {
        case .onAddSuccess:
            presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - Previews

struct AddPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactory.addPortfolioView
    }
}
