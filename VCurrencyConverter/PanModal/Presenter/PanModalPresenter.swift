//
//  PanModalPresenter.swift
//  VCurrencyConverter
//
//  Created by 17790204 on 03.04.2021.
//

// https://github.com/slackhq/PanModal

#if os(iOS)
import UIKit

/**
 A protocol for objects that will present a view controller as a PanModal

 - Usage:
 ```
 viewController.presentPanModal(viewControllerToPresent: presentingVC,
											 sourceView: presentingVC.view,
											 sourceRect: .zero)
 ```
 */
protocol PanModalPresenter: AnyObject {

	/**
	 A flag that returns true if the current presented view controller
	 is using the PanModalPresentationDelegate
	 */
	var isPanModalPresented: Bool { get }

	/**
	 Presents a view controller that conforms to the PanModalPresentable protocol
	 */
	func presentPanModal(_ viewControllerToPresent: PanModalPresentable.LayoutType,
						 sourceView: UIView?,
						 sourceRect: CGRect,
						 completion: (() -> Void)?)

}
#endif

