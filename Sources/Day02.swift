import Algorithms
import Foundation
import Parsing

struct Day02: AdventDay, Sendable {
  let data: String
  let day = 2
  let puzzleName: String = "--- Day 2: Red-Nosed Reports ---"

  init(data: String) {
    self.data = data
  }

  var reports: [[Int]] {
    do {
      return try LevelsParser().parse(data)
    } catch {
      fatalError("Unable to parse data \(error)")
    }
  }

  func part1() async throws -> Int {
    reports.filter(isSafe).count
  }

  func part2() async throws -> Int {
    reports.filter(isSafeOrCorrectable).count
  }
}

extension Day02 {
  func isSafe(_ report: [Int]) -> Bool {
    guard let start = report.first,
          let end = report.last,
          start != end
    else { return false }
    let shouldIncrease = start < end ? true : false

    return report.adjacentPairs().allSatisfy { a, b in
      (shouldIncrease ? a < b : a > b) && (1 ... 3).contains(abs(a - b))
    }
  }

  func isSafeOrCorrectable(_ report: [Int]) -> Bool {
    guard !isSafe(report) else { return true }
    let length = report.count
    var i = 0
    var correctable = false

    while i < length, !correctable {
      var arr = report
      arr.remove(at: i)
      correctable = isSafe(arr)
      i += 1
    }

    return correctable
  }
}

struct NumbersParser: Parser {
  var body: some Parser<Substring, [Int]> {
    Many {
      Int.parser()
    } separator: {
      " "
    }
  }
}

struct LevelsParser: Parser {
  var body: some Parser<Substring, [[Int]]> {
    Many {
      NumbersParser()
    } separator: {
      "\n"
    }
  }
}
