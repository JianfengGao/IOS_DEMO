//
//  http_jicraft.swift
//  jicraft
//
//  Created by JERRY LIU on 23/7/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

class HttpJicraft:NSObject {
    
    let manager = AFHTTPRequestOperationManager()
    var api_url:String!
    
    override init() {
        super.init()
        
        // QA server
        api_url = "http://218.244.147.5"
        
        // JSON settings
//        manager.requestSerializer = AFJSONRequestSerializer()
//        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
//        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        manager.responseSerializer = AFJSONResponseSerializer()
    }
    
    // MARK: POST /users/sign_in/
    func postLogin(username:String, password:String,
                successBlock: (operation: AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void,
                errorBlock: (operation: AFHTTPRequestOperation!, error:NSError!) -> Void
        ) -> Void {
        
        let params = ["user":["email":username, "password":password]] as Dictionary
        let request_url = "\(self.api_url)/users/sign_in/"
        
        manager.POST(
            request_url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                println("[HttpJicraft postLogin] login OK, JSON: " + responseObject.description)
                
                successBlock(operation: operation, responseObject: responseObject)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("[HttpJicraft postLogin] Error: " + error.localizedDescription)
                
                errorBlock(operation: operation, error: error)
            })
    }
    
    // MARK: POST /users/sign_up/
    func postSignup(username:String, password:String, name:String,
        successBlock: (operation: AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void,
        errorBlock: (operation: AFHTTPRequestOperation!, error:NSError!) -> Void
        ) -> Void {
            
            let params = ["user":["email":username, "password":password], "profile":["name":name]] as Dictionary
            let request_url = "\(self.api_url)/users/"
            
            manager.POST(
                request_url,
                parameters: params,
                success: { (operation: AFHTTPRequestOperation!,
                    responseObject: AnyObject!) in
                    println("[HttpJicraft postLogin] signup OK, JSON: " + responseObject.description)
                    
                    successBlock(operation: operation, responseObject: responseObject)
                },
                failure: { (operation: AFHTTPRequestOperation!,
                    error: NSError!) in
                    println("[HttpJicraft postLogin] Error: " + error.localizedDescription)
                    
                    errorBlock(operation: operation, error: error)
            })
    }
    
    // MARK: GET /events/
    func indexEvents(successBlock: (operation: AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void,
        errorBlock: (operation: AFHTTPRequestOperation!, error:NSError!) -> Void ) -> Void {
            
            let request_url = "\(self.api_url)/events/"
            
            manager.GET(
                request_url,
                parameters: nil,
                success: { (operation: AFHTTPRequestOperation!,
                    responseObject: AnyObject!) in
//                    println("[HttpJicraft indexEvents] JSON: " + responseObject.description)
                    
                    successBlock(operation: operation, responseObject: responseObject)
                },
                failure: { (operation: AFHTTPRequestOperation!,
                    error: NSError!) in
                    println("[HttpJicraft indexEvents] Error: " + error.localizedDescription)
                    
                    errorBlock(operation: operation, error: error)
                })
    }
    
    // MARK: GET /events/:id/
    func showEvent(eventId:String, successBlock: (operation: AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void,
        errorBlock: (operation: AFHTTPRequestOperation!, error:NSError!) -> Void ) -> Void {
            
            let request_url = "\(self.api_url)/events/\(eventId)"
            
            manager.GET(
                request_url,
                parameters: nil,
                success: { (operation: AFHTTPRequestOperation!,
                    responseObject: AnyObject!) in
//                    println("[HttpJicraft showEvent] JSON: " + responseObject.description)
                    
                    successBlock(operation: operation, responseObject: responseObject)
                },
                failure: { (operation: AFHTTPRequestOperation!,
                    error: NSError!) in
                    println("[HttpJicraft showEvent] Error: " + error.localizedDescription)
                    
                    errorBlock(operation: operation, error: error)
                })
    }
    
    // MARK: GET /profiles/me
    func showProfile(forUser email:String, token:String, successBlock: (operation: AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void,
        errorBlock: (operation: AFHTTPRequestOperation!, error:NSError!) -> Void ) -> Void {
            
            let request_url = "\(self.api_url)/profiles/me"
            
            // add token info
            manager.requestSerializer.setValue(email, forHTTPHeaderField: "X-API-EMAIL")
            manager.requestSerializer.setValue(token, forHTTPHeaderField: "X-API-TOKEN")
            
            println("[HttpJicraft showProfile] request url: \(request_url), email: \(email), token: \(token)")
            manager.GET(
                request_url,
                parameters: nil,
                success: { (operation: AFHTTPRequestOperation!,
                    responseObject: AnyObject!) in
                    println("[HttpJicraft showProfile] JSON: " + responseObject.description)
                    
                    successBlock(operation: operation, responseObject: responseObject)
                },
                failure: { (operation: AFHTTPRequestOperation!,
                    error: NSError!) in
                    println("[HttpJicraft showProfile] Error: " + error.localizedDescription)
                    
                    errorBlock(operation: operation, error: error)
                })
    }
    
    // MARK: PATCH /profiles/:id/
    func patchProfile(profileId:String, profileObject: AnyObject!, forUser email:String, token:String, successBlock: (operation: AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void,
        errorBlock: (operation: AFHTTPRequestOperation!, error:NSError!) -> Void ) -> Void {
            
            let request_url = "\(self.api_url)/profiles/\(profileId)"
            
            // add token info
            manager.requestSerializer.setValue(email, forHTTPHeaderField: "X-API-EMAIL")
            manager.requestSerializer.setValue(token, forHTTPHeaderField: "X-API-TOKEN")
            
            manager.PATCH(request_url,
                parameters: profileObject,
                success: { (operation: AFHTTPRequestOperation!,
                    responseObject: AnyObject!) in
                    println("[HttpJicraft patchProfile] JSON: " + responseObject.description)
                    
                    successBlock(operation: operation, responseObject: responseObject)
                },
                failure: { (operation: AFHTTPRequestOperation!,
                    error: NSError!) in
                    println("[HttpJicraft patchProfile] Error: " + error.localizedDescription)
                    
                    errorBlock(operation: operation, error: error)
                })
    }
    
    // MARK: PATCH logo via form /profiles/:id/
    func patchProfileLogo(profileId:String, profileObject: [NSObject:AnyObject], logoImage: NSData, forUser email:String, token:String, successBlock: (responseObject:AnyObject!) -> Void,
        errorBlock: (error:NSError!) -> Void ) -> Void {
            
            let request_url = "\(self.api_url)/profiles/\(profileId)"
            
            var error: NSError?
            
            var request = AFHTTPRequestSerializer.sharedSerializer()
                            .multipartFormRequestWithMethod("PUT", URLString: request_url, parameters: profileObject,
                                constructingBodyWithBlock: {(formData: AFMultipartFormData!) -> Void in
                
                    // append image to formdata
                    if (logoImage.length > 0) {
                        formData.appendPartWithFileData(logoImage, name: "profile[logo]", fileName: "logo.jpg", mimeType: "image/jpg")
                    }
            }, error: &error)
            
            // request headers -- note: Content-Type is HTTP formdata, NOT json
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(email, forHTTPHeaderField: "X-API-EMAIL")
            request.setValue(token, forHTTPHeaderField: "X-API-TOKEN")
            
            // instantiate RequestOperation and add to queue. Response is JSON.
            var op = AFHTTPRequestOperation(request: request)
            op.responseSerializer =  AFJSONResponseSerializer.sharedSerializer()
            
            let onSuccess = {(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                println("[HttpJicraft patchProfileLogo] JSON: " + responseObject.description)
                successBlock(responseObject: responseObject)
            }
            
            let onFailure = {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("[HttpJicraft patchProfile] Error: " + error.localizedDescription)
                errorBlock(error: error)
            }
            
            op.setCompletionBlockWithSuccess(onSuccess, failure: onFailure)
            
            NSOperationQueue.mainQueue().addOperation(op)
    }
    
    // MARK: POST /helpme/
    func postHelpme(helpRequestObj: AnyObject!, forUser email:String, token:String,
        successBlock: (responseObject:AnyObject!) -> Void,
        errorBlock: (error:NSError!) -> Void
        ) -> Void {
            
            let request_url = "\(self.api_url)/helpme/"
            
            // add token info
            manager.requestSerializer.setValue(email, forHTTPHeaderField: "X-API-EMAIL")
            manager.requestSerializer.setValue(token, forHTTPHeaderField: "X-API-TOKEN")
        
            
            manager.POST(
                request_url,
                parameters: helpRequestObj,
                success: { (operation: AFHTTPRequestOperation!,
                    responseObject: AnyObject!) in
//                    println("[HttpJicraft postHelpme] response OK, JSON: " + responseObject.description)
                    
                    successBlock(responseObject: responseObject)
                },
                failure: { (operation: AFHTTPRequestOperation!,
                    error: NSError!) in
                    
                    errorBlock(error: error)
            })
    }
    
    // MARK: GET /profile/photos/
    func getProfilePhotos(forUser email:String, token:String, successBlock: (responseObject:AnyObject!) -> Void,
        errorBlock: (error:NSError!) -> Void ) -> Void {
            
            let request_url = "\(self.api_url)/profiles/photos"
            
            // add token info
            manager.requestSerializer.setValue(email, forHTTPHeaderField: "X-API-EMAIL")
            manager.requestSerializer.setValue(token, forHTTPHeaderField: "X-API-TOKEN")
            
            println("[HttpJicraft getProfilePhotos] request url: \(request_url), email: \(email), token: \(token)")
            manager.GET(
                request_url,
                parameters: nil,
                success: { (operation: AFHTTPRequestOperation!,
                    responseObject: AnyObject!) in
//                    println("[HttpJicraft getProfilePhotos] JSON: " + responseObject.description)
                    
                    successBlock(responseObject: responseObject)
                },
                failure: { (operation: AFHTTPRequestOperation!,
                    error: NSError!) in
                    println("[HttpJicraft getProfilePhotos] Error: " + error.localizedDescription)
                    
                    errorBlock(error: error)
            })
    }
    
    
    
}