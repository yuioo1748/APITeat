//
//  MainMenuViewController.h
//  TestProject
//
//  Created by 解庚霖 on 2024/1/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainMenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *recentlyCompany;
@property (weak, nonatomic) IBOutlet UIButton *news;


- (IBAction)recentlyCompanyAction:(id)sender;
- (IBAction)newsAction:(id)sender;
- (IBAction)monthlyIncomeAction:(id)sender;



@end

NS_ASSUME_NONNULL_END
