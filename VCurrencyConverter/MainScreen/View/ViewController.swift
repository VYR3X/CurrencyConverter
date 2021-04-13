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
		label.textColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private lazy var currencyToConvertLabel: InputView = {
		let view = InputView()
		view.delegate = self
		return view
	}()

	private lazy var swapImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "arrow1")
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
		imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(swapCurrency))
		imageView.isUserInteractionEnabled = true
		imageView.addGestureRecognizer(tapGestureRecognizer)
		return imageView
	}()

	private let toLabel: UILabel = {
		let label = UILabel()
		label.text = "Получаем:"
		label.textColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private lazy var resultCurrencyLabel: OutputView = {
		let view = OutputView()
		view.delegate = self
		return view
	}()

	private lazy var infoLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = #colorLiteral(red: 0.7019607843, green: 0.7058823529, blue: 0.7137254902, alpha: 1)
		label.backgroundColor = .clear
		label.font = UIFont(name: "Lato-Regular", size: 13.0)
		label.text = "По курсу ЦБ РФ на " + currencyViewModel.getCurrentShortDate()
		return label
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = "Обменник валют"
		self.navigationController?.navigationBar.barTintColor = .black
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

	@objc private func swapCurrency() {
		let temp = localInputCurrency
		localInputCurrency = localOutputCurrency
		localOutputCurrency = temp
		convertCurrencyCBR(value: inputValue,
						   inputCurrency: localInputCurrency,
						   outputCurrency: localOutputCurrency)
	}

	private func setupView() {
		view.addSubview(fromLabel)
		view.addSubview(currencyToConvertLabel)
		view.addSubview(swapImageView)
		view.addSubview(toLabel)
		view.addSubview(resultCurrencyLabel)
		view.addSubview(infoLabel)
		NSLayoutConstraint.activate([
			fromLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			fromLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			fromLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			fromLabel.heightAnchor.constraint(equalToConstant: 40),

			currencyToConvertLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			currencyToConvertLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			currencyToConvertLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor),

			swapImageView.topAnchor.constraint(equalTo: currencyToConvertLabel.bottomAnchor, constant: 25),
			swapImageView.centerXAnchor.constraint(equalTo: fromLabel.centerXAnchor),

			toLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			toLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			toLabel.topAnchor.constraint(equalTo: swapImageView.bottomAnchor),
			toLabel.heightAnchor.constraint(equalToConstant: 40),

			resultCurrencyLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			resultCurrencyLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			resultCurrencyLabel.topAnchor.constraint(equalTo: toLabel.bottomAnchor),

			infoLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			infoLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			infoLabel.topAnchor.constraint(equalTo: resultCurrencyLabel.bottomAnchor, constant: 25)
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
