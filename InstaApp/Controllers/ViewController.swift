//
//  ViewController.swift
//  InstaApp
//
//  Created by Veldanov, Anton on 5/2/20.
//  Copyright © 2020 Anton Veldanov. All rights reserved.
//

import UIKit
import AWSAppSync
import AWSMobileClient






class ViewController: UIViewController{
  
  //Reference AppSync client
  var appSyncClient: AWSAppSyncClient?
  var signUpModeActive = true
  
  
  
  @IBOutlet weak var emailTextField: UITextField!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var verifyCodeTextField: UITextField!
  
  
  @IBOutlet weak var signUpOrLoginButton: UIButton!
  
  @IBOutlet weak var switchSignupLoginButton: UIButton!
  
  
  @IBOutlet weak var verifyButtonOutlet: UIButton!
  

  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appSyncClient = appDelegate.appSyncClient
    
    
    //    AWSMobileClient.default().showSignIn(
    //        navigationController: self.navigationController!, { (signInState, error) in
    //        if let signInState = signInState {
    //            print("Sign in flow completed: \(signInState)")
    //        } else if let error = error {
    //            print("error logging in: \(error.localizedDescription)")
    //        }
    //    })
    
    //    print(whoIsSignedIn())
    //        signOut()
    
    //    signUpUser()
    //    verifyUser()
    
    //    stateTracking()
    
    //    signInUser()
    
    //    deleteUser()
    
    
//    runUserList()
//     print(runQuery())
    
    
    //      addMutation()
    //    deleteMutation()
    
    //    updateMutation()
    //    getQuery()
    
    //    deleteMutation(id: "bdee805d-939c-4d67-8cc5-690c277fdf3d")
    
    
  }
  
  
    
  
  override func viewDidAppear(_ animated: Bool) {
    
    
    if whoIsSignedIn() != ""{
      print("There is a signedIn user")
      self.performSegue(withIdentifier: "showUserTable", sender: self)


    }
    

    navigationController?.navigationBar.isHidden = true
    
    
  }
  
  
  
  
  
  @IBAction func signUpLoginButtonPressed(_ sender: UIButton) {
    
    
    if emailTextField.text == "" || passwordTextField.text == ""{
      
      displayAlert(title: "Error in the form", message: "Fill in email and password")
    }else{
      if signUpModeActive{
        print("Signing up...")
        
        signUpUser(username: emailTextField.text!, password: passwordTextField.text!)
        
        self.performSegue(withIdentifier: "showUserTable", sender: self)
      }else{
        
        
        signInUser(username: emailTextField.text!, password: passwordTextField.text!)
        self.performSegue(withIdentifier: "showUserTable", sender: self)

        
      }
      
    }
    
    
    
    
    
  }
  
  
  @IBAction func switchLoginModeButtonPressed(_ sender: UIButton) {
    
    if signUpModeActive{
      signUpModeActive = false
      
      signUpOrLoginButton.setTitle("Login", for: .normal)
      
      switchSignupLoginButton.setTitle("SignUp", for: .normal)
      verifyCodeTextField.isHidden = true
      verifyButtonOutlet.isHidden = true
      signOutUser()
    }else{
      signUpModeActive = true
      signUpOrLoginButton.setTitle("SignUp", for: .normal)
      
      switchSignupLoginButton.setTitle("Login", for: .normal)
      
      verifyCodeTextField.isHidden = false
      verifyButtonOutlet.isHidden = false
      
      signOutUser()
    }
  }
  
  
  
  
  @IBAction func verifyButtonPressed(_ sender: UIButton) {
    
    verifyUser(username: emailTextField.text!, confirmationCode: verifyCodeTextField.text!)
    
    
  }
  
  
  
  
}










extension ViewController{
  
  
  func addMutation(){
    
    let userid = whoIsSignedIn()
    
    let mutationInput = CreateTodoInput(name: "JOHNNY", description: "NEW", userid: userid)
    //    let mutationInput = CreateTodoInput(name: "Anton3: ", description:"Desc3")
    appSyncClient?.perform(mutation: CreateTodoMutation(input: mutationInput)) { (result, error) in
      if let error = error as? AWSAppSyncClientError {
        print("Error occurred: \(error.localizedDescription )")
      }
      if let resultError = result?.errors {
        print("Error saving the item on server: \(resultError)")
        return
      }
      self.runQuery()
      print("Mutation complete.")
    }
  }
  
  func deleteMutation(id: GraphQLID){
    let mutationInput = DeleteTodoInput(id: id)
    appSyncClient?.perform(mutation: DeleteTodoMutation(input: mutationInput)) { (result, error) in
      if let error = error as? AWSAppSyncClientError {
        print("Error occurred: \(error.localizedDescription )")
      }
      if let resultError = result?.errors {
        print("Error saving the item on server: \(resultError)")
        return
      }
      self.runQuery()
      print("Mutation complete.")
    }
  }
  
  func updateMutation(){
    let mutationInput = UpdateTodoInput(id: "7fc34130-a019-4504-b232-f98138f9b2ae", name: "Ivan: ", description: "odd")
    appSyncClient?.perform(mutation: UpdateTodoMutation(input: mutationInput)) { (result, error) in
      if let error = error as? AWSAppSyncClientError {
        print("Error occurred: \(error.localizedDescription )")
      }
      if let resultError = result?.errors {
        print("Error saving the item on server: \(resultError)")
        return
      }
      self.runQuery()
      print("Mutation complete.")
    }
  }
  
  func runQuery(){
    appSyncClient?.fetch(query: ListTodosQuery(), cachePolicy: .returnCacheDataAndFetch) {(result, error) in
      if error != nil {
        print(error?.localizedDescription ?? "")
        return
      }
      
      print("Query complete!")
      //        print(result?.data?.listTodos?.items)
      result?.data?.listTodos?.items!.forEach { print(($0?.name)! + " " + ($0?.description)!)}
    }
  }
  
  func getQuery(){
    do{
      try appSyncClient?.clearCaches();
      
    }catch{
      print(error)
    }
    appSyncClient?.fetch(query: GetTodoQuery(id: "7fc34130-a019-4504-b232-f98138f9b2ae"), cachePolicy: .returnCacheDataAndFetch) {(result, error) in
      if error != nil {
        print(error?.localizedDescription ?? "")
        return
      }
      
      print("Query complete!")
      print(result?.data?.getTodo!)
      
      //      result?.data?.listTodos?.items!.forEach { print(($0?.name)! + " " + ($0?.description)!)}
      
      
    }
    
    
    
  }
  
  func stateTracking(){
    
    AWSMobileClient.default().addUserStateListener(self) { (currentState, info) in
      
      switch (currentState) {
        
      case .guest:
        print("user is in guest mode.")
      case .signedOut:
        print("user signed out")
      case .signedIn:
        print("user is signed in.")
      case .signedOutUserPoolsTokenInvalid:
        print("need to login again.")
      case .signedOutFederatedTokensInvalid:
        print("user logged in via federation, but currently needs new tokens")
      default:
        print("unsupported")
      }
    }
    
    
  }
  
  func signUpUser(username: String, password:String){
    //    "Abc@123!"
    
    
    AWSMobileClient.default().signUp(username: username,
                                     password:password ) { (signUpResult, error) in
                                      
                                      print(signUpResult)
                                      if let signUpResult = signUpResult {
                                        print("RESULT:",signUpResult)
                                        switch(signUpResult.signUpConfirmationState) {
                                        case .confirmed:
                                          print("User is signed up and confirmed.")
                                        case .unconfirmed:
                                          print("User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")
                                        case .unknown:
                                          print("Unexpected case")
                                        }
                                      } else if let error = error {
                                        print("RESULT:",signUpResult)
                                        
                                        if let error = error as? AWSMobileClientError {
                                          switch(error) {
                                          case .usernameExists(let message):
                                            print(message)
                                          default:
                                            break
                                          }
                                        }
                                        print("\(error.localizedDescription)")
                                      }
    }
  }
  
  func verifyUser(username: String, confirmationCode:String){
    
    
    AWSMobileClient.default().confirmSignUp(username: username, confirmationCode: confirmationCode) { (signUpResult, error) in
      //      print("RESULT!!!", signUpResult?.signUpConfirmationState.self)
      
      if signUpResult?.signUpConfirmationState == .confirmed{
        print("confirmedYO")
        DispatchQueue.main.async {
          self.displayAlert(title: "Bingo", message: "Your code verified")
          
        }
      }else{
        DispatchQueue.main.async {
          self.displayAlert(title: "Error", message: "Please check the code")
          
        }
        
        
      }
    }
  }
  
  func signInUser(username:String, password: String){
    
    AWSMobileClient.default().signIn(username: username, password: password) { (signInResult, error) in
      print("RESULT:",signInResult)
      if let error = error  {
        print("\(error.localizedDescription)")
      } else if let signInResult = signInResult {
        switch (signInResult.signInState) {
        case .signedIn:
          print("User is signed in.")
        case .smsMFA:
          print("SMS message sent to \(signInResult.codeDetails!.destination!)")
        default:
          print("Sign In needs info which is not et supported.")
        }
      }
    }
    
    
    
  }
  
  func checkState(){
    
    switch( AWSMobileClient.default().currentUserState) {
    case .signedIn:
      DispatchQueue.main.async {
        
        print("Logged In")
      }
    case .signedOut:
      DispatchQueue.main.async {
        print("Signed Out")
      }
    default:
      AWSMobileClient.default().signOut()
    }
  }
  
  func signOutUser(){
    
    AWSMobileClient.default().signOut()
    print("SignOut Called!")
  }
  
  func deleteUser(){
    AWSCognitoIdentityUserPool.default().currentUser()?.delete().continueWith(block: { (task) -> Any? in
      if let error = task.error {
        print("Error deleting user: \(error.localizedDescription)")
      }
      if let _ = task.result {
        print("User deleted successfully.")
      }
      return nil
    })  }
  
  func whoIsSignedIn()->String{
    
    let userid = AWSCognitoIdentityUserPool.default().currentUser()?.username ?? ""
    
    
    
    return userid
  }
  
  
  func displayAlert(title: String, message:String){
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
      self.dismiss(animated: true, completion: nil)
    }))
    
    present(alert, animated: true, completion: nil)
    
    
  }
  
  
  

  
  
}

