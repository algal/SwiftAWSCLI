# SwiftAWSCLI

This library provides a Swift interface to a few methods on AWS, by
the simple expedient of wrapping the AWS command-line tool (which can
be installed with `brew install awscli` and then configured with `aws
configure`).

Why you might want to use this:

- you can rely on the authentication already installed and configured
  for the aws command line tool.
- using this is simpler than trying to integrating AWS's official SDK,
  which is a giant steaming pile of auto-generated code, is an awkward
  API to use, and does not build cleanly out of the box if you want to
  create a static-linked Swift executable.
- is easy to comprehend since this is less than 100 LOCs

Why you might not want to use this:

- requires the AWS CLI, so it cannot be used in iOS, only on the
  command line (in macOS or Linux).
  

## Stability

I am setting the major version number of this library to 0 since it is
currently in development and nothing about it should be treated as stable.

Really, if you want to use it, it's simple and small enough that it
might be more prudent just to copy/paste the code into your project!


  
  
