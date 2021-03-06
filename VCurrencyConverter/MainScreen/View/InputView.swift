//
//  InputView.swift
//  VCurrencyConverter
//
//  Created by 17790204 on 19.03.2021.
//

import UIKit

/// Протокол делегата для управления InputView
protocol InputViewDelegate: NSObject {
	/// Вибираем валюту которую будем конвертировать
	func selectNewCurrency()
	/// Сумма для пересчета
	func inputAmount(value: Double)
}

/// Вью с указанием валюты и суммы
final class InputView: UIView {

	weak var delegate: InputViewDelegate?

	private lazy var currencyButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = .white
		button.layer.cornerRadius = 3
		button.layer.shadowColor = UIColor.black.cgColor
		button.layer.shadowOpacity = 0.5
		button.layer.shadowOffset = .zero
		button.layer.shadowRadius = 1
		button.addTarget(self, action: #selector(selectNewCurrency(sender:)), for: .touchUpInside)
		return button
	}()

	/// Валюта которую мы хотим пересчитать
	let currencyLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.sizeToFit()
		label.text = "RUB"
		label.font = UIFont.boldSystemFont(ofSize: 17)
		label.textColor = .blue //LightPalette().color(.darkBlue)
		label.backgroundColor = .clear
		label.numberOfLines = 1
		label.textAlignment = .center
		return label
	}()

	/// Cумма  которую вводит пользователь для пересчета
	lazy var amountTextField: UITextField = {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.backgroundColor = .clear
		textField.layer.borderColor = UIColor.systemGray.cgColor

		textField.layer.borderWidth = 0.5
		textField.layer.cornerRadius = 3
		textField.textColor = .black
		textField.sizeToFit()
		textField.delegate = self

		// Cтандартный плейс холдер плохо отображается на устройстве
		// https://stackoverflow.com/questions/26076054/changing-placeholder-text-color-with-swift
		textField.attributedPlaceholder = NSAttributedString(string: "Введите сумму",
															 attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
		textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

		textField.keyboardType = .decimalPad

		// Отступ слева
		let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
		textField.leftViewMode = UITextField.ViewMode.always
		textField.leftView = spacerView

		return textField
	}()

	private let modelInfoStaskView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.spacing = 25
		stackView.axis = .horizontal
		stackView.distribution = .fillEqually
		return stackView
	}()

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	override init(frame: CGRect) {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
		setupView()
	}

	private func setupView() {
		currencyButton.addSubview(currencyLabel)
		currencyLabel.pinToSuperView()

		modelInfoStaskView.addArrangedSubview(amountTextField)
		modelInfoStaskView.addArrangedSubview(currencyButton)
		addSubview(modelInfoStaskView)
		self.backgroundColor = .clear

		NSLayoutConstraint.activate([
			modelInfoStaskView.topAnchor.constraint(equalTo: topAnchor),
			modelInfoStaskView.bottomAnchor.constraint(equalTo: bottomAnchor),
			modelInfoStaskView.leadingAnchor.constraint(equalTo: leadingAnchor),
			modelInfoStaskView.trailingAnchor.constraint(equalTo: trailingAnchor),
		])
	}

	@objc private func selectNewCurrency(sender: UIButton) {
		delegate?.selectNewCurrency()
	}

	@objc func textFieldDidChange(_ textField: UITextField) {
		guard let text = textField.text else { return }
		let formettedText = changeSymbol(text: text)
		let amount: Double = Double(formettedText) ?? 0
		delegate?.inputAmount(value: amount)
	}

	/// На устройстве клавиатура имеет запятую ) приходиться менять на точку
	private func changeSymbol(text: String) -> String {
		return text.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil)
	}
}


// MARK: - UITextFieldDelegate
// реализацию выенсти в контроллер
extension InputView: UITextFieldDelegate {

	// при нажатии на клавиатуре enter скрывается клавиатура
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		// called when 'return' key pressed. return NO to ignore.
//		print("TextField should return method called")
		textField.resignFirstResponder()
		return true
	}

	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		// return NO to disallow editing.
//		print("TextField should begin editing method called")
		return true
	}

	func textFieldDidBeginEditing(_ textField: UITextField) {
		// became first responder
//		print("TextField did begin editing method called")
	}

	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
//		print("TextField should snd editing method called")
		return true
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
//		print("TextField did end editing method called")
	}

	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
		// if implemented, called in place of textFieldDidEndEditing:
//		print("TextField did end editing with reason method called")
	}

	func textField(_ textField: UITextField,
				   shouldChangeCharactersIn range: NSRange,
				   replacementString string: String) -> Bool {
		// return NO to not change text
//		print("While entering the characters this method gets called")

		// Set the maximum character length of a UITextField in Swift
		let maxLength = 7 // 1 миллион )
		let currentString = (textField.text ?? "") as NSString
		let newString = currentString.replacingCharacters(in: range, with: string) as NSString
		return newString.length <= maxLength
//		return true
	}

	func textFieldShouldClear(_ textField: UITextField) -> Bool {
		// called when clear button pressed. return NO to ignore (no notifications)
//		print("TextField should clear method called")
		return true
	}
}
