// swiftlint:disable all
import Amplify
import Foundation

public struct Todo: Model {
  public let id: String
  public var name: String
  public var description: String?
  public var userid: String?
  
  public init(id: String = UUID().uuidString,
      name: String,
      description: String? = nil,
      userid: String? = nil) {
      self.id = id
      self.name = name
      self.description = description
      self.userid = userid
  }
}