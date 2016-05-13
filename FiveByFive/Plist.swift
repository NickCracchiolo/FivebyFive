//
//  Plist.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/4/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import Foundation


struct Plist {
    enum PlistError: ErrorType {
        case fileNotWritten
        case fileDoesNotExist
    }
    let name:String
    var sourcePath:String? {
        guard let path = NSBundle.mainBundle().pathForResource(name, ofType: "plist") else {
            return .None
        }
        return path
    }
    var destPath:String? {
        guard sourcePath != .None else {
            return .None
        }
        let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        return (dir as NSString).stringByAppendingPathComponent("\(name).plist")
    }
    
    init?(name:String) {
        self.name = name
        /*
        let fileManager = NSFileManager.defaultManager()
        guard let source = sourcePath else {
            return nil
        }
        guard let destination = destPath else {
            return nil
        }
        guard fileManager.fileExistsAtPath(source) else {
            return nil
        }
        if !fileManager.fileExistsAtPath(destination) {
            do {
                try fileManager.copyItemAtPath(source, toPath: destination)
            } catch let error as NSError {
                print("Unable to copy file. Error: \(error.localizedDescription)")
                return nil
            }
        }
        */
    }
    func getValuesInPlist() -> NSDictionary? {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destPath!) {
            guard let dict = NSDictionary(contentsOfFile: destPath!) else {
                return .None
            }
            print("Dictionary: ",dict)
            return dict
        } else {
            return .None
        }
    }
    func getMutablePlist() -> NSMutableDictionary? {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destPath!) {
            guard let dict = NSMutableDictionary(contentsOfFile: destPath!) else {
                return .None
            }
            return dict
        } else {
            return .None
        }
    }
    func addValuesToPlistFile(dictionary:NSDictionary) throws {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destPath!) {
            if !dictionary.writeToFile(destPath!, atomically: false) {
                print("File not written successfully")
                throw PlistError.fileNotWritten
            }
        } else {
            throw PlistError.fileDoesNotExist
        }
    }
}