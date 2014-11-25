//
//  SearchBar.m
//  NoteBook
//
//  Created by ihefe-JF on 14/11/5.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import "SearchBar.h"

@implementation SearchBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        //set searchbar
        _searchBar = [[UISearchBar alloc] initWithFrame:self.frame];
        _searchBar.tintColor =[UIColor whiteColor];
        _searchBar.layer.cornerRadius = 2;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.placeholder = @"搜索笔记";
        
        _searchBar.translucent = 0;
        
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor orangeColor]];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];
        
        _searchBar.barStyle = UIBarStyleDefault;
      
      //  _searchBar.tintColor = [UIColor redColor];
        for(UIView *subView in _searchBar.subviews){
          //  if([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
               // [subView removeFromSuperview];
                UIView *tempView = [[UIView alloc] initWithFrame:frame];
                tempView.backgroundColor = [UIColor redColor];
                tempView.alpha = 0.5;
            subView.backgroundColor = [UIColor blackColor];
               // [_searchBar insertSubview:tempView aboveSubview:subView];
           //     break;
          //  }
        }
       
        [self addSubview:_searchBar];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
