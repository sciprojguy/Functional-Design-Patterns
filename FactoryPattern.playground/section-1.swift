// Playground - noun: a place where people can play

import Foundation

// singleton

class Highlander {
}

// factory

class Car {
    var type:String
    var wheels:Int
    var doors:Int
    init() {
        self.type = "Nondescript car"
        self.wheels = 0
        self.doors = 0
    }
    
    func toString() -> String {
        return String(format:"%d door, %d wheel %@", self.doors, self.wheels, self.type)
    }
}

class Sedan : Car {
    override init() {
        super.init()
        self.type = "Sedan"
        self.wheels = 4
        self.doors = 4
    }
}

class Minivan : Car {
    override init() {
        super.init()
        self.type = "Minivan"
        self.wheels = 4
        self.doors = 5
    }
}

class Truck : Car {
    override init() {
        super.init()
        self.type = "Truck"
        self.wheels = 4
        self.doors = 2
    }
}

class CarFactory {
    
    var numCars:Int = 0
    init() {
    }
    
    func makeCar(ofType:String) -> Car? {
        var car:Car? = nil
        if( "Sedan" == ofType ) {
            car = Sedan()
            self.numCars++
        }
        else
        if( "Minivan" == ofType ) {
            car = Minivan()
            self.numCars++
        }
        else
        if( "Truck" == ofType ) {
            car = Truck()
            self.numCars++
        }
        return car
    }
}

var factory:CarFactory = CarFactory()
var truck:Truck? = (factory.makeCar("Truck") as Truck)
println(truck!.toString())
var minivan:Minivan? = (factory.makeCar("Minivan") as Minivan)
println(minivan!.toString())
println("made \(factory.numCars) car(s)")


