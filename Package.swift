// swift-tools-version: 6.0
import PackageDescription

let dependencies: [Target.Dependency] = [
  .product(name: "Algorithms", package: "swift-algorithms"),
  .product(name: "ArgumentParser", package: "swift-argument-parser"),
  .product(name: "Collections", package: "swift-collections"),
  .product(name: "AoCCommon", package: "AoCCommon"),
]

let package = Package(
  name: "AdventOfCode",
  platforms: [.macOS(.v15)],
  products: [
    .executable(name: "AdventOfCode", targets: ["AdventOfCode"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/Abizern/AoCCommon",
      from: "0.0.10"
    ),
//    .package(path: "../AoCCommon"),
    .package(path: "NewDayPlugin"),
    .package(
      url: "https://github.com/apple/swift-algorithms.git",
      from: "1.2.0"
    ),
    .package(
      url: "https://github.com/apple/swift-argument-parser.git",
      from: "1.5.0"
    ),
    .package(
      url: "https://github.com/apple/swift-collections.git",
      from: "1.1.0"
    ),
  ],
  targets: [
    .executableTarget(
      name: "AdventOfCode",
      dependencies: dependencies,
      resources: [.copy("Data")]
    ),
    .testTarget(
      name: "AdventOfCodeTests",
      dependencies: ["AdventOfCode"]
    ),
  ]
)
