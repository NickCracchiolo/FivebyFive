//
//  DefaultKeys.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 11/18/17.
//  Copyright © 2017 Nick Cracchiolo. All rights reserved.
//

import Foundation

enum DefaultKeys: CustomStringConvertible  {
	case money
	case notifications
	case sound
	case tutorial
	case life
	case purchased
	case migrate
	
	var description : String {
		switch self {
		case .money:
			return "money"
		case .notifications:
			return "notif_bool"
		case .sound:
			return "sounds_bool"
		case .tutorial:
			return "tutorial"
		case .life:
			return "save_life"
		case .purchased:
			return "purchase_bool"
		case .migrate:
			return "migration"
		}
	}
}
