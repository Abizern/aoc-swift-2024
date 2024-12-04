import Foundation
import Parsing

struct Day04: AdventDay, Sendable {
  let data: String
  let day = 4
  let puzzleName: String = "--- Day 4: Ceres Search ---"

  init(data: String) {
    self.data = data
  }

  var rows: [[Character]] {
    parseInput()
  }

  func part1() async throws -> Int {
    countOccurences(rows)
  }

  func part2() async throws -> Int {
    countCrosses(rows)
  }
}

extension Day04 {
  func findStarts(_ character: Character, rows: [[Character]]) -> [(Int, Int)] {
    var accum = [(Int, Int)]()
    for (r, row) in rows.enumerated() {
      for (c, value) in row.enumerated() {
        if value == character {
          accum.append((r, c))
        }
      }
    }
    return accum
  }

  enum Direction: Equatable, CaseIterable {
    case n, ne, e, se, s, sw, w, nw // Compass points
  }

  struct Candidate {
    let partial: String
    let direction: Direction
    let position: (Int, Int)
    var isValid: Bool {
      partial == "XMAS"
    }

    static func initial(row: Int, col: Int) -> [Candidate] {
      var accumulator = [Candidate]()
      for direction in Direction.allCases {
        accumulator.append(Candidate(partial: "X", direction: direction, position: (row, col)))
      }
      return accumulator
    }

    func next(rows: [[Character]], dimensions: (width: Int, height: Int)) -> Candidate? {
      guard "XMAS".hasPrefix(partial) else { return nil }

      var newRow = position.0
      var newCol = position.1
      switch direction {
      case .n:
        guard position.0 > 0
        else { return nil }
        newRow = position.0 - 1
      case .ne:
        guard position.0 > 0,
              position.1 < dimensions.height - 1
        else { return nil }
        newRow = position.0 - 1
        newCol = position.1 + 1
      case .e:
        guard position.1 < dimensions.width - 1
        else { return nil }
        newCol = position.1 + 1
      case .se:
        guard position.0 < dimensions.width - 1,
              position.1 < dimensions.height - 1
        else { return nil }
        newRow = position.0 + 1
        newCol = position.1 + 1
      case .s:
        guard position.0 < dimensions.height - 1
        else { return nil }
        newRow = position.0 + 1
      case .sw:
        guard position.0 < dimensions.width - 1,
              position.1 > 0
        else { return nil }
        newRow = position.0 + 1
        newCol = position.1 - 1
      case .w:
        guard position.1 > 0
        else { return nil }
        newCol = position.1 - 1
      case .nw:
        guard position.0 > 0,
              position.1 > 0
        else { return nil }
        newRow = position.0 - 1
        newCol = position.1 - 1
      }

      let value = rows[newRow][newCol]
      let newPartial = partial + String(value)
      return Candidate(partial: newPartial, direction: direction, position: (newRow, newCol))
    }
  }
}

// MARK: Part 1

extension Day04 {
  func countOccurrencesAround(_ position: (Int, Int), rows: [[Character]]) -> Int {
    var count = 0
    let dimensions = (width: rows[0].count, height: rows.count)
    var candidates = Candidate.initial(row: position.0, col: position.1)[...]

    while let candidate = candidates.first {
      var newCandidates = candidates.dropFirst()
      if candidate.isValid {
        count += 1
        candidates = candidates.dropFirst()
      } else {
        if let next = candidate.next(rows: rows, dimensions: dimensions) {
          newCandidates.append(next)
        }
      }
      candidates = newCandidates
    }

    return count
  }

  func countOccurences(_ rows: [[Character]]) -> Int {
    let starts = findStarts("X", rows: rows)
    let count = starts.map {
      countOccurrencesAround($0, rows: rows)
    }.reduce(0, +)

    return count
  }
}

// MARK: Part 2

extension Day04 {
  func hasCross(_ position: (Int, Int), rows: [[Character]], dimensions: (width: Int, height: Int)) -> Bool {
    let row = position.0
    let col = position.1
    var result = false

    guard (1 ..< dimensions.width - 1).contains(row),
          (1 ..< dimensions.height - 1).contains(col)
    else { return false }

    let ne = rows[row + 1][col + 1]
    let se = rows[row + 1][col - 1]
    let sw = rows[row - 1][col - 1]
    let nw = rows[row - 1][col + 1]

    switch (nw, se) {
    case ("M", "S"):
      if (sw == "M" && ne == "S") || (sw == "S" && ne == "M") { result = true }
    case ("S", "M"):
      if (sw == "M" && ne == "S") || (sw == "S" && ne == "M") { result = true }
    default: result = false
    }
    return result
  }

  func countCrosses(_ rows: [[Character]]) -> Int {
    let dimensions = (width: rows[0].count, height: rows.count)
    let starts = findStarts("A", rows: rows)
    let count = starts.map {
      hasCross($0, rows: rows, dimensions: dimensions)
    }.filter { $0 }.count

    return count
  }
}

// MARK: Parsing

extension Day04 {
  func parseInput() -> [[Character]] {
    do {
      return try Lines().parse(data)
    } catch {
      fatalError("Unable to parse data: \(error)")
    }
  }

  struct ParseLine: Parser {
    var body: some Parser<Substring, [Character]> {
      Parse(Array.init) {
        Prefix { $0 != "\n" }
      }
    }
  }

  struct Lines: Parser {
    var body: some Parser<Substring, [[Character]]> {
      Many {
        ParseLine()
      } separator: {
        "\n"
      } terminator: {
        End()
      }
    }
  }
}
