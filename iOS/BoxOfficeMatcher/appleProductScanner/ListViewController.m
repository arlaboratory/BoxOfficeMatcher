//
//  ListViewController.m
//  boxOfficeMatcher
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController
@synthesize mytable;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInfo:) name:@"ShowInfoMovie" object:nil];
    [super viewDidLoad];
    mainController = (MainViewController*)self.parentViewController.parentViewController;
	// Do any additional setup after loading the view.
    
    //Create table
    mytable = [[TableViewController alloc] myInit];    
    mytable._moviesArray = mainController.moviesHandler.movies;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [mytable.tableView setFrame:CGRectMake(0, yStartTable_iPhone, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-yStartTable_iPhone-20)];
    }else{
        [mytable.tableView setFrame:CGRectMake(0, yStartTable_iPad, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-yStartTable_iPad-20)];
    }
    [self.view addSubview:mytable.view];
}

-(void)viewDidAppear:(BOOL)animated{
    mytable._moviesArray = mainController.moviesHandler.movies;
    [mytable.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setMytable:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)updateMovies:(id)sender{
    [mainController.alert show];
    mainController.updateMovies = TRUE;
    [self performSelectorInBackground:@selector(downloadMovies) withObject:nil];
}

-(void)downloadMovies{
    [mainController.moviesHandler updateMovies];
    [self performSelectorOnMainThread:@selector(refreshData) withObject:nil waitUntilDone:YES];
}

-(void)refreshData{
    mytable._moviesArray = mainController.moviesHandler.movies;
    [mytable.tableView reloadData];
    mainController.updateMovies = FALSE;
}

-(void)showInfo:(NSNotification *)notification{
    NSNumber *number = [notification object];
    indice = [number intValue];
    [self performSegueWithIdentifier:@"listMovieInfo" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"listMovieInfo"]){
        Movie* mov = [mytable._moviesArray objectAtIndex:indice];
        //MovieInfo* movieInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"movieInfo"];
        [[segue destinationViewController] setMovie:mov];
        [[[segue destinationViewController] navigationItem] setTitle:[mov.movieInfo objectForKey:@"name"]];
    }
}

@end
