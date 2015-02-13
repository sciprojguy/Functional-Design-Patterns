// Playground - noun: a place where people can play

import Foundation

class DroneManager {

    class var sharedInstance : DroneManager {
        struct Static {
            static let instance : DroneManager = DroneManager()
        }
        return Static.instance
    }

    func howManyDrones() -> String {
        return "One on the White House Lawn.. (hic)"
    }
}

private let sharedManager = DroneManager()
let identity:String = sharedManager.howManyDrones()

let sharedManager2 = DroneManager()
let identity2:String = sharedManager2.howManyDrones()

