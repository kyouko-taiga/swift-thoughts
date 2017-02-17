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

class PokemonLover {
  var name: String
  var friends: [PokemonLover] = []

  init(name: String) { /* ... */ }
  init(name: String) {
    self.name = name
  }

  convenience init(name: String, bestFriend: PokemonLover) {
    self.init(name: name)
    self.friends = [bestFriend]
    bestFriend.friends.append(self)
  }

  func makeFriends(with another: PokemonLover) {
    self.friends.append(another)
    another.friends.append(self)
  }
}

class Trainer: PokemonLover {
  var pokemons: [Pokemon]

  override init(name: String) {
    print("new challenger approaching")
    self.pokemons = []
    super.init(name: name)
  }

  init(name: String, pokemons: [Pokemon]) {
    self.pokemons = pokemons
    super.init()
  }
}

class GymLeader: Trainer {
  let location: String

    init(name: String, location: String, pokemons: [Pokemon]) {
      self.location = location
      super.init(name: name, pokemons: pokemons)
    }
}

class EliteFourMember: Trainer {
  let specialty: SpeciesType

  override var name: String {
    get {
      return "Elite Four \(super.name)"
    }

    set {
      if newValue.hasPrefix("Elite Four ") {
        super.name = String(newValue.characters.dropFirst(11))
      } else {
        super.name = newValue
      }
    }
  }

  init(name: String, specialty: SpeciesType, pokemons: [Pokemon]) {
    self.specialty = specialty
    super.init(name: name, pokemons: pokemons)
  }

  override func makeFriends(with another: PokemonLover) {
    guard another is EliteFourMember else {
      print("Elite Four members make friends with other Elite Four members only")
      return
    }
    super.makeFriends(with: another)
  }
}
