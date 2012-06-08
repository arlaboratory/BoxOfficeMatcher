package com.arlab.boxofficematcher;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.graphics.drawable.BitmapDrawable;
import android.net.Uri;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;
import android.widget.Toast;

import com.arlab.boxofficematcher.objects.MovieInfo;


public class MovieFullInfoDialog extends Dialog implements OnClickListener{
	
	private Context mContext;

	protected ImageView poster;
	protected TextView movieName;
	protected RatingBar movieRating;
	protected TextView movieRatingText;
	protected TextView movieRelieaseDate;
	protected TextView movieRunTime;
	protected TextView movieOverview;
	protected TextView movieQuote;
	protected TextView movieLanguage;
	protected Button movieTrailerLink;
	protected Button movieWebLink;
	
	protected MovieInfo movieInfo;
	
	
	 /**
	 * Dialog that show full movie information
	 *
	 */
	public MovieFullInfoDialog(Context context,MovieInfo movieInfo) {
		super(context,android.R.style.Theme_Light_NoTitleBar);
		
		mContext = context;
		/** 'Window.FEATURE_NO_TITLE' - Used to hide the title */
		requestWindowFeature(Window.FEATURE_NO_TITLE);
				
		/** Design the dialog in main.xml file */
		setContentView(R.layout.movie_full_info_dialog_layout);
		
		this.movieInfo = movieInfo;
			
		/** Obtaining views*/
		poster =  (ImageView)findViewById(R.id.infoImageView);
		movieName = (TextView)findViewById(R.id.infoName);
		movieRating = (RatingBar)findViewById(R.id.infoRatingBar);;
		movieRatingText = (TextView)findViewById(R.id.infoRatingText);
		movieRelieaseDate = (TextView)findViewById(R.id.infoReleaseDate);
	    movieRunTime = (TextView)findViewById(R.id.infoRunTime);
	    movieQuote= (TextView)findViewById(R.id.infoQuote); 	    
	    movieOverview = (TextView)findViewById(R.id.infoOverview); 	    
        movieLanguage = (TextView)findViewById(R.id.infoLanguage);
        
    	movieTrailerLink = (Button)findViewById(R.id.linkButton);
    	movieTrailerLink.setOnClickListener(this);
    	
    	movieWebLink = (Button)findViewById(R.id.webButton);
    	movieWebLink.setOnClickListener(this);
			
    	/** Adding movie info to views */
		if(movieInfo != null)
		{
			poster.setImageDrawable(new BitmapDrawable(movieInfo.image)) ;
			movieName.setText(movieInfo.name);
			movieRating.setRating(Float.valueOf(movieInfo.rating));
			movieRatingText.setText(movieInfo.rating+"/10");
			movieRelieaseDate.setText("Release Date: "+movieInfo.released_date);
			movieRunTime.setText("Runtime: "+movieInfo.runtime+" min");
			movieOverview.setText(movieInfo.overview);
			movieQuote.setText(movieInfo.tagline);
			movieLanguage.setText("Language: " + movieInfo.language);
			
		}
		
			
	}

	public void onClick(View v) {
		if(v == movieTrailerLink)
		{
			/** Launch Trailer through intent */
			if(movieInfo.trailer != null)
			{
				Intent youtubeIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(movieInfo.trailer));
				if(isAppInstalled("com.google.android.youtube",mContext)); 
				{
					youtubeIntent.setClassName("com.google.android.youtube", "com.google.android.youtube.WatchActivity");
	            }
	           	mContext.startActivity(youtubeIntent);
			}
			else
			{
				Toast.makeText(mContext, "No Trailer Link Availble !", Toast.LENGTH_SHORT).show();
			}
			
		}
		else if(v == movieWebLink)
		{
			/** Launch Movie through intent */
			if(movieInfo.web_link != null)
			{
				String url = movieInfo.web_link;
				
				if (!url.startsWith("http://") && !url.startsWith("https://"))
					   url = "http://" + url;

				Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
				mContext.startActivity(browserIntent);
			}
			else
			{
				Toast.makeText(mContext, "No Web Link Availble !", Toast.LENGTH_SHORT).show();
			}

		}
		
	}
		
	 /**
		 * Check if certain application is installed on your device
		 *
		 *@param uri application package
		 *@param context current app context
		 */
	static boolean isAppInstalled(String uri, Context context) {
	    PackageManager pm = context.getPackageManager();
	    boolean installed = false;
	    try {
	        pm.getPackageInfo(uri, PackageManager.GET_ACTIVITIES);
	        installed = true;
	    } catch (PackageManager.NameNotFoundException e) {
	        installed = false;
	    }
	    return installed;
	}
}
