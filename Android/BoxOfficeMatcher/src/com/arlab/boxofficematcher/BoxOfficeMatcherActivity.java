package com.arlab.boxofficematcher;

import java.util.ArrayList;

import android.app.AlertDialog;
import android.app.TabActivity;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RatingBar;
import android.widget.RelativeLayout;
import android.widget.TabHost;
import android.widget.TabHost.OnTabChangeListener;
import android.widget.TabHost.TabSpec;
import android.widget.TextView;

import com.arlab.boxofficematcher.listview.MovieListView;
import com.arlab.boxofficematcher.objects.MovieInfo;
import com.arlab.brmatcher.ROI;
import com.arlab.imagerecognition.ARmatcher;
import com.arlab.imagerecognition.ARmatcherCallBack;



/**
 * Main view 
 */
public class BoxOfficeMatcherActivity extends TabActivity implements OnTabChangeListener, ARmatcherCallBack{
	private static final int ImagePoolQuality = 10;
	private static final String API_KEY = "0YpBx5XDf09CrCJBvHw=";
	private ARmatcher aRmatcher;		
	
	private final static String AR_MATCHER_TAB = "matcherTab";
	private final static String MOVIES_LIST_TAB = "movieslistTab";

	private TabHost tabHost;

	private MovieInfoLoader movieInfoDownloader;
	private MovieInfo movieInfo;

	/** View layouts*/
	private RelativeLayout popup;
	private TextView popupTitle;
	private ImageView popupImage;
	private RatingBar popupRatinBar;
	private TextView popupRatinBarText;

	private RelativeLayout touchLayout;
	private boolean first;
	public enum MatcherErrors {ErrorConnection, ErrorNoImages, ErrorNoSD, NoError};
	
	
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.main);

		initTabView();

		/**Get full screen size */
		DisplayMetrics displaymetrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(displaymetrics);

		int screenheight = displaymetrics.heightPixels;
		int screenwidth = displaymetrics.widthPixels;

		/**Create an instance of the ARmatcher object. */
		if(((double)screenheight)/((double)screenwidth)>1)
			aRmatcher = new ARmatcher(this, this,API_KEY,ARmatcher.SCREEN_ORIENTATION_PORTRAIT,screenwidth,screenheight, true);
		else
			aRmatcher = new ARmatcher(this, this,API_KEY,ARmatcher.SCREEN_ORIENTATION_LANDSCAPE,screenwidth,screenheight, true);
		
		/**Set the type of the matching. */
		aRmatcher.setMatchingType(ARmatcher.IMAGE_MATCHER);

		/**Enable median filter ,witch help to reduce noise and mismatches in IMAGE matching .(Optional) */
		aRmatcher.enableMedianFilter(true);

		/**Set minimum image quality threshold ,for image to be accepted to the image pool*/
		aRmatcher.setImageQuality(ImagePoolQuality);


		/**
		 * Add camera view instance to the matcher tab
		 */
		LinearLayout matcherTabLayout = (LinearLayout) findViewById(R.id.matcherTab);
		matcherTabLayout.addView(aRmatcher.getCameraViewInstance());

		/**
		 * Initiate popup views
		 */
		popup = (RelativeLayout)findViewById(R.id.labelPopup);
		popup.bringToFront();
		popup.setVisibility(View.INVISIBLE);
		popupTitle = (TextView)findViewById(R.id.popupMovieName);
		popupImage = (ImageView)findViewById(R.id.poster);
		popupRatinBar = (RatingBar)findViewById(R.id.popupRatingBar);
		popupRatinBarText = (TextView)findViewById(R.id.popupRatingText);

		/**
		 * Initiate popup touch layout
		 */
		touchLayout = (RelativeLayout)findViewById(R.id.touchLayout);
		touchLayout.setOnClickListener(new OnClickListener() {

			public void onClick(View v) {

				MovieFullInfoDialog infoDialog = new MovieFullInfoDialog(BoxOfficeMatcherActivity.this, movieInfo);
				infoDialog.show();
			}
		});

		first=true;
		/** Start Movie Process*/
		movieInfoDownloader = new MovieInfoLoader(this,aRmatcher);   
		movieInfoDownloader.LoadMovieInfo(false);
	}



	/**
	 * Initiation of tab views
	 */
	private void initTabView()
	{
		tabHost = (TabHost) findViewById(android.R.id.tabhost);
		tabHost.setOnTabChangedListener(this);

		View matcherMapView = LayoutInflater.from(this).inflate(R.layout.tab_matcher_layout, null);
		View listView = LayoutInflater.from(this).inflate(R.layout.tab_llist_layout, null);

		TabSpec matcherTabSpec = tabHost.newTabSpec(AR_MATCHER_TAB).setIndicator(matcherMapView).setContent(R.id.matcherTab);

		Intent intent = new Intent(this,MovieListView.class);
		TabSpec listTabSpec = tabHost.newTabSpec(MOVIES_LIST_TAB).setIndicator(listView).setContent(intent);

		tabHost.addTab(matcherTabSpec);
		tabHost.addTab(listTabSpec);

		tabHost.setCurrentTab(0);
	}


	/** Controls the matcher library process*/
	public void onTabChanged(String arg0) {
		if(aRmatcher != null)
		{
			if (arg0.equals(AR_MATCHER_TAB)) {
				aRmatcher.start();
			}
			else if (arg0.equals(MOVIES_LIST_TAB)) {
				popup.setVisibility(View.INVISIBLE);
				aRmatcher.stop();
			}
		}				
	}


	/**Callback that will accept all Movie posters matching results and launch popup if proper result found
	 * 
	 * @param res accepted matcher result
	 * */	
	public void ImageRecognitionResult(int res) {

		if(res != -1)
		{									
			movieInfo = movieInfoDownloader.getMovieByPosterID(res);
			if(movieInfo != null)
			{
				popup.setVisibility(View.VISIBLE);	

				popupImage.setImageDrawable(new BitmapDrawable(movieInfo.image));
				popupTitle.setText(movieInfo.name);
				popupRatinBar.setRating(Float.valueOf(movieInfo.rating));
				popupRatinBarText.setText(movieInfo.rating+"/10");
			}			
		}
		else
		{
			popup.setVisibility(View.INVISIBLE);	
		}

	}


	@Override
	protected void onResume() {
		super.onResume();

		/** Start matcher view
			 * 
			 * 
			 * */
		aRmatcher.start();
		
		if(first){
			aRmatcher.stop();
			first=false;
		}
	}
	@Override
	protected void onPause() {
		super.onPause();

		/** Stop matcher view
		 * 
		 * */
		aRmatcher.stop();
		
	}
	
	/**
	 * Call when the progress dialog has been dismissed
	 */
	public void infoReady(MatcherErrors error){
		if(error==MatcherErrors.ErrorConnection){
			AlertDialog ad=new AlertDialog.Builder(this).create();
			ad.setTitle("Error");
			ad.setMessage("Connection Error");
			ad.setButton("OK", (DialogInterface.OnClickListener) null);
			ad.show();
		}else if(error==MatcherErrors.ErrorNoImages){
			AlertDialog ad=new AlertDialog.Builder(this).create();
			ad.setTitle("Error");
			ad.setMessage("No images found");
			ad.setButton("OK", (DialogInterface.OnClickListener) null);
			ad.show();
		}else if(error==MatcherErrors.ErrorNoSD){
			AlertDialog ad=new AlertDialog.Builder(this).create();
			ad.setTitle("Error");
			ad.setMessage("No SD card available");
			ad.setButton("OK", (DialogInterface.OnClickListener) null);
			ad.show();
		}else if(error==MatcherErrors.NoError){
			aRmatcher.start();
		}
	}
	


	/** Update movies Menu Option*/
	@Override
	public boolean onCreateOptionsMenu(Menu menu)
	{
		menu.add(Menu.NONE,1,Menu.NONE,"Refresh");		   
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {
		case 1:
			aRmatcher.stop();
			movieInfoDownloader.LoadMovieInfo(true);		     
			return true;

		default:
			return super.onOptionsItemSelected(item);
		}
	}

	/** Unused method, no QR recognition is desired */
	public void QRRecognitionResult(String res) {
			
	}
	/** Unused method, no QR recognition is desired */
	public void QRROIsRecognitionResult(ArrayList<ROI> roiList) {
			
	}		
}