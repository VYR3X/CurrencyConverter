//
//  ViewController.swift
//  VCurrencyConverter
//
//  Created by 17790204 on 13.03.2021.
//

import UIKit

final class ViewController: UIViewController {

	private let currencyViewModel = CurrencyConverterViewModel()

	private let fromLabel: UILabel = {
		let label = UILabel()
		label.text = "Меняем:"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private lazy var currencyToConvertLabel: InputView = {
		let view = InputView()
		view.delegate = self
		return view
	}()

	private let toLabel: UILabel = {
		let label = UILabel()
		label.text = "Получаем:"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private lazy var resultCurrnecyLabel: InputView = {
		let view = InputView()
		view.delegate = self
		return view
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = "Обменник валют"
		setupView()
//		convertCurrency(value: 0, valueCurrency: .RUB, outputCurrency: .USD)
		convertCurrencyCBR(value: 0, valueCurrency: .RUB, outputCurrency: .USD)
	}

	/// Метод пересчета валюты
	/// - Parameters:
	///   - value: сумма для конвертации
	///   - valueCurrency: наименование валюты для обмена
	///   - outputCurrency: наименование валюты результата
	func convertCurrencyCBR(value: Double,
							valueCurrency: Currency,
							outputCurrency: Currency) {
		// Обновили
		currencyViewModel.updateExchangeRatesCBR()
		// Получили данные
		let secondResult = self.currencyViewModel.CBRconvert(value, valueCurrency: .RUB, outputCurrency: .USD)
		// Обновили UI
		DispatchQueue.main.async {
			self.currencyToConvertLabel.currencyLabel.text = "RUB"
			self.resultCurrnecyLabel.currencyLabel.text = "USD"
			let result = String(format:"%f", secondResult ?? 0)
			self.resultCurrnecyLabel.amountTextField.text = result
		}
		print("••• \(value) RUB = \(secondResult ?? 0) USD •••")
	}

	func convertCurrency(value: Double,
						 valueCurrency: Currency,
						 outputCurrency: Currency) {
		// Обновляем курс валют
		currencyViewModel.updateExchangeRates(completion: {
			// The code inside here runs after all the data is fetched.

			// • Example_1 (USD to EUR):
//			let doubleResult = self.currencyConverter.convert(10, valueCurrency: .USD, outputCurrency: .EUR)
//			print("••• 10 USD = \(doubleResult!) EUR •••")

			let secondResult = self.currencyViewModel.convert(value, valueCurrency: .RUB, outputCurrency: .USD)
			DispatchQueue.main.async {
				self.currencyToConvertLabel.currencyLabel.text = "RUB"
//				self.currencyToConvertLabel.amountTextField.text = "\(value)"
				self.resultCurrnecyLabel.currencyLabel.text = "USD"
				let result = String(format:"%f", secondResult ?? 0)
				self.resultCurrnecyLabel.amountTextField.text = result
			}
			print("••• \(value) RUB = \(secondResult!) USD •••")

			// • Example_2 (EUR to GBP) - Returning a formatted String:
//			let formattedResult = self.currencyConverter.convertAndFormat(10, valueCurrency: .EUR, outputCurrency: .GBP, numberStyle: .decimal, decimalPlaces: 4)
//			print("••• Formatted Result (10 EUR to GBP): \(formattedResult!) •••")
		})
	}

	func setupView() {
		view.addSubview(fromLabel)
		view.addSubview(currencyToConvertLabel)
		view.addSubview(toLabel)
		view.addSubview(resultCurrnecyLabel)
		NSLayoutConstraint.activate([
			fromLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			fromLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			fromLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			fromLabel.heightAnchor.constraint(equalToConstant: 40),

			currencyToConvertLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			currencyToConvertLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			currencyToConvertLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor),

			toLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			toLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			toLabel.topAnchor.constraint(equalTo: currencyToConvertLabel.bottomAnchor),
			toLabel.heightAnchor.constraint(equalToConstant: 40),

			resultCurrnecyLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			resultCurrnecyLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			resultCurrnecyLabel.topAnchor.constraint(equalTo: toLabel.bottomAnchor)
		])
	}
}

extension ViewController: InputViewDelegate {

	func selectNewCurrency() {
		print("USD")
	}

	func inputAmount(value: Double) {
		// пересчет по европейсокму банку
//		convertCurrency(value: value, valueCurrency: .RUB, outputCurrency: .USD)
		convertCurrencyCBR(value: value, valueCurrency: .RUB, outputCurrency: .USD)
	}
}
