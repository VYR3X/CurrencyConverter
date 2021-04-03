//
//  CBRCurrency.swift
//  VCurrencyConverter
//
//  Created by 17790204 on 03.04.2021.
//

// https://www.cbr-xml-daily.ru

// Перечисление валют
enum CBRCurrency: String, CaseIterable {

	case AUD = "AUD"; case AZN = "AZN";
	case GBP = "GBP"; case AMD = "AMD";
	case BYN = "BYN"; case BGN = "BGN";
	case BRL = "BRL"; case HUF = "HUF";
	case HKD = "HKD"; case DKK = "DKK";
	case USD = "USD"; case EUR = "EUR";
	case INR = "INR"; case KZT = "KZT";
	case CAD = "CAD"; case KGS = "KGS";
	case CNY = "CNY"; case MDL = "MDL";
	case NOK = "NOK"; case PLN = "PLN";
	case RON = "RON"; case XDR = "XDR";
	case SGD = "SGD"; case TJS = "TJS";
	case TRY = "TRY"; case TMT = "TMT";
	case UZS = "UZS"; case UAH = "UAH";
	case CZK = "CZK"; case SEK = "SEK";
	case CHF = "CHF"; case ZAR = "ZAR";
	case KRW = "KRW"; case JPY = "JPY";
	case RUB = "RUB";

	static let fullCurrencyNames: [CBRCurrency: String] = [
		.AUD: "Австралийский доллар", .AZN: "Азербайджанский манат",
		.GBP: "Фунт стерлингов Соединенного королевства", .AMD: "Армянских драм",
		.BYN: "Белорусский рубль", .BGN: "Болгарский лев",
		.BRL: "Бразильский реал", .HUF: "Венгерских форинт",
		.HKD: "Гонконгских доллар", .DKK: "Датская крона",
		.USD: "Доллар США", .EUR: "Евро",
		.INR: "Индийских рупи", .KZT: "Казахстанский тенге",
		.CAD: "Канадский доллар", .KGS: "Киргизский сом",
		.CNY: "Китайский юань", .MDL: "Молдавский леев",
		.NOK: "Норвежская крона", .PLN: "Польский злотый",
		.RON: "Румынский лей", .XDR: "СДР",
		.SGD: "Сингапурский доллар", .TJS: "Таджикских сомони",
		.TRY: "Турецкая лира", .TMT: "Новый туркменский манат",
		.UZS: "Узбекских сумов", .UAH: "Украинских гривен",
		.CZK: "Чешских крон", .SEK: "Шведских крон",
		.CHF: "Швейцарский франк", .ZAR: "Южноафриканских рэндов",
		.KRW: "Вон Республики Корея", .JPY: "Японских иен",
		.RUB: "Российский рубль"
	]
}
