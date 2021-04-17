//
//  LocalCurrecyStorage.swift
//  VCurrencyConverter
//
//  Created by 17790204 on 13.04.2021.
//

import Foundation

/// Локальное хранилище для валюты
final class LocalCurrecyStorage {

	private enum SettingsKeys: String {
		case mostRecentExchangeRates
		case reserveExchangeRates
	}

	/// Словарь для сохранения курса валют
	static var reserveExchangeRates: [CBRCurrency: Double] {
		get {
			if let userDefaultsExchangeRates = UserDefaults.standard.dictionary(forKey: SettingsKeys.mostRecentExchangeRates.rawValue) as? [String: Double] {
				print("Get local value from UserDefaults")
				return convertExchangeRatesFromUserDefaults(userDefaultsExchangeRates)
			} else {
				print("RESIEVE ERROR MODEL FROM UserDefaults")
				return [CBRCurrency: Double]()
			}
		}
		set {
			let key = SettingsKeys.reserveExchangeRates.rawValue
			let dictionary = convertExchangeRatesForUserDefaults(newValue)
			print("Save new value in UserDefaults")
			UserDefaults.standard.set(dictionary, forKey: key)
		}
	}


	// MARK: - Save Currency

	/** Сохраняет самые последние обменные курсы локально. */
	static func saveExchangeRates(_ exchangeRates: [CBRCurrency: Double]) {
		let convertedExchangeRates = convertExchangeRatesForUserDefaults(exchangeRates)
		UserDefaults.standard.set(convertedExchangeRates, forKey: SettingsKeys.mostRecentExchangeRates.rawValue)
	}

	/**
	Преобразует словарь [Currency: Double] с курсами обмена в словарь [String: Double], чтобы его можно было хранить локально.
	так как словаь [Currency: Double] нельзя сразу созратнить в UserDefaults так как Currency - это кастомный тип данных
	 */
	private static func convertExchangeRatesForUserDefaults(_ exchangeRates: [CBRCurrency: Double]) -> [String: Double] {
		var userDefaultsExchangeRates: [String: Double] = [:]
		for exchangeRate in exchangeRates {
			userDefaultsExchangeRates.updateValue(exchangeRate.value, forKey: exchangeRate.key.rawValue)
		}
		return userDefaultsExchangeRates
	}


	// MARK: - Load Currency

	/** Загружает самые последние курсы обмена из локального хранилища. */
	static func loadMostRecentExchangeRates() -> [CBRCurrency: Double] {
		if let userDefaultsExchangeRates = UserDefaults.standard.dictionary(forKey: SettingsKeys.mostRecentExchangeRates.rawValue) as? [String: Double] {
			return convertExchangeRatesFromUserDefaults(userDefaultsExchangeRates)
		} else {
			// Fallback:
			return [CBRCurrency: Double]()
//			return reserveExchangeRates!
		}
	}

	/** Преобразует словарь [String: Double] с курсами обмена в словарь [Currency: Double]. */
	private static func convertExchangeRatesFromUserDefaults(_ userDefaultsExchangeRates: [String: Double]) -> [CBRCurrency: Double] {
		var exchangeRates: [CBRCurrency: Double] = [:]
		for userDefaultExchangeRate in userDefaultsExchangeRates {
			if let currency = CBRCurrency(rawValue: userDefaultExchangeRate.key) {
				exchangeRates.updateValue(userDefaultExchangeRate.value, forKey: currency)
			}
		}
		return exchangeRates
	}
}
