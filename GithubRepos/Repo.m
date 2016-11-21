//
//  Repo.m
//  GithubRepos
//
//  Created by Erin Luu on 2016-11-21.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

#import "Repo.h"

@implementation Repo
-(instancetype) initWithName: (NSString *) name andURL: (NSString *) url {
    self = [super init];
    if (self) {
        _name = name;
        _url = url;
    }
    return self;
}
@end

