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
    
        _searchBar.layer.cornerRadius = 2;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.placeholder = @"搜索";
    
        
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor blueColor]];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];
        
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
