//
//  Ticket.swift
//  TicketMemory
//
//  Created by Kazuma Shinomiya on 2021/01/31.
//

import Foundation
import UIKit
import RealmSwift

class Ticket:Object{
    @objc dynamic var name = ""
    @objc dynamic var adress = ""
    @objc dynamic var selectedDate = ""
    @objc dynamic var imageURL = ""
    
}


