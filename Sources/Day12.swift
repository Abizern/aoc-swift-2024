import Collections
import Foundation
import GameplayKit

struct Day12: AdventDay, Sendable {
  let data: String
  let day = 12
  let puzzleName: String = "--- Day 12: Garden Groups ---"

  init(data: String) {
    self.data = data
  }

  var rows: [[Character]] {
    data.characterLines()
  }

  func part1() async throws -> Int {
    let farm = farm(from: rows)
    let regions = regions(from: farm, rows: rows)

    return regions.map(price).reduce(0, +)
  }

  func part2() async throws -> Int {
    let farm = farm(from: rows)
    let regions = regions(from: farm, rows: rows)

    return regions.map { newPrice($0, rows: rows) }.reduce(0, +)
  }
}

extension Day12 {
  typealias GridGraph = GKGridGraph<GKGridGraphNode>
  typealias Node = GKGridGraphNode

  func farm(from rows: [[Character]]) -> GridGraph {
    let width = Int32(rows[0].count)
    let height = Int32(rows.count)
    let origin = vector_int2(0, 0)
    let graph = GKGridGraph(
      fromGridStartingAt: origin,
      width: width,
      height: height,
      diagonalsAllowed: false,
      nodeClass: Node.self
    )

    for node in graph.nodes! {
      let node = node as! Node
      let position = node.gridPosition
      let (row, column) = (Int(position.y), Int(position.x))

      for neighbor in node.connectedNodes {
        let neighbor = neighbor as! Node
        let nPosition = neighbor.gridPosition
        let (nRow, nColumn) = (Int(nPosition.y), Int(nPosition.x))

        if rows[nRow][nColumn] != rows[row][column] {
          node.removeConnections(to: [neighbor], bidirectional: true)
        }
      }
    }

    return graph
  }

  func regions(from graph: GridGraph, rows _: [[Character]]) -> [Set<Node>] {
    var regions: [Set<Node>] = []
    var seen: Set<Node> = []

    for node in graph.nodes! {
      let node = node as! Node
      guard !seen.contains(node) else { continue }

      var stack = [node]
      var currentRegion = Set<Node>()

      while !stack.isEmpty {
        let currentNode = stack.removeLast()
        guard !seen.contains(currentNode) else { continue }
        seen.insert(currentNode)
        currentRegion.insert(currentNode)

        // Add unvisited neighbors of the same region to the stack
        for neighbor in currentNode.connectedNodes {
          let neighbor = neighbor as! Node
          if !seen.contains(neighbor) {
            stack.append(neighbor)
          }
        }
      }

      if !currentRegion.isEmpty {
        regions.append(currentRegion)
      }
    }

    return regions
  }

  func price(_ region: Set<Node>) -> Int {
    let area = region.count
    let perimeter = region.reduce(0) { partialResult, node in
      partialResult + 4 - node.connectedNodes.count
    }

    return area * perimeter
  }
}

extension Day12 {
  struct Edge: Hashable {
    enum Direction: Hashable {
      case top, right, bottom, left
    }

    let position: vector_int2
    let direction: Direction

    var neighbours: [Edge] {
      let x = position.x
      let y = position.y
      switch direction {
      case .top, .bottom:
        return [
          Edge(position: vector_int2(x: x + 1, y: y), direction: direction),
          Edge(position: vector_int2(x: x - 1, y: y), direction: direction),
        ]
      case .right, .left:
        return [
          Edge(position: vector_int2(x: x, y: y + 1), direction: direction),
          Edge(position: vector_int2(x: x, y: y - 1), direction: direction),
        ]
      }
    }
  }

  func edges(for region: Set<Node>) -> Set<Edge> {
    var edges: Set<Edge> = []

    for node in region {
      let position = node.gridPosition
      let above = position.above
      let below = position.below
      let left = position.left
      let right = position.right

      let neighbours = node.connectedNodes.map { $0 as! Node }.map(\.gridPosition)
      if !neighbours.contains(above) {
        edges.insert(Edge(position: position, direction: .top))
      }

      if !neighbours.contains(below) {
        edges.insert(Edge(position: position, direction: .bottom))
      }

      if !neighbours.contains(left) {
        edges.insert(Edge(position: position, direction: .left))
      }

      if !neighbours.contains(right) {
        edges.insert(Edge(position: position, direction: .right))
      }
    }
    return edges
  }

  func sides(for region: Set<Node>) -> Int {
    let edges = edges(for: region)
    var totalSides = 0
    var seen = Set<Edge>()

    for edge in edges {
      guard !seen.contains(edge) else { continue }
      var stack = Deque<Edge>([edge])

      while !stack.isEmpty {
        let current = stack.removeFirst()
        guard !seen.contains(current) else { continue }
        seen.insert(current)

        for neighbour in current.neighbours {
          guard !seen.contains(neighbour) else { continue }
          if edges.contains(neighbour) {
            stack.append(neighbour)
          }
        }
      }

      totalSides += 1
    }
    return totalSides
  }

  func newPrice(_ region: Set<Node>, rows _: [[Character]]) -> Int {
    let area = region.count
    let sidesCount = sides(for: region)

    return area * sidesCount
  }
}

extension vector_int2 {
  var above: vector_int2 {
    vector_int2(x: x, y: y + 1)
  }

  var below: vector_int2 {
    vector_int2(x: x, y: y - 1)
  }

  var right: vector_int2 {
    vector_int2(x: x + 1, y: y)
  }

  var left: vector_int2 {
    vector_int2(x: x - 1, y: y)
  }
}
