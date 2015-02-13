// Playground - noun: a place where people can play

import Foundation

typealias BuildClosure = (Drone) -> Void

class Drone {
    var type:String?
    var rotors:Int?
    var color:String?
    var massInKm:Float?
    
    init(build:BuildClosure) {
    
        self.type = ""
        self.rotors = 0
        self.color = ""
        self.massInKm = 0.0
        
        build(self)
    }
}

let smallDrone = Drone(build: {
    $0.type = "Civilian"
    $0.rotors = 4
    $0.color = "White"
    $0.massInKm = 10.0
})

let bigDrone = Drone(build: {
    $0.type = "Military"
    $0.rotors = 8
    $0.color = "Gray"
    $0.massInKm = 350.0
})

