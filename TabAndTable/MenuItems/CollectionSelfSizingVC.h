//
// Created by luowei on 15/6/16.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CollectionSelfSizingVC : UICollectionViewController



@end


@interface SelfSizingCell:UICollectionViewCell

@property(nonatomic, strong) UILabel * textLabel;

@end

@interface CollectionReusableView: UICollectionReusableView

@end