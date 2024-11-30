import Testing

@testable import AdventOfCode

@Suite("Package Tests")
enum AdventDayTests {
  @Test("Validate that data can be loaded")
  func testInitData() throws {
    let challenge = Day00()
    #expect(challenge.data.starts(with: "4514"))
  }
}
