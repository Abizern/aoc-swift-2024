// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "new-day",
  products: [
    .plugin(
      name: "new-day",
      targets: ["new-day"]
    ),
  ],
  targets: [
    .plugin(
      name: "new-day",
      capability: .command(
        intent: .custom(
          verb: "new-day",
          description: "Create template files for solutions and tests, and an empty data file for a new day."
        )
      )
    ),
  ]
)
