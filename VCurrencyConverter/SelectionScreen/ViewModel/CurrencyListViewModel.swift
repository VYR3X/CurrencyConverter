//
//  SelectionViewModel.swift
//  VCurrencyConverter
//
//  Created by 17790204 on 04.04.2021.
//

import Foundation

/// View Model  для управления моделью с данными
final class CurrencyListViewModel {

	/// Массив вью моделей для шторки со списком валют
	private var currencyViewModels: [CurrencyViewModel] = []

	/// Массив для заполнения таблицы
	private var currencyModels: [CurrencyModel] = [
		CurrencyModel(codeName: "AUD", currencySing: "€", fullName: "Австралийский доллар", flag: "🇦🇺"),
		CurrencyModel(codeName: "AZN", currencySing: "₼", fullName: "Азербайджанский манат", flag: "🇷🇺"),
		CurrencyModel(codeName: "GBP", currencySing: "£", fullName: "Фунт стерлингов Соединенного королевства", flag: "🇪🇺"),
		CurrencyModel(codeName: "AMD", currencySing: "€", fullName: "Армянских драм", flag: "🇪🇺"),
		CurrencyModel(codeName: "BYN", currencySing: "€", fullName: "Белорусский рубль", flag: "🇪🇺"),
		CurrencyModel(codeName: "BGN", currencySing: "€", fullName: "Болгарский лев", flag: "🇧🇬"),
		CurrencyModel(codeName: "BRL", currencySing: "€", fullName: "Бразильский реал", flag: "🇧🇷"),
		CurrencyModel(codeName: "HUF", currencySing: "€", fullName: "Венгерских форинт", flag: "🇪🇺"),
		CurrencyModel(codeName: "HKD", currencySing: "€", fullName: "Гонконгских доллар", flag: "🇭🇰"),
		CurrencyModel(codeName: "DKK", currencySing: "€", fullName: "Датская крона", flag: "🇪🇺"),
		CurrencyModel(codeName: "USD", currencySing: "$", fullName: "Доллар США", flag: "🇪🇺"),
		CurrencyModel(codeName: "INR", currencySing: "₨", fullName: "Индийских рупи", flag: "🇪🇺"),
		CurrencyModel(codeName: "CAD", currencySing: "€", fullName: "Канадский доллар", flag: "🇨🇦"),
		CurrencyModel(codeName: "CNY", currencySing: "¥", fullName: "Китайский юань", flag: "🇪🇺"),
		CurrencyModel(codeName: "NOK", currencySing: "€", fullName: "Норвежская крона", flag: "🇪🇺"),
		CurrencyModel(codeName: "RON", currencySing: "€", fullName: "Румынский лей", flag: "🇪🇺"),
		CurrencyModel(codeName: "SGD", currencySing: "€", fullName: "Сингапурский доллар", flag: "🇧🇬"),
		CurrencyModel(codeName: "TRY", currencySing: "₺", fullName: "Турецкая лира", flag: "🇪🇺"),
		CurrencyModel(codeName: "UZS", currencySing: "€", fullName: "Узбекских сумов", flag: "🇪🇺"),
		CurrencyModel(codeName: "CZK", currencySing: "€", fullName: "Чешских крон", flag: "🇨🇿"),
		CurrencyModel(codeName: "CHF", currencySing: "€", fullName: "Швейцарский франк", flag: "🇨🇭"),
		CurrencyModel(codeName: "KRW", currencySing: "€", fullName: "Вон Республики Корея", flag: "🇪🇺"),
		CurrencyModel(codeName: "RUB", currencySing: "€", fullName: "Российский рубль", flag: "🇪🇺"),
		CurrencyModel(codeName: "EUR", currencySing: "€", fullName: "Евро", flag: "🇷🇺"),
		CurrencyModel(codeName: "KZT", currencySing: "₸", fullName: "Казахстанский тенге", flag: "🇪🇺"),
		CurrencyModel(codeName: "KGS", currencySing: "€", fullName: "Киргизский сом", flag: "🇪🇺"),
		CurrencyModel(codeName: "MDL", currencySing: "€", fullName: "Молдавский леев", flag: "🇪🇺"),
		CurrencyModel(codeName: "PLN", currencySing: "Zł", fullName: "Польский злотый", flag: "🇧🇬"),
		CurrencyModel(codeName: "XDR", currencySing: "€", fullName: "СДР", flag: "🇪🇺"),
		CurrencyModel(codeName: "TJS", currencySing: "€", fullName: "Таджикских сомони", flag: "🇪🇺"),
		CurrencyModel(codeName: "TMT", currencySing: "€", fullName: "Новый туркменский манат", flag: "🇪🇺"),
		CurrencyModel(codeName: "UAH", currencySing: "₴", fullName: "Украинских гривен", flag: "🇪🇺"),
		CurrencyModel(codeName: "SEK", currencySing: "€", fullName: "Шведских крон", flag: "🇸🇪"),
		CurrencyModel(codeName: "ZAR", currencySing: "€", fullName: "Южноафриканских рэндов", flag: "🇿🇦"),
		CurrencyModel(codeName: "JPY", currencySing: "¥", fullName: "Японских иен", flag: "🇯🇵")
	]

	/// Метод получения массива вью моделей
	func getViewModel() -> [CurrencyViewModel] {
		currencyViewModels = currencyModels.map({ item in
			CurrencyViewModel(model: item)
		})
		return currencyViewModels
	}
}
