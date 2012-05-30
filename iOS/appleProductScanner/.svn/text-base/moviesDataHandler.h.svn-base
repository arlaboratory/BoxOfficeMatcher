//
//  moviesDataHandler.h
//  boxOfficeMatcher
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "movie.h"

@interface moviesDataHandler : NSObject
@property (nonatomic, strong) NSMutableArray* movies;

/**
 *
 *Download the movies.
 *
 */
-(BOOL)updateMovies;

/**
 *
 *Load movies from NSDocumentDirectory.
 *
 */
-(void)reloadMoviesFromDB;

/**
 *
 *Save movies in NSDocumentDirectory and add them into an array.
 *
 */
-(void)writeFiles:(NSDictionary*)movieDict;

/**
 *
 *Add a movie into an array.
 *
 */
-(void)insertObject:(Movie*)movie;


@end
