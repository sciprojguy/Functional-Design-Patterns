// Functional Design Patterns -
// Copyright (c) 2015 Chris Woodard.

import Foundation

enum Rating:Int {
    case NoStars = 0,  OneStar, TwoStars, ThreeStars, FourStars
}

enum Cuisine {
    case Mexican, Cuban, Chinese, American, Thai, Italian, Brazilian, Greek
    func toString() -> String {
        var str:String = ""
        switch(self) {
            case .Mexican: str = "Mexican"
            case .Cuban: str = "Cuban"
            case .Chinese: str = "Chinese"
            case .American: str = "American"
            case .Thai: str = "Thai"
            case .Italian: str = "Italian"
            case .Brazilian: str = "Brazilian"
            case .Greek: str = "Greek"
            default: str = "Unknown"
        }
        return str
    }
}

struct GPSCoordinate {
    let latitude:Double
    let longitude:Double
}

struct Location {
    let addr:String
    let city:String
    let state:String
    let gps:GPSCoordinate
}

struct Restaurant {

    let name:String
    let loc:Location
    let cuisine:Cuisine
    var rating:Rating
    
    init(name:String, cuisine:Cuisine, loc:Location,rating:Rating) {
        self.name = name
        self.cuisine = cuisine
        self.loc = loc
        self.rating = rating
    }
    
    mutating func assignRating(value:Rating) {
        rating = value
    }
    
    func toString() -> String {
        return String(format:"%d star %@ cuisine: '%@'", rating.rawValue, cuisine.toString(), name )
    }
    
}

// location of ActSoft
let currentLocation = GPSCoordinate(latitude: 28.0421803, longitude: -82.5023358)

// formula to compute distance in meters or km between two GPS locations.
// adapted from http://stackoverflow.com/questions/365826/calculate-distance-between-2-gps-coordinates

let eQuatorialEarthRadius:Double = 6378.137
let d2r:Double = (3.1415927 / 180.0)

func HaversineInM(lat1:Double, long1:Double, lat2:Double, long2:Double) -> Double {
    return (1000.0 * HaversineInKM(lat1, long1, lat2, long2));
}

func HaversineInKM(lat1:Double, long1:Double, lat2:Double, long2:Double) -> Double {
    let dlong:Double = (long2 - long1) * d2r;
    let dlat:Double = (lat2 - lat1) * d2r;
    let a:Double = pow(sin(dlat / 2.0), 2.0) + cos(lat1 * d2r) * cos(lat2 * d2r) * pow(sin(dlong / 2.0), 2.0);
    let c:Double = 2.0 * atan2(sqrt(a), sqrt(1.0 - a));
    let d:Double = eQuatorialEarthRadius * c;

    return d;
}

// function to compute distance between two lat/lon points gives us a weighted edge
func distanceInMeters(#from:GPSCoordinate, #to:GPSCoordinate) -> Double {
    return HaversineInM(from.latitude, from.longitude, to.latitude, to.longitude)
}

func distanceInMiles(#from:GPSCoordinate, #to:GPSCoordinate) -> Double {
    return 0.000621371 * HaversineInM(from.latitude, from.longitude, to.latitude, to.longitude)
}

// **********************************************************************
// "database" of restaurants to work with
// **********************************************************************

let restaurants:[Restaurant] = [
    Restaurant(name:"La Cubana", cuisine:.Cuban, loc: Location(addr: "4300 W Cypress St", city: "Tampa", state: "FL", gps:GPSCoordinate(latitude: 27.9519525, longitude: -82.5162256)), rating: .ThreeStars),
    Restaurant(name:"La Leche", cuisine:.Cuban, loc: Location(addr: "1408 N West Shore Blvd", city: "Tampa", state: "FL", gps:GPSCoordinate(latitude: 27.955203, longitude: -82.5251569)), rating: .FourStars),
    Restaurant(name:"China Vase", cuisine:.Chinese, loc: Location(addr: "5501 West Spruce Street", city: "Tampa", state: "FL", gps:GPSCoordinate(latitude: 27.9601558, longitude: -82.5341249)), rating: .FourStars),
    Restaurant(name:"El Maya", cuisine:.Mexican, loc: Location(addr: "8021 Citrus Park Town Center", city: "Tampa", state: "FL", gps:GPSCoordinate(latitude: 28.0607872, longitude: -82.5784993)), rating: .ThreeStars),
    Restaurant(name:"Taco Skateboard", cuisine:.Mexican, loc: Location(addr: "10401 Wilsky Boulevard", city: "Tampa", state: "FL", gps:GPSCoordinate(latitude: 28.0463386, longitude: -82.563951)), rating: .OneStar),
    Restaurant(name:"Bella Belly", cuisine:.Italian, loc: Location(addr: "5907 West Linebaugh Avenue", city: "Tampa", state: "FL", gps:GPSCoordinate(latitude: 28.0412329, longitude: -82.5405219)), rating: .ThreeStars)
]

// **********************************************************************
// functional design patterns to work with the restaurant database
// **********************************************************************

// **********************************************************************
// map/filter/reduce

// **********************************************************************
// map:

let r = restaurants[0]
let d:Double = distanceInMiles(from:currentLocation, to:r.loc.gps)

// list of restaurant names
let names:[String] = map( restaurants, { (r:Restaurant) -> String in return r.name } )
println(names)

// filter:
// get a list of mexican restaurants
let mexicanRestaurants = filter(restaurants, {(restaurant:Restaurant) -> Bool in restaurant.cuisine == .Mexican } )
let numberOfMexicanRestaurants:Int = mexicanRestaurants.count

// get a list of italian restaurants
let italianRestaurants = filter(restaurants, {(r:Restaurant) -> Bool in r.cuisine == .Italian } )
let numberOfItalianRestaurants:Int = italianRestaurants.count

// get a list of greek restaurants
let greekRestaurants = restaurants.filter({(r:Restaurant)->Bool in return .Greek == r.cuisine})
let numberOfGreekRestaurants:Int = greekRestaurants.count

// get list of restaurants w/in some distance of current location (maybe center of tampa)
let restaurantsWithinFiveMiles:[Restaurant] = restaurants.filter({(r:Restaurant)->Bool in
    let d:Double = distanceInMiles(from:currentLocation, to:r.loc.gps)
    return d < 5.0
})

let names2:[String] = restaurantsWithinFiveMiles.map({(r:Restaurant)->String in return r.name})
println(names2)

let restaurantsWithinThreeMiles:[Restaurant] = restaurants.filter({(r:Restaurant)->Bool in
    let d:Double = distanceInMiles(from:currentLocation, to:r.loc.gps)
    return d < 3.0
})

let names3:[String] = restaurantsWithinThreeMiles.map({(r:Restaurant)->String in return r.name})
println(names3)

let restaurantsWithinTwoMiles:[Restaurant] = restaurants.filter({(r:Restaurant)->Bool in
    let d:Double = distanceInMiles(from:currentLocation, to:r.loc.gps)
    return d < 2.0
})

let names4:[String] = restaurantsWithinTwoMiles.map({(r:Restaurant)->String in return r.name})
println(names4)

// reduce:
// min, max, avg star rating for all restaurants

let minRating:Int = reduce( restaurants, Rating.FourStars.rawValue, { (accum:Int, r:Restaurant) -> Int in
    return accum > r.rating.rawValue ? r.rating.rawValue : accum
})

let maxRating:Int = reduce( restaurants, Rating.OneStar.rawValue, { (accum:Int, r:Restaurant) -> Int in
    return accum < r.rating.rawValue ? r.rating.rawValue : accum
})

let sumRating:Int = reduce( restaurants, 0, { (accum:Int, r:Restaurant) -> Int in
    return accum + r.rating.rawValue} )
let avgRating = sumRating / restaurants.count

// **********************************************************************
// chain of execution
// **********************************************************************

// the LONG way
let topMexicanRestaurantRating:Int = restaurants.filter({(restaurant:Restaurant) -> Bool in restaurant.cuisine == .Mexican }).reduce(-1, combine:{(accum:Int, r:Restaurant) -> Int in
    return accum < r.rating.rawValue ? r.rating.rawValue : accum
    })

let bestMexicanRestaurants:[String] = restaurants.filter(
        {(restaurant:Restaurant) -> Bool in
            (restaurant.cuisine == .Mexican) && (restaurant.rating.rawValue == topMexicanRestaurantRating) }).map({(r:Restaurant) -> String in return r.toString()})

let numberBestMexicanRestaurants:Int = bestMexicanRestaurants.count

// best cuban restaurants - ditto for cuban restaurants
let topCubanRestaurantRating:Int = restaurants.filter({(restaurant:Restaurant) -> Bool in restaurant.cuisine == .Cuban }).reduce(-1, combine: { (accum:Int, r:Restaurant) -> Int in
    return accum < r.rating.rawValue ? r.rating.rawValue : accum
    })

let bestCubanRestaurants:[String] = restaurants.filter(
        {(restaurant:Restaurant) -> Bool in
            (restaurant.cuisine == .Cuban) && (restaurant.rating.rawValue == topCubanRestaurantRating) }).map({(r:Restaurant) -> String in return r.toString()})

// chain them for closeness

// **********************************************************************
// recursion - normally hierarchical data structures
// **********************************************************************

struct Comment {
    let text:String
    let children:[Comment]
}

// hierarchical data structure, nested like blog comments or folders and subfolders
let comments:[Comment] = [
    Comment(text: "I like Pizza!", children: [
        Comment( text: "Me too!", children:[]),
        Comment( text: "Me three!", children:[]),
        Comment( text: "Me four!", children:[]),
        Comment( text: "Me five!", children:[]),
    ]),
    Comment(text: "No, I like Thai Food!", children:[]),
    Comment(text: "I LOVE Haggis!", children: [
        Comment( text: "Yech!", children:[
            Comment(text: "Normal Haggis?", children:[
                Comment(text: "No, vegan haggis!", children:[])
            ])
        ]),
        Comment( text: "Ptooey!", children:[])
    ])
]

// recursive-ish functions to
func printComment( comment:Comment, indent:Int) {

    // spaces to indent
    for n in 0..<indent  {
        print("  ")
    }
    
    // print the comment
    println(" \(comment.text)")
    
    // print comment's child comments, if any
    if( comment.children.count > 0 ) {
        for cc:Comment in comment.children  {
            printComment( cc, indent+2 )
        }
    }
}

for cm:Comment in comments {
    printComment( cm, 0 )
}


// event/state

enum CompassHeading {
    case North, NorthEast, East, SouthEast, South, SouthWest, West, NorthWest
    func toString() -> String {
        var str = ""
        switch(self) {
            case .North: str = "N"
            case .NorthEast: str = "NE"
            case .East: str = "E"
            case .SouthEast: str = "SE"
            case .South: str = "S"
            case .SouthWest: str = "SW"
            case .West: str = "W"
            case .NorthWest: str = "NW"
            default:str = ""
        }
        return str
    }
}

func headingToCompassHeading(heading:Float) -> CompassHeading {
    var ch:CompassHeading = .North
    
    if( heading >= 337.5 && heading < 22.5 ) {
        ch = .North
    }
    else
    if( heading >= 22.5 && heading < 67.5 ) {
        ch = .NorthEast
    }
    else
    if( heading >= 67.5 && heading < 112.5 ) {
        ch = .East
    }
    else
    if( heading >= 112.5 && heading < 157.5 ) {
        ch = .SouthEast
    }
    else
    if( heading >= 157.5 && heading < 202.5 ) {
        ch = .South
    }
    else
    if( heading >= 202.5 && heading < 247.5 ) {
        ch = .SouthWest
    }
    else
    if( heading >= 247.5 && heading < 292.5 ) {
        ch = .West
    }
    else
    if( heading >= 292.5 && heading < 337.5 ) {
        ch = .NorthWest
    }
    
    return ch
}

func turnLeft(currentHeading:Float, turnDegrees:Float) -> (Float, CompassHeading) {
    var newHeading = currentHeading - turnDegrees
    if( newHeading<0 ) {
        newHeading = 360.0 + newHeading
    }
    return (newHeading, headingToCompassHeading(newHeading))
}

func turnRight(currentHeading:Float, turnDegrees:Float) -> (Float, CompassHeading) {
    var newHeading = currentHeading + turnDegrees
    if( newHeading > 360 ) {
        newHeading = newHeading - 360.0
    }
    return (newHeading, headingToCompassHeading(newHeading))
}

func simulateCarDriving() -> Void {

    var compassHeading:CompassHeading
    var heading:Float = 0

    // turn left 50 degrees
    (heading, compassHeading) = turnLeft(heading, 50 )
    println("left turn 50 degrees = \(compassHeading.toString())")

    // turn right 121 degrees
    (heading, compassHeading) = turnRight(heading, 50 )
    println("right turn 120 degrees = \(compassHeading.toString())")
}

simulateCarDriving()
