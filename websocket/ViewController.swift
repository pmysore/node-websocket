//
//  ViewController.swift
//  websocket
//
//  Created by Pradeep Mysore on 2/11/19.
//  Copyright © 2019 Lilly. All rights reserved.
//

import UIKit
import Starscream

class ViewController: UIViewController, WebSocketDelegate {
    var socket: WebSocket!
    var counter: Int = 0
    
    
    @IBOutlet weak var labelText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        labelText.text = ""
        var request = URLRequest(url: URL(string: "wss://ct2-dev.lilly.com/websocket")!)
        request.timeoutInterval = 5
        request.setValue("ct2-dev.lilly.com", forHTTPHeaderField: "host")
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    // MARK: Websocket Delegate Methods.
    
    func websocketDidConnect(socket: WebSocketClient) {
        labelText.text = (labelText.text ?? "") + "\n" + "websocket is connected"
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let e = error as? WSError {
            labelText.text = (labelText.text ?? "")  + "\n" + "websocket is disconnected: \(e.message)"
        } else if let e = error {
            labelText.text = (labelText.text ?? "") + "\n" + "websocket is disconnected: \(e.localizedDescription)"
        } else {
            labelText.text = (labelText.text ?? "") + "\n" + "websocket disconnected"
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        labelText.text = (labelText.text ?? "") + "\n" + "Received text: \(text)"
        counter = counter + 1
        labelText.text = (labelText.text ?? "") + "\n" + "Message count till now: \(counter)"
        
        let range = NSMakeRange(labelText.text.count - 1, 0)
        labelText.scrollRangeToVisible(range)

    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        labelText.text = (labelText.text ?? "") + "\n" + "Received data: \(data.count)"
    }
    
    // MARK: Write Text Action
    
    @IBAction func writeText(_ sender: UIBarButtonItem) {
        socket.write(string: "hello there!")
    }
    
    // MARK: Disconnect Action
    
    @IBAction func disconnect(_ sender: UIBarButtonItem) {
        if socket.isConnected {
            sender.title = "Connect"
            socket.disconnect()
        } else {
            sender.title = "Disconnect"
            socket.connect()
        }
    }
    
}

