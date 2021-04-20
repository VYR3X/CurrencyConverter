//
//  ContentView.swift
//  VCurrencyConverter
//
//  Created by Vladislav Zhokhov on 20.04.2021.
//

import UIKit

/// Вью содержащее все жлементы главного экрана
final class ContentView: UIView {

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
//		view.delegate = self
		return view
	}()

	private lazy var swapImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "arrow1")
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
		imageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
//		let tapGestureRecognizer = UITapGestureRecognizer(target: ViewController, action: #selector(swapCurrency))
		imageView.isUserInteractionEnabled = true
//		imageView.addGestureRecognizer(tapGestureRecognizer)
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
//		view.delegate = self
		return view
	}()

	private lazy var infoLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = #colorLiteral(red: 0.7019607843, green: 0.7058823529, blue: 0.7137254902, alpha: 1)
		label.backgroundColor = .clear
		label.font = UIFont(name: "Lato-Regular", size: 13.0)
//		label.text = "По курсу ЦБ РФ на " + currencyViewModel.getCurrentShortDate()
		return label
	}()

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	override init(frame: CGRect) {
		super.init(frame: .zero)
		self.translatesAutoresizingMaskIntoConstraints = false
		self.backgroundColor = .yellow
		setupView()
	}

	private func setupView() {
		addSubviews(fromLabel,
					currencyToConvertLabel,
					swapImageView,
					toLabel,
					resultCurrencyLabel,
					infoLabel)

		NSLayoutConstraint.activate([
			fromLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
			fromLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
			fromLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
			fromLabel.heightAnchor.constraint(equalToConstant: 40),

			currencyToConvertLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
			currencyToConvertLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
			currencyToConvertLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor),

			swapImageView.topAnchor.constraint(equalTo: currencyToConvertLabel.bottomAnchor, constant: 25),
			swapImageView.centerXAnchor.constraint(equalTo: fromLabel.centerXAnchor),

			toLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
			toLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
			toLabel.topAnchor.constraint(equalTo: swapImageView.bottomAnchor),
			toLabel.heightAnchor.constraint(equalToConstant: 40),

			resultCurrencyLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
			resultCurrencyLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
			resultCurrencyLabel.topAnchor.constraint(equalTo: toLabel.bottomAnchor),

			infoLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
			infoLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
			infoLabel.topAnchor.constraint(equalTo: resultCurrencyLabel.bottomAnchor, constant: 25),
			infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
		])
	}

}


