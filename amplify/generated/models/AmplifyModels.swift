// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "4a06f5f367e628be77288ed91907a9cf"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Todo.self)
  }
}