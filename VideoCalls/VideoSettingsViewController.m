//
//  VideoSettingsViewController.m
//  VideoCalls
//
//  Created by Ivan Sein on 15.03.18.
//  Copyright © 2018 struktur AG. All rights reserved.
//

#import "VideoSettingsViewController.h"

#import "NCSettingsController.h"
#import "VideoResolutionsViewController.h"

typedef enum VideoSettingsSection {
    kVideoSettingsSectionResolution = 0,
    kVideoSettingsSectionDefaultVideo,
    kVideoSettingsSectionCount
} VideoSettingsSection;

@interface VideoSettingsViewController ()
{
    UISwitch *_videoDisabledSwitch;
}

@end

@implementation VideoSettingsViewController

- (instancetype)init
{
    self = [super initWithStyle:(UITableViewStyle)UITableViewStyleGrouped];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Video calls";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _videoDisabledSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [_videoDisabledSwitch addTarget: self action: @selector(videoDisabledValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kVideoSettingsSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case kVideoSettingsSectionResolution:
            return @"Quality";
            break;
            
        case kVideoSettingsSectionDefaultVideo:
            return @"Settings";
            break;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    static NSString *kVideoResolutionCellIdentifier = @"VideoResolutionCellIdentifier";
    static NSString *kDefaultVideoToggleCellIdentifier = @"DefaultVideoToggleCellIdentifier";
    
    switch (indexPath.section) {
        case kVideoSettingsSectionResolution:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kVideoResolutionCellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kVideoResolutionCellIdentifier];
            }
            
            cell.textLabel.text = @"Video resolution";
            NSString *resolution = [[[NCSettingsController sharedInstance] videoSettingsModel] currentVideoResolutionSettingFromStore];
            cell.detailTextLabel.text = [[[NCSettingsController sharedInstance] videoSettingsModel] readableResolution:resolution];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case kVideoSettingsSectionDefaultVideo:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kDefaultVideoToggleCellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDefaultVideoToggleCellIdentifier];
            }
            
            cell.textLabel.text = @"Video disabled on start";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            BOOL videoDisabled = [[[NCSettingsController sharedInstance] videoSettingsModel] videoDisabledSettingFromStore];
            [_videoDisabledSwitch setOn:videoDisabled];
            cell.accessoryView = _videoDisabledSwitch;
        }
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case kVideoSettingsSectionResolution:
        {
            VideoResolutionsViewController *videoResolutionsVC = [[VideoResolutionsViewController alloc] init];
            [self.navigationController pushViewController:videoResolutionsVC animated:YES];
        }
            break;
        case kVideoSettingsSectionDefaultVideo:
            break;
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Video disabled switch

- (void)videoDisabledValueChanged:(id)sender
{
    BOOL videoDisable = _videoDisabledSwitch.on;
    [[[NCSettingsController sharedInstance] videoSettingsModel] storeVideoDisabledDefault:videoDisable];
}


@end
