//
//  Currency.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/05/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class Currency: NSObject, NSCoding {
    
    private(set) var code: String!
    
    private init(code: String) {
        self.code = code
    }
    
    class func currency(forCode code: String) -> Currency {
        return Currency(code: code)
    }
    
    class func allCurrencyCodes() -> [String] {
        var result = [String]()
        result.append(contentsOf: iso4127CurrencyCodes())
        result.append(contentsOf: nonIso4217CurrencyCodes())
        return result
    }
    
    /**
     Returns a list of all ISO 4127 currencies
     - returns: Array<String> containing all ISO 4217 Currencies
     */
    class func iso4127CurrencyCodes() -> [String] {
        var result = [String]()
        result.append("AED") // United Arab Emirates dirham
        result.append("AFN") // Afghan afghani
        result.append("ALL") // Albanian lek
        result.append("AMD") // Armenian dram
        result.append("ANG") // Netherlands Antillean guilder
        result.append("AOA") // Angolan kwanza
        result.append("ARS") // Argentine peso
        result.append("AUD") // Australian dollar
        result.append("AWG") // Aruban florin
        result.append("AZN") // Azerbaijani manat
        result.append("BAM") // Bosnia and Herzegovina convertible mark
        result.append("BBD") // Barbados dollar
        result.append("BDT") // Bangladeshi taka
        result.append("BGN") // Bulgarian lev
        result.append("BHD") // Bahraini dinar
        result.append("BIF") // Burundian franc
        result.append("BMD") // Bermudian dollar
        result.append("BND") // Brunei dollar
        result.append("BOB") // Boliviano
        result.append("BOV") // Bolivian Mvdol (funds code)
        result.append("BRL") // Brazilian real
        result.append("BSD") // Bahamian dollar
        result.append("BTN") // Bhutanese ngultrum
        result.append("BWP") // Botswana pula
        result.append("BYN") // Belarusian ruble
        result.append("BZD") // Belize dollar
        result.append("CAD") // Canadian dollar
        result.append("CDF") // Congolese franc
        result.append("CHE") // WIR Euro (complementary currency)
        result.append("CHF") // Swiss franc
        result.append("CHW") // WIR Franc (complementary currency)
        result.append("CLF") // Unidad de Fomento (funds code)
        result.append("CLP") // Chilean peso
        result.append("CNY") // Chinese yuan
        result.append("COP") // Colombian peso
        result.append("COU") // Unidad de Valor Real (UVR) (funds code)[7]
        result.append("CRC") // Costa Rican colon
        result.append("CUC") // Cuban convertible peso
        result.append("CUP") // Cuban peso
        result.append("CVE") // Cape Verde escudo
        result.append("CZK") // Czech koruna
        result.append("DJF") // Djiboutian franc
        result.append("DKK") // Danish krone
        result.append("DOP") // Dominican peso
        result.append("DZD") // Algerian dinar
        result.append("EGP") // Egyptian pound
        result.append("ERN") // Eritrean nakfa
        result.append("ETB") // Ethiopian birr
        result.append("EUR") // Euro
        result.append("FJD") // Fiji dollar
        result.append("FKP") // Falkland Islands pound
        result.append("GBP") // Pound sterling
        result.append("GEL") // Georgian lari
        result.append("GHS") // Ghanaian cedi
        result.append("GIP") // Gibraltar pound
        result.append("GMD") // Gambian dalasi
        result.append("GNF") // Guinean franc
        result.append("GTQ") // Guatemalan quetzal
        result.append("GYD") // Guyanese dollar
        result.append("HKD") // Hong Kong dollar
        result.append("HNL") // Honduran lempira
        result.append("HRK") // Croatian kuna
        result.append("HTG") // Haitian gourde
        result.append("HUF") // Hungarian forint
        result.append("IDR") // Indonesian rupiah
        result.append("ILS") // Israeli new shekel
        result.append("INR") // Indian rupee
        result.append("IQD") // Iraqi dinar
        result.append("IRR") // Iranian rial
        result.append("ISK") // Icelandic króna
        result.append("JMD") // Jamaican dollar
        result.append("JOD") // Jordanian dinar
        result.append("JPY") // Japanese yen
        result.append("KES") // Kenyan shilling
        result.append("KGS") // Kyrgyzstani som
        result.append("KHR") // Cambodian riel
        result.append("KMF") // Comoro franc
        result.append("KPW") // North Korean won
        result.append("KRW") // South Korean won
        result.append("KWD") // Kuwaiti dinar
        result.append("KYD") // Cayman Islands dollar
        result.append("KZT") // Kazakhstani tenge
        result.append("LAK") // Lao kip
        result.append("LBP") // Lebanese pound
        result.append("LKR") // Sri Lankan rupee
        result.append("LRD") // Liberian dollar
        result.append("LSL") // Lesotho loti
        result.append("LYD") // Libyan dinar
        result.append("MAD") // Moroccan dirham
        result.append("MDL") // Moldovan leu
        result.append("MGA") // Malagasy ariary
        result.append("MKD") // Macedonian denar
        result.append("MMK") // Myanmar kyat
        result.append("MNT") // Mongolian tögrög
        result.append("MOP") // Macanese pataca
        result.append("MRO") // Mauritanian ouguiya
        result.append("MUR") // Mauritian rupee
        result.append("MVR") // Maldivian rufiyaa
        result.append("MWK") // Malawian kwacha
        result.append("MXN") // Mexican peso
        result.append("MXV") // Mexican Unidad de Inversion (UDI) (funds code)
        result.append("MYR") // Malaysian ringgit
        result.append("MZN") // Mozambican metical
        result.append("NAD") // Namibian dollar
        result.append("NGN") // Nigerian naira
        result.append("NIO") // Nicaraguan córdoba
        result.append("NOK") // Norwegian krone
        result.append("NPR") // Nepalese rupee
        result.append("NZD") // New Zealand dollar
        result.append("OMR") // Omani rial
        result.append("PAB") // Panamanian balboa
        result.append("PEN") // Peruvian Sol
        result.append("PGK") // Papua New Guinean kina
        result.append("PHP") // Philippine peso
        result.append("PKR") // Pakistani rupee
        result.append("PLN") // Polish złoty
        result.append("PYG") // Paraguayan guaraní
        result.append("QAR") // Qatari riyal
        result.append("RON") // Romanian leu
        result.append("RSD") // Serbian dinar
        result.append("RUB") // Russian ruble
        result.append("RWF") // Rwandan franc
        result.append("SAR") // Saudi riyal
        result.append("SBD") // Solomon Islands dollar
        result.append("SCR") // Seychelles rupee
        result.append("SDG") // Sudanese pound
        result.append("SEK") // Swedish krona/kronor
        result.append("SGD") // Singapore dollar
        result.append("SHP") // Saint Helena pound
        result.append("SLL") // Sierra Leonean leone
        result.append("SOS") // Somali shilling
        result.append("SRD") // Surinamese dollar
        result.append("SSP") // South Sudanese pound
        result.append("STD") // São Tomé and Príncipe dobra
        result.append("SVC") // Salvadoran colón
        result.append("SYP") // Syrian pound
        result.append("SZL") // Swazi lilangeni
        result.append("THB") // Thai baht
        result.append("TJS") // Tajikistani somoni
        result.append("TMT") // Turkmenistani manat
        result.append("TND") // Tunisian dinar
        result.append("TOP") // Tongan paʻanga
        result.append("TRY") // Turkish lira
        result.append("TTD") // Trinidad and Tobago dollar
        result.append("TWD") // New Taiwan dollar
        result.append("TZS") // Tanzanian shilling
        result.append("UAH") // Ukrainian hryvnia
        result.append("UGX") // Ugandan shilling
        result.append("USD") // United States dollar
        result.append("USN") // United States dollar (next day) (funds code)
        result.append("UYI") // Uruguay Peso en Unidades Indexadas (URUIURUI) (funds code)
        result.append("UYU") // Uruguayan peso
        result.append("UZS") // Uzbekistan som
        result.append("VEF") // Venezuelan bolívar
        result.append("VND") // Vietnamese đồng
        result.append("VUV") // Vanuatu vatu
        result.append("WST") // Samoan tala
        result.append("XAF") // CFA franc BEAC
        result.append("XAG") // Silver (one troy ounce)
        result.append("XAU") // Gold (one troy ounce)
        result.append("XBA") // European Composite Unit (EURCO) (bond market unit)
        result.append("XBB") // European Monetary Unit (E.M.U.-6) (bond market unit)
        result.append("XBC") // European Unit of Account 9 (E.U.A.-9) (bond market unit)
        result.append("XBD") // European Unit of Account 17 (E.U.A.-17) (bond market unit)
        result.append("XCD") // East Caribbean dollar
        result.append("XDR") // Special drawing rights
        result.append("XOF") // CFA franc BCEAO
        result.append("XPD") // Palladium (one troy ounce)
        result.append("XPF") // CFP franc (franc Pacifique)
        result.append("XPT") // Platinum (one troy ounce)
        result.append("XSU") // SUCRE
        result.append("XTS") // Code reserved for testing purposes
        result.append("XUA") // ADB Unit of Account
        result.append("XXX") // No currency
        result.append("YER") // Yemeni rial
        result.append("ZAR") // South African rand
        result.append("ZMW") // Zambian kwacha
        result.append("ZWL") // Zimbabwean dollar A/10
        return result
    }
    
    /**
     Returns a list of non ISO 4217 Currency Codes (e.g. crypto-currencies, non-official ones, etc.) 
     Mostly ones that have been requested over time.
     - returns: Array<String> containing all non ISO 4217 Currencies
     */
    class func nonIso4217CurrencyCodes() -> [String] {
        var result = [String]()
        
        // https://en.wikipedia.org/wiki/ISO_4217#Non_ISO_4217_currencies
        result.append("BYN")  // New Belarus Currency
        result.append("CNH")  // Chinese yuan (when traded offshore) - Hong Kong
        result.append("CNT")  // Chinese yuan (when traded offshore) - Taiwan
        result.append("GGP")  // Guernsey pound
        result.append("IMP")  // Isle of Man pound
        result.append("JEP")  // Jersey pound
        result.append("KID")  // Kiribati dollar
        result.append("NIS")  // New Israeli Shekel
        result.append("PRB")  // Transnistrian ruble
        result.append("SLS")  // Somaliland Shillings
        result.append("TVD")  // Tuvalu dollar
        
        // https://coinmarketcap.com/
        result.append("BTC")  // Bitcoin (Old Code)
        result.append("DOGE") // Dogecoin
        result.append("ETH")  // Etherium
        result.append("GNT")  // Golem Project
        result.append("LTC")  // Litecoin
        result.append("PPC")  // Peercoin
        result.append("SC")   // SiaCoin
        result.append("SJCX") // Storjcoin
        result.append("XBT")  // Bitcoin (New Code)
        result.append("XMR")  // Monero
        result.append("XRP")  // Ripple
        
        // Misc Requests from over the years:
        result.append("BYR")  // Belarusian ruble
        result.append("BSF")  // Venezuelan Bolivar
        result.append("DRC")  // Congolese Franc
        result.append("GHS")  // Ghanaian Cedi
        result.append("GST")  // Goods and Services Tax (Not sure how this got here but...?)
        result.append("LVL")  // Latvian lats (Replaced by Euro in 2014)
        result.append("LTL")  // Lithuanian litas (Replaced by Euro in 2015)
        result.append("XOF")  // West African CFA Franc
        result.append("XFU")  // UIC Franc (Replaced by Euro in 2013)
        result.append("ZMK")  // Zambian Kwacha
        result.append("ZWD")  // Zimbabwean Dollar

        return result
    }
    
    //MARK: NSCoding Protocol
    
    required init?(coder aDecoder: NSCoder) {
        code = aDecoder.decodeObject(forKey: "code") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(code, forKey: "code")
    }
    
}
