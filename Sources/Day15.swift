import Foundation
import Parsing

struct Day15: AdventDay, Sendable {
  let data: String
  let day = 15
  let puzzleName: String = "--- Day 15: Warehouse Woes ---"

  init(data: String) {
    self.data = data
  }

  var input: ([[Character]], [Character]) {
    let split = data.split(separator: "\n\n")
    do {
      let warehouse = try Warehouse().parse(split[0])
      let instructions = try Instructions().parse(split[1]).flatMap { $0 }
      return (warehouse, instructions)
    } catch {
      fatalError("Unable to parse data: \(error)")
    }
  }

  func part1() async throws -> Int {
    let (rows, instructions) = input
    let startPos = startPos(rows)
    let (_, newRows) = instructions.reduce((startPos, rows), move)
    return gps(newRows)
  }
}

extension Day15 {
  func startPos(_ rows: [[Character]]) -> (Int, Int) {
    for (r, row) in rows.enumerated() {
      for (c, char) in row.enumerated() {
        if char == "@" {
          return (r, c)
        } else {
          continue
        }
      }
    }
    fatalError("Unable to find start position")
  }

  func move(_ state: ((Int, Int), [[Character]]), dir: Character) -> ((Int, Int), [[Character]]) {
    var (r, c) = state.0
    var rows = state.1
    let dr: Int
    let dc: Int

    switch dir {
    case "^": (dr, dc) = (-1, 0)
    case ">": (dr, dc) = (0, 1)
    case "v": (dr, dc) = (1, 0)
    case "<": (dr, dc) = (0, -1)
    default: fatalError("Unknown direction \(dir)")
    }

    var pile: [(Int, Int)] = []
    var (nr, nc) = (r + dr, c + dc)
    var candidate = rows[nr][nc]
    var found = false

    while candidate != "#", !found {
      if candidate == "." {
        for box in pile {
          rows[box.0 + dr][box.1 + dc] = "O"
        }
        rows[r][c] = "."
        (r, c) = (r + dr, c + dc)
        rows[r][c] = "@"
        found = true
      } else if candidate == "O" {
        pile.append((nr, nc))
        (nr, nc) = (nr + dr, nc + dc)
        candidate = rows[nr][nc]
      }
    }

    return ((r, c), rows)
  }

  func gps(_ rows: [[Character]]) -> Int {
    var score = 0
    for (r, row) in rows.enumerated() {
      for (c, char) in row.enumerated() {
        if char == "O" {
          score += r * 100 + c
        }
      }
    }
    return score
  }
}

// MARK: - Parsing

extension Day15 {
  struct ParseLine: Parser {
    var body: some Parser<Substring, [Character]> {
      Parse(Array.init) {
        Prefix { $0 != "\n" }
      }
    }
  }

  struct Warehouse: Parser {
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

  struct Instructions: Parser {
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

func printRows(_ rows: [[Character]]) {
  print(rows.map { String($0) }.joined(separator: "\n"))
}
