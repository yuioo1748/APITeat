//
//  MonthlyIncomeTableViewController.h
//  TestProject
//
//  Created by 解庚霖 on 2024/2/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MonthlyIncomeTableViewController : UIViewController< UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate >
@property (weak, nonatomic) IBOutlet UITextView *industryTF;
@property (weak, nonatomic) IBOutlet UITextView *nameTF;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;



@end

NS_ASSUME_NONNULL_END
