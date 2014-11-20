//
//  Profile.swift
//  jicraft
//
//  Created by JERRY LIU on 19/9/14.
//  Copyright (c) 2014 com.jicraft. All rights reserved.
//

import Foundation

class Profile : NSObject {
    
    var profileId = Int()
    var name = String()
    var url = String()
    var logoUrl = String()
    var about = String()
    var website = String()
    var address = String()
    var tel = String()
    var email = String()
    var weibo = String()
    var wechat = String()
    var qq = String()
    
    override init () {
        super.init()
    }
    
    init (json jsonObject:Dictionary<String,AnyObject>) {
        
        super.init()
        
        self.name = JicraftJSONSerializer.stringFromDict(jsonObject, key: "name")
        self.url = JicraftJSONSerializer.stringFromDict(jsonObject, key: "url")
        self.logoUrl = JicraftJSONSerializer.stringFromDict(jsonObject, key: "logo_url")
        self.about = JicraftJSONSerializer.stringFromDict(jsonObject, key: "about")
        self.website = JicraftJSONSerializer.stringFromDict(jsonObject, key: "website")
        self.address = JicraftJSONSerializer.stringFromDict(jsonObject, key: "address")
        self.tel = JicraftJSONSerializer.stringFromDict(jsonObject, key: "tel")
        self.email = JicraftJSONSerializer.stringFromDict(jsonObject, key: "email")
        self.weibo = JicraftJSONSerializer.stringFromDict(jsonObject, key: "weibo")
        self.wechat = JicraftJSONSerializer.stringFromDict(jsonObject, key: "wechat")
        self.qq = JicraftJSONSerializer.stringFromDict(jsonObject, key: "qq")
    }
    
    init(coder decoder: NSCoder!) {
        
        super.init()
        
        self.profileId = decoder.decodeIntegerForKey("profileId")
        self.name = decoder.decodeObjectForKey("name") as String
        self.url = decoder.decodeObjectForKey("url") as String
        self.logoUrl = decoder.decodeObjectForKey("logo_url") as String
        self.name = decoder.decodeObjectForKey("about") as String
        self.website = decoder.decodeObjectForKey("website") as String
        self.address = decoder.decodeObjectForKey("address") as String
        self.tel = decoder.decodeObjectForKey("tel") as String
        self.email = decoder.decodeObjectForKey("email") as String
        self.weibo = decoder.decodeObjectForKey("weibo") as String
        self.wechat = decoder.decodeObjectForKey("wechat") as String
        self.qq = decoder.decodeObjectForKey("qq") as String
    }
    
    func encodeWithCoder(encoder: NSCoder!) {
        encoder.encodeInteger(self.profileId, forKey: "profileId")
        encoder.encodeObject(self.name, forKey: "name")
        encoder.encodeObject(self.url, forKey: "url")
        encoder.encodeObject(self.logoUrl, forKey: "logo_url")
        encoder.encodeObject(self.about, forKey: "about")
        encoder.encodeObject(self.website, forKey: "website")
        encoder.encodeObject(self.address, forKey: "address")
        encoder.encodeObject(self.tel, forKey: "tel")
        encoder.encodeObject(self.email, forKey: "email")
        encoder.encodeObject(self.weibo, forKey: "weibo")
        encoder.encodeObject(self.wechat, forKey: "wechat")
        encoder.encodeObject(self.qq, forKey: "qq")
    }
        
    func dict() -> Dictionary<String, AnyObject> {
        return ["profileId": self.profileId,
            "name": self.name,
            "logo_url": self.logoUrl,
            "about": self.about,
            "website": self.website,
            "address": self.address,
            "tel": self.tel,
            "email": self.email,
            "weibo": self.weibo,
            "wechat": self.wechat,
            "qq": self.qq]
    }
    
}