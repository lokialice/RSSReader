//
//  Feed.h
//  RSSReader
//
//  Created by Macbook Pro MD102 on 9/7/15.
//  Copyright (c) 2015 Loki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Feed : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;

@end
