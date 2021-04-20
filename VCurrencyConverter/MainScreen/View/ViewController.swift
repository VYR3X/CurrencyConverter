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
		imageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
		imageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
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

	private var scrollView: UIScrollView = {
		let scrollView = UIScrollView(frame: .zero)
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		return scrollView
	}()

	private lazy var contentViewSuka = UIView()
	private lazy var mainContentView = ContentView()

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		registerNotifications()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = "Обменник валют"
		view.backgroundColor = .white
		self.hideKeyboardWhenTappedAround()
		setupScrollView()
		setupView()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		scrollView.contentInset.bottom = 0
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
	private func convertCurrencyCBR(value: Double,
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
			let result = String(format:"%.2f", localresult)
			self.resultCurrencyLabel.resultTextField.text = result
		}
		print("••• \(value) \(localInputCurrency) = \(localresult) \(localOutputCurrency) •••")
	}

	// MARK: - Keyboard

	private func registerNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}

	@objc func keyboardWillShow(notification: NSNotification) {
		guard let userInfo = notification.userInfo else { return }
		var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
		keyboardFrame = self.view.convert(keyboardFrame, from: nil)

		var contentInset: UIEdgeInsets = self.scrollView.contentInset
		contentInset.bottom = keyboardFrame.size.height // + 20 px
		scrollView.contentInset = contentInset
	}

	@objc func keyboardWillHide(notification: NSNotification) {
		let contentInset: UIEdgeInsets = UIEdgeInsets.zero
		scrollView.contentInset = contentInset
	}

	@objc private func swapCurrency() {
		let temp = localInputCurrency
		localInputCurrency = localOutputCurrency
		localOutputCurrency = temp
		convertCurrencyCBR(value: inputValue,
						   inputCurrency: localInputCurrency,
						   outputCurrency: localOutputCurrency)
	}

	private func setupScrollView() {
		contentViewSuka.translatesAutoresizingMaskIntoConstraints = false

		self.view.addSubview(scrollView)
		scrollView.pinToSuperView()
		scrollView.addSubview(contentViewSuka)
		contentViewSuka.pinToSuperView()
	}

	private func setupView() {
//		contentViewSuka.addSubview(mainContentView)
//		contentViewSuka.backgroundColor = .orange
//		mainContentView.leftAnchor.constraint(equalTo: contentViewSuka.leftAnchor).isActive = true
//		mainContentView.rightAnchor.constraint(equalTo: contentViewSuka.rightAnchor).isActive = true
//		mainContentView.topAnchor.constraint(equalTo: contentViewSuka.topAnchor).isActive = true
//		mainContentView.bottomAnchor.constraint(equalTo: contentViewSuka.bottomAnchor).isActive = true

		contentViewSuka.addSubviews(fromLabel,
						 currencyToConvertLabel,
						 swapImageView,
						 toLabel,
						 resultCurrencyLabel,
						 infoLabel)
		NSLayoutConstraint.activate([
			fromLabel.leftAnchor.constraint(equalTo: contentViewSuka.leftAnchor, constant: 20),
			fromLabel.rightAnchor.constraint(equalTo: contentViewSuka.rightAnchor, constant: -20),
			fromLabel.topAnchor.constraint(equalTo: contentViewSuka.safeAreaLayoutGuide.topAnchor, constant: 20),
			fromLabel.heightAnchor.constraint(equalToConstant: 40),

			currencyToConvertLabel.leftAnchor.constraint(equalTo: contentViewSuka.leftAnchor, constant: 20),
			currencyToConvertLabel.rightAnchor.constraint(equalTo: contentViewSuka.rightAnchor, constant: -20),
			currencyToConvertLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor),

			swapImageView.topAnchor.constraint(equalTo: currencyToConvertLabel.bottomAnchor, constant: 25),
			swapImageView.centerXAnchor.constraint(equalTo: fromLabel.centerXAnchor),

			toLabel.leftAnchor.constraint(equalTo: contentViewSuka.leftAnchor, constant: 20),
			toLabel.rightAnchor.constraint(equalTo: contentViewSuka.rightAnchor, constant: -20),
			toLabel.topAnchor.constraint(equalTo: swapImageView.bottomAnchor),
			toLabel.heightAnchor.constraint(equalToConstant: 40),

			resultCurrencyLabel.leftAnchor.constraint(equalTo: contentViewSuka.leftAnchor, constant: 20),
			resultCurrencyLabel.rightAnchor.constraint(equalTo: contentViewSuka.rightAnchor, constant: -20),
			resultCurrencyLabel.topAnchor.constraint(equalTo: toLabel.bottomAnchor),

			infoLabel.leftAnchor.constraint(equalTo: contentViewSuka.leftAnchor, constant: 20),
			infoLabel.rightAnchor.constraint(equalTo: contentViewSuka.rightAnchor, constant: -20),
			infoLabel.topAnchor.constraint(equalTo: resultCurrencyLabel.bottomAnchor, constant: 25),
			infoLabel.bottomAnchor.constraint(equalTo: contentViewSuka.bottomAnchor)
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

// для скрытия клавиатуры
extension UIViewController {
	func hideKeyboardWhenTappedAround() {
		let tapGesture = UITapGestureRecognizer(target: self,
						 action: #selector(hideKeyboard))
		view.addGestureRecognizer(tapGesture)
	}

	@objc func hideKeyboard() {
		view.endEditing(true)
	}
}
