import AoCCommon
import Foundation
import GameplayKit

typealias GridGraph = GKGridGraph<GKGridGraphNode>
typealias Node = GKGridGraphNode

struct Day18: AdventDay, Sendable {
  let data: String
  let day = 18
  let puzzleName: String = "--- Day 0: Placeholder! ---"

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
    let points = Array(points.prefix(1024))
    remove(points: points, from: graph)

    let start = graph.node(atGridPosition: vector_int2(0, 0))!
    let end = graph.node(atGridPosition: vector_int2(70, 70))!

    let path = graph.findPath(from: start, to: end)

    return "\(path.count - 1)" // steps, is one less than length of path
  }

  func part2() async throws -> String {
    let graph = createGraph(width: 71, height: 71)
    let start = graph.node(atGridPosition: vector_int2(0, 0))!
    let end = graph.node(atGridPosition: vector_int2(70, 70))!

    remove(points: Array(points.prefix(1024)), from: graph)

    for point in points.dropFirst(1024) {
      let node = graph.node(atGridPosition: vector_int2(Int32(point.1), Int32(point.0)))!
      graph.remove([node])

      if graph.findPath(from: start, to: end).isEmpty {
        return "\(point.0),\(point.1)"
      }
    }

    return "Anser not found"
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

  func remove(points: [(Int, Int)], from graph: GridGraph) {
    let nodes = points.map { vector_int2(Int32($0.1), Int32($0.0)) }
      .compactMap { graph.node(atGridPosition: $0) }

    graph.remove(nodes)
  }

  func remove(point: (Int, Int), from graph: GridGraph) {
    let point = vector_int2(Int32(point.1), Int32(point.0))
    let node = graph.node(atGridPosition: point)!
    graph.remove([node])
  }
}
