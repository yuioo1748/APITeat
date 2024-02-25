//
//  MonthlyIncomeTableViewController.m
//  TestProject
//
//  Created by 解庚霖 on 2024/2/16.
//

#import "MonthlyIncomeTableViewController.h"

@interface MonthlyIncomeTableViewController ()
{
    NSMutableDictionary *_industryDic;
    UIPickerView *_picker;
    UIPickerView *_picker2;
    NSMutableDictionary *_companyInfoDic;
}

@end

@implementation MonthlyIncomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getUrlData];
    
    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [_picker setDataSource: self];
    [_picker setDelegate: self];
    _industryTF.inputView = _picker;
    
    _picker2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [_picker2 setDataSource: self];
    [_picker2 setDelegate: self];
    _nameTF.inputView = _picker2;
    
    //不能重複利用
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap)];
    [self.view addGestureRecognizer:singleFingerTap];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"123";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    "出表日期": "1130215",
//            "資料年月": "11301",
//            "公司代號": "000104",
//            "公司名稱": "臺銀證券",
//            "產業別": "證券",
//            "營業收入-當月營收": "88479",
//            "營業收入-上月營收": "99117",
//            "營業收入-去年當月營收": "69073",
//            "營業收入-上月比較增減(%)": "-10.732770362299101",
//            "營業收入-去年同月增減(%)": "28.09491407641191",
//            "累計營業收入-當月累計營收": "88479",
//            "累計營業收入-去年累計營收": "69073",
//            "累計營業收入-前期比較增減(%)": "28.09491407641191",
//            "備註": "-"
    NSString *msg = @"";
    
    switch([indexPath row]) {
       case 0 :
            msg = [self cellStrCheck:@"出表日期: " key:@"出表日期"];
          break;
       case 1 :
            msg = [self cellStrCheck:@"資料年月: " key:@"資料年月"];
          break;
       case 2 :
            msg = [self cellStrCheck:@"公司代號: " key:@"公司代號"];
          break;
       case 3 :
            msg = [self cellStrCheck:@"營業收入-當月營收: " key:@"營業收入-當月營收"];
          break;
       case 4 :
            msg = [self cellStrCheck:@"營業收入-上月營收: " key:@"營業收入-上月營收"];
          break;
        case 5 :
            msg = [self cellStrCheck:@"營業收入-去年當月營收: " key:@"營業收入-去年當月營收"];
           break;
        case 6 :
            msg = [self cellStrCheck:@"營業收入-上月比較增減(%): " key:@"營業收入-上月比較增減(%)"];
           break;
        case 7 :
            msg = [self cellStrCheck:@"營業收入-去年同月增減(%): " key:@"營業收入-去年同月增減(%)"];
           break;
        case 8 :
            msg = [self cellStrCheck:@"累計營業收入-當月累計營收: " key:@"累計營業收入-當月累計營收"];
           break;
        case 9 :
            msg = [self cellStrCheck:@"累計營業收入-去年累計營收: " key:@"累計營業收入-去年累計營收"];
           break;
        case 10 :
            msg = [self cellStrCheck:@"累計營業收入-前期比較增減(%): " key:@"累計營業收入-前期比較增減(%)"];
           break;
        case 11 :
            msg = [self cellStrCheck:@"備註: " key:@"備註"];
           break;
       default :
          NSLog(@"資料空\n" );
       }
    
    cell.textLabel.text = msg;
        return cell;
    
}


- (void)getUrlData {
    
    // Initializing an NSURL object with the specified URL string
    NSURL *url = [NSURL URLWithString:@"https://openapi.twse.com.tw/v1/opendata/t187ap05_P"];
    
    // Creating a new URL request object using the previously initialized NSURL 'url'
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Obtain a shared URLSession instance
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    // Create a data task with the specified URL request and a completion handler
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            // Process the received data if it exists
            NSError *err = nil;
            NSArray *baseArray = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:0
                                  error:&err];
            NSLog(@"baseArray:%@",baseArray.description);
            
            NSMutableDictionary *industryDic = [[NSMutableDictionary alloc] init];
            
            //baseArray 跑for迴圈，依照index撈出該index的dictionary，再從該dictionary的key “Underwriter”撈出值，並用該Underwriter值分類資料
            for (NSInteger i = 0; i < baseArray.count ; i++)
            {
                NSDictionary *dic = baseArray[i];
                
                NSString *industry = [dic objectForKey:@"產業別"];
                
                //發現新的Underwriter時，用新的Underwriter當key存一個新的dictionary，dictionary value也儲存一個新的array
                if([industryDic objectForKey:industry] == FALSE){
                    
                    NSMutableArray *industryArray = [[NSMutableArray alloc] init];
                    [industryArray addObject:dic];
                    [industryDic setValue:industryArray forKey:industry];
                    
                }
                //發現是既有的Underwriter時，用Underwriter當key把dicionary挖出來更新該dictionary儲存的array
                else
                {
                    
                    NSMutableArray *industryArray = [industryDic objectForKey:industry];
                    [industryArray addObject:dic];
                    [industryDic setValue:industryArray forKey:industry];
                    
                }
                
            }
            self->_industryDic = industryDic;
            NSLog(@"e04:%@",industryDic.description);
            
            
        }
    }];
    
    // Start or resume the data task
    [dataTask resume];
    
}

//The event handling method
- (void)handleSingleTap {
    
    [_industryTF endEditing:TRUE];
    [_nameTF endEditing:TRUE];
    
}

- (NSString*)cellStrCheck:(NSString*)listName
                      key:(NSString*)key{
    
    NSString *msg = @"";
    
    msg = [NSString stringWithFormat:@"%@%@",listName,
           [_companyInfoDic objectForKey:key] ? [_companyInfoDic objectForKey:key] : @""];
    
    return msg;
}

//取得同個產業別之下的上市公司名稱
- (NSArray*)getCompanyData{
    
    //承銷商之下的所有上市公司完整資料
    NSArray *aArray = [_industryDic objectForKey:_industryTF.text];
    //用來存上市公司
    NSMutableArray *companyArray= [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < aArray.count ; i++){
        
        NSDictionary *dic = aArray[i];
        NSString *company = [dic objectForKey:@"公司名稱"];
        
        [companyArray addObject:company];
    };
    return companyArray;
}

//取得公司名稱後,在取得公司細項
- (NSMutableDictionary*) getCompanyInfo:(NSInteger)row{
    
    NSArray *aArray = [_industryDic objectForKey:_industryTF.text];
    NSMutableDictionary *dic = aArray[row];
    
    //NSLog(@"%ld", (long)row);
    
    return dic;
}


- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component { 
    if (pickerView == _picker){
        NSArray *keyArray = [_industryDic allKeys];
        return keyArray.count;
    }else{
        NSArray *companyArray= [[NSMutableArray alloc] initWithArray:[self getCompanyData]];
        return companyArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSArray *keyArray = [_industryDic allKeys];
    
    if(thePickerView == _picker){
        return  keyArray[row];
    }else {
        NSArray *companyArray= [[NSMutableArray alloc] initWithArray:[self getCompanyData]];
        return companyArray[row];
    }
}

- (void)pickerView:(UIPickerView *)thePickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    
    NSArray *keyArray = [_industryDic allKeys];
    
    if(thePickerView == _picker){
        _industryTF.text = keyArray[row];
    }else {
        NSArray *companyArray= [[NSMutableArray alloc] initWithArray:[self getCompanyData]];
        _nameTF.text = companyArray[row];
        
        _companyInfoDic = [self getCompanyInfo:row];
        [_myTableView reloadData];
    }
}

//設定tableview有多少區段
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

//設定tableview有多少列
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

@end
