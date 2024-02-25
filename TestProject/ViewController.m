//
//  ViewController.m
//  TestProject
//
//  Created by 解庚霖 on 2023/11/7.
//

#import "ViewController.h"

@interface ViewController ()
{
        
    NSMutableDictionary *_underWriterDic;
    
    UIPickerView *_picker;
    UIPickerView *_picker2;
    
    NSMutableDictionary *_companyInfoDic;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getUrlData];
    
    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [_picker setDataSource: self];
    [_picker setDelegate: self];
    _areaTF.inputView = _picker;
    
    _picker2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [_picker2 setDataSource: self];
    [_picker2 setDelegate: self];
    _weekTF.inputView = _picker2;
    
    //不能重複利用
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap)];
    [self.view addGestureRecognizer:singleFingerTap];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
}

//設定tableview有多少區段
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

//設定tableview有多少列
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    "Code":"6906",  股票代碼
//
//    "Company":"現觀科", 公司名稱
//
//    "ApplicationDate":"1120731", 申請日期
//
//    "Chairman":"邱大剛", 董事長
//
//    "ApprovedListingDate":"1130115", 上市日期
//
//    "Underwriter":"台新", 承銷商
//
//    "UnderwritingPrice":"118.00", 股票價格
//
//    "Note":"科技事業” 公司類別
    NSString *msg = @"";
    
    switch([indexPath row]) {
       case 0 :
            msg = [self cellStrCheck:@"股票代碼: " key:@"Code"];
          break;
       case 1 :
            msg = [self cellStrCheck:@"公司名稱: " key:@"Company"];
          break;
       case 2 :
            msg = [self cellStrCheck:@"申請日期: " key:@"ApplicationDate"];
          break;
       case 3 :
            msg = [self cellStrCheck:@"董事長: " key:@"Chairman"];
          break;
       case 4 :
            msg = [self cellStrCheck:@"上市日期: " key:@"ApprovedListingDate"];
          break;
        case 5 :
            msg = [self cellStrCheck:@"承銷商: " key:@"Underwriter"];
           break;
        case 6 :
            msg = [self cellStrCheck:@"股票價格: " key:@"UnderwritingPrice"];
           break;
        case 7 :
            msg = [self cellStrCheck:@"公司類別: " key:@"Note"];
           break;
       default :
          NSLog(@"資料空\n" );
       }
    
        
    
    cell.textLabel.text = msg;
        return cell;
    
}

//The event handling method
- (void)handleSingleTap {
    
    [_areaTF endEditing:TRUE];
    [_weekTF endEditing:TRUE];
    
}

- (NSString*)cellStrCheck:(NSString*)listName
                      key:(NSString*)key{
    
    NSString *msg = @"";
    
    msg = [NSString stringWithFormat:@"%@%@",listName,
           [_companyInfoDic objectForKey:key] ? [_companyInfoDic objectForKey:key] : @""];
    
    return msg;
}

- (void)getUrlData {
    
    // Initializing an NSURL object with the specified URL string
    NSURL *url = [NSURL URLWithString:@"https://openapi.twse.com.tw/v1/company/newlisting"];
    
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
            
            NSMutableDictionary *underWriterDic = [[NSMutableDictionary alloc] init];
            
            //baseArray 跑for迴圈，依照index撈出該index的dictionary，再從該dictionary的key “Underwriter”撈出值，並用該Underwriter值分類資料
            for (NSInteger i = 0; i < baseArray.count ; i++)
            {
                NSDictionary *dic = baseArray[i];
                
                NSString *underWriter = [dic objectForKey:@"Underwriter"];
                
                //發現新的Underwriter時，用新的Underwriter當key存一個新的dictionary，dictionary value也儲存一個新的array
                if([underWriterDic objectForKey:underWriter] == FALSE){
                    
                    NSMutableArray *underWriterArray = [[NSMutableArray alloc] init];
                    [underWriterArray addObject:dic];
                    [underWriterDic setValue:underWriterArray forKey:underWriter];
                    
                }
                //發現是既有的Underwriter時，用Underwriter當key把dicionary挖出來更新該dictionary儲存的array
                else
                {
                    
                    NSMutableArray *underWriterArray = [underWriterDic objectForKey:underWriter];
                    [underWriterArray addObject:dic];
                    [underWriterDic setValue:underWriterArray forKey:underWriter];
                    
                }
                
            }
            self->_underWriterDic = underWriterDic;
            NSLog(@"e04:%@",underWriterDic.description);
            
            
        }
    }];
    
    // Start or resume the data task
    [dataTask resume];
    
}

//取得同個承銷商之下的上市公司名稱
- (NSArray*)getCompanyData{
    
    //承銷商之下的所有上市公司完整資料
    NSArray *aArray = [_underWriterDic objectForKey:_areaTF.text];
    //用來存上市公司
    NSMutableArray *companyArray= [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < aArray.count ; i++){
        
        NSDictionary *dic = aArray[i];
        NSString *company = [dic objectForKey:@"Company"];
        
        [companyArray addObject:company];
    };
    return companyArray;
}

//取得上市公司後,在取得公司細項
- (NSMutableDictionary*) getCompanyInfo:(NSInteger)row{
    
    NSArray *aArray = [_underWriterDic objectForKey:_areaTF.text];
    NSMutableDictionary *dic = aArray[row];
    
    //NSLog(@"%ld", (long)row);
    
    return dic;
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView == _picker){
        NSArray *keyArray = [_underWriterDic allKeys];
        return keyArray.count;
    }else{
        NSArray *companyArray= [[NSMutableArray alloc] initWithArray:[self getCompanyData]];
        return companyArray.count;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSArray *keyArray = [_underWriterDic allKeys];
    
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
    
    NSArray *keyArray = [_underWriterDic allKeys];
    
    if(thePickerView == _picker){
        _areaTF.text = keyArray[row];
    }else {
        NSArray *companyArray= [[NSMutableArray alloc] initWithArray:[self getCompanyData]];
        _weekTF.text = companyArray[row];
        
        _companyInfoDic = [self getCompanyInfo:row];
        [_myTableView reloadData];
    }
}



@end
