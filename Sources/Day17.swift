import Foundation

struct Day17: AdventDay, Sendable {
  let data: String
  let day = 17
  let puzzleName: String = "--- Day 17: Chronospatial Computer ---"

  init(data: String) {
    self.data = data
  }

  var computer: ChronoComp {
    do {
      return try ChronoCompParser().parse(data)
    } catch {
      fatalError("Unable to parse input data: \(error)")
    }
  }

  func part1() async throws -> String {
    var comp = computer
    comp.run()
    return comp.output.map(String.init).joined(separator: ",")
  }
}

extension Day17 {}
