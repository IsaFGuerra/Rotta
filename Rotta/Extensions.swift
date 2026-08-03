//
//  Extensions.swift
//  Rotta
//
//  Created by Isadora Ferreira Guerra on 12/06/25.
//

import Foundation

extension String {
    func getCountryFlag() -> String {
        let country = self.lowercased()

        // As chaves ficam em minúsculo porque a busca é feita com `country` já rebaixado.
        let flagMapping: [String: String] = [
            "brazil": "🇧🇷",
            "ireland": "🇮🇪",
            "united kingdom": "🇬🇧",
            "england": "🏴󠁧󠁢󠁥󠁮󠁧󠁿",
            "france": "🇫🇷",
            "spain": "🇪🇸",
            "italy": "🇮🇹",
            "germany": "🇩🇪",
            "netherlands": "🇳🇱",
            "monaco": "🇲🇨",
            "australia": "🇦🇺",
            "argentina": "🇦🇷",
            "colombia": "🇨🇴",
            "sweden": "🇸🇪",
            "india": "🇮🇳",
            "czech republic": "🇨🇿",
            "paraguay": "🇵🇾",
            "mexico": "🇲🇽",
            "japan": "🇯🇵",
            "belgium": "🇧🇪",
            "estonia": "🇪🇪",
            "bulgaria": "🇧🇬",
            "austria": "🇦🇹",
            "finland": "🇫🇮",
            "poland": "🇵🇱",
            "singapore": "🇸🇬",
            "norway": "🇳🇴",
            "denmark": "🇩🇰",
            "thailand": "🇹🇭",
            "united states": "🇺🇸",
            "peru": "🇵🇪",
            "united arab emirates": "🇦🇪",
            "bahrain": "🇧🇭",

            "brasil": "🇧🇷",
            "irlanda": "🇮🇪",
            "reino unido": "🇬🇧",
            "frança": "🇫🇷",
            "espanha": "🇪🇸",
            "itália": "🇮🇹",
            "alemanha": "🇩🇪",
            "holanda": "🇳🇱",
            "mônaco": "🇲🇨",
            "austrália": "🇦🇺",
            "estados unidos": "🇺🇸",
            "colômbia": "🇨🇴",
            "suécia": "🇸🇪",
            "índia": "🇮🇳",
            "república tcheca": "🇨🇿",
            "paraguai": "🇵🇾",
            "méxico": "🇲🇽",
            "japão": "🇯🇵",
            "bélgica": "🇧🇪",
            "estônia": "🇪🇪",
            "bulgária": "🇧🇬",
            "áustria": "🇦🇹",
            "finlândia": "🇫🇮",
            "polônia": "🇵🇱",
            "singapura": "🇸🇬",
            "noruega": "🇳🇴",
            "dinamarca": "🇩🇰",
            "tailândia": "🇹🇭",
            "emirados árabes unidos": "🇦🇪",
            "uae": "🇦🇪",
            "arábia saudita": "🇸🇦",
            "azerbaijão": "🇦🇿",
            "hungria": "🇭🇺",
            "uk": "🇬🇧",
            "emirados árabes unidos / alemanha": "🇦🇪🇩🇪"
        ]

        return flagMapping[country] ?? "🏁"
    }
}
