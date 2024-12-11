import Algorithms
import AoCCommon
import Foundation
import GameplayKit

struct Day10: AdventDay, Sendable {
  let data: String
  let day = 10
  let puzzleName: String = "--- Day 10: Hoof It ---"

  let rows: [[Int]]

  init(data: String) {
    self.data = data
    do {
      rows = try SingleDigitLinesParser().parse(data)
    } catch {
      fatalError("Unable to parse input \(error)")
    }
  }

  var grid: Grid<Int> {
    do {
      return try SingleDigitGridParser().parse(data)
    } catch {
      fatalError("Unable to parse data because \(error)")
    }
  }

  func part1() async throws -> Int {
    score(gridGraph)
//    trailHeads(grid)
//      .map { score(grid, start: $0) }
//      .reduce(0, +)
  }

  func part2() async throws -> Int {
    rating(gridGraph)
//    trailHeads(grid)
//      .map { rating(grid, start: $0) }
//      .reduce(0, +)
  }
}

// MARK: - Using Foundation

extension Day10 {
  func trailHeads(_ grid: Grid<Int>) -> Set<Cell> {
    grid.filter { $0 == 0 }
  }

  func trailCount(_ grid: Grid<Int>, start: Cell, allPaths: Bool = false) -> Int {
    var count = 0
    var queue = Deque<Cell>([start])
    var ends = Set<Cell>()

    while !queue.isEmpty {
      let cursor = queue.removeFirst()
      let cursorValue = grid.element(cursor)!

      if cursorValue == 9 {
        switch (allPaths, ends.contains(cursor)) {
        case (false, false):
          count += 1
          ends.insert(cursor)
        case (false, true):
          continue
        case (true, _):
          count += 1
          continue
        }
      }

      let neighbours = grid
        .neighbours(cursor, includeDiagonals: false)
        .filter { grid.element($0)! - cursorValue == 1 }
      queue.append(contentsOf: neighbours)
    }

    return count
  }

  func score(_ grid: Grid<Int>, start: Cell) -> Int {
    trailCount(grid, start: start)
  }

  func rating(_ grid: Grid<Int>, start: Cell) -> Int {
    trailCount(grid, start: start, allPaths: true)
  }
}

// MARK: - Using GamePlayKit

extension Day10 {
  typealias GridGraph = GKGridGraph<GKGridGraphNode>
  typealias Node = GKGridGraphNode

  var gridGraph: GridGraph {
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

      for neighbour in node.connectedNodes {
        let neighbour = neighbour as! Node
        let nPosition = neighbour.gridPosition
        let (nRow, nColumn) = (Int(nPosition.y), Int(nPosition.x))

        if rows[nRow][nColumn] != rows[row][column] + 1 {
          node.removeConnections(to: [neighbour], bidirectional: false)
        }
      }
    }

    return graph
  }

  func trailHeads(_ graph: GridGraph) -> [Node] {
    nodes(for: 0, graph: graph)
  }

  func trailEnds(_ graph: GridGraph) -> [Node] {
    nodes(for: 9, graph: graph)
  }

  func nodes(for value: Int, graph: GridGraph) -> [Node] {
    graph
      .nodes!
      .compactMap { node -> Node? in
        guard let node = node as? Node else { return nil }
        return node
      }
      .filter { node in
        let position = node.gridPosition
        let (row, column) = (Int(position.y), Int(position.x))
        return rows[row][column] == value
      }
  }

  func countConnections(_: GridGraph, head: Node, ends: [Node]) -> Int {
    var queue = Deque<Node>([head])
    var seen = Set<Node>()

    while !queue.isEmpty {
      let node = queue.removeFirst()
      if ends.contains(node) {
        seen.insert(node)
        continue
      }
      queue.append(contentsOf: node.connectedNodes as! [Node])
    }
    return seen.count
  }

  func countPaths(_: GridGraph, head: Node, ends: [Node]) -> Int {
    var count = 0
    var queue = Deque<Node>([head])

    while !queue.isEmpty {
      let node = queue.removeFirst()
      if ends.contains(node) {
        count += 1
        continue
      }
      queue.append(contentsOf: node.connectedNodes as! [Node])
    }
    return count
  }

  func score(_ graph: GridGraph) -> Int {
    let heads = trailHeads(graph)
    let ends = trailEnds(graph)
    var score = 0

    for head in heads {
      score += countConnections(graph, head: head, ends: ends)
    }
    return score
  }

  func rating(_ graph: GridGraph) -> Int {
    let heads = trailHeads(graph)
    let ends = trailEnds(graph)
    var score = 0

    for head in heads {
      score += countPaths(graph, head: head, ends: ends)
    }

    return score
  }
}
