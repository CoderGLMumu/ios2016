
#import "GLButton.h"

@implementation GLButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
//        [self setTitleColor:[UIColor hx_colorWithHexRGBAString:@"1976d2"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor hx_colorWithHexRGBAString:@"222222"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.gly_y = 0;
    self.imageView.glcx_centerX = self.glw_width * 0.5;
    self.imageView.glw_width = self.glw_width * 0.6;
    self.imageView.glh_height = self.glh_height * 0.6;
    
    self.titleLabel.glw_width = self.glw_width;
    self.titleLabel.gly_y = CGRectGetMaxY(self.imageView.frame) + 10;
    self.titleLabel.glx_x = 0;
    self.titleLabel.glh_height = self.glh_height - self.titleLabel.gly_y;
    
    self.imageView.glcx_centerX = self.glw_width * 0.5;
}

@end
