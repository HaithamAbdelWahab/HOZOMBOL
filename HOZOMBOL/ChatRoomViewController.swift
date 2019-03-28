//
//  ChatRoomViewController.swift
//  HOZOMBOL
//
//  Created by Haitham Abdel Wahab on 3/14/19.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    
    
    

    @IBOutlet weak var chatTF: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    var room:Room?
    
    
    var chatMessages = [Message]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.separatorStyle = .none
        chatTableView.allowsSelection = false
        observeMessages()
        


        title = room?.roomName
        
        

    }
    
    
    func observeMessages() {
        guard let roomId = self.room?.roomId else {
            return
        }
        let databaseRef = Database.database().reference()
        databaseRef.child("rooms").child(roomId).child("message").observe(.childAdded) { (snapshot) in
        print(snapshot)

            if  let dataArray = snapshot.value as? [String: Any] {
                guard let senderName = dataArray["senderName"] as? String, let messageText = dataArray["text"] as? String, let userId = dataArray["senderId"] as? String else {
                    return
                }
                
                let message = Message.init(messageKey: snapshot.key, senderName: senderName, messageText: messageText, userId: userId)
                self.chatMessages.append(message)
                self.chatTableView.reloadData()

                
            }
            

            
            

        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = self.chatMessages[indexPath.row]
        
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "chatCell") as! ChatCell
        cell.setMessageData(message: message)
        
        if(message.userId == Auth.auth().currentUser!.uid) {
            cell.setBubbleType(type: .outgoing)
            
        }else {
            cell.setBubbleType(type: .incoming)
        }
        

        
        return cell
   }
    
    
    func getUsernameWithId(id: String, completion: @escaping (_ userName: String?) -> ()) {
     
        
        
        let databaseRef = Database.database().reference()
        let user = databaseRef.child("users").child(id  )
        user.child("username").observeSingleEvent(of: .value) { (snapshot) in
            if let userName = snapshot.value as? String {
                completion(userName)
            }else {
                completion(nil)
            }
        }
    }
    func sendMessage(text: String, completion: @escaping (_ isSuccess: Bool) -> () ) {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let databaseRef = Database.database().reference()
        getUsernameWithId(id: userId) { (userName) in

            
            if let userName = userName  {
                
                if let roomId = self.room?.roomId, let userId = Auth.auth().currentUser?.uid  {
                    
                    
                    let dataArray: [String: Any] = ["senderName": userName, "text": text, "senderId": userId]
                    
                    let room =  databaseRef.child("rooms").child(roomId)
                    room.child("message").childByAutoId().setValue(dataArray, withCompletionBlock: { (error, ref) in
                        if(error == nil) {
                            completion(true)
                        }else {
                            completion(false)
                        }
                    })
                }
            }

            
        
        }
        
    }
    
    
    @IBAction func didPressSendBtn(_ sender: UIButton) {
       
        guard let chatText = self.chatTF.text , chatText.isEmpty == false  else {
            return
        }
        sendMessage(text: chatText) { (isSuccess) in
            if(isSuccess) {
                print("message sent")
                self.chatTF.text = ""
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}

