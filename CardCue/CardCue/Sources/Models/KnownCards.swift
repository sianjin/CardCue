import Foundation

enum KnownCards {
    static let all: [String] = {
        let fromRules = RewardStore.shared.rewardRules.map(\.cardName)
        let fromQuarterly = RewardStore.shared.quarterlyCategories.map(\.cardName)
        let configurable = configurableCards.map(\.name)
        var seen = Set<String>()
        return (fromRules + fromQuarterly + configurable)
            .filter { seen.insert($0).inserted }
            .sorted()
    }()

    static func suggestions(for query: String) -> [String] {
        guard !query.isEmpty else { return all }
        let lower = query.lowercased()
        return all.filter { $0.lowercased().contains(lower) }
    }

    struct ConfigurableCard {
        let name: String
        let rewardText: String
        let slots: Int  // how many bonus categories the user can choose
    }

    static let configurableCards: [ConfigurableCard] = [
        ConfigurableCard(name: "Citi Custom Cash", rewardText: "5%", slots: 1),
        ConfigurableCard(name: "Bank of America Customized Cash Rewards", rewardText: "3%", slots: 1),
        ConfigurableCard(name: "U.S. Bank Cash+", rewardText: "5%", slots: 2),
    ]

    static func isConfigurable(_ cardName: String) -> Bool {
        configurableCards.contains { $0.name == cardName }
    }

    static func rewardText(for cardName: String) -> String {
        configurableCards.first { $0.name == cardName }?.rewardText ?? ""
    }

    static func slots(for cardName: String) -> Int {
        configurableCards.first { $0.name == cardName }?.slots ?? 1
    }

    static func icon(for category: String) -> String? {
        // Match by prefix so subcategories (e.g. "Flights – Delta Only") inherit the parent icon.
        for (prefix, symbol) in categoryIcons {
            if category == prefix || category.hasPrefix(prefix + " –") || category.hasPrefix(prefix + " &") {
                return symbol
            }
        }
        return nil
    }

    private static let categoryIcons: [(String, String)] = [
        ("Groceries",         "cart"),
        ("Gas",               "fuelpump"),
        ("Dining",            "fork.knife"),
        ("Drug Stores",       "cross.vial"),
        ("Transit & Commute", "tram.fill"),
        ("Rideshare",         "car.fill"),
        ("Flights",           "airplane"),
        ("Hotels",            "bed.double"),
        ("Car Rentals",       "steeringwheel"),
        ("Streaming",         "play.tv"),
        ("Entertainment",     "theatermasks"),
        ("Fitness",           "figure.run"),
        ("Amazon & Whole Foods", "shippingbox"),
        ("Costco",            "building.2"),
        ("Sam's Club",        "building.2"),
        ("BJ's Wholesale",    "building.2"),
        ("Home Improvement",  "hammer"),
        ("Online Shopping",   "bag"),
        ("Apple Purchases",   "apple.logo"),
        ("PayPal Purchases",  "creditcard"),
        ("Rent",              "house"),
        ("Everything Else",   "square.grid.2x2"),
    ]

    static func defaultCue(for cardName: String) -> String {
        cues[cardName] ?? "e.g. When to use this card"
    }

    private static let cues: [String: String] = [
        // Amex
        "Amex Blue Business Cash": "e.g. 2% on all spending up to $50k/year, then 1%",
        "Amex Blue Business Plus": "e.g. 2x Membership Rewards points up to $50k/year, then 1x",
        "Amex Blue Cash Everyday": "e.g. 3% on US supermarkets, online retail, and gas (up to $6k/yr per category); excludes Costco/Walmart; has 2.7% FTF",
        "Amex Blue Cash Preferred": "e.g. 6% on US supermarkets (up to $6k/yr, then 1%) and streaming; $95 annual fee",
        "Amex Business Gold": "e.g. 4x points auto-calculates on top 2 categories each billing cycle (up to $150k/yr)",
        "Amex Business Platinum": "e.g. 5x on flights and prepaid hotels booked via Amex Travel; $695 annual fee",
        "Amex Cash Magnet": "e.g. Flat 1.5% cash back; has 2.7% FTF",
        "Amex Delta SkyMiles Blue": "e.g. 2x on dining and Delta; no annual fee; no FTF",
        "Amex Delta SkyMiles Gold": "e.g. First checked bag free; $150 annual fee (waived first year)",
        "Amex Delta SkyMiles Gold Business": "e.g. First checked bag free and 20% in-flight savings; $150 annual fee",
        "Amex Delta SkyMiles Platinum": "e.g. Annual companion certificate upon renewal; $350 annual fee",
        "Amex Delta SkyMiles Platinum Business": "e.g. Annual companion certificate + MQD headstart; $350 annual fee",
        "Amex Delta SkyMiles Reserve": "e.g. Delta Sky Club access when flying Delta; $650 annual fee",
        "Amex Delta SkyMiles Reserve Business": "e.g. Delta Sky Club & Centurion Lounge access when flying Delta; $650 annual fee",
        "Amex EveryDay": "e.g. Use 20+ times in a billing cycle to get a 20% point bonus on those purchases",
        "Amex EveryDay Preferred": "e.g. Use 30+ times in a billing cycle to get a 50% point bonus; $95 annual fee",
        "Amex Gold Card": "e.g. 4x on dining worldwide and US supermarkets (up to $25k/yr); $325 annual fee",
        "Amex Green Card": "e.g. 3x on travel, transit, and restaurants; $150 annual fee",
        "Amex Hilton Honors": "e.g. 5x on Hilton, 5x on dining/groceries/gas; no annual fee",
        "Amex Hilton Honors Aspire": "e.g. Automatic top-tier Hilton Diamond status + annual free night; $550 annual fee",
        "Amex Hilton Honors Business": "e.g. 5x on all spending up to $40k/yr; $195 annual fee",
        "Amex Hilton Honors Surpass": "e.g. 6x on dining, groceries, and gas; $150 annual fee",
        "Amex Marriott Bonvoy": "e.g. Legacy card: Annual free night award (up to 35k points); $95 annual fee",
        "Amex Marriott Bonvoy Bevy": "e.g. 1,000 bonus points per stay; free night award only after $15k spend; $250 annual fee",
        "Amex Marriott Bonvoy Brilliant": "e.g. Automatic Marriott Platinum Elite status + annual free night (up to 85k points); $650 annual fee",
        "Amex Marriott Bonvoy Business": "e.g. Annual free night award + 7% discount on eligible Marriott rooms; $125 annual fee",
        "Amex Platinum": "e.g. 5x on flights booked direct or via Amex Travel; $695 annual fee; lounge access",
        // Apple
        "Apple Card": "e.g. 3% at Apple/select merchants and 2% on all other Apple Pay; drops to 1% if you use the physical card",
        // Bank of America
        "Bank of America Air France KLM World Elite": "e.g. 3x on SkyTeam airlines; annual 60 XP loyalty bonus; $89 annual fee",
        "Bank of America Alaska Airlines": "e.g. Annual companion fare + free checked bag; requires active BofA checking for bonus; $75 annual fee",
        "Bank of America Alaska Airlines Business": "e.g. Annual companion fare + free checked bag; $75 annual fee",
        "Bank of America Business Advantage Travel Rewards": "e.g. Flat 1.5 points/$1; points boosted up to 75% via Preferred Rewards; no annual fee",
        "Bank of America Business Advantage Unlimited Cash Rewards": "e.g. Flat 1.5% cash back; earnings boosted up to 2.62% via Preferred Rewards",
        "Bank of America Customized Cash Rewards": "e.g. Manually select one 3% category each calendar month (gas, online shopping, dining, travel, drugstores, or home improvement)",
        "Bank of America Premium Rewards": "e.g. 2 points on travel/dining, 1.5 points elsewhere; boosted up to 3.5% / 2.62% via Preferred Rewards; $95 annual fee",
        "Bank of America Premium Rewards Elite": "e.g. 4 Priority Pass memberships + $550 annual fee; earnings boosted by Preferred Rewards",
        "Bank of America Travel Rewards": "e.g. Flat 1.5 points/$1; no FTF; boosted up to 2.62% via Preferred Rewards",
        "Bank of America Unlimited Cash Rewards": "e.g. Flat 1.5% cash back; boosted up to 2.62% with Preferred Rewards; has 3% FTF",
        // Barclays
        "Barclays Aviator Red World Elite Mastercard": "e.g. First checked bag free on AA; annual $99 companion certificate after anniversary; $99 annual fee",
        "Barclays Aviator Silver World Elite Mastercard": "e.g. Invite/upgrade only: Earns companion certificates and flight credits; $199 annual fee",
        "Barclays Hawaiian Airlines World Elite Mastercard": "e.g. One-time 50% companion discount + free checked bag; $99 annual fee",
        "Barclays JetBlue": "e.g. 3x on JetBlue, 2x on dining/groceries; no annual fee; no FTF",
        "Barclays JetBlue Business": "e.g. 5x on JetBlue, 2x on office supply and dining; free checked bag; $99 annual fee",
        "Barclays JetBlue Plus": "e.g. 6x on JetBlue + free checked bag; 5,000 bonus points every anniversary; $99 annual fee",
        "Barclays Wyndham Rewards Earner Business": "e.g. 8x on gas and Wyndham; automatic Diamond status; $95 annual fee",
        "Barclays Wyndham Rewards Earner Plus": "e.g. 6x on gas and Wyndham; automatic Platinum status; $75 annual fee",
        // Bread
        "Bread Cashback Amex": "e.g. Flat 2% cash back on everything; no annual fee; no FTF",
        // Capital One
        "Capital One Quicksilver": "e.g. Flat 1.5% cash back; no annual fee; no FTF",
        "Capital One QuicksilverOne": "e.g. Flat 1.5% cash back; $39 annual fee; strictly for rebuilding credit",
        "Capital One Savor": "e.g. 4% on dining, entertainment, and streaming; $95 annual fee; no FTF",
        "Capital One SavorOne": "e.g. 3% on dining, entertainment, popular streaming, and grocery stores; no annual fee; no FTF",
        "Capital One Spark Cash Plus": "e.g. Flat 2% cash back; pay-in-full card (no preset limit); $150 annual fee",
        "Capital One Spark Cash Select": "e.g. Flat 1.5% cash back; no annual fee; no FTF",
        "Capital One Spark Miles": "e.g. Flat 2x miles; miles transfer to travel partners; $95 annual fee (waived first year)",
        "Capital One Spark Miles Select": "e.g. Flat 1.5x miles; no annual fee; no FTF",
        "Capital One Venture": "e.g. Flat 2x miles; miles transfer to travel partners; $95 annual fee; no FTF",
        "Capital One Venture X": "e.g. 2x miles on everything; $300 annual travel credit + Capital One/Priority Pass lounge access; $395 annual fee",
        "Capital One Venture X Business": "e.g. 2x miles on everything; $300 annual travel credit; pay-in-full business card; $395 annual fee",
        "Capital One VentureOne": "e.g. Flat 1.25x miles; transfers to partners; no annual fee; no FTF",
        "Capital One Walmart Rewards Mastercard": "e.g. 5% on Walmart.com (including pickup/delivery); drops to 2% for physical in-store shopping",
        // Chase
        "Chase Aer Lingus Visa Signature": "e.g. 3x on Aer Lingus/British Airways/Iberia; $100 annual fee",
        "Chase Amazon Prime Visa": "e.g. 5% on Amazon and Whole Foods; requires active Amazon Prime membership",
        "Chase Amazon Visa": "e.g. 3% on Amazon and Whole Foods; no annual fee (does not require Prime)",
        "Chase Disney Premier Visa": "e.g. 2% on grocery stores, restaurants, gas, and Disney; $49 annual fee",
        "Chase Disney Visa": "e.g. Access to Disney photo spots and 10% off select merch/dining; no annual fee",
        "Chase Freedom Flex": "e.g. 5% on rotating quarterly categories (up to $1.5k/quarter) upon activation; has 3% FTF",
        "Chase Freedom Rise": "e.g. Flat 1.5% cash back; designed for building credit history; no annual fee",
        "Chase Freedom Unlimited": "e.g. 3% on dining/drugstores, 1.5% on everything else; has 3% FTF",
        "Chase IHG One Rewards Premier": "e.g. Automatic Platinum Elite status + annual free night (up to 40k points); $99 annual fee",
        "Chase IHG One Rewards Traveler": "e.g. 4th night free on consecutive points stays; no annual fee",
        "Chase Iberia Visa Signature": "e.g. 3x on Avios-earning airlines; annual $1,000 flight voucher after $30k spend; $95 annual fee",
        "Chase Ink Business Cash": "e.g. 5% on office supply stores and internet/cable/phone services (up to $25k/yr)",
        "Chase Ink Business Preferred": "e.g. 3x on travel, shipping, internet/phone, and select advertising (up to $150k/yr); transfers to partners; $95 annual fee",
        "Chase Ink Business Premier": "e.g. Flat 2% cash back (2.5% on purchases over $5k); points cannot be transferred to travel partners; $195 annual fee",
        "Chase Ink Business Unlimited": "e.g. Flat 1.5% cash back on all business purchases; no annual fee",
        "Chase Marriott Bonvoy Bold": "e.g. 15 annual Elite Night credits; no annual fee; no FTF",
        "Chase Marriott Bonvoy Boundless": "e.g. Annual free night award (up to 35k points); $95 annual fee",
        "Chase Marriott Bonvoy Bountiful": "e.g. 6x at Marriott, 4x on groceries/dining (up to $15k/yr); $250 annual fee",
        "Chase Sapphire Preferred": "e.g. 3x on online groceries only (excludes in-store, Target, and Walmart); primary rental car insurance; $95 annual fee",
        "Chase Sapphire Reserve": "e.g. $300 automatic annual travel credit; 3x on travel/dining; Priority Pass; primary rental car insurance; $550 annual fee",
        "Chase Southwest Rapid Rewards Plus": "e.g. 3,000 bonus points every anniversary; has 3% FTF; $69 annual fee",
        "Chase Southwest Rapid Rewards Premier": "e.g. 6,000 bonus points every anniversary; no FTF; $99 annual fee",
        "Chase Southwest Rapid Rewards Priority": "e.g. $75 annual Southwest travel credit + 7,500 anniversary points; $149 annual fee",
        "Chase United Club Infinite": "e.g. Complimentary United Club lounge access + 2 free checked bags; $525 annual fee",
        "Chase United Explorer": "e.g. First checked bag free (must book flight with this card); 2 annual United Club passes; $95 annual fee (waived first year)",
        "Chase United Gateway": "e.g. 2x on United, gas stations, and transit; no annual fee",
        "Chase United Quest": "e.g. $125 annual United credit + two 5,000-point award flight rebates per year; $250 annual fee",
        "Chase World of Hyatt": "e.g. Annual free night award (Category 1–4); second free night achievable at $15k spend; $95 annual fee",
        "Chase World of Hyatt Business": "e.g. 2x on your top 2 spend categories each quarter; adaptive tier tracking; $199 annual fee",
        // Citi
        "Citi AAdvantage Executive World Elite": "e.g. Admirals Club lounge access for the cardholder and immediate family; $595 annual fee",
        "Citi AAdvantage MileUp": "e.g. 2x on American Airlines and grocery stores; no annual fee",
        "Citi AAdvantage Platinum Select": "e.g. First checked bag free on domestic American Airlines flights; $99 annual fee (waived first year)",
        "Citi AT&T Points Plus": "e.g. Earns ThankYou points; up to $240 in annual bill credits based on monthly spend; no annual fee",
        "Citi Custom Cash": "e.g. Automatically gives 5% back on your highest eligible spend category each billing cycle (up to $500 spent); has 3% FTF",
        "Citi Double Cash": "e.g. Flat 2% cash back (1% when you buy, 1% when you pay); has 3% FTF",
        "Citi Premier": "e.g. 3x on restaurants, supermarkets, gas, EV charging, air travel, and hotels; transfers to partners; $95 annual fee",
        "Citi Rewards+": "e.g. Automatically rounds up earnings to nearest 10 points per purchase; 10% points back on redemptions (up to 10k points/yr)",
        "Citi Strata Elite": "e.g. Ultra-premium card: high multipliers on travel and transfers to airline/hotel partners; $595 annual fee",
        "Citi Strata Premier": "e.g. 3x on restaurants, supermarkets, gas, EV charging, air travel, and hotels; transfers to partners; $95 annual fee",
        "Costco Anywhere Visa by Citi": "e.g. 4% on gas/EV charging globally (up to $7k/yr, then 1%); 3% on restaurants/travel; requires Costco membership",
        "Costco Anywhere Visa Business by Citi": "e.g. 4% on gas/EV charging globally (up to $7k/yr, then 1%); 3% on restaurants/travel",
        // Discover
        "Discover it Cash Back": "e.g. 5% on rotating quarterly categories (up to $1.5k/quarter) upon activation; no FTF",
        "Discover it Chrome": "e.g. 2% on gas and dining (up to $1k combined spend per quarter); no annual fee",
        "Discover it Miles": "e.g. Flat 1.5x miles; Discover matches all miles earned at the end of your first year",
        "Discover it Secured": "e.g. Requires a refundable security deposit; earns 2% cash back on gas and dining (up to $1k/quarter)",
        "Discover it Student Cash Back": "e.g. 5% on rotating categories upon activation; first-year earnings match; no credit history required",
        "Discover it Student Chrome": "e.g. 2% on gas and dining (up to $1k/quarter); first-year earnings match; no credit history required",
        // Fidelity
        "Fidelity Rewards Visa Signature": "e.g. Flat 2% cash back when deposited directly into an eligible Fidelity account; no annual fee",
        // Navy Federal
        "Navy Federal Flagship Rewards Visa Signature": "e.g. 3x on travel, 2x on everything else; requires credit union membership; $49 annual fee",
        "Navy Federal More Rewards American Express": "e.g. 3x on supermarkets, food delivery, dining, gas, and transit; no annual fee",
        "Navy Federal cashRewards Visa Signature": "e.g. Up to 1.75% cash back if you maintain direct deposit with Navy Federal (otherwise 1.5%)",
        // PayPal
        "PayPal Cashback Mastercard": "e.g. 3% cash back on purchases made through PayPal checkout; 1.5% on all other purchases; has 3% FTF",
        // PenFed
        "PenFed Platinum Rewards Visa Signature": "e.g. 5x points on gas/EV charging, 3x on supermarkets/dining; requires credit union membership",
        "PenFed Power Cash Rewards Visa Signature": "e.g. 2% cash back for Honors Advantage members (otherwise 1.5%); no annual fee",
        // Robinhood
        "Robinhood Gold Card": "e.g. Flat 3% cash back on all categories; requires active Robinhood Gold membership; no FTF",
        // Synchrony
        "Synchrony Premier World Mastercard": "e.g. Flat 2% cash back automatically applied as a statement credit; no annual fee",
        "Synchrony Sam's Club Mastercard": "e.g. 5% back on gas globally (up to $6k/yr, then 1%); 3% back at Sam's Club for Plus members",
        // U.S. Bank
        "U.S. Bank Altitude Connect": "e.g. 4x on travel and gas/EV charging; no annual fee; lounge passes included",
        "U.S. Bank Altitude Go": "e.g. 4x cash back on dining and takeout; no annual fee; no FTF",
        "U.S. Bank Altitude Reserve": "e.g. 3x on all mobile wallet purchases (Apple Pay/Google Pay) and direct travel; $400 annual fee",
        "U.S. Bank Business Triple Cash Rewards": "e.g. 3% on gas, office supplies, cell service, and dining; no annual fee",
        "U.S. Bank Cash+": "e.g. Must manually select two 5% categories and one 2% category every quarter (5% capped at $2k spend)",
        "U.S. Bank Shopper Cash Rewards": "e.g. Must manually select two retailers for 6% back (up to $1.5k spend/quarter); $95 annual fee (waived first year)",
        // Wells Fargo
        "Wells Fargo Active Cash": "e.g. Flat 2% cash back on all spending; no annual fee; has 3% FTF",
        "Wells Fargo Autograph": "e.g. 3x on travel, transit, dining, gas/EV charging, streaming, and phone plans; no annual fee; no FTF",
        "Wells Fargo Autograph Journey": "e.g. 5x on hotels, 4x on airlines, 3x on dining; points transfer to airline/hotel partners; $95 annual fee",
    ]

    // Canonical categories in display order.
    // Do NOT add entries here without first adding them to MVP.md and getting approval.
    static let canonicalCategories: [String] = [
        // Everyday
        "Groceries",
        "Groceries – Online",
        "Gas",
        "Gas – Costco",
        "Dining",
        "Drug Stores",
        "Transit & Commute",
        // Rideshare
        "Rideshare – Uber",
        "Rideshare – Lyft",
        // Flights
        "Flights – General",
        "Flights – via Portal",
        "Flights – Delta Only",
        "Flights – United Only",
        "Flights – Southwest Only",
        "Flights – JetBlue Only",
        "Flights – American Airlines Only",
        "Flights – Alaska Airlines Only",
        // Hotels
        "Hotels – General",
        "Hotels – via Portal",
        "Hotels – Hyatt Only",
        "Hotels – Hilton Only",
        "Hotels – Marriott Only",
        "Hotels – IHG Only",
        "Hotels – Wyndham Only",
        // Other travel
        "Car Rentals",
        "Car Rentals – via Portal",
        // Entertainment & Lifestyle
        "Streaming",
        "Entertainment",
        "Fitness",
        // Shopping
        "Amazon & Whole Foods",
        "Costco",
        "Sam's Club",
        "BJ's Wholesale",
        "Home Improvement",
        "Online Shopping",
        // Card-Specific
        "Apple Purchases",
        "PayPal Purchases",
        "Rent",
        // Catch-all
        "Everything Else",
    ]
}
