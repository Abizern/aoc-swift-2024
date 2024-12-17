import Foundation
import Parsing

struct ChronoComp: Equatable, Sendable {
  var regA: Int
  var regB: Int
  var regC: Int

  let insstructions: [UInt8]
  var output: [UInt8] = []

  var iPointer: Int = 0

  let terminator: Int

  init(regA: Int, regB: Int, regC: Int, insstructions: [UInt8]) {
    self.regA = regA
    self.regB = regB
    self.regC = regC
    self.insstructions = insstructions
    terminator = insstructions.count
  }

  mutating func step() {
    let opCode = insstructions[iPointer]
    let operaand = insstructions[iPointer + 1] // Assuming well formed input

    switch opCode {
    case 0: adv(operaand)
    case 1: bxl(operaand)
    case 2: bst(operaand)
    case 3: jnz(operaand)
    case 4: bxc()
    case 5: out(operaand)
    case 6: bdv(operaand)
    case 7: cdv(operaand)
    default: fatalError("Unknown opCode \(opCode)")
    }
  }

  mutating func run() {
    while iPointer < terminator {
      step()
    }
  }
}

extension ChronoComp {
  mutating func adv(_ operand: UInt8) {
    regA = division(operand)
    incrementPointer()
  }

  mutating func bxl(_ operand: UInt8) {
    regB = regB ^ Int(operand)
    incrementPointer()
  }

  mutating func bst(_ operand: UInt8) {
    regB = combo(operand) % 8
    incrementPointer()
  }

  mutating func jnz(_ operand: UInt8) {
    switch regA {
    case 0: incrementPointer()
    default: iPointer = Int(operand)
    }
  }

  mutating func bxc() {
    regB = regB ^ regC
    incrementPointer()
  }

  mutating func out(_ operand: UInt8) {
    let result = UInt8(combo(operand) % 8)
    output.append(result)
    incrementPointer()
  }

  mutating func bdv(_ operand: UInt8) {
    regB = division(operand)
    incrementPointer()
  }

  mutating func cdv(_ operand: UInt8) {
    regC = division(operand)
    incrementPointer()
  }

  func combo(_ operand: UInt8) -> Int {
    switch operand {
    case 0 ... 3: Int(operand)
    case 4: regA
    case 5: regB
    case 6: regC
    default: fatalError("Unknown compbo operand \(operand)")
    }
  }

  func division(_ operand: UInt8) -> Int {
    regA >> combo(operand)
  }

  mutating func incrementPointer() {
    iPointer += 2
  }
}

struct ChronoCompParser: Parser {
  var body: some Parser<Substring, ChronoComp> {
    Parse(ChronoComp.init) {
      "Register A: "
      Int.parser()
      "\nRegister B: "
      Int.parser()
      "\nRegister C: "
      Int.parser()
      "\n\nProgram: "
      Many {
        Int.parser().map { UInt8($0) }
      } separator: {
        ","
      } terminator: {
        End()
      }
    }
  }
}
