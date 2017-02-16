indirect enum SpeciesType {
    case grass, fire, water
    case dual(primary: SpeciesType, secondary: SpeciesType)
}

typealias Species = (number: Int, name: String)

struct Pokemon {
  let species: Species
  var level: Int
}

// ----

protocol Person {
    var name: String { get set }
    var friends: [Person] { get set }

    mutating func makeFriends(with another: inout Person)
}

protocol PokemonHolder {
    var pokemons: [Pokemon] { get set }
}

protocol Champion {
    var location: String { get }
}

protocol Specialist {
    var specialty: SpeciesType { get }
}

// ----

extension Person {
    mutating func makeFriends(with another: inout Person) {
        self.friends.append(another)
        another.friends.append(self)
    }
}

// ----

struct PokemonLover: Person {
    var name: String
    var friends: [Person] = []
}

struct Trainer: Person, PokemonHolder {
    var name: String
    var friends: [Person] = []
    var pokemons: [Pokemon]

    init(name: String, friends: [Person] = [], pokemons: [Pokemon] = []) {
        print("new challenger approaching")
        self.name = name
        self.friends = friends
        self.pokemons = pokemons
    }
}

struct GymLeader: Person, PokemonHolder, Champion {
    var name: String
    var friends: [Person]
    var pokemons: [Pokemon]
    let location: String
}

struct EliteFourMember: Person, PokemonHolder, Specialist {
    var _name: String
    var name: String {
        get {
            return "Elite Four \(self._name)"
        }

        set {
            if newValue.hasPrefix("Elite Four ") {
                self._name = String(newValue.characters.dropFirst(11))
            } else {
                self._name = newValue
            }
        }
    }

    mutating func makeFriends(with another: inout Person) {
        guard another is EliteFourMember else {
            print("Elite Four members make friends with other Elite Four members only")
            return
        }

        self.friends.append(another)
        another.friends.append(self)
    }

    var friends: [Person]
    var pokemons: [Pokemon]
    let specialty: SpeciesType
}

// ----

protocol InitializableWithBestFriend {
  init(name: String, bestFriend: Person)
}

extension PokemonLover: InitializableWithBestFriend {
  init(name: String, bestFriend: Person) {
    self.init(name: name, friends: [bestFriend])
  }
}

extension Trainer: InitializableWithBestFriend {
  init(name: String, bestFriend: Person) {
    self.init(name: name, friends: [bestFriend], pokemons: [])
  }
}
