import Foundation
import Parsing

struct Day23: AdventDay, Sendable {
  let data: String
  let day = 23
  let puzzleName: String = "--- Day 23: LAN Party ---"

  init(data: String) {
    self.data = data
  }

  var connections: [(String, String)] {
    do {
      return try InputParser().parse(data)
    } catch {
      fatalError("Unable to parse data \(error)")
    }
  }

  func part1() async throws -> String {
    String(bruteForce())
  }
}

extension Day23 {
  func nodes(_ connections: [(String, String)]) -> [String: Set<String>] {
    var dict = [String: Set<String>]()
    for (a, b) in connections {
      dict[a, default: []].insert(b)
      dict[b, default: []].insert(a)
    }
    return dict
  }

  func bruteForce() -> Int {
    let nodes = nodes(connections)
    var triplets = Set<Set<String>>()

    let keys = nodes.keys.sorted()
    for i in 0 ..< keys.count {
      for j in 0 + 1 ..< keys.count {
        for k in 0 + 2 ..< keys.count {
          let a = keys[i]
          let b = keys[j]
          let c = keys[k]

          if nodes[a]!.contains(b), nodes[b]!.contains(c), nodes[c]!.contains(a) {
            triplets.insert([a, b, c])
          }
        }
      }
    }

    return triplets.filter { set in
      set.contains { $0.hasPrefix("t") }
    }.count
  }
}

extension Day23 {
  struct Connection: Parser {
    var body: some Parser<Substring, (String, String)> {
      Prefix { $0 != "-" }.map(String.init)
      "-"
      Prefix { $0 != "\n" }.map(String.init)
    }
  }

  struct InputParser: Parser {
    var body: some Parser<Substring, [(String, String)]> {
      Many {
        Connection()
      } separator: {
        "\n"
      } terminator: {
        End()
      }
    }
  }
}
