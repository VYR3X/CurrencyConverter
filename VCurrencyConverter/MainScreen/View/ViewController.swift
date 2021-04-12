//
//  ViewController.swift
//  VCurrencyConverter
//
//  Created by 17790204 on 13.03.2021.
//

import UIKit

/// Состояние выбрано валюта для пересчета иил результат 
enum State {
	case inputView
	case outputView
}

/// Вью контроллер главного экрана: Экран с конвертацией валюты
final class ViewController: UIViewController {

	// вью модель
	private let currencyViewModel = CurrencyConverterViewModel()

	// переменные для пересохранения )
	private var inputValue: Double = 0
	private var localInputCurrency: CBRCurrency = .RUB
	private var localOutputCurrency: CBRCurrency = .USD
	private var selectedView: State?

	// MARK: - UI

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

	private lazy var changeButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = .white
		button.heightAnchor.constraint(equalToConstant: 50).isActive = true
		button.widthAnchor.constraint(equalToConstant: 50).isActive = true
		button.layer.cornerRadius = 25
		button.layer.shadowColor = UIColor.black.cgColor
		button.layer.shadowOpacity = 0.5
		button.layer.shadowOffset = .zero
		button.layer.shadowRadius = 1
		button.addTarget(self, action: #selector(selectNewCurrency(sender:)), for: .touchUpInside)
		return button
	}()

	private let toLabel: UILabel = {
		let label = UILabel()
		label.text = "Получаем:"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private lazy var resultCurrencyLabel: OutputView = {
		let view = OutputView()
		view.delegate = self
		return view
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = "Обменник валют"
		setupView()
	}

	/// проверка состояния
	private func moveToState(state: State, currency: CBRCurrency) {
		switch state {
		case .inputView:
			localInputCurrency = currency
		case .outputView:
			localOutputCurrency =  currency
		}
		convertCurrencyCBR(value: inputValue, inputCurrency: localInputCurrency, outputCurrency: localOutputCurrency)
	}

	/// Метод пересчета валюты
	/// - Parameters:
	///   - value: сумма для конвертации
	///   - valueCurrency: наименование валюты для обмена
	///   - outputCurrency: наименование валюты результата
	func convertCurrencyCBR(value: Double,
							inputCurrency: CBRCurrency,
							outputCurrency: CBRCurrency) {
		// Обновили курс валют
		currencyViewModel.updateExchangeRatesCBR()
		inputValue = value
		// Получили данные
		let localresult = self.currencyViewModel.CBRconvert(value, inputCurrency, outputCurrency) ?? 0
		// Обновили UI
		DispatchQueue.main.async {
			self.currencyToConvertLabel.currencyLabel.text = inputCurrency.rawValue
			self.resultCurrencyLabel.currencyLabel.text = outputCurrency.rawValue
			let result = String(format:"%f", localresult)
			self.resultCurrencyLabel.resultLabel.text = result
		}
		print("••• \(value) \(localInputCurrency) = \(localresult) \(localOutputCurrency) •••")
	}

	@objc private func selectNewCurrency(sender: UIButton) {
		let temp = localInputCurrency
		localInputCurrency = localOutputCurrency
		localOutputCurrency = temp
		convertCurrencyCBR(value: inputValue, inputCurrency: localInputCurrency, outputCurrency: localOutputCurrency)
	}

	private func setupView() {
		view.addSubview(fromLabel)
		view.addSubview(currencyToConvertLabel)
		view.addSubview(changeButton)
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

			changeButton.topAnchor.constraint(equalTo: currencyToConvertLabel.bottomAnchor, constant: 25),
			changeButton.centerXAnchor.constraint(equalTo: fromLabel.centerXAnchor, constant: -100),

			toLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			toLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			toLabel.topAnchor.constraint(equalTo: changeButton.bottomAnchor),
			toLabel.heightAnchor.constraint(equalToConstant: 40),

			resultCurrencyLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			resultCurrencyLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			resultCurrencyLabel.topAnchor.constraint(equalTo: toLabel.bottomAnchor)
		])
	}
}


// MARK: - InputViewDelegate

extension ViewController: InputViewDelegate {

	func selectNewCurrency() {
		let nextViewController = CurrencyListViewController(vc: self)
		selectedView = .inputView
		self.present(nextViewController, animated: true, completion: nil)
		// презент через шторку
//		presentPanModal(nextViewController)
	}

	func inputAmount(value: Double) {
		convertCurrencyCBR(value: value,
						   inputCurrency: localInputCurrency,
						   outputCurrency: localOutputCurrency)
	}
}

// MARK: - OutputViewDelegate

extension ViewController: OutputViewDelegate {

	func selectNewOutputCurrency() {
		let nextViewController = CurrencyListViewController(vc: self)
		selectedView = .outputView
		self.present(nextViewController, animated: true, completion: nil)
	}
}


// MARK: - CurrencyListViewControllerDelegate

extension ViewController: CurrencyListViewControllerDelegate {

	func selectCurrency(vm: CurrencyViewModel) {
		guard let state = selectedView,
			  let cur = CBRCurrency(rawValue: vm.codeName) else { return }
		moveToState(state: state, currency: cur)
	}
}
