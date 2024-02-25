//
//  NewsTableViewCell.m
//  TestProject
//
//  Created by 解庚霖 on 2024/2/3.
//

#import "NewsTableViewCell.h"

@interface NewsTableViewCell ()
{
        
    NSString *_url;
    
}
@end

@implementation NewsTableViewCell

//程式自帶這次沒使用
- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType=UITableViewCellAccessoryNone;

    // Initialization code
}

//程式自帶這次沒使用
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
  
}

//塞入要顯示的內容
-(void)showContentList:(NSInteger)row
                 title:(NSString*)title
                   url:(NSString*)url
                  date:(NSString*)date{
    _numberLabel.text = [NSString stringWithFormat:@"%ld",(long)row];
    _titleLabel.text = title;
    NSString *dateYear = [[date substringFromIndex:0] substringToIndex:3];
    NSString *dateMonth = [[date substringFromIndex:3] substringToIndex:2];
    NSString *dateday = [[date substringFromIndex:5] substringToIndex:2];
    NSString *newsdate = [NSString stringWithFormat:@"民國%@年%@月%@日",dateYear,dateMonth,dateday];
    _dateLabel.text = newsdate;
    _url = url;
}


-(NSString*)geturl
{
    return _url;
}


@end
