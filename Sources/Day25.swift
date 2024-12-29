import Foundation
import Parsing

struct Day25: AdventDay, Sendable {
  let data: String
  let day = 25
  let puzzleName: String = "--- Day 25: Code Chronicle ---"

  init(data: String) {
    self.data = data
  }

  var inputs: [FivePin] {
    do {
      let split = data.split(separator: "\n\n")
      let parser = FivePinParser()
      return try split.map(parser.parse)
    } catch {
      fatalError("Unable to parse data \(error)")
    }
  }

  func part1() async throws -> Int {
    let keys = inputs.filter { if case .key = $0 { true } else { false } }
    let locks = inputs.filter { if case .lock = $0 { true } else { false } }
    var counts = 0
    for key in keys {
      for lock in locks {
        if lock.fits(key) {
          counts += 1
        }
      }
    }
    return counts
  }
}

extension Day25 {
  enum FivePin: Equatable {
    case lock([Int])
    case key([Int])

    init(_ pins: [[Character]]) {
      let isLock = pins[0].contains("#")
      var heights: [Int] = Array(repeating: 0, count: 5)
      for col in 0 ..< 5 {
        heights[col] = [
          pins[1][col],
          pins[2][col],
          pins[3][col],
          pins[4][col],
          pins[5][col],
        ].filter { $0 == "#" }
          .count
      }
      if isLock {
        self = .lock(heights)
      } else {
        self = .key(heights)
      }
    }

    func fits(_ key: FivePin) -> Bool {
      guard case .lock(let lPins) = self,
            case .key(let kPins) = key
      else {
        return false
      }

      for (l, k) in zip(lPins, kPins) {
        if l + k > 5 {
          return false
        }
      }
      return true
    }
  }
}

extension Day25 {
  struct FivePinParser: Parser {
    var body: some Parser<Substring, FivePin> {
      Many {
        Prefix { $0 != "\n" }.map(Array.init)
      } separator: {
        "\n"
      }.map(FivePin.init)
    }
  }
}
