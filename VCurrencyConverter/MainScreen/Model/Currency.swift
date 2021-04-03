//
//  Currency.swift
//  VCurrencyConverter
//
//  Created by 17790204 on 13.03.2021.
//

// Перечисление валют
enum Currency: String, CaseIterable {

	case AUD = "AUD"; case INR = "INR"; case TRY = "TRY"
	case BGN = "BGN"; case ISK = "ISK"; case USD = "USD"
	case BRL = "BRL"; case JPY = "JPY"; case ZAR = "ZAR"
	case CAD = "CAD"; case KRW = "KRW"
	case CHF = "CHF"; case MXN = "MXN"
	case CNY = "CNY"; case MYR = "MYR"
	case CZK = "CZK"; case NOK = "NOK"
	case DKK = "DKK"; case NZD = "NZD"
	case EUR = "EUR"; case PHP = "PHP"
	case GBP = "GBP"; case PLN = "PLN"
	case HKD = "HKD"; case RON = "RON"
	case HRK = "HRK"; case RUB = "RUB"
	case HUF = "HUF"; case SEK = "SEK"
	case IDR = "IDR"; case SGD = "SGD"
	case ILS = "ILS"; case THB = "THB"

	// Public Static Methods:
	/** Returns a currency name with it's flag (🇺🇸 USD, for example). */
	static func nameWithFlag(for currency: Currency) -> String {
		return (Currency.flagsByCurrencies[currency] ?? "?") + " " + currency.rawValue
	}

	// Public Properties:
	/** Returns an array with all currency names and their respective flags. */
	static let allNamesWithFlags: [String] = {
		var namesWithFlags: [String] = []
		for currency in Currency.allCases {
			namesWithFlags.append(Currency.nameWithFlag(for: currency))
		}
		return namesWithFlags
	}()

	static let flagsByCurrencies : [Currency : String] = [
		.AUD : "🇦🇺", .INR : "🇮🇳", .TRY : "🇹🇷",
		.BGN : "🇧🇬", .ISK : "🇮🇸", .USD : "🇺🇸",
		.BRL : "🇧🇷", .JPY : "🇯🇵", .ZAR : "🇿🇦",
		.CAD : "🇨🇦", .KRW : "🇰🇷",
		.CHF : "🇨🇭", .MXN : "🇲🇽",
		.CNY : "🇨🇳", .MYR : "🇲🇾",
		.CZK : "🇨🇿", .NOK : "🇳🇴",
		.DKK : "🇩🇰", .NZD : "🇳🇿",
		.EUR : "🇪🇺", .PHP : "🇵🇭",
		.GBP : "🇬🇧", .PLN : "🇵🇱",
		.HKD : "🇭🇰", .RON : "🇷🇴",
		.HRK : "🇭🇷", .RUB : "🇷🇺",
		.HUF : "🇭🇺", .SEK : "🇸🇪",
		.IDR : "🇮🇩", .SGD : "🇸🇬",
		.ILS : "🇮🇱", .THB : "🇹🇭",
	]

	static let currencySign : [Currency : String] = [
		.AUD : "🇦🇺", .INR : "🇮🇳", .TRY : "🇹🇷",
		.BGN : "🇧🇬", .ISK : "🇮🇸", .USD : "🇺🇸",
		.BRL : "🇧🇷", .JPY : "🇯🇵", .ZAR : "🇿🇦",
		.CAD : "🇨🇦", .KRW : "🇰🇷",
		.CHF : "🇨🇭", .MXN : "🇲🇽",
		.CNY : "¥", .MYR : "🇲🇾",
		.CZK : "🇨🇿", .NOK : "🇳🇴",
		.DKK : "🇩🇰", .NZD : "🇳🇿",
		.EUR : "€", .PHP : "🇵🇭",
		.GBP : "🇬🇧", .PLN : "🇵🇱",
		.HKD : "🇭🇰", .RON : "🇷🇴",
		.HRK : "🇭🇷", .RUB : "₽",
		.HUF : "🇭🇺", .SEK : "🇸🇪",
		.IDR : "🇮🇩", .SGD : "🇸🇬",
		.ILS : "🇮🇱", .THB : "🇹🇭",
	]

}

