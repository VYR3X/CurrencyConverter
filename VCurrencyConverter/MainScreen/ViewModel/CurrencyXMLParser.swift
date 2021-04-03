//
//  CurrencyXMLParser.swift
//  VCurrencyConverter
//
//  Created by 17790204 on 13.03.2021.
//

import Foundation


class CurrencyXMLParser: NSObject {

	// URL для получения валют в xml формате
	private let xmlURL = "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"

	// Курс обмена валют Европейского Центрального Банка
	private var exchangeRates: [Currency : Double] = [
		.EUR : 1.0 // Base currency
	]

	// Получение курса валют из ECB - Европейского Центрального Банка
	public func getExchangeRates() -> [Currency : Double] {
		return exchangeRates
	}

	public func parse(completion : @escaping () -> Void,
					  errorCompletion : @escaping () -> Void) {

		guard let url = URL(string: xmlURL) else { return }
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			guard let data = data, error == nil else {
				print("Failed to parse the XML!")
				print(error ?? "Unknown error")
				errorCompletion()
				return
			}
			let parser = XMLParser(data: data)
			parser.delegate = self
			if parser.parse() {
				completion()
			} else {
				errorCompletion()
			}
		}
		task.resume()
	}

	// Private Methods:
	private func makeExchangeRate(currency: String, rate: String) -> (currency: Currency, rate: Double)? {
		guard let currency = Currency(rawValue: currency) else { return nil }
		guard let rate = Double(rate) else { return nil }
		return (currency, rate)
	}
}

// MARK: - XMLParserDelegate
extension CurrencyXMLParser: XMLParserDelegate {

	func parser(_ parser: XMLParser,
				didStartElement elementName: String,
				namespaceURI: String?,
				qualifiedName qName: String?,
				attributes attributeDict: [String : String] = [:]) {
		if elementName == "Cube" {
			guard let currency = attributeDict["currency"] else { return }
			guard let rate = attributeDict["rate"] else { return }
			guard let exchangeRate = makeExchangeRate(currency: currency, rate: rate) else { return }
			exchangeRates.updateValue(exchangeRate.rate, forKey: exchangeRate.currency)
		}
	}
}

