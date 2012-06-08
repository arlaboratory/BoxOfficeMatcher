package com.arlab.boxofficematcher;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.util.Log;

import com.arlab.boxofficematcher.BoxOfficeMatcherActivity.MatcherErrors;
import com.arlab.boxofficematcher.connect.HttpConnector;
import com.arlab.boxofficematcher.objects.MovieInfo;
import com.arlab.imagerecognition.ARmatcher;

/** This class manages the process of downloading the movies information from the service*/
public class MovieInfoLoader {
	
	private static final long  UPDATE_DELAY_IN_DAYS = 1;
	
	private final String LOG_TITLE = this.getClass().getName();
	private BoxOfficeMatcherActivity context;
	
	
	private HttpConnector httpConnector;
	private SDdataParser sDdataParser;
	
	
	public MovieInfoLoader(BoxOfficeMatcherActivity ctx,ARmatcher aRmatcher) {
		this.context = ctx;
		
		httpConnector = new HttpConnector(context);
		sDdataParser  = new SDdataParser(context,aRmatcher);
	}
	
	
	 /** Download movie info from the server if not exist locally and load it to the application  
	  * 
	  * The movies is being refreshed every amount of time ( Days)
	  * 
	  * @param isForcedUpdate is to force movie info update
	  * */
	public void LoadMovieInfo(boolean isForcedUpdate)
	{	
		if(SDdataParser.hasSDCard())
		{
			if(sDdataParser.isFlodersEmpty() || isForcedUpdate == true)
			{
				isToRefreshMovieInfo();
				
				sDdataParser.emptyFolders();
				
				new downloadPopularMovies(context).execute();			
			}
			else
			{	
				if(isToRefreshMovieInfo())
				{
					sDdataParser.emptyFolders();
					new downloadPopularMovies(context).execute();					
				}
				else
				{
					/// In this case is not necessary to download all the info, 
					/// just load it into library.
					sDdataParser.loadPostersToMatcherImagePool();
				}			
			}
		}else{
			context.infoReady(MatcherErrors.ErrorNoSD);
		}
	}
	
	 /** Get movie info object by poster id (id of the image in the matcher pool) 
	  * 
	  *  @param id found poster id
	  *  */
	public MovieInfo getMovieByPosterID(int id)
	{
		return sDdataParser.findMovieByPosterId(id);
	}
	
	
	/**
	 * 
	 * Download json file with data about movie, and poster, on background thread , loads maximum 40 movies.
	 * 
	 */
	private class downloadPopularMovies extends AsyncTask<Void, Integer, Void> {

		private static final int MaxFilms = 40;
		private Context context;
		private ProgressDialog dialog;
		
		private int progressNum = 0;
		private boolean urlError;

		public downloadPopularMovies(final Context context) {
			this.context = context;
		}

		@Override
		protected void onPreExecute() {
			super.onPreExecute();
			urlError=false;
			progressNum = 0;
			InitiProgressDialog();
		}

		@Override
		protected Void doInBackground(Void... params) {
			
			String Url = AppVariables.MOVIE_POPULAR_DB_URL + "&page=" + String.valueOf(1);
					
			int results = 0;
			String sJson = null;
						
			try {
				sJson = httpConnector.getJsonStringFromServer(Url);
				
				if(sJson != null)
				{
					if(!sJson.isEmpty())
					{  Log.i(LOG_TITLE, sJson);
						
						JSONObject jsonObj = new JSONObject(sJson);
						
						Integer [] temp = new Integer[2];
			    		temp[0] = -1;  
			    		results = jsonObj.getInt("total_results");
			    		if(results >= MaxFilms)
			    			temp[1] = MaxFilms;
			    		else
			    			temp[1] = results;
			    		publishProgress(temp);  // initiate the progress dialog		
			    		
			    		parseAndSaveMovieData(sJson);		
				    }
							     								
				} else{
					Log.e(LOG_TITLE, "ParseJsonPOIs - the Url: " + Url+ " is empty");
					urlError=true;
				}
			} catch (JSONException e) {
				Log.e(LOG_TITLE, "ParseJsonPOIs Error - " + e.getMessage());
				e.printStackTrace();
			}
			
			if(results > 20)				
			{  
				 Url = AppVariables.MOVIE_POPULAR_DB_URL + "&page=" + String.valueOf(2);
								
					sJson = httpConnector.getJsonStringFromServer(Url);
					
					if(sJson != null)
					{
						if(!sJson.isEmpty())
						{  Log.i(LOG_TITLE, sJson);
																    		
				    		parseAndSaveMovieData(sJson);		
					    }
								     								
					} else
						Log.e(LOG_TITLE, "ParseJsonPOIs - the Url: " + Url+ " is empty");				
			}
					
			return null;
		}

		@Override
		protected void onPostExecute(Void v) {

			if (null != dialog) {
				dialog.dismiss();
				dialog = null;
			}
			if(!urlError){
				sDdataParser.loadPostersToMatcherImagePool();
			}else{
				MovieInfoLoader.this.context.infoReady(MatcherErrors.ErrorConnection);
			}
		}
		
		
		@Override
		protected void onProgressUpdate(Integer... values) {
			
			if(values[0] == -1)
			{
				dialog.setMax(values[1]);
			}
			else
			{
				dialog.setProgress(values[0]);
			}
			
		}
		
		
		
		/**
		 * 
		 * Parse json movie data , download movie  poster and save it all to local folders on SD card
		 * 
		 * @param jsonString json string
		 * 
		 */
		private boolean parseAndSaveMovieData(String jsonString)
		{
			    JSONObject jsonObj;
			try {
				jsonObj = new JSONObject(jsonString);
			
    		JSONArray moviesArray = jsonObj.getJSONArray("results");
    		
    		for (int i = 0; i < moviesArray.length(); i++) {
				JSONObject movie = moviesArray.getJSONObject(i);
				
				String movieID = movie.getString("id");
				String posterURL = movie.getString("poster_path");
							   
			    Log.i(LOG_TITLE, "ParseJson - Parse json ok - movie id  : " + movie.getString("id"));  // REMOVE LATER
			    
			    if(movieID != null)
			    {
			    	String url = AppVariables.MOVIE_FULL_INFO_URL + movieID;	
			    	String jsonMovieInfo = httpConnector.getJsonStringFromServer(url);
			    	
			    	if(jsonMovieInfo != null)
					{									    		
			    		sDdataParser.saveJsonToSD(jsonMovieInfo, movieID);		
					}
			    }
			    
			    if(posterURL != null)
			    {
			    	String url = AppVariables.MOVIE_POSTER_URL + posterURL;	
			    	Bitmap posterImage = httpConnector.getBitmapImageFromServer(url);
			    	if(posterImage != null)
			    	{
			    		sDdataParser.saveBitmapToSD(posterImage, movieID);
			    	}
			    }
			    
			    progressNum ++;
			    publishProgress(progressNum);
		   }
    		
			} catch (JSONException e) {
				e.printStackTrace();
				return false;
			}	
			return true;
		}
		
		/** Initiates progress bar dialog that displays download progress */
		
		private void InitiProgressDialog()
		{
			dialog = new ProgressDialog(context);
			dialog.setTitle("Downloading...");
			dialog.setCancelable(false);
			dialog.setMessage("Downloading movies info...");
			dialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
			dialog.setProgress(0);
			dialog.show();
		}

	} // end of parseAndSaveMovieData
	
	
	/** Check if update delay is over to start movie info refreshing  */
	private boolean isToRefreshMovieInfo()
	{
		long updateDelay = UPDATE_DELAY_IN_DAYS * 24 * 60 * 60 * 1000;
		
		SharedPreferences settings = context.getSharedPreferences("BoxOfficePrefs",Activity.MODE_PRIVATE);
		long savedMilis = settings.getLong("LastUpdateTime", -1);
		
		if(savedMilis == -1 || ((System.currentTimeMillis() - savedMilis) > updateDelay))
		{
			 SharedPreferences.Editor editor = settings.edit();
			 editor.putLong("LastUpdateTime", System.currentTimeMillis());
			 editor.commit();
			 return true;
		}
		else
		{
			return false;
		}		
	}
}
