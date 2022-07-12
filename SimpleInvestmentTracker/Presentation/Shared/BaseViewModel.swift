//
//  BaseViewModel.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 12/7/22.
//

import Foundation

protocol BaseViewModel: ObservableObject {
    associatedtype ViewInput

    func trigger(input: ViewInput)
}
