//
//  MainViewController.m
//  boxOfficeMatcher
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import "MainViewController.h"

#define dateKey @"dateKey"

@interface MainViewController ()
{
    
}
@end

@implementation MainViewController

@synthesize moviesHandler;
@synthesize myProgressView;
@synthesize alert;
@synthesize updateMovies;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tabBar setSelectedImageTintColor:[UIColor whiteColor]];

    //Create notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAlert:) name:@"RemoveAlert" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initializeProgressView:) name:@"InitializeProgress" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incrementProgressView:) name:@"MovieAdded" object:nil];

    //Create UIProgressView
    myProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(xStartProgress,yStartProgress ,WidthProgress ,HeightProgress )];
    myProgressView.progressViewStyle = UIProgressViewStyleDefault;
    myProgressView.progress = 0.0;
    myProgressView.trackTintColor = [UIColor whiteColor];
    myProgressView.progressTintColor = [UIColor blueColor];
    alert = [[UIAlertView alloc] initWithTitle:nil message:@"Download posters..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    
    //Add UIProgressView to UIAlert
    [alert addSubview:myProgressView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xStartLabel1, yStartLabel1, WidthLabel1, HeightLabel1)]; 
    label.backgroundColor = [UIColor clearColor]; 
    label.textColor = [UIColor whiteColor]; 
    label.font = [UIFont systemFontOfSize:SizeLabel]; 
    label.text = @""; 
    label.tag = 2; 
    [alert addSubview:label]; 
    
    UIImageView *imageCamera = [[UIImageView alloc] initWithFrame:CGRectMake(xStartImage, yStartImage, WidthImage, HeightImage)];
    NSArray *images;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        images = [NSArray arrayWithObjects:[UIImage imageNamed:@"splash_animation01.png"],
                                        [UIImage imageNamed:@"splash_animation02.png"],
                                        [UIImage imageNamed:@"splash_animation03.png"],
                                        [UIImage imageNamed:@"splash_animation04.png"],
                                        [UIImage imageNamed:@"splash_animation01.png"],
                                        [UIImage imageNamed:@"splash_animation02.png"],
                                        [UIImage imageNamed:@"splash_animation03.png"],
                                        [UIImage imageNamed:@"splash_animation04.png"],nil];
    else 
        images = [NSArray arrayWithObjects:[UIImage imageNamed:@"splash_animation01_ipad.png"],
                  [UIImage imageNamed:@"splash_animation02_ipad.png"],
                  [UIImage imageNamed:@"splash_animation03_ipad.png"],
                  [UIImage imageNamed:@"splash_animation04_ipad.png"],
                  [UIImage imageNamed:@"splash_animation01_ipad.png"],
                  [UIImage imageNamed:@"splash_animation02_ipad.png"],
                  [UIImage imageNamed:@"splash_animation03_ipad.png"],
                  [UIImage imageNamed:@"splash_animation04_ipad.png"],nil];

              
    imageCamera.animationImages = images;
    imageCamera.animationDuration = 1;
    imageCamera.animationRepeatCount = 0;
    
    [alert addSubview:imageCamera];
    [imageCamera startAnimating];

    [alert show];
    
    [self initMoviesHandler];

}

-(void)initMoviesHandler{
    
    moviesHandler = [[moviesDataHandler alloc] init];
    
    //Get date from NSUserDefaults if it exists and get movies
    NSDate *myDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:dateKey];
    currentDate = [NSDate date];
    if (myDate == nil || [currentDate timeIntervalSinceDate:myDate]/360 >= 24) {
        [self performSelectorInBackground:@selector(downloadPosters) withObject:nil];
    }else {
        [moviesHandler performSelectorInBackground:@selector(reloadMoviesFromDB) withObject:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
}

-(void)initializeProgressView:(NSNotification*)notification{
    image = 0;
    NSNumber *numb = [notification object];
    totalImages = [numb intValue];
    stepProgress = 1.0/(totalImages);
}

-(void)incrementProgressView:(NSNotification*)notification{
    [self performSelectorOnMainThread:@selector(incrementeProgress) withObject:nil waitUntilDone:YES];
}

-(void)incrementeProgress{
    image = image+1;
    //Increments UIProgressView
    myProgressView.progress = myProgressView.progress + stepProgress;
    UILabel *label = (UILabel *)[alert viewWithTag:2];
    label.text = [NSString stringWithFormat:@"%d%%",image*100/totalImages];
}

-(void)removeAlert:(NSNotification*)notification{
    [self performSelectorOnMainThread:@selector(QuitAlert) withObject:notification waitUntilDone:YES];
}

-(void)QuitAlert{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    UILabel *label = (UILabel *)[alert viewWithTag:2];
    label.text = @"";
    myProgressView.progress = 0.0;
}

-(void)downloadPosters{
    BOOL returnOK = [moviesHandler updateMovies];
    if(returnOK)
        [self performSelectorOnMainThread:@selector(updateDate) withObject:nil waitUntilDone:YES];
}

-(void)updateDate{
    //Save date in NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:dateKey]; 
}
         
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setAlert:nil];
    [self setUpdateMovies:0];
    [self setMoviesHandler:nil];
    [self setMyProgressView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
