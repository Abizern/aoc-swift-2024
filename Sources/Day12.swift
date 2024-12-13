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
