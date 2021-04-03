//
//  CurrencyJSONParser.swift
//  VCurrencyConverter
//
//  Created by 17790204 on 31.03.2021.
//

import Foundation

class CurrencyJSONParser: NSObject {

	// URL для получения валют в json формате
	private let jsonUrl = "https://www.cbr-xml-daily.ru/latest.js"

	// Курс обмена валют ЦБ РФ
	private var exchangeRatesCBR: [CBRCurrency: Double] = [
		.RUB : 1.0 // Base currency
	]

	// Получение курса валют
	public func getExchangeRatesFromCBR() -> [CBRCurrency : Double] {
		return exchangeRatesCBR
	}

	/// Запрос на получение валют
	func getCurrencyesJson() {

		let url = URL(string: jsonUrl)
		let request = URLRequest(url: url!)

		let task = URLSession.shared.dataTask(with: request) { data, responce, error in
//			print(String(decoding: data!, as: UTF8.self))
			if let data = data, let model = try? JSONDecoder().decode(CurrencyJsonModel.self, from: data) {
				// перевожу [String: Double] -> [Currency: Double]
				self.setExchangeRatesCBR(model: model.rates)
			}
		}
		task.resume()
	}

	/// Формируем кортеж с [USD: 0.01321, ....]
	private func makeExchangeRate(currency: String, rate: Double) -> (currency: CBRCurrency, rate: Double)? {
		guard let currency = CBRCurrency(rawValue: currency) else { return nil }
		return (currency, rate)
	}

	private func setExchangeRatesCBR(model: [String: Double]) {
		model.map { item in
			guard let exchangeRate = makeExchangeRate(currency: item.key, rate: item.value) else { return }
			exchangeRatesCBR.updateValue(exchangeRate.rate, forKey: exchangeRate.currency)
//			return exchangeRate
		}
	}
}
