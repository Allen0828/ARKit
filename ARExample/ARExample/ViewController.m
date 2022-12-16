//
//  ViewController.m
//  ARExample
//
//  Created by allen0828 on 2022/11/23.
//

#import <ARKit/ARKit.h>
#import "ViewController.h"

#import "ARPlaneController.h"
#import "ARMetalController.h"
#import "ARBodyController.h"
#import "DeWuViewController.h"
#import "ARImageController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) NSArray *data;

@end

@implementation ViewController

- (NSArray *)data
{
    if (_data == nil)
    {
        _data = @[@"平面监测", @"使用metal渲染", @"骨骼监测", @"仿得物试衣间", @"图片检测"];
    }
    return _data;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds];
    table.dataSource = self;
    table.delegate = self;
    table.rowHeight = 50;
    table.tableFooterView = nil;
    [self.view addSubview:table];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.text = self.data[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!ARConfiguration.isSupported)
    {
        NSLog(@"此设备不支持AR ⚠️⚠️⚠️ This device does not support AR");
        return;
    }

    switch (indexPath.row)
    {
        case 0:
        {
            if (!ARWorldTrackingConfiguration.isSupported)
            {
                NSLog(@"此设备不支持AR平面监测⚠️This device does not support ARWorldTracking");
                return;
            }
            [self.navigationController pushViewController:[ARPlaneController new] animated:true];
            break;
        }
        case 1:
        {
            if (!ARWorldTrackingConfiguration.isSupported)
            {
                NSLog(@"此设备不支持AR平面监测⚠️This device does not support ARWorldTracking");
                return;
            }
            [self.navigationController pushViewController:[ARMetalController new] animated:true];
            break;
        }
        case 2:
        {
            if (@available(iOS 13.0, *)) {
                if (!ARBodyTrackingConfiguration.isSupported)
                {
                    NSLog(@"⚠️This device does not support ARBodyTrackingConfiguration");
                    return;
                }
                [self.navigationController pushViewController:[ARBodyController new] animated:true];
            } else {
                NSLog(@"⚠️This device does not support ARBodyTrackingConfiguration");
            }
            break;
        }
        case 3:
        {
            if (@available(iOS 13.0, *)) {
                if (!ARBodyTrackingConfiguration.isSupported)
                {
                    NSLog(@"⚠️This device does not support ARBodyTrackingConfiguration");
                    return;
                }
                [self.navigationController pushViewController:[DeWuViewController new] animated:true];
            } else {
                NSLog(@"⚠️This device does not support ARBodyTrackingConfiguration");
            }
            break;
        }
        case 4:
        {
            [self.navigationController pushViewController:[ARImageController new] animated:true];
            break;
        }
        default:
            break;
    }
    
}

@end
