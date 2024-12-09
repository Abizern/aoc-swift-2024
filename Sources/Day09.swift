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
      n % 2 == 0 ? .file(id: n / 2, length: number) : .empty(length: number)
    }
  }

  func part1() async throws -> Int {
    let files = Deque(diskMap.flatMap(\.expanded))
    let rearranged = rearrange(files)

    return checksum(rearranged)
  }

  func part2() async throws -> Int {
    defrag(diskMap)
      .flatMap(\.expanded)
      .map { $0 > Int.min ? $0 : 0 }
      .enumerated()
      .map { $0 * $1 }
      .reduce(0, +)
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

  func defrag(_ input: [Descriptor]) -> [Descriptor] {
    var input = input[...]
    var highestIndex = input.last!.fileId

    while highestIndex > 0 {
      guard let candidateIndex = input.firstIndex(where: { $0.fileId == highestIndex }) else { fatalError("We should have fileID \(highestIndex)") }
      let candidateLength = input[candidateIndex].length

      guard let targetIndex = input.firstIndex(
        where: { descriptor in
          if case .empty(let length) = descriptor, length >= candidateLength {
            true
          } else {
            false
          }
        }
      ),
        targetIndex < candidateIndex
      else {
        highestIndex -= 1
        continue
      }

      input.replaceSubrange(candidateIndex ... candidateIndex, with: [.empty(length: candidateLength)])
      let targetLength = input[targetIndex].length
      let newTarget = Descriptor.file(id: highestIndex, length: candidateLength)
      if targetLength == candidateLength {
        input.replaceSubrange(targetIndex ... targetIndex, with: [newTarget])
      } else {
        input.replaceSubrange(targetIndex ... targetIndex, with: [newTarget, .empty(length: targetLength - candidateLength)])
      }

      highestIndex -= 1
    }

    return Array(input)
  }

  func compressEmptySpace(_ input: [Descriptor]) -> [Descriptor] {
    guard !input.isEmpty else { return [] }
    return input.reduce(into: [Descriptor]()) { result, descriptor in
      switch (result.last, descriptor) {
      case (.empty(let len1), .empty(let len2)):
        result = result.dropLast() + [.empty(length: len1 + len2)]
      default:
        result.append(descriptor)
      }
    }
  }

  func checksum(_ input: [Int]) -> Int {
    input.enumerated().map(*).reduce(0, +)
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

    var fileId: Int {
      switch self {
      case .file(id: let id, length: _):
        id
      case .empty(length: _):
        Int.min
      }
    }

    var length: Int {
      switch self {
      case .file(_, let length):
        length
      case .empty(let length):
        length
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

// MARK: - Parsing

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
