import Foundation
import SwiftShell

// These structs are aligned with the shape of AWS JSON output

struct ListObjectsOutput: Decodable {
  var Contents:[S3ObjectContent]
}

struct S3ObjectContent: Decodable {
  var Key:String
}

struct RunInstancesOutput: Decodable {
  var Instances:[Instance]
}

struct DescribeInstancesOutput: Decodable {
  var Reservations:[Reservation]
}

struct Reservation: Decodable {
  var Instances:[Instance]
}

struct Instance: Decodable {
  var PublicDnsName:String
  var InstanceId:String
}


/// Lists the objects in a bucket
///
/// - Parameter bucket: name of the bucket
/// - Returns: `Array<String>` of object names (i.e., "keys"), or nil on error
public func listObject(bucket:String) -> [String]?
{
  let runbash = run("aws","s3api","list-objects","--bucket",bucket)
  guard runbash.succeeded,
    let output = runbash.stdout.data(using: .utf8),
    let value = try? JSONDecoder().decode(ListObjectsOutput.self, from: output)
  else {
    return nil
  }
  let keys = value.Contents.map({$0.Key})
  return keys
}

/// Creates an EC2 instance, and returns its instanceId
///
/// - Parameters:
///   - imageId: ED2 AMI image ID
///   - instanceType: EC2 instance type, e.g., "m4.4xlarge"
///   - securityGroups: `Array<String>` of security groups
///   - region: an EC2 region. E.g., "us-west-2"
/// - Returns: returns the instance ID, or nil
public func runInstances(imageId:String,
                         instanceType:String,
                         securityGroups:[String],
                         region:String) -> String?
{
  var args:[String] = ["ec2","run-instances",
                       "--image-id",imageId,
                       "--instance-type",instanceType,
                       "--security-groups"]
  args.append(contentsOf: securityGroups)
  args.append(contentsOf: ["--ebs-optimized",
                           "--region",region])

  let runOutput = run("aws",args)
  guard let result = try? JSONDecoder().decode(RunInstancesOutput.self,
                                               from: runOutput.stdout.data(using: .utf8)!)
    else {
      return nil
  }
  return result.Instances[0].InstanceId
}

/// Gets the PublicDnsName of an EC2 instance
///
/// - Parameter instanceId: EC2 instance Id
/// - Returns: the PublicDnsName. Or, nil if there is none or if the operation fails
public func publicDnsName(ofInstanceId instanceId:String) -> String?
{
  let ro = run("aws","ec2","describe-instances",
               "--instance-ids",instanceId)

  guard let result = try? JSONDecoder().decode(DescribeInstancesOutput.self,
                                         from: ro.stdout.data(using: .utf8)!)
    else {
      return nil
  }
  return result.Reservations.first?.Instances.first?.PublicDnsName
}

