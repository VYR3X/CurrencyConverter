//
//  UserGroupMemberPresentable.swift
//  VCurrencyConverter
//
//  Created by 17790204 on 03.04.2021.
//

import UIKit

/// Модель для хедера шторки
struct HeaderPresentableModel: Equatable {
	let handle: String
	let description: String
	let memberCount: Int
}

/// Модель ячейки с информацией о разработчике
struct UserGroupMemberPresentable: Equatable {
	let name: String
	let role: String
	let avatarBackgroundColor: UIColor
}

/// Модель ячейки с информацией о выбираемой валюте
struct CurrencyModel: Equatable {
	/// Код валюты из трех букв: RUB
	let codeName: String
	/// Знак валюты 
	let currencySing: String
	/// Полное наименование валюты
	let fullName: String
	/// Флаг страны
	let flag: String
}


/// Вью модель для отображения информации о валюте в шторке
struct CurrencyViewModel {

	/// Строка хранящая флаг страны
	let flag: String

	/// Полная расшифровка названия валюты
	let fullName: String

	/// Знак валюты
	let currencySing: String

	/// Краткая запись названия валюты  в три символа
	let codeName: String

	/// Текущий курс валюты
	let currentExchangeRate: String

	/// Показатель изменения курса
	let trend: String

	init(model: CurrencyModel) {
		flag = model.flag
		fullName = model.fullName
		currencySing = model.currencySing
		codeName = model.codeName
		currentExchangeRate = "0"
		trend = "-"
	}

	private func getFlag(model: CurrencyModel) -> String {
		return "🇪🇺"
	}

	private func trend(current: Double, previous: Double) -> String {
		return current > previous ? "▲" : "▼"
	}

	private func getCurrentExchangeRate() -> String {
		return ""
	}
}
