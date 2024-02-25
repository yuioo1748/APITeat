//
//  ViewController.h
//  TestProject
//
//  Created by 解庚霖 on 2023/11/7.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController< UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate >
@property (weak, nonatomic) IBOutlet UITextView *areaTF;
@property (weak, nonatomic) IBOutlet UITextView *weekTF;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;



@end

