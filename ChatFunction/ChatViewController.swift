//
//  ChatViewController.swift
//  ChatFunction
//
//  Created by kp_mac on 2020/07/27.
//  Copyright © 2020 kp_mac. All rights reserved.
//

import UIKit
import SocketIO
import SwiftyJSON

class ChatViewController: UIViewController {

    @IBOutlet weak var conSocket: UIButton!
    @IBOutlet weak var disConSocket: UIButton!
    @IBOutlet weak var userOneTextField: UITextField!
    @IBOutlet weak var userTwoTextField: UITextField!
    let socket = SocketConnect()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func conActionBtn(_ sender: UIButton) {
        socket.establishConnection(receivedNum: 0)
    }
    
    @IBAction func disConActionBtn(_ sender: UIButton) {
        socket.establishConnection(receivedNum: 1)
    }
    
    @IBAction func sendTextActionBtn(_ sender: UIButton) {
        socket.sendMessage(sendText: userOneTextField.text!)
        
    
    }
    
    func setUserOneText(inputData: String){

        userOneTextField?.text = inputData
        print("inputData111", inputData)
    }
    
    func setUserTwoText(inputData: String){

        userTwoTextField?.text = inputData
        print("inputData222", inputData)
    }
}

class SocketConnect:NSObject {
    var manager: SocketManager?
    var socket: SocketIOClient!
    
    override init() {
        super.init()
        self.manager = SocketManager(socketURL: URL(string: "http://106.240.247.44:4545")!, config: [ .compress])
        
    }
    
    func establishConnection(receivedNum: Int) -> Bool {
        socket = self.manager?.defaultSocket
        
        socket.on("chat message"){data, ack in
            let anyData = JSON(data)
            
            func giveDataforViewController(){
                let stringResult = anyData[0].stringValue
            }
           
        }
        
        socket.on(clientEvent: .connect){data, ack in
            print("socket connected!")
        }
        
        socket.on(clientEvent: .error){data, ack in
            print("socket error")
        }
        
        socket.on(clientEvent: .disconnect){data, ack in
            print("socket disconnect")
        }
        
        socket.on(clientEvent: .reconnect){data, ack in
            print("socket reconnect")
        }
        
        if receivedNum == 0 {
            socket.connect()
            
            return true
         }else if receivedNum == 1{
            socket.disconnect()
         }
        
        return false
    }
    
    func sendMessage(sendText: String) {
        socket.emit("chat message", sendText as SocketData)
        
    }
}

//func encodeFromJson(inputData: [String: Any]) -> Any {
//    do {
//        let jsonData = try JSONSerialization.data(withJSONObject: inputData, options: [])
//        let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
//        let temp = jsonString.data(using: .utf8)!
//        let jsonObject = try JSONSerialization.jsonObject(with: temp, options: .allowFragments)
//
//        print("jsonObject:", jsonObject)
//        return jsonObject
//
//    } catch {
//        return 0
//    }
//}

