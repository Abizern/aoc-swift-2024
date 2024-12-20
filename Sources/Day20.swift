import Foundation
import Parsing
import GameplayKit

struct Day20: AdventDay, Sendable {
  let data: String
  let day = 20
  let puzzleName: String = "--- Day 20: Race Condition ---"

  init(data: String) {
    self.data = data
  }

  var rows: [[Character]] {
    do {
      return try InputParser().parse(data)
    } catch {
      fatalError("Unable to parse data \(error)")
    }
  }

  func part1() async throws -> Int {
    bruteForce(from: rows, target: 100)
  }
}

extension Day20 {
  typealias GridGraph = GKGridGraph<GKGridGraphNode>
  typealias Node = GKGridGraphNode

  func bruteForce(from rows: [[Character]], target: Int) -> Int {
    let graph = GKGridGraph(
      fromGridStartingAt: vector_int2(0, 0),
      width: Int32(rows[0].count),
      height: Int32(rows.count),
      diagonalsAllowed: false,
      nodeClass: Node.self
    )

    var walls: [Node] = []
    var candidates: [[Node]] = []
    var start: Node = graph.nodes!.first! as! Node
    var end: Node = graph.nodes!.first! as! Node
    for node in graph.nodes! {
      let node = node as! Node
      let position = node.gridPosition
      let value = rows[Int(position.y)][Int(position.x)]
      switch value {
      case "#":
        walls.append(node)
      case "S":
        start = node
        continue
      case "E":
        end = node
        continue
      default:
        continue
      }
      let neighbours = (node.connectedNodes as! [Node]).filter { n in
        rows[Int(n.gridPosition.y)][Int(n.gridPosition.x)] != "#"
      }
      if neighbours.count > 1 {
        candidates.append(neighbours)
      }
    }

    graph.remove(walls)
    let path = graph.findPath(from: start, to: end) as! [Node]

    let shortened = candidates.filter { candidates in
      guard let s = candidates.first,
            let e = candidates.last,
            let sIndex = path.firstIndex(of: s),
            let eIndex = path.firstIndex(of: e)
      else { return false }
      return abs(eIndex - sIndex) >= target + 2
    }

    return shortened.count
  }

}

// MARK: - Parsing
extension Day20 {
  struct ParseLine: Parser {
    var body: some Parser<Substring, [Character]> {
      Parse(Array.init) {
        Prefix { $0 != "\n" }
      }
    }
  }

  struct InputParser: Parser {
    var body: some Parser<Substring, [[Character]]> {
      Many {
        ParseLine()
      } separator: {
        "\n"
      } terminator: {
        End()
      }
    }
  }
}
