/*
 Copyright (c) 2017-present, salesforce.com, inc. All rights reserved.
 
 Redistribution and use of this software in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of
 conditions and the following disclaimer in the documentation and/or other materials provided
 with the distribution.
 * Neither the name of salesforce.com, inc. nor the names of its contributors may be used to
 endorse or promote products derived from this software without specific prior written
 permission of salesforce.com, inc.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import SalesforceSDKCore
class PermissionsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SFSDKUserSelectionView{
 
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "mycell"
    
    var userList: [SFUserAccount] = []
    var userSelectionDelegate :SFSDKUserSelectionViewDelegate?
    
    var spAppOptions: [AnyHashable : Any]!
    @IBOutlet weak var infoTextView: UITextView!
    
    @IBAction func addUserAction(_ sender: Any) {
       userSelectionDelegate?.createNewUser(self.spAppOptions)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        userSelectionDelegate?.cancel(self.spAppOptions)
    }
    var gradientLayer: CAGradientLayer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginHost = spAppOptions["login_host"]
        if let host  = loginHost {
            userList = SFUserAccountManager.sharedInstance().userAccounts(forDomain: host as! String) as! [SFUserAccount];
        } else {
            userList = SFUserAccountManager.sharedInstance().allUserAccounts()!
        }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 80
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0.439, blue: 0.824, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        self.title = "Login as"
        var appName:String = ""
        if (spAppOptions.index(forKey:"app_name") != nil) {
            appName = spAppOptions["app_name"] as! String
        }
        self.infoTextView.attributedText = self.getAttributedText(appName: appName)
        self.infoTextView.textAlignment = .center
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "UserTableViewCell", bundle: bundle)
        self.tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    
        self.view.addSubview(self.tableView)
        // Do any additional setup after loading the view.
    }
    
    /*
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
        //createGradientLayer();
        
        let topColor = UIColor(red: 69/255, green: 140/255, blue: 68/255, alpha: 1).cgColor
        let bottomColor = UIColor(red: 143/255, green: 239/255, blue: 141/255, alpha: 1).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.frame
        gradientLayer.colors = [topColor,bottomColor]
        gradientLayer.locations = [0.1,1.0]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }*/
    
   /*
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
        gradientLayer.insertSublayer(<#T##layer: CALayer##CALayer#>, at: 0)
        
        self.view.layer.addSublayer(gradientLayer)
    }
 */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.userList.count)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let result = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)  as! UserTableViewCell
        result.currentUserImage.isHidden = true;
        result.user = userList[indexPath.row]
        result.userFullName.text = userList[indexPath.row].fullName
        result.email.text = userList[indexPath.row].userName
       
        let image = UIImage(named: (userList[indexPath.row].idData?.firstName?.lowercased())!)
        
        if let img = image  {
           result.userPicture.image = img
        } else {
            result.userPicture.image = UIImage(named: "placeholder")
        }
       
        return result;
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userSelectionDelegate?.selectedUser(userList[indexPath.row],spAppContext: self.spAppOptions)
    }
    
    func getAttributedText( appName:String ) ->  NSMutableAttributedString {
        let info = "Select user for \n";
    
        let plainAttribute = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
    
        let highlightAttribute = [NSAttributedStringKey.foregroundColor: UIColor.salesforceBlue(), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 24)]
     
        let partOne = NSMutableAttributedString(string: info, attributes: plainAttribute)
        let partTwo = NSMutableAttributedString(string: appName, attributes: highlightAttribute)
        
        
        
//         let partThree = NSMutableAttributedString(string: " app.", attributes: plainAttribute)
    
        let combination = NSMutableAttributedString()
    
        combination.append(partOne)
        combination.append(partTwo)
        //combination.append(partThree)
        return combination
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
   

}


