//
// Created by luowei on 15/6/16.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import "CollectionSelfSizingVC.h"

@implementation CollectionSelfSizingVC {
    NSArray *strings;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *text = @"“If I were a boy again, I would practice perseverance more often, and never give up a thing \
because it was or inconvenient. If we want light, we must conquer darkness. Perseverance can sometimes equal genius in its results. \
“There are only two creatures,” says a proverb, “who can surmount the pyramids—the eagle and the snail.”";
    strings = [text componentsSeparatedByString:@" "];

//    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame
//                                         collectionViewLayout:[UICollectionViewFlowLayout new]];
//    self.collectionView.backgroundColor = [UIColor lightGrayColor];
//    [self.collectionView registerClass:[SelfSizingCell class] forCellWithReuseIdentifier:@"selfsizingcell"];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return strings.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelfSizingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"selfsizingcell" forIndexPath:indexPath];

    cell.textLabel.text = strings[(NSUInteger) indexPath.item];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"kind is:%@", kind);


    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"selfsizingheader" forIndexPath:indexPath];
}


@end


@implementation SelfSizingCell

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];

//    attributes.frame = NSString(string: textLabel.text!).boundingRectWithSize(CGSize(width: intmax_t(), height: Int(textLabel.frame.size.height)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:textLabel.font], context: nil)

    [_textLabel sizeToFit];
    attributes.frame = [_textLabel.text boundingRectWithSize:CGSizeMake(_textLabel.bounds.size.width, _textLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSShadowAttributeName : _textLabel.font} context:nil];
    return attributes;

}

@end


@implementation CollectionReusableView

@end

