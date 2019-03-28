//
//  ChatCell.swift
//  HOZOMBOL
//
//  Created by Haitham Abdel Wahab on 3/17/19.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    enum mbubbleType {
        case incoming
        case outgoing
    }

    @IBOutlet weak var chatTextBubble: UIView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var chatStackView: UIStackView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chatTextBubble.layer.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setBubbleType (type: mbubbleType) {
        if(type == .incoming) {
            
            chatStackView.alignment = .leading
            chatTextBubble.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
            chatTextView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else if (type == .outgoing){
            chatStackView.alignment = .trailing
            chatTextBubble.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            chatTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
    }

    func setMessageData(message: Message)
    {
        userNameLbl.text = message.senderName
        chatTextView.text = message.messageText
    }}
