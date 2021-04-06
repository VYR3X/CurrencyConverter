//
//  UserGroupHeaderView.swift
//  VCurrencyConverter
//
//  Created by 17790204 on 03.04.2021.
//

import UIKit

/// Хедер вью для экрана со списокм доступных валют
final class HeaderView: UIView {

	private struct Constants {
		static let contentInsets = UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0)
	}

	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Lato-Bold", size: 17.0)
		label.textColor = #colorLiteral(red: 0.8196078431, green: 0.8235294118, blue: 0.8274509804, alpha: 1)
		return label
	}()

	private let subtitleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 2
		label.textColor = #colorLiteral(red: 0.7019607843, green: 0.7058823529, blue: 0.7137254902, alpha: 1)
		label.font = UIFont(name: "Lato-Regular", size: 13.0)
		return label
	}()

	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
		stackView.axis = .vertical
		stackView.alignment = .leading
		stackView.spacing = 4.0
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	private let seperatorView: UIView = {
		let view = UIView()
		view.backgroundColor = #colorLiteral(red: 0.8196078431, green: 0.8235294118, blue: 0.8274509804, alpha: 1).withAlphaComponent(0.11)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	// MARK: - Initializers

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1137254902, blue: 0.1294117647, alpha: 1)
		addSubview(stackView)
		addSubview(seperatorView)
		setupConstraints()
	}

	required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	private func setupConstraints() {
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.contentInsets.top),
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentInsets.left),
			stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.contentInsets.right),
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.contentInsets.bottom),

			seperatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
			seperatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
			seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
			seperatorView.heightAnchor.constraint(equalToConstant: 1.0)
		])
	}

	/// Метод для передачи значений внутрь хедер вью
	/// - Parameter presentable: модель данных
	func configure(with presentable: HeaderPresentableModel) {
		titleLabel.text = presentable.handle
		subtitleLabel.text = "\(presentable.memberCount) элементов  |  \(presentable.description)"
	}
}

