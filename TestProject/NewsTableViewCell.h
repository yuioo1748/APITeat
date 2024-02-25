//
//  NewsTableViewCell.h
//  TestProject
//
//  Created by 解庚霖 on 2024/2/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

-(void)showContentList:(NSInteger)row
                 title:(NSString*)title
                   url:(NSString*)url
                  date:(NSString*)date;

-(NSString*)geturl;

@end

NS_ASSUME_NONNULL_END
