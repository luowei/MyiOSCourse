//
//  ViewController.m
//  Map-Demo
//
//  Created by luowei on 15/5/9.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ViewController.h"

typedef enum {

    None,
    Follow,
    FollowWithHeading

} UserTrackingMode;

@interface ViewController () <UISearchBarDelegate, UIActionSheetDelegate, MKMapViewDelegate>{
    BOOL showTools;
}

@property(strong, nonatomic) UISearchBar *searchBar;
@property(strong, nonatomic) UIBarButtonItem *locationItem;
@property(strong, nonatomic) UIBarButtonItem *shareItem;
@property(strong, nonatomic) UIBarButtonItem *detailItem;
@property(strong, nonatomic) UIBarButtonItem *bookMarkItem;
@property(strong, nonatomic) UIBarButtonItem *roadGudieItem;
@property(strong, nonatomic) MKMapView *mapView;
@property(assign, nonatomic) NSUInteger trackMode;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    showTools = YES;

    [self setupTopView];

    [self setupToolbar];

    _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_mapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dispearKeyboard)]];
    [self.view addSubview:_mapView];
}

- (void)setupTopView {
    _roadGudieItem = [[UIBarButtonItem alloc] initWithTitle:@"线路" style:UIBarButtonItemStyleBordered
                                                     target:self action:@selector(route:)];
    _bookMarkItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks
                                                                  target:self
                                                                  action:@selector(bookMark)];
    self.navigationItem.leftBarButtonItem = _roadGudieItem;
    self.navigationItem.rightBarButtonItem = _bookMarkItem;

    _searchBar = [UISearchBar new];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索或输入地址";
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeYes;
    self.navigationItem.titleView = _searchBar;
}


- (void)dispearKeyboard {
    [_searchBar resignFirstResponder];
    if(showTools){
        self.navigationController.navigationBar.hidden = YES;
        self.navigationController.toolbar.hidden = YES;
    }else{
        self.navigationController.navigationBar.hidden = NO;
        self.navigationController.toolbar.hidden = NO;
    }
    showTools = !showTools;
}


- (void)setupToolbar {
    _locationItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"location"]
                                                     style:UIBarButtonItemStyleBordered
                                                    target:self
                                                    action:@selector(location:)];
    _shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                               target:self
                                                               action:@selector(share:)];
    _detailItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"detail"]
                                                   style:UIBarButtonItemStyleBordered
                                                  target:self
                                                  action:@selector(detail:)];

    UIBarButtonItem *flexibleSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *flexibleSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    self.toolbarItems = @[_locationItem, flexibleSpace1, _shareItem, flexibleSpace2, _detailItem];
}


- (void)route:(id)route {
    [[[UIAlertView alloc] initWithTitle:nil message:@"线路 click!"
                               delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
}

- (void)bookMark {
    [[[UIAlertView alloc] initWithTitle:nil message:@"bookMark click!"
                               delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
}


- (void)location:(id)location {
    //这段代码用于搜索位置然后定位
    //用下面的方法来指定一个坐标
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 31.2298711;//纬度
    coordinate.longitude = 121.483221;//经度
    //下面的方法用来确定定位的精准度
    MKCoordinateSpan span = {0, 0};//数值越小，越精确，反之越模糊
    //定位的区域
    MKCoordinateRegion region;
    //通过上述定义的两个值来确定区域的位置和定义的精准度
    region = MKCoordinateRegionMake(coordinate, span);
    //设置这样的参数可以实现定位时的动画效果
    [_mapView setRegion:region animated:YES];

    switch (_trackMode) {
        case None: {
            [_locationItem setImage:[UIImage imageNamed:@"location"]];
            [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
            _trackMode = Follow;
        }
            break;
        case Follow: {
            [_locationItem setImage:[UIImage imageNamed:@"compass"]];
            [_mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
            _trackMode = FollowWithHeading;
        }
            break;
        case FollowWithHeading: {
            [_locationItem setImage:[UIImage imageNamed:@"position"]];
            [_mapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
            _trackMode = None;
        }
            break;

        default:
            break;
    }
}

- (void)share:(id)share {
    [[[UIAlertView alloc] initWithTitle:nil message:@"share click!"
                               delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
}

- (void)detail:(id)detail {
    UIActionSheet *changeMapSytleActionSheet = [[UIActionSheet alloc]
            initWithTitle:@""
                 delegate:self
        cancelButtonTitle:@"更多参考:http://luowei.github.com"
   destructiveButtonTitle:@"标准"
        otherButtonTitles:@"卫星", @"混合", nil];
    [changeMapSytleActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            _mapView.mapType = MKMapTypeStandard;
        }
            break;
        case 1: {
            _mapView.mapType = MKMapTypeSatellite;
        }
            break;
        case 2: {
            _mapView.mapType = MKMapTypeHybrid;
        }
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
