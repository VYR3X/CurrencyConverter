//
//  ViewController.swift
//  VCurrencyConverter
//
//  Created by 17790204 on 13.03.2021.
//

import UIKit

/// Вью контроллер главного экрана: Экран с конвертацией валюты
final class ViewController: UIViewController {

	private let currencyViewModel = CurrencyConverterViewModel()

	// переменные для пересохранения ) 
	private var localValue: Double = 0
	private var localOutputCurrency: CBRCurrency = .USD

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

	private lazy var resultCurrencyLabel: InputView = {
		let view = InputView()
		view.delegate = self
		return view
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = "Обменник валют"
		setupView()
		// При старте приложения по умолчанию выводим перевод из рублей в доллары )
		convertCurrencyCBR(value: 0, valueCurrency: .RUB, outputCurrency: .USD)
	}

	/// Метод пересчета валюты
	/// - Parameters:
	///   - value: сумма для конвертации
	///   - valueCurrency: наименование валюты для обмена
	///   - outputCurrency: наименование валюты результата
	func convertCurrencyCBR(value: Double,
							valueCurrency: CBRCurrency,
							outputCurrency: CBRCurrency) {
		// Обновили
		currencyViewModel.updateExchangeRatesCBR()
		// Получили данные
		let secondResult = self.currencyViewModel.CBRconvert(value, valueCurrency: .RUB, outputCurrency: outputCurrency)
		localValue = secondResult ?? 0
		localOutputCurrency = outputCurrency
		// Обновили UI
		DispatchQueue.main.async {
			self.currencyToConvertLabel.currencyLabel.text = valueCurrency.rawValue
			self.resultCurrencyLabel.currencyLabel.text = outputCurrency.rawValue
			let result = String(format:"%f", secondResult ?? 0)
			self.resultCurrencyLabel.amountTextField.text = result
		}
		print("••• \(value) RUB = \(secondResult ?? 0) USD •••")
	}

	private func setupView() {
		view.addSubview(fromLabel)
		view.addSubview(currencyToConvertLabel)
		view.addSubview(toLabel)
		view.addSubview(resultCurrencyLabel)
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

			resultCurrencyLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			resultCurrencyLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			resultCurrencyLabel.topAnchor.constraint(equalTo: toLabel.bottomAnchor)
		])
	}
}

extension ViewController: InputViewDelegate {

	func selectNewCurrency() {
		let nextViewController = CurrencyListViewController(vc: self)
//		self.navigationController?.pushViewController(vc, animated: true)
		self.present(nextViewController, animated: true, completion: nil)

		// презент через шторку
//		presentPanModal(nextViewController)
	}

	func inputAmount(value: Double) {
		// пересчет по европейсокму банку
//		convertCurrency(value: value, valueCurrency: .RUB, outputCurrency: .USD)
		convertCurrencyCBR(value: value, valueCurrency: .RUB, outputCurrency: localOutputCurrency)
	}
}

extension ViewController: CurrencyListViewControllerDelegate {

	func selectCurrency(vm: CurrencyViewModel) {
		convertCurrencyCBR(value: localValue, valueCurrency: .RUB, outputCurrency: CBRCurrency(rawValue: vm.codeName)!)
//		DispatchQueue.main.async {
//			self.currencyToConvertLabel.currencyLabel.text = "RUB"
//			self.resultCurrencyLabel.currencyLabel.text = vm.codeName
//		}
	}
}
