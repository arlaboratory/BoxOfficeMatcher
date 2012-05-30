//
//  moviesDataHandler.m
//  boxOfficeMatcher
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import "moviesDataHandler.h"

#define tmdbApiKey @"b88c76167314f1e1e6dca85cb9e0d7d1"
#define tmdbURL @"http://api.themoviedb.org/3/movie/popular?"
#define tmdImageURL @"http://cf2.imgobject.com/t/p/w342"
#define tmdMovieInfoURL @"http://api.themoviedb.org/2.1/Movie.getInfo/en/json/"

@implementation moviesDataHandler

@synthesize movies;

-(id)init
{
    if (self = [super init]) {
        movies = [[NSMutableArray alloc] init];
    }
    return self;
}

-(BOOL)updateMovies
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteImages" object:nil];

    bool finishDownload = FALSE;
    
    [movies removeAllObjects];
    [self removeAllFilesIn:NSDocumentDirectory];

    UIApplication *app = [UIApplication sharedApplication];  
    [app setNetworkActivityIndicatorVisible:YES];
    
    NSMutableArray* moviesList = [[NSMutableArray alloc] initWithCapacity:40];
    for (int i = 1 ; i<=3; i++) {
        NSString* urlString = [NSString stringWithFormat:@"%@api_key=%@&page=%d",tmdbURL,tmdbApiKey,i];
        NSURL* url = [[NSURL alloc] initWithString:urlString];
        NSData* dat = [[NSData alloc] initWithContentsOfURL:url];
        if(dat!=nil){
            NSError * error;
            NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:dat //1
                                                                     options:kNilOptions 
                                                                       error:&error];
            
            [moviesList addObjectsFromArray:[jsonDict objectForKey:@"results"]];
        }
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InitializeProgress" object:[[NSNumber alloc] initWithInt:[moviesList count]]];
    
    int moviesLoaded = 0;
    for (NSDictionary* movieDict in moviesList) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MovieAdded" object:movieDict];
        moviesLoaded = moviesLoaded+1;
        if(moviesLoaded == [moviesList count])
            finishDownload = TRUE;
    }
    [app setNetworkActivityIndicatorVisible:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveAlert" object:nil];

    
    if(finishDownload)
        return TRUE;
    else
        return FALSE;
}

-(void)writeFiles:(NSDictionary*)movieDict{
    Movie* movie = [[Movie alloc] init];

    NSString* movieId = [movieDict objectForKey:@"id"];
    NSString* urlString = [NSString stringWithFormat:@"%@%@/%@",tmdMovieInfoURL,tmdbApiKey,movieId];
    NSURL* url = [[NSURL alloc] initWithString:urlString];
    NSData* dat = [[NSData alloc] initWithContentsOfURL:url];
    NSError * error;
    if(dat !=nil){
        NSArray* json = [NSJSONSerialization JSONObjectWithData:dat //1
                                                        options:kNilOptions 
                                                          error:&error];
        
        movie.movieId = movieId.intValue;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingFormat:@"/%@",movieId];
        NSString *file = [filePath stringByAppendingString:@".ar"];
        
        NSDictionary* jsonDict = [json objectAtIndex:0];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:jsonDict];
        NSArray *keysJson = [dictionary allKeys];
        for(int j=0; j<[keysJson count]; j++){
            if([dictionary objectForKey:[keysJson objectAtIndex:j]]==[NSNull null])
                [dictionary removeObjectForKey:[keysJson objectAtIndex:j]];
        }
        
        BOOL FILESave = [dictionary writeToFile:file atomically:YES];
        
        movie.movieInfo = dictionary;
        
        NSString* posterPath = [movieDict objectForKey:@"poster_path"];
        NSString* posterurlString = [NSString stringWithFormat:@"%@%@",tmdImageURL,posterPath];
        NSURL* posterurl = [[NSURL alloc] initWithString:posterurlString];
        NSData* posterdat = [[NSData alloc] initWithContentsOfURL:posterurl];
        
        NSString *imagefile = [filePath stringByAppendingString:@".jpg"];
        BOOL IMAGESAVE = FALSE;
        if(posterdat!=nil)
            IMAGESAVE = [posterdat writeToFile:imagefile atomically:YES];
        
        movie.posterImage = [UIImage imageWithData:posterdat];
        
        if(FILESave && IMAGESAVE){
            [movies addObject:movie];
        }
    }
    

}

-(void)removeAllFilesIn:(NSSearchPathDirectory) dir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtPath:documentsDirectory];
    
    for (NSString *path in directoryEnumerator) 
    {
        [fileManager removeItemAtPath:path error:NULL];
    }   
}

-(void)reloadMoviesFromDB
{
    [movies removeAllObjects];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSDirectoryEnumerator *directoryEnumerator1 = [[NSFileManager defaultManager] enumeratorAtPath:documentsDirectory];
        
    int i=0;
    for(NSString *objects in directoryEnumerator1){
        if ([[objects pathExtension] isEqualToString:@"ar"]) 
        i=i+1;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InitializeProgress" object:[[NSNumber alloc]initWithInt:i]];
    
    NSDirectoryEnumerator *directoryEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:documentsDirectory];

    for (NSString *path in directoryEnumerator) 
    {    
        Movie* movie = [[Movie alloc] init];
        
        
        if ([[path pathExtension] isEqualToString:@"ar"]) 
        { 
            NSString* fileName = [[path lastPathComponent] stringByDeletingPathExtension];

            NSString *dictPath = [documentsDirectory stringByAppendingPathComponent:path];
            NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:@"jpg"]];

            movie.movieId = fileName.intValue;
            movie.movieInfo = [NSDictionary dictionaryWithContentsOfFile:dictPath];
            movie.posterImage = [UIImage imageWithContentsOfFile:imagePath];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MovieAdded" object:movie];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveAlert" object:nil];
}

-(void)insertObject:(Movie*)movie{
    [movies addObject:movie];
}
@end
