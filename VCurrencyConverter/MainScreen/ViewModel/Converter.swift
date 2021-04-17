//
//  Converter.swift
//  VCurrencyConverter
//
//  Created by 17790204 on 13.03.2021.
//

import Foundation

/// ViewModel 
final class CurrencyConverterViewModel {

	private var exchangeRatesCBR: [CBRCurrency : Double] = [:]
	private let jsonParser = CurrencyJSONParser()

	init() {
//		updateExchangeRates {}
		updateExchangeRatesCBR()
	}

	/// Обновляем обменный курс и после этого запускает завершение
	/// - Parameter completion: обработчик завершения
	public func updateExchangeRatesCBR(completion: @escaping() -> Void = {}) {
		jsonParser.getCurrencyesJson(completion: { result in
			switch result {
			case .success(let model):
				print("Данные получены успешно \n")
				// Получает курс обмена
				self.exchangeRatesCBR = model
				LocalCurrecyStorage.reserveExchangeRates = model
//				LocalCurrecyStorage.saveExchangeRates(model)
				completion()
			case .failure(let error):
				print("error: \n \(error)")
				self.exchangeRatesCBR = LocalCurrecyStorage.reserveExchangeRates 
//				self.exchangeRatesCBR = LocalCurrecyStorage.loadMostRecentExchangeRates()
				completion()
			}
		})
	}

	/*
	Преобразует значение типа Double на основе его валюты (valueCurrency) и выходной валюты (outputCurrency).
	Пример преобразования доллара в евро: convert (42, valueCurrency: .USD, outputCurrency: .EUR)

	Чтобы перевести рубли в доллары надо  1.0 / model.rates["USD"] == 76 рублей )
	*/
	public func CBRconvert(_ value: Double,
						_ valueCurrency: CBRCurrency,
						_ outputCurrency: CBRCurrency) -> Double? {
		guard let valueRate = exchangeRatesCBR[valueCurrency] else { return nil }
		guard let outputRate = exchangeRatesCBR[outputCurrency] else { return nil }
		let multiplier = outputRate / valueRate
		print("Текущий курс валюты: \(multiplier)")
		let kratnost = value * multiplier
		return kratnost
	}

//	public func CBRconvert(_ value: Double,
//						_ valueCurrency: CBRCurrency,
//						_ outputCurrency: CBRCurrency) -> Double? {
//		guard let valueRate = exchangeRatesCBR[valueCurrency] else { return nil }
//		guard let outputRate = exchangeRatesCBR[outputCurrency] else { return nil }
//		let multiplier = valueRate / outputRate
//		let kratnost = value / multiplier
////		print("Текущий курс валюты: \(outputRate)")
//		return kratnost
//	}

	/**
	 Returns a formatted string from a double value.
	 Usage example: format(42, numberStyle: .currency, decimalPlaces: 4)
	 */
	public func format(_ value: Double,
					   numberStyle: NumberFormatter.Style,
					   decimalPlaces: Int) -> String? {
		let formatter = NumberFormatter()
		formatter.numberStyle = numberStyle
		formatter.maximumFractionDigits = decimalPlaces
		return formatter.string(from: NSNumber(value: value))
	}


	//	https://stackoverflow.com/questions/28332946/how-do-i-get-the-current-date-in-short-format-in-swift

	/// Получаем дату как строку
	/// - Returns: строка с датой в формате "dd-MM-yyyy"
	func getCurrentShortDate() -> String {
		let todaysDate = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd-MM-yyyy"
		let date = dateFormatter.string(from: todaysDate)
		return changeSymbol(date: date)
	}

	private func changeSymbol(date: String) -> String {
		return date.replacingOccurrences(of: "-", with: ".", options: .literal, range: nil)
	}
}
