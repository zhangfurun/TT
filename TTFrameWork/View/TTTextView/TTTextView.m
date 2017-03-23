//
//  TTTextView.m
//  TT
//
//  Created by 张福润 on 2017/3/23.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTTextView.h"
#import "UIView+TTSuperView.h"

@interface TTTextView()
@property (strong, nonatomic) UILabel *placeHolderLabel;
@end

@implementation TTTextView

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.placeHolderLabel.x = 5;
    self.placeHolderLabel.y = 8;
    self.placeHolderLabel.width = self.width - self.placeHolderLabel.x * 2.0;
    
    //计算文字占用高度
    CGSize maxSize = CGSizeMake(self.width, CGFLOAT_MAX);
    self.placeHolderLabel.height = [self.placeHolerText boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placeHolderLabel.font} context:nil].size.height;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:UITextViewTextDidChangeNotification];
}

#pragma mark - Method
- (void)initialization{
    self.backgroundColor = [UIColor clearColor];
    UILabel *holderLabel = [[UILabel alloc] init];
    holderLabel.backgroundColor = [UIColor clearColor];
    holderLabel.numberOfLines = 0;
    [self addSubview:holderLabel];
    self.placeHolderLabel = holderLabel;
    self.placeHolderLabel.textColor = [UIColor lightGrayColor];
    [self setFont:[UIFont systemFontOfSize:15.0f]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textDidChange{
    _placeHolderLabel.hidden = self.hasText;
}

- (void)setPlaceHolerText:(NSString *)placeHolerText{
    _placeHolerText = [placeHolerText copy];
    _placeHolderLabel.text = placeHolerText;
    //重新计算子控件frame
    [self setNeedsDisplay];
}

- (void)setPlaceHolerTextColor:(UIColor *)placeHolerTextColor{
    _placeHolerTextColor = placeHolerTextColor;
    _placeHolderLabel.textColor = placeHolerTextColor;
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    self.placeHolderLabel.font = font;
    //重新计算子控件frame
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text{
    [super setText:text];
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    [self textDidChange];
}

@end

