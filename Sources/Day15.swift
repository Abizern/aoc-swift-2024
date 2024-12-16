import AoCCommon
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
    let (_, newRows) = instructions.reduce((startPos, rows)) { move($0, dir: $1) }
    return gps(newRows)
  }

  func part2() async throws -> Int {
    let (r, instructions) = input
    let rows = r.map(enlarge)
    let startCell = Cell(startPos(rows))
    let (_, newRows) = instructions.reduce((startCell, rows)) { wideMove($0, dir: $1) }

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

  func gps(_ rows: [[Character]]) -> Int {
    var score = 0
    for (r, row) in rows.enumerated() {
      for (c, char) in row.enumerated() {
        if char == "O" || char == "[" {
          score += r * 100 + c
        }
      }
    }
    return score
  }
}

// MARK: - Part 1 specific

extension Day15 {
  func move(
    _ state: ((Int, Int), [[Character]]),
    dir: Character,
    tip: (Int, Int)? = nil,
    boxes: [(Int, Int)] = []
  ) -> ((Int, Int), [[Character]]) {
    var ((r, c), rows) = state

    let dr: Int
    let dc: Int

    switch dir {
    case "^": (dr, dc) = (-1, 0)
    case ">": (dr, dc) = (0, 1)
    case "v": (dr, dc) = (1, 0)
    case "<": (dr, dc) = (0, -1)
    default: fatalError("Unknown direction \(dir)")
    }

    let (nr, nc) = tip ?? (r + dr, c + dc)
    let candidate = rows[nr][nc]

    if candidate == "#" {
      return state
    } else if candidate == "." {
      for box in boxes {
        rows[box.0 + dr][box.1 + dc] = "O"
      }
      rows[r][c] = "."
      (r, c) = (r + dr, c + dc)
      rows[r][c] = "@"
      return ((r, c), rows)
    } else { // candidate = "O"
      let newTip = (nr + dr, nc + dc)
      let newBoxes = boxes + [(nr, nc)]
      return move(state, dir: dir, tip: newTip, boxes: newBoxes)
    }
  }
}

// MARK: - Part 2 specific

extension Day15 {
  func wideMove(_ state: (Cell, [[Character]]), dir: Character) -> (Cell, [[Character]]) {
    let (r, c) = (state.0.row, state.0.col)

    switch dir {
    case "^":
      let vOffset = -1
      return moveVertically(state, vOffset: vOffset, nextPos: [Cell((r + vOffset, c))], boxes: [:])
    case "v":
      let vOffset = 1
      return moveVertically(state, vOffset: vOffset, nextPos: [Cell((r + vOffset, c))], boxes: [:])
    case ">":
      let hOffset = 1
      return moveHorizontally(state, hOffset: hOffset, nextPos: Cell((r, c + hOffset)), boxes: [:])
    case "<":
      let hOffset = -1
      return moveHorizontally(state, hOffset: hOffset, nextPos: Cell((r, c + hOffset)), boxes: [:])
    default:
      fatalError("Unknown direction \(dir)")
    }
  }

  func moveHorizontally(_ state: (Cell, [[Character]]), hOffset: Int, nextPos: Cell, boxes: [Cell: Character]) -> (Cell, [[Character]]) {
    var (robot, rows) = state
    var boxes = boxes
    let candidate = rows[nextPos.row][nextPos.col]

    guard candidate != "#" else {
      return state
    }

    if candidate == "." {
      for (key, value) in boxes {
        rows[key.row][key.col + hOffset] = value
      }
      rows[robot.row][robot.col] = "."

      rows[robot.row][robot.col + hOffset] = "@"
      return (Cell(robot.row, robot.col + hOffset), rows)
    }

    if candidate == "[" || candidate == "]" {
      boxes[nextPos] = candidate
      let newNextPos = Cell((nextPos.row, nextPos.col + hOffset))

      return moveHorizontally(state, hOffset: hOffset, nextPos: newNextPos, boxes: boxes)
    }

    fatalError("We should have handled something by now.")
  }

  func moveVertically(_ state: (Cell, [[Character]]), vOffset: Int, nextPos: [Cell], boxes: [Cell: Character]) -> (Cell, [[Character]]) {
    var (robot, rows) = state
    var boxes = boxes
    let candidates = nextPos.map { rows[$0.row][$0.col] }

    if candidates.contains("#") {
      return state
    }

    if candidates.allSatisfy({ $0 == "." }) {
      for (key, _) in boxes {
        rows[key.row][key.col] = "."
      }
      for (key, value) in boxes {
        rows[key.row + vOffset][key.col] = value
      }
      rows[robot.row][robot.col] = "."
      rows[robot.row + vOffset][robot.col] = "@"
      return (Cell(robot.row + vOffset, robot.col), rows)
    }

    if candidates.contains("[") || candidates.contains("]") {
      var candidateBoxes = nextPos.map { ($0, rows[$0.row][$0.col]) }.sorted { $0.0.col < $1.0.col }

      if let lst = candidateBoxes.last, lst.1 == "[" {
        let (rightRow, rightCol) = (lst.0.row, lst.0.col + 1)
        candidateBoxes.append((Cell((rightRow, rightCol)), rows[rightRow][rightCol]))
      }

      if let fst = candidateBoxes.first, fst.1 == "]" {
        let (leftRow, leftCol) = (fst.0.row, fst.0.col - 1)
        candidateBoxes.append((Cell((leftRow, leftCol)), rows[leftRow][leftCol]))
      }

      var newNextPos: [Cell] = []
      for (cell, value) in candidateBoxes {
        if value == "[" || value == "]" {
          boxes[cell] = value
          newNextPos.append(Cell((cell.row + vOffset, cell.col)))
        }
      }

      return moveVertically(state, vOffset: vOffset, nextPos: newNextPos, boxes: boxes)
    }

    fatalError("We should have matched something by now")
  }

  func enlarge(_ row: [Character]) -> [Character] {
    var newRow: [Character] = []
    for c in row {
      switch c {
      case ".": newRow += [".", "."]
      case "O": newRow += ["[", "]"]
      case "#": newRow += ["#", "#"]
      case "@": newRow += ["@", "."]
      default: fatalError("Unexpected character")
      }
    }

    return newRow
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
