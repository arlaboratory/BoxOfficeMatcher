//
//  TableViewController.m
//  boxOfficeMatcher
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import "TableViewController.h"
#import "MovieInfo.h"
#import "DLStarRatingControl.h"

@interface TableViewController ()

@end

@implementation TableViewController
@synthesize _moviesArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _moviesArray = [[NSArray alloc] init];
    
}

-(id)myInit
{
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    self.tableView.opaque = FALSE;
    
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_moviesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            [cell.imageView setImage:[UIImage imageNamed:@"movie_block_background.png"]];
            //[cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, ROW_iPhone)];
        }else{
            [cell.imageView setImage:[UIImage imageNamed:@"movie_block_background_ipad.png"]];
            //[cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, ROW_iPad)];
        }
        
        cell.imageView.contentMode = UIViewContentModeScaleToFill;

        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            [cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, ROW_iPhone)];
        else
            [cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, ROW_iPad)];
        
        UILabel *label;
        UIImageView *posterImage;
        DLStarRatingControl *stars;
        
        CGRect rect;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            rect = CGRectMake(xStartTitle_iPhone, yStartTitle_iPhone, WidthTitle_iPhone, heigthTitle_iPhone);
            label = [[UILabel alloc] initWithFrame:rect];
            label.tag = 1;
            [cell.contentView addSubview:label];
            
            rect = CGRectMake(xStartImage_iPhone, 0, WidthImage_iPhone, heigthImage_iPhone);
            posterImage = [[UIImageView alloc] initWithFrame:rect];
            posterImage.tag = 2;
            [cell.contentView addSubview:posterImage];
            
            rect = CGRectMake(xStartRating_iPhone, yStartRating_iPhone, WidthRating_iPhone, heigthRating_iPhone);
            label = [[UILabel alloc] initWithFrame:rect];
            label.tag = 3;
            [cell.contentView addSubview:label];
            
            rect = CGRectMake(xStartStar_iPhone, yStartStar_iPhone, WidthStar_iPhone, heigthStar_iPhone);
            stars = [[DLStarRatingControl alloc]initWithFrame:rect];
            [stars setTag:4];
            [cell.contentView addSubview:stars];
            
            
        }else{
            rect = CGRectMake(xStartTitle_iPad, yStartTitle_iPad, WidthTitle_iPad, heigthTitle_iPad);
            label = [[UILabel alloc] initWithFrame:rect];
            label.tag = 1;
            [cell.contentView addSubview:label];
            
            rect = CGRectMake(xStartImage_iPad, 0, WidthImage_iPad, heigthImage_iPad);
            posterImage = [[UIImageView alloc] initWithFrame:rect];
            posterImage.tag = 2;
            [cell.contentView addSubview:posterImage];
            
            rect = CGRectMake(xStartRating_iPad, yStartRating_iPad, WidthRating_iPad, heigthRating_iPad);
            label = [[UILabel alloc] initWithFrame:rect];
            label.tag = 3;
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            
            rect = CGRectMake(xStartStar_iPad, yStartStar_iPad, WidthStar_iPad, heigthStar_iPad);
            stars = [[DLStarRatingControl alloc]initWithFrame:rect];
            [stars setTag:4];
            [cell.contentView addSubview:stars];
            
            

        }
            

    }
    
    Movie *mov = [_moviesArray objectAtIndex:indexPath.row];
    NSDictionary* dic = mov.movieInfo;
    
    if(dic != nil){
        UILabel *label;
        UIImageView *imagePoster;
        DLStarRatingControl *stars;
        
        label = (UILabel *)[cell viewWithTag:1];
        label.text = [dic objectForKey:@"name"];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            [label setFont:[UIFont boldSystemFontOfSize:SizeTitle_iPhone]];
        }else{ 
            [label setFont:[UIFont boldSystemFontOfSize:SizeTitle_iPad]];
        }
        [label setAdjustsFontSizeToFitWidth:TRUE];
        
        imagePoster = (UIImageView *)[cell viewWithTag:2];
        [imagePoster setImage:mov.posterImage];
        imagePoster.backgroundColor = [UIColor clearColor];
        
        int rate = ((NSString*)[dic objectForKey:@"rating"]).intValue;
        
        label = (UILabel *)[cell viewWithTag:3];
        [label setText:[NSString stringWithFormat:@"%d/10",rate]];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:25]];
        }else{
            [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:40]];
        }
        
        stars = (DLStarRatingControl *)[cell viewWithTag:4];
        [stars setUserInteractionEnabled:NO];
        stars.backgroundColor = [UIColor clearColor];
        [stars setRating:rate];


        

    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indice = indexPath.row;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowInfoMovie" object:[[NSNumber alloc] initWithInt:indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return ROW_iPhone;
    else 
        return ROW_iPad;
}

@end
