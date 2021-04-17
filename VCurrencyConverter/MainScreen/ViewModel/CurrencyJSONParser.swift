//
//  CurrencyJSONParser.swift
//  VCurrencyConverter
//
//  Created by 17790204 on 31.03.2021.
//

import Foundation

/// Класс отвечающий за парсинг курса валют
final class CurrencyJSONParser: NSObject {

	// URL для получения валют в json формате
	private let jsonUrl = "https://www.cbr-xml-daily.ru/latest.js"

	// Курс обмена валют ЦБ РФ
	private var exchangeRatesCBR: [CBRCurrency: Double] = [
		.RUB : 1.0 // Base currency
	]

	/// Запрос на получение валют
	/// - Parameter completion: комплишн возвращает словарь с валютами
	func getCurrencyesJson(completion: @escaping (Result<[CBRCurrency: Double], Error>) -> Void) {

		let url = URL(string: jsonUrl)
		let request = URLRequest(url: url!)

		let session = URLSession.shared

		session.dataTask(with: request) { data, responce, error in
			guard let data = data else { return }
			// Проверка успешно ли распарсились данные
			do {
				let fuckdata: Data = Data()
				let currencyJsonModel = try JSONDecoder().decode(CurrencyJsonModel.self, from: fuckdata)
				// перевожу [String: Double] -> [Currency: Double]
				self.setExchangeRatesCBR(model: currencyJsonModel.rates)
				// получаю словарь [Currency: Double]
				let result = self.getExchangeRatesFromCBR()
				// выход
				completion(.success(result))
			}
			catch let jsonError {
				print("could not parse data")
				completion(.failure(jsonError))
			}
		}.resume()
	}

	/// Устанавливаем значения в словарь
	private func setExchangeRatesCBR(model: [String: Double]) {
		for item in model {
			guard let exchangeRate = makeExchangeRate(currency: item.key, rate: item.value) else { return }
			exchangeRatesCBR.updateValue(exchangeRate.rate, forKey: exchangeRate.currency)
		}
	}

	/// Формируем кортеж с [USD: 0.01321, ....]
	private func makeExchangeRate(currency: String, rate: Double) -> (currency: CBRCurrency, rate: Double)? {
		guard let currency = CBRCurrency(rawValue: currency) else { return nil }
		return (currency, rate)
	}

	/// Получение курса валют
	private func getExchangeRatesFromCBR() -> [CBRCurrency : Double] {
		return exchangeRatesCBR
	}
}
