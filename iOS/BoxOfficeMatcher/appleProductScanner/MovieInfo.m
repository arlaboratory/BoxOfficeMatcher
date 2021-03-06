//
//  MovieInfo.m
//  boxOfficeMatcher
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import "MovieInfo.h"


@interface MovieInfo ()

@end

@implementation MovieInfo
@synthesize titleLabel;
@synthesize poster;
@synthesize starsView;
@synthesize tagline;
@synthesize overview;
@synthesize ratingLable;
@synthesize movie;
@synthesize releaseDate;
@synthesize runtime;
@synthesize language;
@synthesize trailerLinkBTN;
@synthesize WebLinkBTN;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _stars = [[DLStarRatingControl alloc] initWithFrame:starsView.frame];
    [_stars setBounds:starsView.bounds];
    [_stars setUserInteractionEnabled:NO];
    [self.view addSubview:_stars];

	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setPoster:nil];
    [self setStarsView:nil];
    [self setTagline:nil];
    [self setOverview:nil];
    [self setRatingLable:nil];
    [self setMovie:nil];
    [self setReleaseDate:nil];
    [self setRuntime:nil];
    [self setLanguage:nil];
    [self setTrailerLinkBTN:nil];
    [self setWebLinkBTN:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Set information about the movie.
    [titleLabel setText:[movie.movieInfo objectForKey:@"name"]];

    UIImage *imagePoster = [MovieInfo imagesmall:movie.posterImage width:poster.frame.size.width height:poster.frame.size.height];
    [poster setImage:imagePoster];
    [poster setFrame:CGRectMake(poster.frame.origin.x, poster.frame.origin.y, imagePoster.size.width, imagePoster.size.height)];
        [_stars setRating:((NSString*)[movie.movieInfo objectForKey:@"rating"]).intValue];
    [tagline setText:[movie.movieInfo objectForKey:@"tagline"]];

    [overview setText:[movie.movieInfo objectForKey:@"overview"]];
    overview.editable = FALSE;
    overview.selectedTextRange = FALSE;
    [ratingLable setText:[NSString stringWithFormat:@"%d/10",((NSString*)[movie.movieInfo objectForKey:@"rating"]).intValue]];
    [releaseDate setText:(NSString*)[movie.movieInfo objectForKey:@"released"]];
    int runTimeLabel = [[movie.movieInfo objectForKey:@"runtime"]intValue];
    NSString *labelRun = [NSString stringWithFormat:@"%d",runTimeLabel];
    labelRun = [labelRun stringByAppendingString:@" min"];
    [runtime setText:labelRun];
    [language setText:(NSString*)[movie.movieInfo objectForKey:@"language"]];
    
    [titleLabel setAdjustsFontSizeToFitWidth:TRUE];

}

-(IBAction)back_touch:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)trailer_touch:(id)sender{
    NSString *link = (NSString*)[movie.movieInfo objectForKey:@"trailer"];
    UIApplication *app = [UIApplication sharedApplication];
    [app openURL:[NSURL URLWithString:link]];
}

-(IBAction)link_touch:(id)sender{
    NSString *link = (NSString*)[movie.movieInfo objectForKey:@"url"];
    UIApplication *app = [UIApplication sharedApplication];
    [app openURL:[NSURL URLWithString:link]];
}

+(UIImage*)imagesmall:(UIImage*)imagename width:(float)value1 height:(float)value2{
    
    float widthimag = imagename.size.width;
    float heightimag = imagename.size.height;
    float ref;
    float val1;
    float val2;
    
    
    if(value1>widthimag || value2>heightimag){
        val1 = widthimag;
        val2 = heightimag;
        
    }else{
        if( (widthimag/value1) > (heightimag/value2)){
            ref = (widthimag/value1);
            val1 = value1;
            val2 = (heightimag/ref);
        }else{
            ref = heightimag/value2;
            val2 = value2;
            val1 = (widthimag/ref);
        }
    }
    
    
    //Create a graphics context.
    UIGraphicsBeginImageContext(CGSizeMake(val1,val2)); 
    UIGraphicsGetCurrentContext(); 
    
    //draw the image in the desired range.
    [imagename drawInRect: CGRectMake(0, 0, val1, val2)];
    UIImage * small = UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    
    
    //take me back other image with the desired size.
    return small;
    
}

@end
