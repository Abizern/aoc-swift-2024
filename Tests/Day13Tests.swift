import Testing

@testable import AdventOfCode

@Suite("Day13 Tests")
struct Day13Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let day = Day13(data: testInput)
      let machines = day.machines
      #expect(machines.count == 4)
    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day13(data: testInput)

    @Test("Part1 example")
    func testPart1() async throws {
      let result = try await day.part1()
      #expect(result == 480)
    }
  }
}

private let testInput =
  """
  Button A: X+94, Y+34
  Button B: X+22, Y+67
  Prize: X=8400, Y=5400

  Button A: X+26, Y+66
  Button B: X+67, Y+21
  Prize: X=12748, Y=12176

  Button A: X+17, Y+86
  Button B: X+84, Y+37
  Prize: X=7870, Y=6450

  Button A: X+69, Y+23
  Button B: X+27, Y+71
  Prize: X=18641, Y=10279
  """
