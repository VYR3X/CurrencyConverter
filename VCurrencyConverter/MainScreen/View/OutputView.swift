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
	lazy var resultLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.backgroundColor = .white
		label.sizeToFit()
		label.text = "0"
		label.textAlignment = .center
		label.layer.cornerRadius = 3
		label.layer.shadowColor = UIColor.black.cgColor
		label.layer.shadowOpacity = 0.5
		label.layer.shadowOffset = .zero
		label.layer.shadowRadius = 1
		return label
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

		modelInfoStaskView.addArrangedSubview(resultLabel)
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
