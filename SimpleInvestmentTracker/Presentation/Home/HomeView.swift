//
//  HomeView.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 6/4/22.
//

import SwiftUI

private extension LocalizedStringKey {
    static var portfolio: Self { "My Portfolio" }
    static var investments: Self { "Investments" }
    static var unknown: Self { "Unknown" }
    static var addInvestment: Self { "Add portfolio" }
}

private extension Color {
    static var shadowColor: Self { .black.opacity(0.2) }
}

//MARK: - Main View

struct HomeView: View {

    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        NavigationView {
            ContentView()
                .environmentObject(viewModel)
                .navigationBarItems(trailing: addButton)
                .navigationBarTitle("", displayMode: .inline)
        }
    }

    var addButton: some View {
        NavigationLink(destination: ViewFactory.addPortfolioView) {
            Text(.addInvestment)
                .foregroundColor(.white)
                .bold()
        }
    }
}

//MARK: - Additional Views

private struct ContentView: View {

    @EnvironmentObject var viewModel: HomeViewModel

    var body: some View {

        VStack(alignment: .leading) {
            headerView

            investmentsList
                .background(Color.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .edgesIgnoringSafeArea(.bottom)
        }
        .background(Color.primaryColor)
        .onAppear {
            viewModel.trigger(input: .loadData)
        }
    }

    var headerView: some View {
        VStack(alignment: .leading, spacing: .sizeSmall) {
            Text(.portfolio)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)

            Text(viewModel.totalValue.currencyFormatted)
                .font(.largeTitle)
                .foregroundColor(.white)
            
            growthView
                .padding(.top, .sizeSmall)
        }
        .padding(.horizontal, .sizeLarge)
        .padding(.bottom, .sizeLargeExtra)
    }

    var growthView: some View {
        HStack(spacing: .zero) {
            viewModel.isPositive ? Image.arrowUp : Image.arrowDown

            Text(
                viewModel.gains.currencyFormatted + " (\(viewModel.yield.percentageFormatted))"
            )
                .font(.title3)
                .bold()
        }
        .foregroundColor(viewModel.isPositive ? .green : .red)
    }

    var investmentsList: some View {
        VStack(alignment: .leading) {
            Text(.investments)
                .font(.title2)
                .bold()
                .padding(.top, .sizeLargeExtra)

            List {
                ForEach(viewModel.portfolioList) { portfolio in
                    HStack {
                        VStack(alignment: .leading, spacing: .sizeSmall) {
                            Text(portfolio.name)
                                .bold()

                            Text(portfolio.value.currencyFormatted)
                        }
                        .padding(.leading, .sizeMedium)

                        Spacer()

                        Image.arrowRight
                            .padding(.trailing, .sizeSmall)
                    }
                    .padding(.sizeMedium)
                    .background(Color.white)
                    .cornerRadius(.sizeNormal)
                    .shadow(color: .shadowColor, radius: .sizeSmall)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(
                        top: .sizeSmall,
                        leading: .sizeSmall,
                        bottom: .sizeSmall,
                        trailing: .sizeSmall
                    ))
                }
                .onDelete { [weak viewModel] indexSet in
                    viewModel?.trigger(input: .deletePortfolios(indexSet))
                }
            }
            .listStyle(.plain)
            .padding(.horizontal, -.sizeSmall)
        }
        .padding(.horizontal, .sizeLarge)
    }
}

//MARK: - Previews

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactory.homeView
    }
}
