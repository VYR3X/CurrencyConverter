//
//  SelectionViewController.swift
//  VCurrencyConverter
//
//  Created by 17790204 on 03.04.2021.
//

import UIKit

/// Протокол делегата
protocol CurrencyListViewControllerDelegate{
	func selectCurrency(vm: CurrencyViewModel)
}

/// Контроллер со списком валют
final class CurrencyListViewController: UITableViewController {

	private let viewModel = CurrencyListViewModel()

	private var currencies: [CurrencyViewModel] = []

	private let headerView = HeaderView()

	private let mainViewController: CurrencyListViewControllerDelegate

	private var isShortFormEnabled = false //true

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	init(vc: CurrencyListViewControllerDelegate) {
		mainViewController = vc
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	override func viewDidLoad() {
		super.viewDidLoad()
		setupData()
		setupTableView()
	}

	private func setupData() {
		currencies = viewModel.getViewModel()
	}

	private func setupTableView() {
		tableView.separatorStyle = .none
		tableView.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1137254902, blue: 0.1294117647, alpha: 1)
		tableView.register(CurrencyCell.self, forCellReuseIdentifier: "cell")
	}

	// MARK: - UITableViewDataSource

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return currencies.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CurrencyCell
			else { return UITableViewCell() }

		cell.configure(with: currencies[indexPath.row])
		return cell
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60.0
	}

	// MARK: - UITableViewDelegate

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		headerView.configure(with: HeaderPresentableModel.init(handle: "Выбираем валюту для обмена",
															   description: "Валюты",
															   memberCount: currencies.count))
		return headerView
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		mainViewController.selectCurrency(vm: currencies[indexPath.row])
		dismiss(animated: true, completion: nil)
	}
}


// MARK: - PanModalPresentable

extension CurrencyListViewController: PanModalPresentable {

	var panScrollable: UIScrollView? {
		return tableView
	}

	var shortFormHeight: PanModalHeight {
		return isShortFormEnabled ? .contentHeight(300.0) : longFormHeight
	}

	var scrollIndicatorInsets: UIEdgeInsets {
		let bottomOffset = presentingViewController?.bottomLayoutGuide.length ?? 0
		return UIEdgeInsets(top: headerView.frame.size.height, left: 0, bottom: bottomOffset, right: 0)
	}

	var anchorModalToLongForm: Bool {
		return false
	}

	func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
		let location = panModalGestureRecognizer.location(in: view)
		return headerView.frame.contains(location)
	}

	func willTransition(to state: PanModalPresentationController.PresentationState) {
		guard isShortFormEnabled, case .longForm = state
			else { return }

		isShortFormEnabled = false
		panModalSetNeedsLayoutUpdate()
	}
}
