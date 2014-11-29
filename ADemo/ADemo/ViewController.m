//
//  ViewController.m
//  ADemo
//
//  Created by GK on 11/29/14.
//  Copyright (c) 2014 GK. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(strong,nonatomic) NSMutableArray *imageViewArray;
@property(strong,nonatomic) NSArray *imageViewBackgroundColorArray;
@property(strong,nonatomic) UIView *viewBarrierOuter;
@property(strong,nonatomic) UIView *viewBarrierInner;
@property(strong,nonatomic) UIView *containerView;

@end


@implementation ViewController

static CGFloat imageViewSizeHeightAndHeight = 100;
static int notAnimation = 0;
static int isAnimating = 1;

static CGFloat maxScale = 1.0;
static CGFloat midScale = 0.7;
static CGFloat minScale = 0.4;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGFloat gutter = 150;
    
    self.imageViewArray = [[NSMutableArray alloc] init];
    self.imageViewBackgroundColorArray =[[NSArray alloc] initWithObjects:[UIColor redColor],[UIColor grayColor],[UIColor greenColor],[UIColor purpleColor],[UIColor yellowColor],[UIColor whiteColor],[UIColor blueColor],[UIColor brownColor],[UIColor orangeColor],[UIColor groupTableViewBackgroundColor], nil];
    
    self.scrollView.backgroundColor = [UIColor blackColor];
    CGFloat width = self.view.frame.size.width * 1.5 + (gutter * 3);
    CGFloat height = self.view.frame.size.height * 1.5 + (gutter *3);
    self.scrollView.contentSize=CGSizeMake(width, height);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentSize.width/2-self.view.frame.size.width/2 - gutter, self.scrollView.contentSize.height/1.5-self.view.frame.size.height/2 - 3 * gutter);
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    self.scrollView.delegate = self;
    CGFloat gap = 15;
    CGFloat xValue = gutter;
    CGFloat yValue = gutter;
    NSUInteger rowNumber = 2;
    
    self.scrollView.maximumZoomScale = 1.1;
    self.scrollView.minimumZoomScale = 0.01;
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, width - 50, height - 50)];
    [self.scrollView addSubview:self.containerView];
    
    for( NSInteger zz = 0; zz < 32; zz++) {
        
        UIImageView *imageOne = [[UIImageView alloc] initWithFrame:CGRectMake(xValue, yValue, imageViewSizeHeightAndHeight, imageViewSizeHeightAndHeight)];
        
        [self addImageViewToScrollView:imageOne];
        
        xValue += (100+gap+gap);
        
        if(xValue > (self.scrollView.contentSize.width - gutter *2)){
            if(rowNumber % 2 == 0){
                xValue = 30 + gutter;
            }else {
                xValue = 0 + gutter;
            }
            yValue += (100 + gap);
            rowNumber += 1;
        }
        
    }
    
    self.viewBarrierOuter = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/6,self.view.frame.size.height/8, self.view.frame.size.width-self.view.frame.size.width/3, self.view.frame.size.height-self.view.frame.size.height/4)];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedView:)];
    [self.scrollView addGestureRecognizer:gesture];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTaped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    self.viewBarrierOuter.backgroundColor = [UIColor redColor];
    self.viewBarrierOuter.alpha = 0.3;
    self.viewBarrierOuter.hidden = YES;
    
    self.viewBarrierOuter.userInteractionEnabled = NO;
    [self.view addSubview:self.viewBarrierOuter];
    
    self.viewBarrierInner = [[UIView alloc] initWithFrame: CGRectMake(self.view.frame.size.width/4,self.view.frame.size.height/6, self.view.frame.size.width-self.view.frame.size.width/2, self.view.frame.size.height-self.view.frame.size.height/3)];
    self.viewBarrierInner.backgroundColor = [UIColor redColor];
    self.viewBarrierInner.alpha = 0.3;
    self.viewBarrierInner.hidden = YES;
    self.viewBarrierInner.userInteractionEnabled = NO;
    [self.view addSubview:self.viewBarrierInner];
    
    [self initImageScale];
}
-(void)scrollViewDoubleTaped:(UITapGestureRecognizer*)recognizer
{
    CGPoint pointInView = [recognizer locationInView:self.containerView];
    
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    CGSize scrollViewSize =  self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w /2.0f);
    CGFloat y = pointInView.y - (h /2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
    
}
-(void)didClickedView:(UITapGestureRecognizer*)sender
{
    CGPoint point = [sender locationInView:self.scrollView];
    NSString *strMessage;
    for (int vv=0; vv<self.containerView.subviews.count; vv++) {
        UIView *VView = self.containerView.subviews[vv];
        if([VView isMemberOfClass:[UIImageView class]]){
            CGRect vRect = VView.frame;
            if(CGRectContainsPoint(vRect, point)){
                
                UIImageView *tempImageView =(UIImageView*)VView;
                strMessage = [NSString stringWithFormat:@"You Clicked Me,My color is %@,the position you clicked is [x %lf],[y %lf]",tempImageView.backgroundColor.description,point.x,point.y];
                NSLog(@"vv backgroundColor is %@,point x is %f,y is %f",tempImageView.backgroundColor.description,point.x,point.y);
                
                //show message
                TempView *tempShowView = [[TempView alloc] initWithView:self.view text:strMessage];
                [tempShowView showWithAnimation:YES];
            }
        }
       
    }
}

-(void)initImageScale {
    CGRect container = CGRectMake(self.scrollView.contentOffset.x+(self.viewBarrierOuter.frame.size.width/6), self.scrollView.contentOffset.y + (self.viewBarrierOuter.frame.size.height/8), self.viewBarrierOuter.frame.size.width, self.viewBarrierOuter.frame.size.height);
    CGRect containerTwo = CGRectMake(self.scrollView.contentOffset.x+(self.viewBarrierInner.frame.size.width/2), self.scrollView.contentOffset.y+(self.viewBarrierInner.frame.size.height/3), self.viewBarrierInner.frame.size.width, self.viewBarrierInner.frame.size.height);
    
    for (int ii = 0; ii < self.imageViewArray.count; ii++) {
        UIImageView *tempImageView = self.imageViewArray[ii];
        CGRect thePosition = tempImageView.frame;
        
        if(CGRectIntersectsRect(containerTwo, thePosition)){
            tempImageView.transform = CGAffineTransformMakeScale(maxScale,maxScale);
        }else if(CGRectIntersectsRect(container, thePosition)){
            tempImageView.transform = CGAffineTransformMakeScale(midScale,midScale);
        }else{
            tempImageView.transform = CGAffineTransformMakeScale(minScale,minScale);
        }
    }
}
-(void)addImageViewToScrollView:(UIImageView*)imageView
{
    int index = (int)(arc4random()%9);
    imageView.userInteractionEnabled = YES;
    
    imageView.backgroundColor = self.imageViewBackgroundColorArray[index];
    
    imageView.layer.cornerRadius = 12;
    imageView.layer.masksToBounds = YES;
    imageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    //[self.scrollView addSubview:imageView];
    [self.containerView addSubview:imageView];
    [self.imageViewArray addObject:imageView];
}

-(void)centerScrollViewContents
{
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.containerView.frame;
    
    if(contentsFrame.size.width < boundsSize.width){
        
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
        
    }else {
        
        contentsFrame.origin.x = 0.0f;
    }
    
    if(contentsFrame.size.height < boundsSize.height){
        
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
        
    }else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.containerView.frame = contentsFrame;
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return  self.containerView;
}
#pragma mask -m scrollview delegate
-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerScrollViewContents];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect container = CGRectMake(self.scrollView.contentOffset.x+(self.viewBarrierOuter.frame.size.width/6), self.scrollView.contentOffset.y + (self.viewBarrierOuter.frame.size.height/8), self.viewBarrierOuter.frame.size.width, self.viewBarrierOuter.frame.size.height);
    CGRect containerTwo = CGRectMake(self.scrollView.contentOffset.x+(self.viewBarrierInner.frame.size.width/2), self.scrollView.contentOffset.y+(self.viewBarrierInner.frame.size.height/3), self.viewBarrierInner.frame.size.width, self.viewBarrierInner.frame.size.height);
    const char *myQueue = [@"myQueue" UTF8String];
    dispatch_queue_t  fetchQ = dispatch_queue_create(myQueue, nil);
    
    dispatch_async(fetchQ, ^{
        for (int cc = 0; cc <self.imageViewArray.count; cc++) {
            UIImageView *tempImageView = self.imageViewArray[cc];
            CGRect thePosition = tempImageView.frame;
            
            if(CGRectIntersectsRect(containerTwo, thePosition))
            {
                if (tempImageView.tag == notAnimation)
                {
                    tempImageView.tag = isAnimating;

                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:0.5 animations:^{
                            tempImageView.transform = CGAffineTransformMakeScale(maxScale, maxScale);
                        } completion:^(BOOL finished) {
                            tempImageView.tag = notAnimation;
                        }];
                    });
                }
            }else if(CGRectIntersectsRect(container, thePosition))
            {
                if (tempImageView.tag == notAnimation)
                {
                    tempImageView.tag = isAnimating;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:0.5 animations:^{
                            tempImageView.transform = CGAffineTransformMakeScale(midScale, midScale);
                        } completion:^(BOOL finished) {
                            tempImageView.tag = notAnimation;
                        }];
                    });

                    
                }
            }else{
                if (tempImageView.tag == notAnimation)
                {
                    tempImageView.tag = isAnimating;

                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:0.5 animations:^{
                            tempImageView.transform = CGAffineTransformMakeScale(minScale, minScale);
                        } completion:^(BOOL finished) {
                            tempImageView.tag = notAnimation;
                        }];
                    });
                }
            }
        
        }
    });
}
@end
