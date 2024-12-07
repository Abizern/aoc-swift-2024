import Testing

@testable import AdventOfCode

@Suite("Day07 Tests")
struct Day07Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let day = Day07(data: testInput)
      let calibrations = day.calibrations
      #expect(calibrations.count == 9)
      #expect(calibrations[0].target == 190)
      #expect(calibrations[1].target == 3267)
      #expect(calibrations[8].target == 292)
      #expect(calibrations[0].values == [10, 19])
      #expect(calibrations[8].values == [11, 6, 16, 20])
    }
  }

  @Suite("Calibaration Tests")
  struct CalibrationTests {
    @Test("Validation")
    func valiadation() {
      let c1 = Day07.Calibration(target: 190, values: [10, 19])
      #expect(c1.isValid)

      let c2 = Day07.Calibration(target: 3267, values: [81, 40, 27])
      #expect(c2.isValid)

      let c3 = Day07.Calibration(target: 83, values: [17, 5])
      #expect(!c3.isValid)
    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day07(data: testInput)

    @Test("Part1 example")
    func testPart1() async throws {
      let result = try await day.part1()
      #expect(result == 3749)
    }

    @Test("Part2 example")
    func testPart2() async throws {
      let result = try await day.part2()
      #expect(result == 11387)
    }
  }
}

private let testInput =
  """
  190: 10 19
  3267: 81 40 27
  83: 17 5
  156: 15 6
  7290: 6 8 6 15
  161011: 16 10 13
  192: 17 8 14
  21037: 9 7 18 13
  292: 11 6 16 20
  """
