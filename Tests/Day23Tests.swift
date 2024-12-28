import Testing

@testable import AdventOfCode

@Suite("Day23 Tests")
struct Day23Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let day = Day23(data: testInput)
      #expect(day.connections.count == 32)
    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day23(data: testInput)

    @Test("Part1 example")
    func testPart1() async throws {
      let result = try await day.part1()
      #expect(result == "7")
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
  kh-tc
  qp-kh
  de-cg
  ka-co
  yn-aq
  qp-ub
  cg-tb
  vc-aq
  tb-ka
  wh-tc
  yn-cg
  kh-ub
  ta-co
  de-co
  tc-td
  tb-wq
  wh-td
  ta-ka
  td-qp
  aq-cg
  wq-ub
  ub-vc
  de-ta
  wq-aq
  wq-vc
  wh-yn
  ka-de
  kh-ta
  co-tc
  wh-qp
  tb-vc
  td-yn
  """
