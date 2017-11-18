//
//  TypeExtensions.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/18/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import Swift

extension Character {
    //Checks if the Character is an operator
    func isOperator() -> Bool {
        if self == "+" || self == "-" || self == "/" || self == "*" {
            return true
        }
        return false
    }
    //Checks if the Characters is a punctuation mark
    func isPunctuation() -> Bool {
        if self == "." || self == "!" || self == "?" {
            return true
        }
        return false
    }
    //Checks if the Character is a space
    func isSpace() -> Bool {
        if self == " " {
            return true
        }
        return false
    }
}
//Extension for FFLabel class to help parse string into words
extension String {
    //Returns an array of all the words in the String
    func words() -> [String] {
        var words:[String] = []
        var word = ""
        for c in self {
            if c.isPunctuation() || c.isSpace() {
                if word != "" {
                    words.append(word)
                }
                word = ""
            } else {
                word.append(c)
            }
        }
        if !word.isEmpty {
            words.append(word)
        }
        return words
    }
}
