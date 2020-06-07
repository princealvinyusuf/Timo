//
//  CurhatCommentViewController.swift
//  Timo
//
//  Created by Prince Alvin Yusuf on 30/03/20.
//  Copyright © 2020 sambalpete. All rights reserved.
//

import UIKit
import FirebaseFirestore

class CurcolCommentViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewCurhatComments: UITableView!
    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var txtNickname: UILabel!
    @IBOutlet weak var txtFeeling: UILabel!
    @IBOutlet weak var txtTitleEmpty: UILabel!
    @IBOutlet weak var viewEmpty: UIView!
    
    var curhat = Curcol()
    var curhatComments = [CurcolComment]()
    
    var db: Firestore?
    var curhatReference: CollectionReference?
    var curhatCommentsReference: CollectionReference?
    var curhatCommentsListerner: ListenerRegistration?
    
    deinit {
        curhatCommentsListerner?.remove()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil);
        
        self.hideKeyboardWhenTappedAround()
        
        self.tabBarController?.tabBar.isHidden = true

        self.tableViewCurhatComments.delegate = self
        self.tableViewCurhatComments.dataSource = self

        self.txtComment.delegate = self
        self.txtComment.becomeFirstResponder()

        self.txtNickname.text = self.curhat.nickname
        self.txtFeeling.text = self.curhat.feeling
        
        self.txtTitleEmpty.font = UIFont(name: "Nunito-Bold", size: 24.0) ?? UIFont.boldSystemFont(ofSize: 24.0)
        
        if NICKNAME?.isEmpty ?? true {
            changeNickname()
        }

        self.db = Firestore.firestore()
        self.curhatReference = db?.collection(CollectionPath.curhats)
        
        self.curhatCommentsReference = db?.collection([CollectionPath.curhats, self.curhat.id!, CollectionPath.comments].joined(separator: "/"))
        self.curhatCommentsListerner = curhatCommentsReference?.addSnapshotListener({ (querySnapshot, error) in
            guard let snapshot = querySnapshot else {return}
            
            self.viewEmpty.isHidden = snapshot.count > 0 ? true : false

            snapshot.documentChanges.forEach({ (documentChange) in
                guard let curhatComment = CurcolComment(document: documentChange.document) else {return}
            
                self.curhatReference?.document(self.curhat.id!).updateData([CollectionPath.comments : snapshot.count])
                
                switch documentChange.type {
                case .added:
                    self.addList(curhatComment)
                    
                case .modified:
                    self.updateList(curhatComment)
                    
                case .removed:
                    self.removeList(curhatComment)
                }
            })
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func btnSendClicked(_ sender: Any) {
        self.postComment()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.postComment()
        return true
    }

    func postComment() {
        if NICKNAME?.isEmpty ?? true {
            changeNickname()
            return
        }
        
        guard let comment = txtComment.text, txtComment.text != "" else {return}
        
        let docData: [String : Any] = [
            "nickname" : NICKNAME!,
            "comment" : comment,
            "sendDate" : Date()
        ]
        
        self.dismissKeyboard()
        self.txtComment.text = ""
        self.curhatReference?.document(self.curhat.id!).collection(CollectionPath.comments).addDocument(data: docData)
    }
    
    func addList(_ curhatComment: CurcolComment) {
        guard !self.curhatComments.contains(curhatComment) else {return}
        
        self.curhatComments.append(curhatComment)
        self.curhatComments.sort()
        
        guard let index = curhatComments.firstIndex(of: curhatComment) else {return}
        
        tableViewCurhatComments.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func updateList(_ curhatComment: CurcolComment) {
        guard let index = curhatComments.firstIndex(of: curhatComment) else {return}
        
        curhatComments[index] = curhatComment
        tableViewCurhatComments.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func removeList(_ curhatComment: CurcolComment) {
        guard let index = curhatComments.firstIndex(of: curhatComment) else {return}
        
        curhatComments.remove(at: index)
        tableViewCurhatComments.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.bottomConstraint.constant = -(keyboardFrame.size.height - 34)
        })
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.bottomConstraint.constant = 0
        })
    }
}

extension CurcolCommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curhatComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewCurhatComments.dequeueReusableCell(withIdentifier: CellIdentifier.CurhatComment, for: indexPath) as! CurcolCommentTableViewCell
        
        cell.txtNickname.text = curhatComments[indexPath.row].nickname
        cell.txtComment.text = curhatComments[indexPath.row].comment
        
        return cell
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
