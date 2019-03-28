//
//  RoomsViewController.swift
//  HOZOMBOL
//
//  Created by Haitham Abdel Wahab on 3/12/19.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

import UIKit
import Firebase

class RoomsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
  
    
    
    @IBOutlet weak var newRoomTF: UITextField!
    
    

    
    @IBOutlet weak var roomsTableView: UITableView!
    
    var rooms = [Room]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.roomsTableView.delegate = self
self.roomsTableView.dataSource = self

        observeRooms()

    }
    
    func observeRooms() {
        let databaseRef = Database.database().reference()
        databaseRef.child("rooms").observe(.childAdded) { (snapshot) in
            
            if let dataArray = snapshot.value as? [String: Any] {
                if let roomName = dataArray["roomName"] as? String {
                    let room = Room.init(roomId: snapshot.key, roomName: roomName)
                    self.rooms.append(room)
                    
                   self.roomsTableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func didPressCreateNewRoom(_ sender: UIButton) {
        
        guard let roomName = self.newRoomTF.text , roomName.isEmpty == false else {
            return
        }
        let databaseRef = Database.database().reference()
        let room = databaseRef.child("rooms").childByAutoId()
        
        let dataArray:[String: Any] = ["roomName": roomName]
        room.setValue(dataArray) { (error, ref) in
            if(error == nil) {
             self.newRoomTF.text = ""
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRoom = self.rooms[indexPath.row]
        
        let chatRoomView = self.storyboard?.instantiateViewController(withIdentifier: "chatRoom") as! ChatRoomViewController
        chatRoomView.room = selectedRoom
        self.navigationController?.pushViewController(chatRoomView, animated: true)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (Auth.auth().currentUser == nil) {
            self.presentLoginScreen()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func didPresslogout(_ sender: UIBarButtonItem) {

        try! Auth.auth().signOut()
        self.presentLoginScreen()
        
    }
    
    func presentLoginScreen() {
        
        let formScreen = self.storyboard?.instantiateViewController(withIdentifier: "LoginAndRegisterSceen") as! ViewController
        
        self.present(formScreen, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let room = self.rooms[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell")!
        cell.textLabel?.text = room.roomName
        return cell
    }
}
