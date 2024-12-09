import Algorithms
import Collections
import Foundation
import Parsing

struct Day09: AdventDay, Sendable {
  let data: String
  let day = 9
  let puzzleName: String = "--- Day 9: Disk Fragmenter ---"

  init(data: String) {
    self.data = data
  }

  var diskMap: [Descriptor] {
    parseData().enumerated().map { n, number in
      switch n % 2 {
      case 0:
        .file(id: n / 2, length: number)
      default:
        .empty(length: number)
      }
    }
  }

  func part1() async throws -> Int {
    let files = Deque(diskMap.flatMap(\.expanded))
    let rearranged = rearrange(files)
    let checksum = rearranged.enumerated().map(*).reduce(0, +)

    return checksum
  }
}

extension Day09 {
  func rearrange(_ input: Deque<Int>) -> [Int] {
    var input = input
    var accumulator: [Int] = []
    while let f = input.popFirst() {
      if f > Int.min {
        accumulator.append(f)
      } else if !input.isEmpty {
        accumulator.append(input.popLast()!)
        // Clear out spaces from the back
        while !input.isEmpty, input.last! == Int.min {
          input.removeLast()
        }
      } else {
        continue
      }
    }

    return accumulator
  }
}

extension Day09 {
  enum Descriptor: Equatable, CustomStringConvertible {
    case file(id: Int, length: Int)
    case empty(length: Int)

    var expanded: [Int] {
      switch self {
      case .file(let id, let length):
        Array(repeating: id, count: length)
      case .empty(let length):
        Array(repeating: Int.min, count: length)
      }
    }

    var description: String {
      switch self {
      case .file(let id, let length):
        "file(\(id),\(length))"
      case .empty(let length):
        "empty(\(length))"
      }
    }
  }
}

extension Day09 {
  func parseData() -> [Int] {
    do {
      return try Numbers().parse(data)
    } catch {
      fatalError("Unable to parse data \(error)")
    }
  }

  struct Numbers: Parser {
    var body: some Parser<Substring, [Int]> {
      Many {
        Digits(1)
      } terminator: {
        End()
      }
    }
  }
}
