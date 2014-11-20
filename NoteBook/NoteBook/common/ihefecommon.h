//
//  ihefecommon.h
//  nurse
//
//  Created by macHs on 14-4-8.
//  Copyright (c) 2014年 shuai huang. All rights reserved.
//


//#ifndef SERVERURL
//
//    #ifdef FKYY
//
//    #define SERVERURL  @"http://172.16.6.23/nurse/api.php?"
//
//    #else
//
//    #define SERVERURL  @"http://192.168.10.5/nurse/api.php?"
//
//    #endif
//
//#endif
//
//#ifdef FKYY
//
//    #define SERVERIP @"172.16.6.23"
//    #define SERVERIPS "172.16.6.23"
//    #define STREAMSERVERIP SERVERIP
//
//#else
//
//    #define STREAMSERVERIP @"192.168.10.1"
//    #define SERVERIP @"us.ihefe.com"
//    #define SERVERIPS "us.ihefe.com"
//    //#define SERVERIP @"192.168.10.1"
//    //#define SERVERIPS "us.ihefe.com"
//
//#endif
//
//
//
//#define AESCryptPassWord @"11"
//
////是否http缓存
//#define iIsCache 0
//#define PostKey @"iphone"
//#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//#define iOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)?YES:NO
//#define boundsWidth [[UIScreen mainScreen] bounds].size.width
//#define boundsHeight ([[UIScreen mainScreen] bounds].size.height - 20)
//
//#define iosY ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)?20:0
//#define LeftWidth 240.0
#define LeftWidth 275.0
//
///**
// 函数
// **/
//颜色
#define  COLORA(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
//颜色
#define  COLOR(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//
//#define showHudDialog(a,c) [common showHudDialog:a views:c]
//
//#define LoadingFont [common loadingFont]
//
//#define IH_CC [UIColor colorWithRed:85.0/255.0 green:52.0/255.0 blue:.0/255.0 alpha:1.0]
//#define IH_SCC [UIColor colorWithRed:217.0/255.0 green:81.0/255.0 blue:.0/255.0 alpha:1.0]
//#define IH_BC ImageWithColor([UIColor colorWithRed:0.0/255.0 green:150.0/255.0 blue:255.0/255.0 alpha:1.0])
//#define IH_TBC [UIColor colorWithRed:0.0/255.0 green:150.0/255.0 blue:255.0/255.0 alpha:1.0]
//#define IH_TBSC [UIColor colorWithRed:247.0/255.0 green:248.0/255.0 blue:245.0/255.0 alpha:1.0]
//
//
//#define IH_DATEC [UIColor colorWithRed:48.0/255.0 green:51.0/255.0 blue:56.0/255.0 alpha:1.0]
//
//
//#define TextColor [UIColor colorWithRed:51.0f / 255.0f green:50.0f / 255.0f blue:29.0f / 255.0f alpha:1.0f]
//#define FontSize [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.0f]
//
//#define LeftNavigationColor [UIColor colorWithRed:0.0f green:99.0f / 255.0f blue:197.0 / 255.0f alpha:1.0f]
//
//#define H_FontSize(s)  [UIFont fontWithName:@"HelveticaNeue-Thin" size:s]
//
//#define ObjToStr(s) [NSString stringWithFormat:@"%@",s]
//#define StrToInt(s) [NSString stringWithFormat:@"%d",s]
//
//#define HudLoad(v,t) [common MBHudLoad:v title:t]
//#define ImageWithColor(c) [common createImageWithColor:c]
//#define AESCryptEncrypt(m)   [AESCrypt encrypt:m password:AESCryptPassWord]
//#define AESCryptDecrypt(m)  [AESCrypt decrypt:m password:AESCryptPassWord]
//
//#define StringIsNUllToId(s) [common stringIsNUllToId:s]
//
//#define IH_PATIENTID [[NSUserDefaults standardUserDefaults] stringForKey:@"PATIENT_ID"]
//#define IH_SYXH [[NSUserDefaults standardUserDefaults] stringForKey:@"syxh"]
//#define IH_UID [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"]
//#define IH_PWD [[NSUserDefaults standardUserDefaults] stringForKey:@"password"]
//#define IH_BLH [[NSUserDefaults standardUserDefaults] stringForKey:@"blh"]
//#define IH_MZH [[NSUserDefaults standardUserDefaults] stringForKey:@"mzh"]
//#define IH_UNAME [[NSUserDefaults standardUserDefaults] stringForKey:@"uname"]
//#define IH_RYRQ [[NSUserDefaults standardUserDefaults] stringForKey:@"ryrq"]
//#define IH_RQRQ [[NSUserDefaults standardUserDefaults] stringForKey:@"rqrq"]
////define notification name
//#define OPTTYPENEEDDOWNLOAD     @"OPTTYPENEEDDOWNLOAD"
//#define NETWORKSTATUS @"NETWORKSTATUS"
//#define DATADOWNLOADED @"DATADOWNLOADED"
//
//
/**
 文字
 **/
#define LoadingHUDLabel  @"加载中..."
#define LoginHUDLabel  @"登录中..."
#define NotNetWork  @"网络连接失败"

#define NoData  @"暂无数据"

#define NoSelect  @"您还没选择患者"

/* 来自护理Mrs Zhang */
#define DEFAULT_HEIGHT  548             // 视图默认高度
#define DEFAULT_WIDTH   320             // 视图默认宽度

// 颜色
#define RGBA(R,G,B,A)   [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define CLEAR   [UIColor clearColor]    // 透明
#define BLACK   [UIColor blackColor]    // 黑色
#define WHITE   [UIColor whiteColor]    // 白色
#define RED     [UIColor redColor]      // 红色
#define BLUE    [UIColor blueColor]     // 蓝色


/* default font */
#define kDefaultHomeNumberFont [UIFont fontWithName:@"HelveticaNeue-UltraLightItalic" size:34.0f]


#define SERVERURL [[NSUserDefaults standardUserDefaults] stringForKey:@"SERVERURL"]
#define SERVERIP [[NSUserDefaults standardUserDefaults] stringForKey:@"SERVERIP"]
#define SERVERIPS [[NSUserDefaults standardUserDefaults] stringForKey:@"SERVERIPS"]
#define STREAMSERVERIP [[NSUserDefaults standardUserDefaults] stringForKey:@"STREAMSERVERIP"]
#define BG_SERVERIP [[NSUserDefaults standardUserDefaults] stringForKey:@"BG_SERVERIP"]
#define SERVER_PORT [[NSUserDefaults standardUserDefaults] integerForKey:@"SERVER_PORT"]

#define AESCryptPassWord @"ihefe123"

//是否http缓存
#define IsCache 0

/**
 函数
 **/
//颜色
//#define  COLOR(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

#define showHudDialog(a,c) [common showHudDialog:a views:c]

#define LoadingFont [common loadingFont]

#define IH_CC [UIColor colorWithRed:85.0/255.0 green:52.0/255.0 blue:.0/255.0 alpha:1.0]
#define IH_SCC [UIColor colorWithRed:217.0/255.0 green:81.0/255.0 blue:.0/255.0 alpha:1.0]
#define IH_BC ImageWithColor([UIColor colorWithRed:0.0/255.0 green:150.0/255.0 blue:255.0/255.0 alpha:1.0])
#define IH_TBC [UIColor colorWithRed:0.0/255.0 green:150.0/255.0 blue:255.0/255.0 alpha:1.0]
#define IH_TBSC [UIColor colorWithRed:247.0/255.0 green:248.0/255.0 blue:245.0/255.0 alpha:1.0]


#define IH_DATEC [UIColor colorWithRed:48.0/255.0 green:51.0/255.0 blue:56.0/255.0 alpha:1.0]


#define TextColor [UIColor colorWithRed:51.0f / 255.0f green:50.0f / 255.0f blue:29.0f / 255.0f alpha:1.0f]
#define FontSize [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.0f]

#define LeftNavigationColor [UIColor colorWithRed:0.0f green:99.0f / 255.0f blue:197.0 / 255.0f alpha:1.0f]

#define H_FontSize(s)  [UIFont fontWithName:@"HelveticaNeue-Thin" size:s]

#define ObjToStr(s) [NSString stringWithFormat:@"%@",s]
#define StrToInt(s) [NSString stringWithFormat:@"%d",s]

#define HudLoad(v,t) [common MBHudLoad:v title:t]
#define ImageWithColor(c) [common createImageWithColor:c]
#define AESCryptEncrypt(m) [AESCrypt encrypt:m password:AESCryptPassWord]
#define AESCryptDecrypt(m) [AESCrypt decrypt:m password:AESCryptPassWord]

#define StringIsNUllToId(s) [common stringIsNUllToId:s]

#define IH_PATIENTID [[NSUserDefaults standardUserDefaults] stringForKey:@"PATIENT_ID"]
#define IH_SYXH [[NSUserDefaults standardUserDefaults] stringForKey:@"syxh"]
#define IH_UID [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"]
#define IH_PWD [[NSUserDefaults standardUserDefaults] stringForKey:@"password"]
#define IH_BLH [[NSUserDefaults standardUserDefaults] stringForKey:@"blh"]
#define IH_MZH [[NSUserDefaults standardUserDefaults] stringForKey:@"mzh"]
#define IH_UNAME [[NSUserDefaults standardUserDefaults] stringForKey:@"uname"]
#define IH_RYRQ [[NSUserDefaults standardUserDefaults] stringForKey:@"ryrq"]
#define IH_RQRQ [[NSUserDefaults standardUserDefaults] stringForKey:@"rqrq"]
#define IH_BCID  [[NSUserDefaults standardUserDefaults] stringForKey:@"bcid"]
#define IH_BQDM  [[NSUserDefaults standardUserDefaults] stringForKey:@"bqdm"]

//define notification name
#define OPTTYPENEEDDOWNLOAD     @"OPTTYPENEEDDOWNLOAD"
#define NETWORKSTATUS @"NETWORKSTATUS"
#define DATADOWNLOADED @"DATADOWNLOADED"


/**
 文字
 **/
#define LoadingHUDLabel  @"加载中..."
#define LoginHUDLabel  @"登录中..."


//-------------------//
#define FONT_OF_TEXT    16                                                // 标题的字体大小
#define TEXT_FONT    H_FontSize(FONT_OF_TEXT)                // 标题字体
#define COLOR_OF_TEXT [UIColor colorWithRed:0 green:0.5 blue:0.8 alpha:1]   // 标题的颜色

#define FONT_OF_TITLE_LABEL   14
#define FONT_OF_LABEL   16                                                 // 文字的字体大小
#define COLOR_OF_LABEL  [UIColor colorWithRed:111.0f / 255.0f green:118.0f / 255.0f blue:128.0f / 255.0f alpha:1.0f]                  // 文字的颜色
#define LABEL_FONT   H_FontSize(18)

#define LABEL_TITLE_FONT   H_FontSize(16)

#define VIEW_LINE [[UIColor colorWithRed:.0/255.0 green:.0/255.0 blue:.0/255.0 alpha:0.05]  CGColor]
//[UIFont systemFontOfSize:FONT_OF_LABEL]     // 文字字体



#define LAYER_BORDER_WIDTH  0.0 // 控件边框宽度，该数值供测试用，设为1,可以看到各个控件的边框，设为0,边框消失

#define TITLE_HEIGHT    0.16    // 标题的高度比例
#define LABEL_HEIGHT    0.28    // 标签的高度比例

// 以下为第一部分的视图
#define LABEL_INIT_WIDTH    0.17            // 固定标签的起始宽度
#define INIT_WIDTH          0.26            // 自定义标签的起始宽度
// 以下为第二三四部分的视图
#define LABEL_INIT_WIDTH2   0.03            // 固定标签的起始宽度
#define INIT_WIDTH2         0.14            // 自定义标签的起始宽度


#define LABEL_INIT_HEIGHT   TITLE_HEIGHT    // 固定标签的起始高度



// 第一部分
#define LABEL_GAP1       0.21         // 固定标签的间距
#define LABEL_WIDTH1     0.08         // 固定标签宽度
#define WIDTH1           0.11         // 自定义标签的宽度

// 第二三四部分
#define LABEL_GAP        0.25         // 固定标签的间距
#define LABEL_WIDTH      0.1          // 固定标签宽度
#define WIDTH            0.13         // 自定义标签的宽度

//----------------//

/*********************体温单***********************/
#define DefaultOrdinateUnitHeight 16.0f
#define DefaultAbscissaUnitWidth 16.0f
//#define kBTDefaultFontColor color(83,88,95)
#define kBTDefaultFontColor [UIColor blackColor]


/*******************begin DicomView********************/
#ifdef DEBUG
#define DLog(...) NSLog(@"%@", [NSString stringWithFormat:__VA_ARGS__])
#define FLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#define ALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
#else
#define DLog(...) do { } while (0)
#ifndef NS_BLOCK_ASSERTIONS
#define NS_BLOCK_ASSERTIONS
#endif

#define ALog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#endif

#define ZAssert(condition, ...) do { if (!(condition)) { ALog(__VA_ARGS__); }} while(0)


#define NSStringIsNilOrEmpty(str) (nil == (str) || [(str) isEqualToString:@""])
#define NSLocalString(str) NSLocalizedString(str, nil)
//#endif

#define SAFE_FREE(ptr) do { if (ptr) { free(ptr); ptr = NULL;} } while (0)
#define SAFE_DELETE(ptr) do { if (ptr) { delete ptr; ptr = NULL;} } while (0)
/*******************end DicomView********************/

/*
    来自IHExamineView的宏
 */
#define FrameW self.frame.size.width
#define FrameH self.frame.size.height
#define  color(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

/*
    来自IHCheckoutView、DataBrowseView的宏
 */
#define IHCheckoutView_USE_IN_IPAD 0
#define DataBrowseView_USE_IN_IPAD 0




