import Testing

@testable import AdventOfCode

@Suite("Day17 Tests")
struct Day17Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let day = Day17(data: testInput)
      let computer = day.computer
      #expect(computer.regA == 729)
      #expect(computer.regB == 0)
      #expect(computer.regC == 0)
      #expect(computer.insstructions == [0, 1, 5, 4, 3, 0])
    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day17(data: testInput)

    @Test("Part1 example")
    func testPart1() async throws {
      let result = try await day.part1()
      #expect(result == "4,6,3,5,6,3,5,2,1,0")
    }

    @Test("Part2 example")
    func testPart2() async throws {
      await withKnownIssue {
        let result = try await day.part2()
        #expect(result == "10")
      }
    }
  }
}

private let testInput =
  """
  Register A: 729
  Register B: 0
  Register C: 0

  Program: 0,1,5,4,3,0
  """
