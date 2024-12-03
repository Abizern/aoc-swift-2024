import Foundation
import Parsing

struct Day03: AdventDay, Sendable {
  let data: String
  let day = 3
  let puzzleName: String = "--- Day 3: Mull It Over ---"

  init(data: String) {
    self.data = data
  }

  var instructions: [Instruction] {
    parseInput()
  }

  func part1() async throws -> Int {
    instructions.map(\.value).reduce(0, +)
  }

  func part2() async throws -> Int {
    instructions.reduce(into: (0, Instruction.enabled)) { accumulator, instruction in
      let sum = accumulator.0
      let state = accumulator.1

      switch instruction {
      case .enabled:
        accumulator = (sum, .enabled)
      case .disabled:
        accumulator = (sum, .disabled)
      case .mul:
        if state == .enabled {
          accumulator = (sum + instruction.value, .enabled)
        }
      }
    }.0
  }
}

extension Day03 {
  func parseInput() -> [Instruction] {
    var result = [Instruction]()
    var data = data[...]
    while !data.isEmpty {
      if let pair = try? InstructionParser().parse(&data) {
        result.append(pair)
      } else {
        data = data.dropFirst()
      }
    }
    return result
  }
}

extension Day03 {
  enum Instruction: Equatable {
    case mul(Int, Int)
    case enabled
    case disabled

    init(_ a: Int, _ b: Int) {
      self = .mul(a, b)
    }

    var value: Int {
      switch self {
      case .mul(let a, let b): a * b
      case .disabled: 0
      case .enabled: 0
      }
    }
  }

  struct MulParser: Parser {
    var body: some Parser<Substring, Instruction> {
      Parse(Instruction.init) {
        "mul("
        Int.parser()
        ","
        Int.parser()
        ")"
      }
    }
  }

  struct InstructionParser: Parser {
    var body: some Parser<Substring, Instruction> {
      OneOf {
        MulParser()
        "don't()".map { _ in Instruction.disabled }
        "do()".map { _ in Instruction.enabled }
      }
    }
  }
}
