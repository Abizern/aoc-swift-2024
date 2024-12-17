import Testing

@testable import AdventOfCode

@Suite("Chronospatial Computer")
struct ChronospatialComputerTests {
  @Test("Initialisation")
  func initialisation() {
    let comp = ChronoComp(regA: 10, regB: 20, regC: 30, insstructions: [1, 2, 3])
    #expect(comp.regA == 10)
    #expect(comp.regB == 20)
    #expect(comp.regC == 30)
    #expect(comp.insstructions == [1, 2, 3])
    #expect(comp.terminator == 3)
    #expect(comp.iPointer == 0)
  }

  @Test("Parser initialisation")
  func parserInitialisation() throws {
    let input =
      """
      Register A: 10
      Register B: 20
      Register C: 30

      Program: 1,2,3
      """
    let comp = try ChronoCompParser().parse(input)
    #expect(comp.regA == 10)
    #expect(comp.regB == 20)
    #expect(comp.regC == 30)
    #expect(comp.insstructions == [1, 2, 3])
    #expect(comp.terminator == 3)
    #expect(comp.iPointer == 0)
  }

  @Suite("Operations")
  struct OperationsTests {
    var comp1 = ChronoComp(regA: 360, regB: 20, regC: 30, insstructions: [1, 2, 3])
    var comp2 = ChronoComp(regA: 10, regB: 20, regC: 30, insstructions: [1, 2, 3])
    @Test("Advance Pointer")
    func advancePointer() {
      var comp = comp1
      #expect(comp.iPointer == 0)
      #expect(comp.iPointer == 0)
      comp.incrementPointer()
      #expect(comp.iPointer == 2)
    }

    @Test("Combo operands")
    func comboOperands() {
      let comp = comp2
      #expect(comp.combo(0) == 0)
      #expect(comp.combo(1) == 1)
      #expect(comp.combo(2) == 2)
      #expect(comp.combo(3) == 3)
      #expect(comp.combo(4) == 10)
      #expect(comp.combo(5) == 20)
      #expect(comp.combo(6) == 30)
    }
  }

  @Suite("Specific examples")
  struct SpecificExamplesTests {
    @Test("First")
    func first() {
      var comp = ChronoComp(regA: 0, regB: 0, regC: 9, insstructions: [2, 6])
      comp.run()
      #expect(comp.regB == 1)
    }

    @Test("Second")
    func second() {
      var comp = ChronoComp(regA: 10, regB: 0, regC: 0, insstructions: [5, 0, 5, 1, 5, 4])
      comp.run()
      #expect(comp.output == [0, 1, 2])
    }

    @Test("Third")
    func third() {
      var comp = ChronoComp(regA: 2024, regB: 0, regC: 0, insstructions: [0, 1, 5, 4, 3, 0])
      comp.run()
      #expect(comp.output == [4, 2, 5, 6, 7, 7, 7, 7, 3, 1, 0])
      #expect(comp.regA == 0)
    }

    @Test("Fourth")
    func fourth() {
      var comp = ChronoComp(regA: 0, regB: 29, regC: 0, insstructions: [1, 7])
      comp.run()
      #expect(comp.regB == 26)
    }

    @Test("Fifth")
    func fifth() {
      var comp = ChronoComp(regA: 0, regB: 2024, regC: 43690, insstructions: [4, 0])
      comp.run()
      #expect(comp.regB == 44354)
    }
  }
}
