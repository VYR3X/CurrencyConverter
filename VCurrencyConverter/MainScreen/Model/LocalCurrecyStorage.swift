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

	static var reserveExchangeRates: [CBRCurrency: Double]? {
		get {
			return UserDefaults.standard.object(forKey: SettingsKeys.reserveExchangeRates.rawValue) as? [CBRCurrency: Double] ?? [:]
		}
		set {
			let defaults = UserDefaults.standard
			let key = SettingsKeys.reserveExchangeRates.rawValue
			if let dictionary = newValue {
				defaults.set(dictionary, forKey: key)
			} else {
				defaults.removeObject(forKey: key)
			}
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
			return reserveExchangeRates!
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
