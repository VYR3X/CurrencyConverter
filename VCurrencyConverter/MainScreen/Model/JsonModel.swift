//
//  JsonModel.swift
//  VCurrencyConverter
//
//  Created by 17790204 on 31.03.2021.
//

import Foundation

struct CurrencyJsonModel: Codable {
	let disclaimer: String
	let date: String
	let timestamp: Int
	let base: String
	let rates: [String: Double]
}
