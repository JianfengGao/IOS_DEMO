//
//  Photo.swift
//  jicraft
//
//  Created by JERRY LIU on 7/8/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation
import AssetsLibrary

struct JicraftPhoto {
    static let albumName: String = "jicraft-test"
}

class Photo:NSObject {
    
    // singleton library
    class var defaultAssetsLibrary : ALAssetsLibrary {
        struct Static {
            static let library : ALAssetsLibrary =  ALAssetsLibrary()
        }
        return Static.library
    }
    
    class func loadAlbum(albumName: String, successBlock: (loadedAsset : AnyObject!) -> Void) -> Void {
        
        var assets: [AnyObject] = []
        var _tmpAssets: [AnyObject] = []
        
        let assetsLib: ALAssetsLibrary = Photo.defaultAssetsLibrary
        // ALAssetsGroup!, UnsafeMutablePointer<ObjCBool>
        let enumGroupBlock: ALAssetsLibraryGroupsEnumerationResultsBlock = {(assetsGroup: ALAssetsGroup!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            if (assetsGroup != nil) {
                // run only target album
                let thisAlbumName = assetsGroup.valueForProperty(ALAssetsGroupPropertyName) as String
                if (albumName == thisAlbumName) {
                    assetsGroup.enumerateAssetsUsingBlock(
                        {(asset: ALAsset!,
                            index: Int,
                            stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                            
                            if (asset != nil) {
//                                _tmpAssets.append(asset)
                                // done
//                                assets = _tmpAssets
                                successBlock(loadedAsset: asset)
                            }
                        })
                }
            }
        }
        
        let enumFail: ALAssetsLibraryAccessFailureBlock = {(error: NSError!) -> () in
            println("[PhotoPicker] loadAlbum error: \(error)")
        }
        
        assetsLib.enumerateGroupsWithTypes(ALAssetsGroupType(ALAssetsGroupAlbum), usingBlock: enumGroupBlock, failureBlock: enumFail)
    }
    
    class func imagesFromAssets(assets: Array<ALAsset>) -> Array<UIImage> {
        var a : [UIImage] = []
        
        for asset in assets {
            if let obj : AnyObject? = asset.valueForProperty(ALAssetPropertyType) {
                continue
            }
//            if (obj == nil) {continue}
            
            let assetRep : ALAssetRepresentation = asset.defaultRepresentation()
            let imgRef : CGImageRef = assetRep.fullScreenImage().takeUnretainedValue()
            
            let img : UIImage = UIImage(CGImage: imgRef)
            a.append(img)
        }
        return a
    }
  
    class func createOrFetchAlbum(albumName: String,
            successBlock: (group: ALAssetsGroup!) -> Void,
            failureBlock: (error: NSError!) -> Void) {
        
        let assetsLib: ALAssetsLibrary = Photo.defaultAssetsLibrary
        
        let addGroup: ALAssetsLibraryGroupResultBlock = {(newGroup: ALAssetsGroup!) -> Void in
            if ((newGroup) != nil) {
                println("[Photo createAlbum] album created: \(newGroup.valueForProperty(ALAssetsGroupPropertyName))")
                successBlock(group: newGroup)
            } else {
                // fetch group
                let enumGroupBlock: ALAssetsLibraryGroupsEnumerationResultsBlock = {(foundGroup: ALAssetsGroup!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                    
                    if (foundGroup != nil) {
                        let thisAlbumName = foundGroup.valueForProperty(ALAssetsGroupPropertyName) as String
                        if (thisAlbumName == albumName) {
                            println("[Photo createAlbum] album found: \(foundGroup)")
                            successBlock(group: foundGroup)
                        }
                    }
                    
                    
                }
                
                let enumFail: ALAssetsLibraryAccessFailureBlock = {(error: NSError!) -> () in
                    println("[Photo createAlbum] album exists but acess denied: \(error)")
                    failureBlock(error: error)
                }
                
                assetsLib.enumerateGroupsWithTypes(ALAssetsGroupType(ALAssetsGroupAlbum), usingBlock: enumGroupBlock, failureBlock: enumFail)
            }
            
        }
        
        let addGroupFailed: ALAssetsLibraryAccessFailureBlock = {(error: NSError!) -> Void in
            println("[Photo createAlbum] album failed to create - access denied...")
            failureBlock(error: error)
        }
        assetsLib.addAssetsGroupAlbumWithName(albumName, resultBlock: addGroup, failureBlock: addGroupFailed)
    }
    
    
    
    class func saveImageToAlbum(albumName: String, image: UIImage,
        successBlock: (asset: ALAsset!) -> Void,
        failureBlock: (error: NSError!) -> Void) {
        
        
        let assetsLib: ALAssetsLibrary = Photo.defaultAssetsLibrary
        let imgRef: CGImageRef = image.CGImage
            
        let writeImageCompletionBlock: ALAssetsLibraryWriteImageCompletionBlock = {
            (assetUrl: NSURL!, error: NSError!) -> Void in
            
            if(error == nil) {
                println("[Photo saveImageToAlbum] image write OK: \(assetUrl)")
                
                let assetResultBlock: ALAssetsLibraryAssetForURLResultBlock = {
                    (asset: ALAsset!) -> Void in
                    
                    let addGroup: (ALAssetsGroup!) -> Void = {(group: ALAssetsGroup!) -> Void in
                        println("[Photo saveImageToAlbum] addGroup block, album: \(group)")
                        println("[Photo saveImageToAlbum] addGroup block, asset: \(asset)")
                        
                        group.addAsset(asset)
                        println("[Photo saveImageToAlbum added asset: \(asset.valueForProperty(ALAssetPropertyURLs)) to album: \(group.valueForProperty(ALAssetsGroupPropertyName))")
                        successBlock(asset: asset)
                    }
                    
                    // create or fetch album and add asset to group
                    self.createOrFetchAlbum(albumName, successBlock: addGroup, failureBlock: {(error: NSError!) -> Void in
                            failureBlock(error: error)
                    })

                }
                // fetch asset from assetUrl
                assetsLib.assetForURL(assetUrl, resultBlock: assetResultBlock,
                    failureBlock: {(error: NSError!) -> Void in
                        
                        println("[Photo saveImageToAlbum] failed to fetch asset: \(error)")
                        failureBlock(error: error)
                        
                    })
            } else {
                print("[Photo saveImageToAlbum] failed to write image")
                failureBlock(error: error)
            }
        }
            
        // save image to asset library
        assetsLib.writeImageToSavedPhotosAlbum(imgRef, orientation: ALAssetOrientation.Up, completionBlock: writeImageCompletionBlock)
            
    }

    
}
