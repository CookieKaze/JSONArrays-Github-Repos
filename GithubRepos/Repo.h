//
//  Repo.h
//  GithubRepos
//
//  Created by Erin Luu on 2016-11-21.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repo : NSObject
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * url;

-(instancetype) initWithName: (NSString *) name andURL: (NSString *) url;
@end
