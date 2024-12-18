import Algorithms
import AoCCommon
import Foundation
import GameplayKit

typealias GridGraph = GKGridGraph<GKGridGraphNode>
typealias Node = GKGridGraphNode

struct Day18: AdventDay, Sendable {
  let data: String
  let day = 18
  let puzzleName: String = "--- Day 18: RAM Run ---"

  init(data: String) {
    self.data = data
  }

  var points: [(Int, Int)] {
    do {
      return try NumberPairs().parse(data)
    } catch {
      fatalError("Unable to parse input \(error)")
    }
  }

  func part1() async throws -> String {
    let graph = createGraph(width: 71, height: 71)
    let points = points.prefix(1024)
    remove(points: points, from: graph)

    let start = graph.node(atGridPosition: vector_int2(0, 0))!
    let end = graph.node(atGridPosition: vector_int2(70, 70))!

    let path = graph.findPath(from: start, to: end)

    return "\(path.count - 1)" // steps, is one less than length of path
  }

  func part2() async throws -> String {
    let index = points.partitioningIndex { point in
      let graph = createGraph(width: 71, height: 71)
      let start = graph.node(atGridPosition: vector_int2(0, 0))!
      let end = graph.node(atGridPosition: vector_int2(70, 70))!
      let searchIndex = points.firstIndex { $0 == point }!
      let slice = points.prefix(through: searchIndex)
      remove(points: slice, from: graph)

      return graph.findPath(from: start, to: end).isEmpty
    }

    let point = points[index]

    return "\(point.0),\(point.1)"
  }
}

extension Day18 {
  func createGraph(width: Int, height: Int) -> GridGraph {
    GKGridGraph(
      fromGridStartingAt: vector_int2(0, 0),
      width: Int32(width),
      height: Int32(height),
      diagonalsAllowed: false,
      nodeClass: Node.self
    )
  }

  func nodes(for points: [(Int, Int)].SubSequence, from graph: GridGraph) -> [Node] {
    points.map { vector_int2(Int32($0.1), Int32($0.0)) }
      .compactMap { graph.node(atGridPosition: $0) }
  }

  func remove(points: [(Int, Int)].SubSequence, from graph: GridGraph) {
    graph.remove(nodes(for: points, from: graph))
  }
}
