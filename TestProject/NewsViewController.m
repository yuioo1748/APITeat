//
//  NewsViewController.m
//  TestProject
//
//  Created by 解庚霖 on 2024/2/3.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"


@interface NewsViewController ()
{
        
    NSArray *_baseArray;
    
    
}
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _newsTableView.delegate = self;
    _newsTableView.dataSource = self;
    
    //_newsTableView.estimatedSectionHeaderHeight =20.0;
    
    [self getUrlData];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.tintColor = [UIColor grayColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    [refreshControl addTarget:self action:@selector(getUrlData) forControlEvents:UIControlEventValueChanged];
    _newsTableView.refreshControl = refreshControl;
    
}


//設定tableview有多少區段
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

//設定tableview有多少列
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_baseArray)
        return _baseArray.count;
    else
        return 0;
}

//設定每列的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"newsCell";
    
    //節省記憶體
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
//    "Title": "string",
//      "Url": "string",
//      "Date": "string"
    
    NSDictionary *dic = _baseArray[indexPath.row];
    
    NSString *title = [dic objectForKey:@"Title"];
    NSString *url = [dic objectForKey:@"Url"];
    NSString *date = [dic objectForKey:@"Date"];
    
    [cell showContentList:indexPath.row+1 title:title url:url date:date];
    
    return cell;
}

//使目標列被點擊後可以跳轉到指定url
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsTableViewCell *cell = (NewsTableViewCell *)[_newsTableView cellForRowAtIndexPath:indexPath];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[cell geturl]] options:@{} completionHandler:nil];
    
}

//串接API
- (void)getUrlData {
//    _baseArray = nil;
//    [self->_newsTableView reloadData];
    // Initializing an NSURL object with the specified URL string
    NSURL *url = [NSURL URLWithString:@"https://openapi.twse.com.tw/v1/news/newsList"];
    
    // Creating a new URL request object using the previously initialized NSURL 'url'
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Obtain a shared URLSession instance
    NSURLSession *session = [NSURLSession sharedSession];
    
    // Create a data task with the specified URL request and a completion handler
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            // Process the received data if it exists
            NSError *err = nil;
            self->_baseArray = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:0
                                  error:&err];
            NSLog(@"baseArray:%@",self->_baseArray.description);
            dispatch_queue_t queue = dispatch_get_main_queue();
            dispatch_async(queue, ^{
                
                if([self->_newsTableView.refreshControl isRefreshing]){
                    [self->_newsTableView.refreshControl endRefreshing];
                }
                
                [UIView animateWithDuration:1.0 delay:0.1 options:UIViewAnimationOptionTransitionCrossDissolve  animations:^{
                    self->_newsTableView.contentOffset=CGPointMake(0, 0);
                      } completion:^(BOOL finished) {
                   }];
                //查詢完畫面reload,不然會是空的
                [self->_newsTableView reloadData];
                
            });
            //NSLog(@"e04:%@",underWriterDic.description);
        }
    }];
    // Start or resume the data task
    [dataTask resume];

        
    
}

@end
