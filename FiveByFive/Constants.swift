//
//  GlobalVariables.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 4/1/15.
//  Copyright (c) 2015 Nick Cracchiolo. All rights reserved.
//

import Foundation
import SpriteKit

struct Constants {
    static let googleInterstitialAdsID = ""
    static let rewardedInterstitialAdsID = ""

    struct FontName {
        static let Game_Font = "Impact Label Reversed"
        static let Bolded_Font = "Impact Label"
        static let HUD_Font = "Impact Label Reversed"
        static let Title_Font = "Impact Label Reversed"
        static let Game_Over_Font = "Impact Label"
    }
    struct FontSize {
        static let DispFontSize:CGFloat = 20
        static let Title:CGFloat = 45
    }
    struct Notifications {
        static let PLAYER_AUTH = "authenticated_player"
        static let PRESENT_AUTH_VC = "present_authentication_view"
        static let BOMB_SELECTED = "bomb_selected"
        static let PRESENT_LEADERBOARDS = "present_leaderboard_vc"
        static let PRESENT_INTERSTITIAL = "present_interstitial_ad"
    }
    struct Leaderboards {
        static let highScore = "leaderboards.highest_score"
    }
}
