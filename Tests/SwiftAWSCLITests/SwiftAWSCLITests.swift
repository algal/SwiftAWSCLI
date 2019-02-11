import XCTest
@testable import SwiftAWSCLI

final class SwiftAWSCLITests: XCTestCase {
    func testRunInstances() {
      let groups:[String] = "sshable moshable default".split(separator: " ").map(String.init)
      let instanceId = runInstances(imageId: "ami-a2e544da",
                                    instanceType: "m4.4xlarge",
                                    securityGroups: groups,
                                    region: "us-west-2")
      XCTAssertNotNil(instanceId)
    }

  func testGetPublicDnsName() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct
    // results.
    let instanceID:String = "i-0ab7562662c89b728"
    let dnsName  = publicDnsName(ofInstanceId: instanceID)
    XCTAssertNotNil(dnsName)
  }

  func testListObjects() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct
    // results.
    let objs = listObject(bucket:"compute-worker-inbox")
    XCTAssertNotNil(objs, "Unexpected nil")
  }

    static var allTests = [
//        ("testRunInstances", testRunInstances),
    ]
}
