//
//  MainMenuViewController.m
//  TestProject
//
//  Created by 解庚霖 on 2024/1/31.
//

#import "MainMenuViewController.h"
#import "NewsViewController.h"
#import "MonthlyIncomeTableViewController.h"
 
@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)monthlyIncomeAction:(id)sender {
    
    MonthlyIncomeTableViewController *mIncomeView = [[MonthlyIncomeTableViewController alloc] init];
    [self.navigationController pushViewController:mIncomeView animated:YES];
    
}

- (IBAction)newsAction:(id)sender {
    
    NewsViewController *newsView = [[NewsViewController alloc] init];
    [self.navigationController pushViewController:newsView animated:YES];
    
}

- (IBAction)recentlyCompanyAction:(id)sender {
    
    UIViewController *recentlyCompanyView = [self.storyboard instantiateViewControllerWithIdentifier:@"recentlyCompanyPage"];
    [self.navigationController pushViewController:recentlyCompanyView animated:YES];
    
}


@end
