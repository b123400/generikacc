//
//  SettingsViewController.m
//  generika
//
//  Created by Yasuhiro Asaka on 08/05/13.
//  Copyright (c) 2013 ywesee GmbH. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsDetailViewController.h"

static const float kCellHeight = 44.0; // default = 44.0

@interface SettingsViewController ()

@property (nonatomic, strong, readwrite) SettingsDetailViewController *settingsDetail;
@property (nonatomic, strong, readwrite) NSUserDefaults *userDefaults;
@property (nonatomic, strong, readwrite) UITableView *settingsView;
@property (nonatomic, strong, readwrite) NSArray *entries;

@end

@implementation SettingsViewController

@synthesize settingsDetail = _settingsDetail;
@synthesize userDefaults = _userDefaults;
@synthesize settingsView = _settingsView;
@synthesize entries = _entries;

- (id)init
{
  self = [super initWithNibName:nil
                         bundle:nil];
  _userDefaults = [NSUserDefaults standardUserDefaults];
  _entries = [NSArray arrayWithObjects:@"Search", @"Language", nil];
  return self;
}

- (void)dealloc
{
  _userDefaults = nil;
  _entries      = nil;
  [self didReceiveMemoryWarning];
}

- (void)didReceiveMemoryWarning
{
  if ([self isViewLoaded] && [self.view window] == nil) {
    _settingsView   = nil;
    _settingsDetail = nil;
  }
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.settingsView reloadData];
  [super viewWillAppear:animated];
}

- (void)loadView
{
  [super loadView];
  CGRect screenBounds = [[UIScreen mainScreen] bounds];
  self.settingsView = [[UITableView alloc] initWithFrame:screenBounds style:UITableViewStyleGrouped];
  self.settingsView.delegate = self;
  self.settingsView.dataSource = self;
  self.settingsView.rowHeight = kCellHeight;
  self.view = self.settingsView;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"close"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(closeSettings)];
  self.navigationItem.leftBarButtonItem = closeButton;
}


#pragma mark - Action

- (void)closeSettings
{
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return kCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  CGRect headerRect = CGRectMake(0, 0, 300, 40);  
  UIView *headerView = [[UIView alloc] initWithFrame:headerRect];
  headerView.backgroundColor = [UIColor clearColor];
  UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 5.0, 300.0, 45.0)];
  sectionLabel.font = [UIFont boldSystemFontOfSize:18.0];
  sectionLabel.textAlignment = kTextAlignmentLeft;
  sectionLabel.textColor = [UIColor blackColor];
  sectionLabel.backgroundColor = [UIColor clearColor];
  switch (section) {
    case 0:
      sectionLabel.text = @"Settings";
      break;
    default:
      sectionLabel.text = @"";
      break;
  }
  [headerView addSubview:sectionLabel];
  return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"Cell";
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:cellIdentifier];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  // name
  UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 8.0, 100.0, 25.0)];
  nameLabel.font = [UIFont boldSystemFontOfSize:16.0];
  nameLabel.textAlignment = kTextAlignmentLeft;
  nameLabel.textColor = [UIColor blackColor];
  nameLabel.backgroundColor = [UIColor clearColor];
  nameLabel.text = [self.entries objectAtIndex:indexPath.row];
  [cell.contentView addSubview:nameLabel];
  // option
  UILabel *optionLabel = [[UILabel alloc] initWithFrame:CGRectMake(160.0, 8.0, 110.0, 25.0)];
  optionLabel.font = [UIFont systemFontOfSize:16.0];
  optionLabel.textAlignment = kTextAlignmentRight;
  optionLabel.textColor = [UIColor colorWithRed:0.2 green:0.33 blue:0.5 alpha:1.0];
  optionLabel.backgroundColor = [UIColor clearColor];
  NSDictionary *context = [self contextFor:indexPath];
  NSInteger selectedRow = [self.userDefaults integerForKey:[context objectForKey:@"key"]];
  optionLabel.text = [[context objectForKey:@"options"] objectAtIndex:selectedRow];
  [cell.contentView addSubview:optionLabel];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  // next
  self.settingsDetail = [[SettingsDetailViewController alloc] init];
  self.settingsDetail.title = [self.entries objectAtIndex:indexPath.row];
  NSDictionary *context = [self contextFor:indexPath];
  self.settingsDetail.options = [context objectForKey:@"options"];
  self.settingsDetail.defaultKey = [context objectForKey:@"key"];
  [self.navigationController pushViewController:self.settingsDetail animated:YES];
}

- (NSDictionary *)contextFor:(NSIndexPath *)indexPath
{
  switch (indexPath.row) {
    case 0:
      return [NSDictionary dictionaryWithObjectsAndKeys:
                              [Constant searchTypes], @"options",
                              @"search.result.type", @"key",
                              nil];
      break;
    case 1:
      return [NSDictionary dictionaryWithObjectsAndKeys:
                              [Constant searchLanguages], @"options",
                              @"search.result.lang", @"key",
                              nil];
      break;
    default:
      // unexpected
      return [NSDictionary dictionaryWithObjectsAndKeys:nil];
      break;
  }
}

@end
