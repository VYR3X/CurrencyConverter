//
//  OutputView.swift
//  VCurrencyConverter
//
//  Created by 17790204 on 12.04.2021.
//

import UIKit

/// Протокол делегата для управления OutputView
protocol OutputViewDelegate: NSObject {
	/// Вибираем валюту которую будем конвертировать
	func selectNewOutputCurrency()
}

/// Вью с указанием валюты и суммы
final class OutputView: UIView {

	weak var delegate: OutputViewDelegate?

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

	/// Наименование валюты в которую мы перевели деньги
	let currencyLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.sizeToFit()
		label.text = CBRCurrency.USD.rawValue
		label.font = UIFont.boldSystemFont(ofSize: 17)
		label.textColor = .blue //LightPalette().color(.darkBlue)
		label.backgroundColor = .clear
		label.numberOfLines = 1
		label.textAlignment = .center
		return label
	}()

	/// Результат пересчета
	lazy var resultTextField: UITextField = {
		let textField = UITextField()
		textField.isUserInteractionEnabled = false
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.backgroundColor = .clear
		textField.sizeToFit()
		textField.text = "0"
		textField.textColor = .black
		textField.textAlignment = .left

		textField.layer.borderColor = UIColor.systemGray.cgColor
		textField.layer.borderWidth = 0.5
		textField.layer.cornerRadius = 3

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

		modelInfoStaskView.addArrangedSubview(resultTextField)
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
		delegate?.selectNewOutputCurrency()
	}
}
