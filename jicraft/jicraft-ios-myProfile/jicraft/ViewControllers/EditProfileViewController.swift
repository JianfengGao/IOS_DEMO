//
//  EditProfileViewController.swift
//  jicraft
//
//  Created by JERRY LIU on 19/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation
import AssetsLibrary


struct JicraftEditProfile {
    static let logoUploadJpegRatio = 0.9
    static let logoUploadResize = "200x200#"
}

class EditString {
    var field = String()
    var string = String()
    init(field: String, string: String) {
        self.field = field
        self.string = string
    }
}

class EditProfileViewController: UITableViewController {
    
    var logoImage: UIImage? // for encoding to multipart upload
    var profile = Profile()
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var about: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var tel: UITextField!
    @IBOutlet var wechat: UITextField!
    @IBOutlet var weibo: UITextField!
    @IBOutlet var address: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var qq: UITextField!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
//   //save about
    @IBAction func saveAbout(segue:UIStoryboardSegue) {
        if segue.identifier == "saveAbout" {
            if segue.sourceViewController.isKindOfClass(BrandInfoEditViewController) {
                var brandVC = segue.sourceViewController as BrandInfoEditViewController
                self.about.text  = brandVC.about
            }
            println("\(segue.sourceViewController):\(segue.destinationViewController)")
        }
    }
    @IBAction func cancelAbout(segue:UIStoryboardSegue) {
        //do nothing
    }
    override func viewDidLoad() {
        self.setUIData()
        self.setTableViewAppearence()
    }
    func setTableViewAppearence() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    func setUIData() {
        self.logoImageView.sd_setImageWithURL(NSURL.URLWithString(self.profile.logoUrl), placeholderImage:UIImage(named: "empty-profile"))
        self.about.text = self.profile.about
        self.name.text = self.profile.name
        self.tel.text = self.profile.tel
        self.wechat.text = self.profile.wechat
        self.weibo.text = self.profile.weibo
        self.address.text = self.profile.address
        self.email.text = self.profile.email
        self.qq.text = self.profile.qq
    }
    
    // MARK: logo photo
   func pickPhoto() {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        imagePicker.mediaTypes = [String(kUTTypeImage)]
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    //upload profile
    @IBAction func uploadLogo(sender: AnyObject) {
        
        if self.profile.name == "" {
            UIAlertView(title: nil, message: "储存失败，用户名不能为空", delegate: self, cancelButtonTitle: "知道了").show()
            return
        }
        
        LoginManager.defaultManager.checkForLogin(self, onSuccess: {(username: String) -> Void in
            
            // encode UIImage to NSData
            var logoImageData = UIImageJPEGRepresentation(self.logoImage, CGFloat(JicraftEditProfile.logoUploadJpegRatio))
            
            // start spinner
            
            
            // upload with LoginManager
            LoginManager.defaultManager.patchProfileLogo(logoImage: logoImageData,
                onSuccess: {(responseObject: AnyObject) -> Void in
                    
                    // end spinner
                }, onFailure: {(error: NSError) -> Void in
                    
                    
                    // UIAlertView
                    
                    // end spinner
            })
           
          
            
        })
    }
    
    // MARK: segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "shortEdit") {
            var inputVC = segue.destinationViewController as ShortInputViewController
            inputVC.delegate = self
            
            let editString = sender as EditString
            inputVC.text = editString.string
            inputVC.editingField = editString.field
            
            switch editString.field {
            case "name":
                inputVC.tipText = " "
            case "tel":
                inputVC.tipText = " "
            case "email":
                inputVC.tipText = "邮箱: hello@me.com"
            case "address":
                inputVC.tipText = " "
            case "weibo":
                inputVC.tipText = " "
            case "wechat":
                inputVC.tipText = " "
            case "qq":
                inputVC.tipText = " "
            default:
                break
            }

        }
    }
  
}
// MARK: UItableViewdelegate
extension EditProfileViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                // pick photo
                self.pickPhoto()
                
            } else if(indexPath.row == 1) {
                self.performSegueWithIdentifier("shortEdit", sender: EditString(field: "name", string: self.profile.name))
            } else {
                self.performSegueWithIdentifier("brandInfoEdit", sender: nil)
            }
        } else {
            // short edit
            let editStrings: [EditString]  =
                [
                    EditString(field: "tel", string: self.profile.tel),
                    EditString(field: "email", string: self.profile.email),
                    EditString(field: "address", string: self.profile.address),
                    EditString(field: "weibo", string: self.profile.weibo),
                    EditString(field: "wechat", string: self.profile.wechat),
                    EditString(field: "qq", string: self.profile.qq)]
            
            let editString = editStrings[indexPath.row]
            self.performSegueWithIdentifier("shortEdit", sender: editString)
        }

    }
    func displayActionView(viewShowActionSheet:UIView) {
        var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "从相册选择",otherButtonTitles: "拍照")
       actionSheet.showFromRect(CGRectMake(0, 0, 80, 80), inView: viewShowActionSheet, animated: true)
        
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        tableView.tableHeaderView?.layer.borderColor = UIColor(red: 255/255, green: 153/255, blue: 0, alpha: 1).CGColor
        tableView.tableHeaderView?.layer.borderWidth = 1.0
        if section == 0 {
            return 0
        }
        return 10
    }
}
//MARK: UIActionSheetDelegate 
extension EditProfileViewController:UIActionSheetDelegate {
    
}
// MARK: UIImagePickerControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
            
            let pickedImage: UIImage = info[UIImagePickerControllerEditedImage] as UIImage
            self.logoImage = pickedImage.resizedImageByMagick(JicraftEditProfile.logoUploadResize)
            
            self.logoImageView.image = self.logoImage
            picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

// MARK: ShortInputViewControllerDelegate
extension EditProfileViewController: ShortInputViewControllerDelegate {
    func shortInputViewControllerDidDismiss(sender: AnyObject) {
        //do nothing
    }
    
    func shortInputViewControllerDidDone(text: String, field: String) {
        switch field {
            case "name":
                self.profile.name = text
            
            case "tel":
                self.profile.tel = text
            
            case "email":
                self.profile.email = text
            
            case "address":
                self.profile.address = text
            
            case "weibo":
                self.profile.weibo = text
            
            case "wechat":
                self.profile.wechat = text
            
            case "qq":
                self.profile.qq = text
        
            default:
                break
        }
        
        self.setUIData() // refresh
        
    }
}
