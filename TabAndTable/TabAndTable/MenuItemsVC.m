//
// Created by luowei on 15/6/15.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import "MenuItemsVC.h"


@implementation MenuItemsVC {

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        UIView *selectionView = [[UIView alloc] initWithFrame:cell.bounds];
        selectionView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
        [cell setSelectedBackgroundView:selectionView];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Row %ld", (long)indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


@end