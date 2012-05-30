package com.arlab.boxofficematcher;


/**
 * Contains important application variables
 */
public class AppVariables {
	
	/// Films Api access
	private static final String TMDB_API_KEY = "b88c76167314f1e1e6dca85cb9e0d7d1";
	private static final String POSTER_IMAGE_SIZE = "w500";  //  "w92", "w154", "w185", "w342", "w500", "original"
	public static final String MOVIE_POPULAR_DB_URL = "http://api.themoviedb.org/3/movie/popular?api_key=" + TMDB_API_KEY;
	public static final String MOVIE_FULL_INFO_URL = "http://api.themoviedb.org/2.1/Movie.getInfo/en/json/" + TMDB_API_KEY + "/";
	public static final String MOVIE_POSTER_URL = "http://cf2.imgobject.com/t/p/"+POSTER_IMAGE_SIZE;

	///Http Connection Variables
	public static final int CONNECTION_TIMEOUT = 5000;
	public static final int READ_TIMEOUT = 10000;

}
