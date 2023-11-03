//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore()
    var messages: [Message] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        title = K.appname
        loadMessage()
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    func loadMessage() {
        
        db.collection(K.FStore.collectionName).getDocuments() { (querySnapshot, err) in
          if let err = err {
            print("Error getting documents: \(err)")
          } else {
            for document in querySnapshot!.documents {
                if  let messageSender = document.data()[K.FStore.senderField] as? String, let messageBody = document.data()[K.FStore.bodyField] as? String {
                    let newMessage = Message(sender: messageSender, body: messageBody)
                    self.messages.append(newMessage)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            }
          }
        }

    }
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageSender = Auth.auth().currentUser?.email, let messageBody = messageTextfield.text  {
          // User is signed in.
            var ref: DocumentReference? = nil
            ref = db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody
            ]) { err in
              if let err = err {
                print("Error adding document: \(err)")
              } else {
                print("Document added with ID: \(ref!.documentID)")
              }
            }
        } else {
          // No user is signed in.
          // ...
        }
    }
    

    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}
extension ChatViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label?.text = messages[indexPath.row].body
        return cell
    }
    
    
    
}
