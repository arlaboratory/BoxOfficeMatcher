//
//  MovieCell.m
//  boxOfficeMatcher
//
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

@synthesize stars;
@synthesize rating;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        NSLog(@"%f %f %f %f",self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        UIImageView *background = [[UIImageView alloc] init];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            stars = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(70, self.frame.size.height, 170,20)];
            _ratingLable = [[UILabel alloc] initWithFrame:CGRectMake(245, self.frame.size.height, 50, 20)];
            [_ratingLable setFont:[UIFont fontWithName:@"Arial-BoldMT" size:11]];
            [background setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 71)];
            [background setImage:[UIImage imageNamed:@"movie_block_background.png"]];
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 71);
        }else{
            stars = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(70, self.frame.size.height+15, 150,20)];
            _ratingLable = [[UILabel alloc] initWithFrame:CGRectMake(225, self.frame.size.height+10, 100, 40)];
            [_ratingLable setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
            [background setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 90)];
            [background setImage:[UIImage imageNamed:@"movie_block_background_iPad.png"]];
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 90);
        }
        [self addSubview:background];
        [self sendSubviewToBack:background];
        [stars setUserInteractionEnabled:NO];
        stars.backgroundColor = [UIColor clearColor];
        [self addSubview:stars];
        [_ratingLable setTextColor:[UIColor darkGrayColor]];
        [_ratingLable setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_ratingLable];
    }
    return self;
}

-(void)setRating:(int)rate
{
    rating = rate;
    [_ratingLable setText:[NSString stringWithFormat:@"%d/10",rate]];
    [stars setRating:rate];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
