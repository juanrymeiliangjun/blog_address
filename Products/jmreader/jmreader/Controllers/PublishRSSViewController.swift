//
//  PublishRSSViewController.swift
//  jmreader
//
//  Created by meiliangjun1_vendor on 2020/10/14.
//  Copyright © 2020 meiliangjun1_vendor. All rights reserved.
//

import UIKit

class PublishRSSViewController: UIViewController {

    @IBOutlet weak var nameT: UITextField!
    @IBOutlet weak var linkTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func clickSureAction(_ sender: Any) {
        
        guard let nameString = self.nameT.text, nameString.count > 0 else {
            print("订阅主题为空\n")
            return
        }
        
        guard let linkString = self.linkTF.text, linkString.count > 0 else {
            print("订阅主题为空\n")
            return
        }
        
        // add RssInfo to DB
        // go back
        var subjects: [[String]] = UserDefaults.standard.mutableArrayValue(forKey: "subject_list_key") as! [[String]]
        
        subjects.append([nameString, linkString])
        UserDefaults.standard.set(subjects, forKey: "subject_list_key")
        UserDefaults.standard.synchronize()
        
        self.navigationController?.popViewController(animated: true)
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
