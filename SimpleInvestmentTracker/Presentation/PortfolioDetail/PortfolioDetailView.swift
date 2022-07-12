//
//  PortfolioDetailView.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 7/7/22.
//

import SwiftUI

private extension LocalizedStringKey {
    static var contributions: Self { "Contributions" }
    static var addContribution: Self { "Add Contribution" }
    static var amount: Self { "Amount" }
    static var date: Self { "Date" }
    static var accept: Self { "Accept" }
    static var value: Self { "Value" }
}

private extension CGFloat {
    static var cornerSize: Self { 20 }
    static var circleLineWidth: Self { 2 }
}

private extension Double {
    static var backgroundOpacity: Self { 0.4 }
}

//MARK: Main View

struct PortfolioDetailView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject var viewModel: PortfolioDetailViewModel

    @State private var showAddContribution = false
    @State private var value = ""
    @State private var showError = false
    @FocusState var isInputActive: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: .sizeMedium) {
            InvestmentHeader(
                name: viewModel.portfolio.name,
                value: viewModel.portfolio.value,
                contributed: viewModel.totalContributed
            )

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
        .overlay {
            AddContributionView(show: $showAddContribution, isInputActive: $isInputActive)
                .environmentObject(viewModel)
                .opacity(showAddContribution ? 1 : 0)
        }
        .onAppear { [weak viewModel] in
            value = viewModel?.portfolio.value.currencyFormatted ?? ""
        }
        .toolBarDone {
            isInputActive = false
        }
        .errorAlert(isPresented: $showError)
        .onReceive(viewModel.output, perform: state)
    }

    func state(_ value: PortfolioDetailViewModel.ViewOutput) {
        guard case .error = value else { return }
        showError = true
    }
}

extension PortfolioDetailView {
    var contentView: some View {
        VStack(alignment: .leading) {
            Text(.value)
                .font(.title2)
                .bold()
                .padding(.top, .sizeLargeExtra)

            CustomTextfield(
                placeholder: .value,
                text: $value,
                keyboardType: .decimalPad,
                onEditingEnd: { [weak viewModel] in
                    viewModel?.input(.valueChanged(to: value))
                }
            )
            .focused($isInputActive)

            HStack {
                Text(.contributions)
                    .font(.title2)
                    .bold()

                Spacer()

                Button {
                    showAddContribution.toggle()
                } label: {
                    Image.plus
                        .padding(.sizeSmall)
                        .background(
                            Circle().stroke(lineWidth: .circleLineWidth)
                        )
                        .foregroundColor(.black)
                }
            }
            .padding(.top, .sizeLargeExtra)

            List(viewModel.sortedContributions, id: \.self) { contribution in
                SimpleListRow(
                    title: contribution.date.toString(),
                    subtitle: contribution.amount.currencyFormatted,
                    showArrow: false
                )
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(
                    top: .sizeSmall,
                    leading: .sizeSmall,
                    bottom: .sizeMedium,
                    trailing: .sizeSmall
                ))
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, .sizeLarge)
    }
}

//MARK: - Additional Views

private struct AddContributionView: View {

    @EnvironmentObject var viewModel: PortfolioDetailViewModel

    @Binding var show: Bool
    var isInputActive: FocusState<Bool>.Binding

    @State private var date = Date()
    @State private var amount: String = ""

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(.backgroundOpacity)
                .onTapGesture {
                    show.toggle()
                }

            VStack(alignment: .center, spacing: .sizeLargeExtra) {
                Text(.addContribution)
                    .font(.title2)
                    .bold()

                CustomTextfield(
                    placeholder: .amount,
                    text: $amount,
                    keyboardType: .decimalPad,
                    onEditingEnd: {
                        amount = amount.currencyFormatted
                    }
                )
                    .padding(.top, .sizeLarge)
                    .focused(isInputActive)

                DatePicker(.date, selection: $date, displayedComponents: .date)
                    .padding(.bottom, .sizeLargeExtra)
                    .padding(.horizontal, .sizeNormal)

                Button { [weak viewModel] in
                    viewModel?.input(
                        .addContribution(date: date, amount: amount)
                    )
                    show.toggle()
                } label: {
                    Text(LocalizedStringKey.accept.toString().uppercased())
                        .font(.headline)
                        .padding(.horizontal, .sizeLarge)
                        .padding(.vertical, .sizeLarge)
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(
                                cornerSize: CGSize(
                                    width: .sizeLargeExtra, height: .sizeLargeExtra
                                )
                            )
                                .foregroundColor(.secondaryColor)
                        )
                }
            }
            .padding([.horizontal, .top], .sizeLarge)
            .padding(.bottom, .sizeLargeExtra)
            .background(Color.white)
            .cornerRadius(.cornerSize, corners: [.topLeft, .topRight])
        }
        .edgesIgnoringSafeArea(.all)
    }
}

//MARK: - Previews

struct PortfolioDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactory.portfolioDetailView(
            for: Portfolio(
                id: UUID(),
                name: "Preview",
                value: 110,
                contributions: [
                    Portfolio.Contribution(date: Date(), amount: 1000)
                ]
            )
        )
    }
}
