//
//  CurcolPostViewController.swift
//  Timo
//
//  Created by Prince Alvin Yusuf on 30/03/20.
//  Copyright © 2020 sambalpete. All rights reserved.
//

import UIKit
import FirebaseFirestore

class CurcolPostViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtFeeling: UITextView!
    
    let placeholderText = "Type your feeling here.."
    
    var db: Firestore?
    
    var curhatReference: CollectionReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        self.txtFeeling.delegate = self
        self.txtFeeling.text = placeholderText
        self.txtFeeling.textColor = UIColor.lightGray
        self.txtFeeling.becomeFirstResponder()

        if NICKNAME?.isEmpty ?? true {
            changeNickname()
        }
        
        let rightBarButton = UIBarButtonItem(title: "Post", style: UIBarButtonItem.Style.plain, target: self, action: #selector(postCurhat(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        self.db = Firestore.firestore()
        self.curhatReference = db?.collection(CollectionPath.curhats)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func postCurhat(_ sender:UIBarButtonItem!) {
        if NICKNAME?.isEmpty ?? true {
            changeNickname()
            return
        }

        guard let feeling = txtFeeling.text,
            txtFeeling.text != "",
            txtFeeling.text != placeholderText else {return}
        
        let docData: [String : Any] = [
            "nickname" : NICKNAME!,
            "feeling" : feeling,
            "comments" : 0,
            "sendDate" : Date()
        ]
        
        self.curhatReference?.addDocument(data: docData)
        self.navigationController?.popViewController(animated: true)
    }
}

extension CurcolPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
        }
    }
}
