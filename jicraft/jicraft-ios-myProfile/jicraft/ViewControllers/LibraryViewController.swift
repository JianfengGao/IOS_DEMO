//
//  LibraryViewController.swift
//  jicraft
//
//  Created by JERRY LIU on 7/8/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation
import AssetsLibrary

class LibraryViewController: UIKit.UIViewController {
    
    @IBOutlet var menuButton : UIButton!
    @IBOutlet var cameraButton : UIButton!
    
    @IBOutlet var collectionView : UICollectionView!
    
    
    var assets: [ALAsset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Photo.loadAlbum(JicraftPhoto.albumName, {(loadedAsset: AnyObject!) in
            
//            dispatch_sync(dispatch_get_main_queue(), {
//                self.addedAsset(loadedAsset as ALAsset)
//            })
            
            self.addedAsset(loadedAsset as ALAsset)
        })
    }
    
    func addedAsset(asset: ALAsset!) {
        self.assets.append(asset)
        self.collectionView.reloadData()
        println("[viewDidLoad] load album: \(self.assets.count)")
    }
    
    @IBAction func menuButtonTapped() {
        
    }
    @IBAction func cameraButtonTapped() {
        
    }
    @IBAction func addButtonTapped() {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        imagePicker.mediaTypes = [String(kUTTypeImage)]
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
//    // temp for testing
//    @IBOutlet var uploadButton : UIButton!
//    @IBAction func uploadTapped() {
//        var actionSheet = UIActionSheet(title: "上传图片", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "选择相册")
//        actionSheet.showInView(self.view)
//    }
    
    func captureCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [String(kUTTypeImage)]
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            println("[captureCamera] camera not available")
        }
    }
    
}


// MARK - UICollectionViewDelegate
extension LibraryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            var cell: UICollectionViewCell! = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell
            
            // cell for asset at indexPath
            let thisAsset: ALAsset = self.assets[indexPath.row] as ALAsset
            let imageRef: CGImageRef = thisAsset.aspectRatioThumbnail().takeUnretainedValue()
            
            let img: UIImage =  UIImage(CGImage: imageRef)!
            
            var imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.size.height))
            imageView.image = img
            
            println("collectionView cellForItemAtIndexPath: \(indexPath.row)")
            cell.addSubview(imageView)
            return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("collectionView didSelect: \(indexPath.row)")
    }
    
}

// MARK - UIImagePickerControllerDelegate
extension LibraryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
            
//            let pickedImage:UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
            let pickedImage: UIImage = info[UIImagePickerControllerEditedImage] as UIImage
            
//            let thisAsset: ALAsset = ALAsset()
            
            // save this pic to custom album
            let saveImageSuccessBlock: (asset: ALAsset!)->Void = {
                (asset: ALAsset!) -> Void in
                println("[imagePicker saveImage] success")
                self.addedAsset(asset)
                
                picker.dismissViewControllerAnimated(true, completion: nil)
            }
            let saveImageErrorBlock: (error: NSError!) -> Void = {
                (error: NSError!) -> Void in
                println("[imagePicker saveImage] error: \(error)")
                
                picker.dismissViewControllerAnimated(true, completion: nil)
            }
            
            println("[imagePicker didFinish] info: \(info), :mediaMetadata => \(info[UIImagePickerControllerMediaMetadata])")
            Photo.saveImageToAlbum(JicraftPhoto.albumName, image: pickedImage, successBlock: saveImageSuccessBlock, failureBlock: saveImageErrorBlock)
            
    }
}
