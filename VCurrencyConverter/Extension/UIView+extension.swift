//
//  UIView+extension.swift
//  VCurrencyConverter
//
//  Created by 17790204 on 19.03.2021.
//
import UIKit

public extension UIView {

	///  Прицепить вью констрейнтами к супервью с одинаковым отступом от всех сторон
	///
	/// - Parameters:
	///   - inset:  отступ
	func pinToSuperView(inset: CGFloat = 0.0) {
		pinToSuperView(insets: UIEdgeInsets(top: inset,
									   left: inset,
									   bottom: inset,
									   right: inset))
	}

	///  Прицепить вью констрейнтами к супервью с разным отступом от всех сторон
	///
	/// - Parameters:
	///   - insets:  отступы
	func pinToSuperView(insets: UIEdgeInsets) {

		guard let superview = superview else { return }

		let top = superview.topAnchor
		let leading = superview.leadingAnchor
		let trailing = superview.trailingAnchor
		let bottom = superview.bottomAnchor

		translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			topAnchor.constraint(equalTo: top, constant: insets.top),
			leadingAnchor.constraint(equalTo: leading, constant: insets.left),
			trailingAnchor.constraint(equalTo: trailing, constant: -insets.right),
			bottomAnchor.constraint(equalTo: bottom, constant: -insets.bottom)
		])
	}
}
