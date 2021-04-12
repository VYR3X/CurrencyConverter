//
//  Converter.swift
//  VCurrencyConverter
//
//  Created by 17790204 on 13.03.2021.
//

import Foundation

/// ViewModel 
class CurrencyConverterViewModel {

	private var exchangeRates: [Currency : Double] = [:]
	private var exchangeRatesCBR: [CBRCurrency : Double] = [:]
	private let xmlParser = CurrencyXMLParser()
	private let jsonParser = CurrencyJSONParser()

	init() {
//		updateExchangeRates {}
		updateExchangeRatesCBR()
	}

	/* Обновляем обменный курс и после этого запускает завершение. */
	public func updateExchangeRates(completion : @escaping () -> Void = {}) {
		xmlParser.parse(completion: {
			// Получает курс обмена
			self.exchangeRates = self.xmlParser.getExchangeRates()
			// Сохраняет обновленный курс обмена в локальное хранилище устройства
			CurrencyConverterLocalData.saveMostRecentExchangeRates(self.exchangeRates)
			completion()
		}, errorCompletion: {
			// Обработчик поломки интернет соединения и процих ошибок )
			// Загружает самый последний обменный курс из локального хранилища устройства
			self.exchangeRates = CurrencyConverterLocalData.loadMostRecentExchangeRates()
			completion()
		})
	}


	/// Обновляем обменный курс и после этого запускает завершение
	/// - Parameter completion: обработчик завершения
	public func updateExchangeRatesCBR(completion: @escaping() -> Void = {}) {
		jsonParser.getCurrencyesJson()
		exchangeRatesCBR = jsonParser.getExchangeRatesFromCBR()
		CurrencyConverterLocalData.saveMostRecentExchangeRates(self.exchangeRates)
	}

	/**
	Преобразует значение типа Double на основе его валюты (valueCurrency) и выходной валюты (outputCurrency).
	Пример преобразования доллара в евро: convert (42, valueCurrency: .USD, outputCurrency: .EUR)
	 */
	public func convert(_ value: Double,
						valueCurrency: Currency,
						outputCurrency: Currency) -> Double? {
		guard let valueRate = exchangeRates[valueCurrency] else { return nil }
		guard let outputRate = exchangeRates[outputCurrency] else { return nil }
		let multiplier = outputRate / valueRate
		print("Текущий курс валюты: \(valueRate)")
		return value * multiplier
	}

	/*
	чтобы перевести рубли в доллары надо  1.0 / model.rates["USD"] == 76 рублей )
	**/
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
	 Converts a Double value based on it's currency and the output currency, and returns a formatted String.
	 Usage example: convertAndFormat(42, valueCurrency: .USD, outputCurrency: .EUR, numberStyle: .currency, decimalPlaces: 4)
	 */
	public func convertAndFormat(_ value: Double,
								 valueCurrency: Currency,
								 outputCurrency: Currency,
								 numberStyle: NumberFormatter.Style,
								 decimalPlaces: Int) -> String? {
		guard let doubleOutput = convert(value, valueCurrency: valueCurrency, outputCurrency: outputCurrency) else {
			return nil
		}
		return format(doubleOutput, numberStyle: numberStyle, decimalPlaces: decimalPlaces)
	}

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

}

