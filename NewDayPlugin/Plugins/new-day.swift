import Foundation
import PackagePlugin

@main
struct NewDay: CommandPlugin {
  func performCommand(context _: PluginContext, arguments: [String]) async throws {
    guard arguments.count == 1 else {
      throw NewDayError.message("Please provide a single day number such as '1' or '20'")
    }
    guard let dayArgument = arguments.first,
          let dayNumber = Int(dayArgument),
          (1 ... 25).contains(dayNumber)
    else {
      throw NewDayError.message("Please provide a number between 1 and 25 inclusive")
    }

    try writeFiles(String(format: "%02d", dayNumber))
  }
}

extension NewDay {
  func writeFiles(_ day: String) throws {
    try solution(day).write(
      to: solutionFile(day),
      atomically: true,
      encoding: .utf8
    )
    try tests(day).write(
      to: testFile(day),
      atomically: true,
      encoding: .utf8
    )
    try "".write(
      to: dataFile(day),
      atomically: true,
      encoding: .utf8
    )
  }
}

extension NewDay {
  func solutionFile(_ day: String) -> URL {
    URL(
      string: "Sources/Day\(day).swift",
      relativeTo: .currentDirectory()
    )!
  }

  func testFile(_ day: String) -> URL {
    URL(
      string: "Tests/Day\(day)Tests.swift",
      relativeTo: .currentDirectory()
    )!
  }

  func dataFile(_ day: String) -> URL {
    URL(
      string:
      "Sources/Data/day\(day).txt",
      relativeTo: .currentDirectory()
    )!
  }

  func solution(_ number: String) -> String {
    """
    import Foundation

    struct Day\(number): AdventDay, Sendable {
      // Save your data in a corresponding text file in the `Data` directory.
      let data: String
      let day = 0
      let puzzleName: String = "--- Day 0: Placeholder! ---"

      init(data: String) {
        self.data = data
      }

      // Replace this with your solution for the first part of the day's challenge.
      func part1() async throws -> Int {
        0
      }
    }

    // Add any extra code and types in here to separate it from the required behaviour
    extension Day\(number) {}

    """
  }

  func tests(_ number: String) -> String {
    """
      import Testing

      @testable import AdventOfCode

      @Suite("Day\(number) Tests")
      struct Day\(number)Tests {
      @Suite("Parser Tests")
      struct ParserTests {
        @Test("Test parser implementation")
        func parseInput() {
          //
        }
      }

      @Suite("Tests on sample inputs")
      struct SolutionsTests {
        @Suite("Tests on sample inputs")
        struct SolutionsTests {
          let day = Day\(number)(data: testInput)

          @Test("Part1 example")
          func testPart1() async throws {
            await withKnownIssue {
              let result = try await day.part1()
              #expect(result == 10)
            }
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
    }

    private let testInput =
      \"\"\"
      \"\"\"

    """
  }
}

enum NewDayError: Error {
  case message(String)
}
