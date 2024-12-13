import Foundation
import Parsing

struct Day13: AdventDay, Sendable {
  let data: String
  let day = 13
  let puzzleName: String = "--- Day 13: Claw Contraption ---"

  init(data: String) {
    self.data = data
  }

  var machines: [Machine] {
    do {
      return try MachinesParser().parse(data)
    } catch {
      fatalError("Unable to parse data: \(error)")
    }
  }

  func part1() async throws -> Int {
    machines.compactMap(\.minimumCost).reduce(0, +)
  }
}

extension Day13 {
  struct Machine: Equatable {
    struct Button: Equatable {
      let dx: Int
      let dy: Int
    }

    struct Prize: Equatable {
      let x: Int
      let y: Int
    }

    let buttonA: Button
    let buttonB: Button
    let prize: Prize

    init(buttonA: Button, buttonB: Button, prize: Prize) {
      self.buttonA = buttonA
      self.buttonB = buttonB
      self.prize = prize
    }

    var minimumCost: Int? {
      var minimumCost: Int?
      for a in 0 ..< 100 {
        for b in 0 ..< 100 {
          let currentX = a * buttonA.dx + b * buttonB.dx
          let currentY = a * buttonA.dy + b * buttonB.dy

          if currentX == prize.x, currentY == prize.y {
            let cost = 3 * a + b
            if minimumCost == nil || cost < minimumCost! {
              minimumCost = cost
            }
          }
        }
      }
      return minimumCost
    }
  }
}

extension Day13 {
  struct ButtonParser: Parser {
    var body: some Parser<Substring, Machine.Button> {
      Parse {
        "Button "
        OneOf {
          "A"
          "B"
        }
        ": X+"
        Int.parser()
        ", Y+"
        Int.parser()
      }.map { Machine.Button(dx: $0, dy: $1) }
    }
  }

  struct PrizeParser: Parser {
    var body: some Parser<Substring, Machine.Prize> {
      Parse {
        "Prize: X="
        Int.parser()
        ", Y="
        Int.parser()
      }.map { Machine.Prize(x: $0, y: $1) }
    }
  }

  struct MachineParser: Parser {
    var body: some Parser<Substring, Machine> {
      Parse {
        ButtonParser()
        "\n"
        ButtonParser()
        "\n"
        PrizeParser()
      }.map { Machine(buttonA: $0, buttonB: $1, prize: $2) }
    }
  }

  struct MachinesParser: Parser {
    var body: some Parser<Substring, [Machine]> {
      Many {
        MachineParser()
      } separator: {
        "\n\n"
      } terminator: {
        End()
      }
    }
  }
}
