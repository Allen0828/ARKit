//
//  ViewController.m
//  ARKitDemo
//
//  Created by gw_pro on 2021/9/10.
//

#import "ViewController.h"
#import "AERayCastingController.h"
#import "AEFaceViewController.h"
#import "AEImageViewController.h"
#import "AEPersonOcclusionController.h"
#import "AREyeBlinkController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *data;

@end

@implementation ViewController

- (NSArray *)data {
    if (_data == nil) {
        _data = @[@"平面监测", @"特征点监测", @"光照估计", @"射线监测", @"图象跟踪", @"3D物体监测与跟踪", @"环境光探头", @"世界地图", @"人脸跟踪(识别,姿态,网格和形状)", @"远程调试", @"人体动作捕捉", @"人形遮挡", @"多人脸监测", @"多人协作", @"多图象识别"];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds];
    table.dataSource = self;
    table.delegate = self;
    table.rowHeight = 50;
    table.tableFooterView = nil;
    [self.view addSubview:table];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.text = self.data[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > 9) {
        NSLog(@"需要 iphoneX 及以上机型");
    }
    switch (indexPath.row) {
        case 0:
            break;
        case 3:
            [self.navigationController pushViewController:[AERayCastingController new] animated:true];
            break;
        case 4:
            [self.navigationController pushViewController:[AEImageViewController new] animated:true];
            break;
            
        case 8:
            [self.navigationController pushViewController:[AEFaceViewController new] animated:true];
            break;
        case 10:
            [self.navigationController pushViewController:[AREyeBlinkController new] animated:true];
            break;
            
        case 11:
            [self.navigationController pushViewController:[AEPersonOcclusionController new] animated:true];
            break;
            
        default:
            break;
    }
    
}

@end
