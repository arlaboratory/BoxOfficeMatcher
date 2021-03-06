package com.arlab.boxofficematcher.listview;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;

import com.arlab.boxofficematcher.MovieFullInfoDialog;
import com.arlab.boxofficematcher.R;
import com.arlab.boxofficematcher.SDdataParser;



/** Movies list tab activity */
public class MovieListView extends Activity{
	
	private ListView moviesList;
	private MovieListAdapter movieListAdapter;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.movie_list_layout);
		
		moviesList = (ListView)findViewById(R.id.moviesList);
		moviesList.setOnItemClickListener(new OnItemClickListener() {

			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,long arg3) {

				MovieFullInfoDialog dialog = new MovieFullInfoDialog(MovieListView.this, SDdataParser.MoviesArray.get(arg2));
				dialog.show();
				
			}
		});
		
		movieListAdapter = new MovieListAdapter(this, R.layout.movie_list_row_layout, SDdataParser.MoviesArray);
		moviesList.setAdapter(movieListAdapter);
	}
	
	@Override
	protected void onResume() {
		super.onResume();
		movieListAdapter.notifyDataSetChanged();
	}
	
}
