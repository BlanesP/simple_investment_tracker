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

//MARK: - Main View

struct HomeView: View {

    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        NavigationView {
            contentView
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

    var contentView: some View {

        VStack(alignment: .leading) {
            InvestmentHeader(
                name: LocalizedStringKey.portfolio.toString(),
                value: viewModel.totalValue,
                contributed: viewModel.totalContributed
            )

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

    var investmentsList: some View {
        VStack(alignment: .leading) {
            Text(.investments)
                .font(.title2)
                .bold()
                .padding(.top, .sizeLargeExtra)

            List {
                ForEach(viewModel.portfolioList) { portfolio in
                    SimpleListRow(
                        title: portfolio.name,
                        subtitle: portfolio.value.currencyFormatted,
                        showArrow: true
                    )
                        .background(
                            NavigationLink(
                                destination: ViewFactory.portfolioDetailView(for: portfolio),
                                label: { EmptyView() }
                            )
                            .opacity(0)
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
