import Testing

@testable import AdventOfCode

@Suite("Day22 Tests")
struct Day22Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let day = Day22(data: testInput)
      #expect(day.rows == [1, 10, 100, 2024])
    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day22(data: testInput)

    @Test("Next function")
    func testNext() {
      #expect(day.next(from: 123) == 15887950)
      #expect(day.next(from: 15887950) == 16495136)
      #expect(day.next(from: 16495136) == 527345)
      #expect(day.next(from: 527345) == 704524)
      #expect(day.next(from: 704524) == 1553684)
      #expect(day.next(from: 1553684) == 12683156)
      #expect(day.next(from: 12683156) == 11100544)
      #expect(day.next(from: 11100544) == 12249484)
      #expect(day.next(from: 12249484) == 7753432)
      #expect(day.next(from: 7753432) == 5908254)
    }

    @Test("Evolution function")
    func testEvolution() {
      let fn = day.evolvutionFunction(n: 10)
      #expect(fn(123) == 5908254)
    }

    @Test("Part1 example")
    func testPart1() async throws {
      let result = try await day.part1()
      #expect(result == 37327623)
    }

    @Test("Part2 example")
    func testPart2() async throws {
      await withKnownIssue {
        let result = try await day.part2()
        #expect(result == 10)
      }
    }
  }
}

private let testInput =
  """
  1
  10
  100
  2024
  """
