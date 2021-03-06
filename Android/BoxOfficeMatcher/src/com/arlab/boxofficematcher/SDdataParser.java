package com.arlab.boxofficematcher;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

import android.app.ProgressDialog;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Environment;

import com.arlab.boxofficematcher.BoxOfficeMatcherActivity.MatcherErrors;
import com.arlab.boxofficematcher.objects.MovieInfo;
import com.arlab.imagerecognition.ARmatcher;


/** This class process the images information and downloads them*/
public class SDdataParser {
		
	
	private BoxOfficeMatcherActivity mContext;
	private ARmatcher aRmatcher;
	
	
	private String posterImageRootFolder;
	private String posterInfoRootFolder;
	
	
	public static ArrayList<MovieInfo> MoviesArray = new ArrayList<MovieInfo>();
	private BufferedReader br;	
	
	public SDdataParser(BoxOfficeMatcherActivity context,ARmatcher aRmatcher) {
		this.mContext = context;
		this.aRmatcher = aRmatcher;
		
		posterImageRootFolder = Environment.getExternalStorageDirectory() + File.separator + "BoxOfficeMatcherTemp" + File.separator + "poster";
		posterInfoRootFolder = Environment.getExternalStorageDirectory() + File.separator + "BoxOfficeMatcherTemp" + File.separator + "movieInfo";
		
		if(hasSDCard())
		{	
			checkIfexistAndCreateOtherwise(posterImageRootFolder);
			checkIfexistAndCreateOtherwise(posterInfoRootFolder);
		}
		
	 }

	
	/**
	 * Load Movies data from SD card and upload images to the Matcher image pool
	 *
	 */
	  public void loadPostersToMatcherImagePool()
	  {		
		  	for(MovieInfo mi:MoviesArray){
		  		aRmatcher.removeImage(mi.imagePoolid);
		  	}
			 MoviesArray.clear();			
			 
			 if(hasSDCard())
			{
				 new loadMovieDataFromSDandAddImagesToThePool().execute();
			}	  
	
	  }
	  
	  /**
		 * Check if the folder path exist , if not create one
		 *
		 *@param rootDir path to the directory
		 */
	  private void checkIfexistAndCreateOtherwise(String rootDir)
	  {	
		  File file = new File(rootDir);		 
		  if (!file.exists()) {			
			  file.mkdirs();		       		     
		  }
	  }

	
	  
	  /**
		 * Load Movie info from SD and upload images to Matcher image pool Asynchronously (In another Thread)
		 *
		 */
	  private class loadMovieDataFromSDandAddImagesToThePool extends AsyncTask<Void,Integer,Void> {
			
			private ProgressDialog progressDialog;
			private String[] fileList;
	
			@Override
			protected void onPreExecute() {
				super.onPreExecute();
				
				
				 if(hasSDCard())
				 {										 
					 File file = new File(posterInfoRootFolder);		 
					 boolean isExist = file.exists();			 
					 if(isExist)
					 {		     								
						 fileList = file.list();		
					 }
				 }
				
				InitiProgressDialog(fileList.length);
				
			}
				
			@Override
			protected Void doInBackground(Void... v) {
				
				MovieInfo movieInfo = null;
				
				if(fileList.length != 0)
				 {
					 for(int i = 0 ; i < fileList.length ; i++)
					 {
						 /// For each film create a new MovieInfo object and set its information
						 movieInfo = new MovieInfo();
						 
						 String jsonMovieInfo = readStringFromFile(fileList[i]);
						 
						 if(jsonMovieInfo != null)
						 {
						   try {									
									JSONArray moviesArray = new JSONArray(jsonMovieInfo);								
									JSONObject jsonObj = moviesArray.getJSONObject(0);
									
									movieInfo.id = jsonObj.getString("id");
									movieInfo.language = jsonObj.getString("language");
									movieInfo.name = jsonObj.getString("original_name");
									movieInfo.overview = jsonObj.getString("overview");
									movieInfo.rating = jsonObj.getString("rating");
									movieInfo.released_date = jsonObj.getString("released");
									movieInfo.runtime = jsonObj.getString("runtime");
									movieInfo.tagline = jsonObj.getString("tagline");
									movieInfo.trailer = jsonObj.getString("trailer");
									movieInfo.web_link = jsonObj.getString("url");
																	
									
									Bitmap posterImage = getBitmapFromSD(movieInfo.id+".png");
									
									if(posterImage != null)
									{
										
										int id = Integer.valueOf(movieInfo.id).intValue();
										
												
										if (aRmatcher.addImage(posterImage,id))
										{										
											movieInfo.imagePoolid = id;											
												
											movieInfo.image = posterImage;																			
											MoviesArray.add(movieInfo);
										}
													
									}
						 
						        } catch (Exception e) {  }					 					 
						 	}
						 publishProgress(i);
					   }
					}
	
				return null;					
			}
		
		@Override
		protected void onProgressUpdate(Integer... values) {
			
			progressDialog.setProgress(values[0]);
		}
		
		@Override
		protected void onPostExecute(Void v) {
			progressDialog.dismiss();	
			if(MoviesArray==null||MoviesArray.size()==0)
				mContext.infoReady(MatcherErrors.ErrorNoImages);
			else
				mContext.infoReady(MatcherErrors.NoError);
		} 
		
		
		/**
		 * Initiate progress bar dialogs (Shows loading progress)
		 *
		 */
		private void InitiProgressDialog(int MaxValue)
		{
			progressDialog = new ProgressDialog(mContext);
			progressDialog.setCancelable(false);
			progressDialog.setMessage("Loading posters...");
			progressDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
			progressDialog.setProgress(0);
			progressDialog.setMax(MaxValue);
			progressDialog.show();
		}			
	 }
	    
	  
	  
	  /**
		 * Save bitmap image to SD card
		 *
		 *@param bitmap Bitmap image
		 *@param movieId movie id (act as file name)
		 */
	 public void saveBitmapToSD(Bitmap bitmap,String movieId)
	 {
		 String imagePath = posterImageRootFolder + File.separator + movieId + ".png";
		 
		 try {
	          FileOutputStream out = new FileOutputStream(imagePath);
	          bitmap.compress(CompressFormat.PNG, 100, out);
	          out.flush();
	          out.close();
	      } catch(Exception e) {}
	 }
	 
	 
	 /**
		 * Save json String to txt file on SD card
		 *
		 *@param jsonString Json string
		 *@param movieId movie id (act as file name)
		 */
	 public void saveJsonToSD(String jsonString,String movieId)
	 {
		 String imagePath = posterInfoRootFolder + File.separator + movieId + ".txt";
		 
		 try {
			 File jsonFile = new File(imagePath);
			 FileWriter writer = new FileWriter(jsonFile);
			 writer.append(jsonString);
		     writer.flush();
		     writer.close();
	      } catch(Exception e) {}
	 }
	 
	 
	 
	/**
	 * Check if SD card available
	 *
	 *
	 *@param movieId movie id (act as file name)
	 *@return  <b>"true"</b> id SD card available , <b>"false"</b> otherwise
	 */
	 public static boolean hasSDCard() { 
	      String status = Environment.getExternalStorageState();
	      return status.equals(Environment.MEDIA_MOUNTED);
	  }
	  
	 
	 
	 /**
		 * Read json string from txt file from SD card
		 *
		 *
		 *@param fileName movie id (act as file name)
		 *@return  json string
		 */
	 protected String readStringFromFile(String fileName)
	 {
		 String result = null;
		 try {
			 File file = new File(posterInfoRootFolder,fileName);
			 

		        if (file.exists()) {
		        	br = new BufferedReader(new FileReader(file));
		        	StringBuilder text = new StringBuilder();
		        	String line;

		        	while ((line = br.readLine()) != null) {
		                text.append(line);		             
		            }	
		        	
		        	result = text.toString();
		        }
		    }
		    catch (Throwable t) { }
		 
		 return result;
	 }
	 
	 
	 /**
		 * Get bitmap image from SD card
		 *
		 *@param fileName file name (movie id)
		 *@return Bitmap image
		 */
	 protected Bitmap getBitmapFromSD(String fileName)
	 {
		 Bitmap bitmap = null;
		 try {
			 File file = new File(posterImageRootFolder,fileName);		

		        if (file.exists()) {
		        	
		        	bitmap =  BitmapFactory.decodeFile(posterImageRootFolder + File.separator + fileName);		        			       		         			        	
		        }
		    }
		    catch (Throwable t) { }
		 
		 return bitmap;
	 }
	 
	 
	 
	 /**
		 * Is folder empty
		 *
		 *@return  <b>"true"</b>  or "false"
		 */
	public boolean isFlodersEmpty()
	{
		boolean isEmpty = false;
		
		File posters = new File(posterImageRootFolder+"/");
		File jsoninfo = new File(posterInfoRootFolder+"/");
		
		int numImageFiles = posters.list().length;
		int numJsonFiles = jsoninfo.list().length;
		
		if((numImageFiles == 0) || (numJsonFiles == 0))		
			  isEmpty= true;
			else
			  isEmpty= false;		
		return isEmpty;		
	}
	
	 /**
	 * Empty application folders
	 *
	 */
	public void emptyFolders()
	{
		deleteFiles(posterImageRootFolder);
		deleteFiles(posterInfoRootFolder);
	}
	
		 /**
		 * Delete all files from folder
		 *
		 *@param folderPath folder path
		 */
	 private void deleteFiles(String folderPath)
	 {
		 File path = new File(folderPath);	
		 if(path.exists() && path.isDirectory())
		 {
			 File[] files = path.listFiles();
	            for(int i=0; i<files.length; i++) {	                
	               
	                    files[i].delete();	               
	            }
		 }
	 }
 
	
	 /**
		 * Find movie by poster id (Matcher pool id)
		 *
		 *@param folderPath folder path
		 */
	public MovieInfo findMovieByPosterId(int movieId)
	{
		MovieInfo movieInfo = null;
		
		for(int i = 0 ; i < MoviesArray.size() ; i++)
		{
			if(MoviesArray.get(i).imagePoolid == movieId)
			{
				movieInfo = MoviesArray.get(i);
				break;
			}
			
		}		
		return movieInfo;  
	}
	
	
	
}
