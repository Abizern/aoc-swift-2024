# Advent of Code Swift Template for Swift Solutions

[![Language](https://img.shields.io/badge/language-Swift-red.svg)](https://swift.org)

Daily programming puzzles at [Advent of Code](<https://adventofcode.com/>), by
[Eric Wastl](<http://was.tl/>). This is a small example starter project for
building Advent of Code solutions.

## Template 

Based on the [swift-aoc-starter-example](https://github.com/apple/swift-aoc-starter-example/) provided by Apple

### Major changes from the forkeed template

- Swift 6 (Have fun with Sendable Types)
- Swift Testing instead of XCTest

## Challenges

The challenges assume three files (replace 00 with the day of the challenge).

- `Sources/Data/day00.txt`: the input data provided for the challenge
- `Sources/Day00.swift`: the code to solve the challenge
- `Tests/Day00Tests.swift`: any unit tests that you want to include

The Package contains a plug-in to generate these files:

To start a new day's challenge, `cd` to the root directory of the package and run 

```shell
swift package --allow-writing-to-package-directory new-day <day-number>
```

which will create the three files for the day. It may look like a lot to type, but if your shell is correctly set up, history and auto-completien will make this easier.

Alternatively, if you don't want to use the plugin make a copy of these files, updating 00 to the  day number.

In either case, you will need to add the solution to the list of available solutions:

```diff
// Add each new day implementation to this array:
let allChallenges: [any AdventDay] = [
-  Day00()
+  Day00(),
+  Day01(),
]
```

Then implement part 1 and 2. The `AdventOfCode.swift` file controls which challenge
is run with `swift run`. Add your new type to its `allChallenges` array. By default 
it runs the most recent challenge.

The `AdventOfCode.swift` file controls which day's challenge is run
with `swift run`. By default that runs the most recent challenge in the package.

To supply command line arguments use `swift run AdventOfCode`. For example,
`swift run -c release AdventOfCode --benchmark 3` builds the binary with full
optimizations, and benchmarks the challenge for day 3.

## Linting and Formatting

I`m trying out 2 space indents, so watch out for that!

I use Swiftformat so this works for me:

```shell
swiftformat .
```

