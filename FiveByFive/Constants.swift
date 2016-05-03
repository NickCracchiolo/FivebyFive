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
    struct AppColor {
        static let backColor = UIColor(red: 61/255, green: 83/255, blue: 178/255, alpha: 1.0)
    }
    struct FontColor {
        static let titleClr = SKColor(red: 225/255, green: 205/255, blue: 58/255, alpha: 1.0)
        static let fontClr = SKColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
        static let blackColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    }
    struct FontName {
        static let Game_Font = "Impact Label Reversed"
        static let HUD_Font = "Impact Label Reversed"
        static let Title_Font = "Impact Label Reversed"
        static let Game_Over_Font = "Impact Label"
    }
    struct FontSize {
        static let DispFontSize:CGFloat = 30
    }
    struct zPosition {
        static let tutorial_zPosition:CGFloat = 50
        static let grid_zPosition:CGFloat = 2
        static let OVERLAYZ:CGFloat = 50
        static let OVERLAY_OBJZ:CGFloat = 51
        static let BOMB_zPOSITION:CGFloat = 3
    }
    struct Notifications {
        static let PLAYER_AUTH = "authenticated_player"
        static let PRESENT_AUTH_VC = "present_authentication_view"
    }
}

enum DefaultKeys: CustomStringConvertible  {
    case FreeCoins
    case Money
    case Level
    case Notifications
    case Sound
    case Tutorial
    case Year
    case Month
    case Day
    case Ads
    case Life
    case Purchased
    
    var description : String {
        switch self {
        case .FreeCoins: return "freeCoins"
        case .Money: return "money"
        case .Level: return "level"
        case .Notifications: return "notif_bool"
        case .Sound: return "sounds_bool"
        case .Tutorial: return "tutorial"
        case .Year: return "savedyear"
        case .Month: return "savedmonth"
        case .Day: return "savedday"
        case .Ads: return "ads"
        case .Life: return "save_life"
        case .Purchased: return "purchase_bool"
        }
    }
}