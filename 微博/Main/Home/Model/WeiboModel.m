//
//  WeiboModel.m
//  微博
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "WeiboModel.h"
#import "RegexKitLite.h"

@implementation WeiboModel

- (NSDictionary*)attributeMapDictionary{
    
    //   @"属性名": @"数据字典的key"
    NSDictionary *mapAtt = @{
                             @"createDate":@"created_at",
                             @"weiboId":@"id",
                             @"text":@"text",
                             @"source":@"source",
                             @"favorited":@"favorited",
                             @"thumbnailImage":@"thumbnail_pic",
                             @"bmiddlelImage":@"bmiddle_pic",
                             @"originalImage":@"original_pic",
                             @"geo":@"geo",
                             @"repostsCount":@"reposts_count",
                             @"commentsCount":@"comments_count",
                             @"weiboIdStr":@"idstr"
                             };
    
    return mapAtt;
}

-(void)setAttributes:(NSDictionary *)dataDic {
    
    [super setAttributes:dataDic];
    
    //消息来源
    if (_source != nil) {
        NSString *regex = @">.+<";
        NSArray *array = [_source componentsMatchedByRegex:regex];
        if (array != nil) {
            NSString *str = [array lastObject];
            str = [str substringWithRange:NSMakeRange(1,str.length-2)];
            _source = [NSString stringWithFormat:@"来自:%@",str];
        }
    }

    //用户信息的解析
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    if (userDic != nil) {
        _userModel = [[UserModel alloc] initWithDataDic:userDic];
        
    }
    
    //被转发的微博
    NSDictionary *weiboDic = [dataDic objectForKey:@"retweeted_status"];
    if (weiboDic != nil) {
        _reWeiboModel = [[WeiboModel alloc] initWithDataDic:weiboDic];
        
        //转发用户名字的处理
        NSString *reName = _reWeiboModel.userModel.name;
        _reWeiboModel.text = [NSString stringWithFormat:@"@%@:%@",reName,_reWeiboModel.text];

    }
    
    //自己发的微博
//    _text = [dataDic objectForKey:@"text"];
    
    
    //表情处理 emoticons
    //我喜欢哈哈[兔子]----》我喜欢哈哈<image usl = '1.png'>
    NSString *ragex = @"\\[\\w+\\]";
    NSArray *faceItems = [_text componentsMatchedByRegex:ragex];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *faceArray = [NSArray arrayWithContentsOfFile:filePath];

    for (NSString *faceName in faceItems) {
        
        NSString *t = [NSString stringWithFormat:@"self.chs='%@'",faceName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:t];
        
        NSArray *item = [faceArray filteredArrayUsingPredicate:predicate];
        
        if (item.count > 0) {
            NSString *imageName = [item[0] objectForKey:@"png"];
            // <image usl = '1.png'>
            NSString *urlStr = [NSString stringWithFormat:@"<image url = '%@'>",imageName];
            _text = [_text stringByReplacingOccurrencesOfString:faceName withString:urlStr];
            
        }
                                  
                                  
    }
    
    
}

@end
