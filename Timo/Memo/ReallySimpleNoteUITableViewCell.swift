//
//  ReallySimpleNoteUITableViewCell.swift
//  Timo
//
//  Created by Prince Alvin Yusuf on 02/04/20.
//  Copyright © 2020 sambalpete. All rights reserved.
//

import UIKit

class ReallySimpleNoteUITableViewCell : UITableViewCell {
    private(set) var noteTitle : String = ""
    private(set) var noteText  : String = ""
    private(set) var noteDate  : String = ""
 
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteTextLabel: UILabel!
    @IBOutlet weak var noteDateLabel: UILabel!
}
