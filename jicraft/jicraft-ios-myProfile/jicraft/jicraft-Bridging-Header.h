//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

// crashes
#import <Crashlytics/Crashlytics.h>

// Http client
#import <AFNetworking/AFNetworking.h>

// Events async remote image loading
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageCompat.h>
#import <SDWebImage/SDWebImageManager.h>

// TaskCell
#import <MCSwipeTableViewCell/MCSwipeTableViewCell.h>

// LoginManager
#import <SSKeychain/SSKeychain.h>

// shared serializer for AFNetworking serializers
#import "AFHTTPRequestSerializer+SharedSerializer.h"
#import "AFJSONResponseSerializer+SharedSerializer.h"

// resize image
#import "UIImage+Resize.h"

// FXLabel
#import <FXLabel/FXLabel.h>