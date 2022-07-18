//
//  BaseViewModel.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 12/7/22.
//

import Combine
import Foundation

protocol BaseViewModel: ObservableObject {
    associatedtype ViewInput
    associatedtype ViewOutput

    var output: PassthroughSubject<ViewOutput, Never> { get }

    func input(_ input: ViewInput)
}
