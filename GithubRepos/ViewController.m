//
//  ViewController.m
//  GithubRepos
//
//  Created by Erin Luu on 2016-11-21.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

#import "ViewController.h"
#import "Repo.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (nonatomic) NSMutableArray <Repo *> * repos;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.repos = [[NSMutableArray alloc] init];
    //Create a new NSURL object from the GitHub api url string
    NSURL *url = [NSURL URLWithString:@"https://api.github.com/users/cookiekaze/repos"];
    
    //Use this object to make configurations specific to the URL.
    //For example, speicifying if this is a GET or POST request, or how we should cache data.
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    //NSURLSessionConfiguration defines the behavior and policies to use when making a request with an NSURLSession.
    //We can use the session configuration to create many different requests,
    //where any configurations we make to the NSURLRequest object will only apply to that single request.
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //Create an NSURLSession object using our session configuration
    //Configurations MUST be done before this
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 4
    
    
    //The session creates and configures the task and the task makes the request
    //Data tasks send and receive data using NSData objects.
    //Data tasks are intended for short, often interactive requests to a server
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //    data: The data returned by the server, most of the time this will be JSON or XML.
        //    response: Response metadata such as HTTP headers and status codes.
        //    error: An NSError that indicates why the request failed, or nil when the request is successful.
        if (error) {
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        //The data task retrieves data from the server as an NSData
        //NSJSONSerialization used to convert the NSData to JSON
        NSError *jsonError = nil;
        NSArray *repos = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            //if the server actually returned XML to us, then we want to handle it here.
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        
        // If we reach this point, we have successfully retrieved the JSON from the API
        for (NSDictionary *repo in repos) { // 4
            NSString *repoName = repo[@"name"];
            NSString *url = repo[@"html_url"];
            Repo * myRepo = [[Repo alloc] initWithName:repoName andURL:url];
            [self.repos addObject:myRepo];
        }
        
        //Reload table on main thread to show new data
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(){
            [self.tableView reloadData];
        }];
    }];
    
    //A task is created in a suspended state, so we need to resume it (Other options: suspend, resume and cancel)
    [dataTask resume];
    
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.repos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    Repo * repo = self.repos[indexPath.row];
    cell.textLabel.text = repo.name;
    return cell;
}

@end

