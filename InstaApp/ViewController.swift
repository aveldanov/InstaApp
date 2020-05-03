//
//  ViewController.swift
//  InstaApp
//
//  Created by Veldanov, Anton on 5/2/20.
//  Copyright © 2020 Anton Veldanov. All rights reserved.
//

import UIKit
import AWSAppSync

class ViewController: UIViewController {

  //Reference AppSync client
  var appSyncClient: AWSAppSyncClient?

  override func viewDidLoad() {
      super.viewDidLoad()
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      appSyncClient = appDelegate.appSyncClient
    
    
    
    
    
 runQuery()
    
    
//    runMutation()
  }


}


extension ViewController{
  
  func runMutation(){
      let mutationInput = CreateTodoInput(name: "Anton: ", description:"Desc")
      appSyncClient?.perform(mutation: CreateTodoMutation(input: mutationInput)) { (result, error) in
          if let error = error as? AWSAppSyncClientError {
              print("Error occurred: \(error.localizedDescription )")
          }
          if let resultError = result?.errors {
              print("Error saving the item on server: \(resultError)")
              return
          }
          print("Mutation complete.")
      }
  }
  
  func runQuery(){
      appSyncClient?.fetch(query: ListTodosQuery(), cachePolicy: .returnCacheDataAndFetch) {(result, error) in
          if error != nil {
              print(error?.localizedDescription ?? "")
              return
          }
          print("Query complete.")
          result?.data?.listTodos?.items!.forEach { print(($0?.name)! + " " + ($0?.description)!) }
      }
  }
  
  
  
}

