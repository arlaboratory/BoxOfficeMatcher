//
//  ViewController.m
//  appleProductScanner
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import "ViewController.h"
#import "moviesDataHandler.h"
#import "movie.h"
#import "MovieInfo.h"

#define PAINTINGS_FOLDER @"paintings"

@interface ViewController ()

@end

@implementation ViewController
@synthesize updateBTN;

static BOOL PopUpActive;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PopUpActive = TRUE;

    //Initialize cvSDK.
    _cvView = [[cvSDK alloc] initWithAppKey:API_KEY useDefaultCamera:YES];
    [_cvView setDelegate:self];
    [_cvView setImagePoolMinimumRating:10];
    [_cvView setEnableMedianFilter:YES];
    [_cvView setMatchMode:matcher_mode_Image];
    
    [_cvView.view setFrame:_matchView.frame];
    [_matchView addSubview:_cvView.view];
    [_matchView sendSubviewToBack:_cvView.view];

    //Initialize view with stars and rating of the movie.
    _stars = [[DLStarRatingControl alloc] init];
    [_stars setBounds:_starsView.bounds];
    [_stars setFrame:CGRectMake(0, 0, 167, 20)];
    [_stars setUserInteractionEnabled:NO];
    [_starsView addSubview:_stars];
    
    _popupView.alpha = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"MovieAdded" object:nil];    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteImagesOfLibrary:) name:@"DeleteImages" object:nil];    


    mainController = (MainViewController*)self.parentViewController.parentViewController;
    
    _moviesArray = mainController.moviesHandler.movies;
    
}

- (void)handleNotification:(NSNotification*)note {
    BOOL resultAdd=FALSE;
    NSDate *myDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"dateKey"];
    NSDate *currentDate = [NSDate date];
    //Add images into the library.
    if (myDate == nil || ([currentDate timeIntervalSinceDate:myDate]/360 >= 24) ||     mainController.updateMovies) {
        NSDictionary *auxDictionary = [note object];
        NSString* posterPath = [auxDictionary objectForKey:@"poster_path"];
        NSString* posterurlString = [NSString stringWithFormat:@"%@%@",tmdImageURL,posterPath];
        NSURL* posterurl = [[NSURL alloc] initWithString:posterurlString];
        NSData* posterdat = [[NSData alloc] initWithContentsOfURL:posterurl];
        UIImage* posterImage=[UIImage imageWithData:posterdat];
        if(posterdat!=nil&&posterImage!=nil){
            int movieId = [[auxDictionary objectForKey:@"id"]intValue];
            resultAdd = [_cvView addImage:[UIImage imageWithData:posterdat] withUniqeID:[NSNumber numberWithInt:movieId]];
            if(resultAdd){
                [mainController.moviesHandler writeFiles:auxDictionary];
            }
        }
        
    }else{
        if(((Movie*)note.object).posterImage!=nil)
        resultAdd = [_cvView addImage:((Movie*)note.object).posterImage withUniqeID:[NSNumber numberWithInt:((Movie*)note.object).movieId]];
        
        if(resultAdd){
            [mainController.moviesHandler insertObject:((Movie*)note.object)];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [_cvView start];
    PopUpActive = TRUE;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [_cvView stop];
    [self hidePopup];
    PopUpActive = FALSE;
}

- (void)viewDidUnload
{
    _matchView = nil;
    _popupView = nil;
    _popupLable = nil;
    _popupImg = nil;
    _starsView = nil;
    _ratingLable = nil;
    _cvView = nil;
    _moviesArray = nil;
    _stars = nil;
    _currentMovie = nil;
    mainController = nil;
    [self setUpdateBTN:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark popup animations

-(void)hidePopup
{
    [UIView animateWithDuration:0.5 animations:^{
        _popupView.alpha = 0;
    }];
    [_popupView removeFromSuperview];
}

-(void)showPopup
{
    [UIView animateWithDuration:0.5 animations:^{
        _popupView.alpha = 1;
    }];
    [self.view addSubview:_popupView];
}

#pragma mark matcher delegate

-(void)imageMatched:(int)uId
{
    [self performSelectorOnMainThread:@selector(showMoviePopup:) withObject:[NSNumber numberWithInt:uId] waitUntilDone:NO];
}

-(void)showMoviePopup:(NSNumber*)movieId
{
    int uId = movieId.intValue;
    if (uId >= 0) {
        //When the library identifies an image, appears a popup with information about these film.
        for (Movie* mov in _moviesArray) {
            if (mov.movieId == uId) {
                _currentMovie = mov;
                
                [self showPopup];

                int  stringValue = [(NSString*)[mov.movieInfo objectForKey:@"rating"] intValue];
                NSString *value = [[NSString stringWithFormat:@"%d",stringValue] stringByAppendingString:@"/10"];
                [_ratingLable setText:value];
                _ratingLable.textColor = [UIColor whiteColor];
                [_popupLable setText:[mov.movieInfo objectForKey:@"name"]];
                [_stars setRating:((NSString*)[mov.movieInfo objectForKey:@"rating"]).intValue];
                [_popupImg setImage:mov.posterImage];
                    
            }
        }
    }else{
        [self hidePopup];
    }
}

- (IBAction)popupClicked:(id)sender {
    [self performSegueWithIdentifier:@"scanInfo" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"scanInfo"]){
        //MovieInfo* movieInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"movieInfo"];
        [[segue destinationViewController] setMovie:_currentMovie];
        [[[segue destinationViewController] navigationItem] setTitle:[_currentMovie.movieInfo objectForKey:@"name"]];
    }
}

-(void)updateMovies:(id)sender{
    [_cvView stop];
    mainController.updateMovies = TRUE;
    [mainController.alert show];
    [self performSelectorInBackground:@selector(downloadMovies) withObject:nil];
}

-(void)downloadMovies{
    [mainController.moviesHandler updateMovies];
    [self performSelectorOnMainThread:@selector(refreshData) withObject:nil waitUntilDone:YES];
}

-(void)refreshData{
    _moviesArray = mainController.moviesHandler.movies;
    [_cvView start];
    mainController.updateMovies = FALSE;
}

-(void)deleteImagesOfLibrary:(NSNotification*)notification{
    [self performSelectorOnMainThread:@selector(removeImages) withObject:nil waitUntilDone:YES];
}

-(void)removeImages{
    //Remove images of the library.
    NSArray *auxArray = mainController.moviesHandler.movies;
    for(int i=0; i<[auxArray count]; i++){
        Movie *auxMovie = [auxArray objectAtIndex:i];
        int indiceMovie = auxMovie.movieId;
        [_cvView removeImage:[[NSNumber alloc] initWithInt:indiceMovie]];
    }
}

+(bool)getPopUpActive{
    return PopUpActive;
}
@end
