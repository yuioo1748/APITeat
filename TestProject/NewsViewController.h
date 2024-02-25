//
//  NewsViewController.h
//  TestProject
//
//  Created by 解庚霖 on 2024/2/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsViewController : UIViewController< UITableViewDataSource,UITableViewDelegate >

@property (weak, nonatomic) IBOutlet UITableView *newsTableView;


@end

NS_ASSUME_NONNULL_END
