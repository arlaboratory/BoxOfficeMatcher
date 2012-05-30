package com.arlab.boxofficematcher.listview;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;

import com.arlab.boxofficematcher.R;
import com.arlab.boxofficematcher.objects.MovieInfo;


/**
 * List adapter that manages movies list view
 *
 */
public class MovieListAdapter extends ArrayAdapter<MovieInfo> {

	private ArrayList<MovieInfo> posters;
	private Context mContext;
	private int rowResourceId;
	
	public MovieListAdapter(Context context, int ViewResourceId,ArrayList<MovieInfo> items) {
		
		super(context, ViewResourceId, items);
		this.posters = items;
		this.mContext = context;
		this.rowResourceId = ViewResourceId;
	}
	
	static class ViewHolder {
		
		public ImageView image;
		public TextView descripcion;
		public RatingBar ratingbar;
		public TextView ratingText;
	}
	
	/** Configures the Movie information into the list Cell */
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		
		final ViewHolder holder;
		View rowview = convertView;
		
		if (rowview == null) 
		{
			LayoutInflater inflator = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			rowview = inflator.inflate(rowResourceId, null);	
			holder = new ViewHolder();
			
			holder.image = (ImageView) rowview.findViewById(R.id.image);
			holder.descripcion = (TextView) rowview.findViewById(R.id.description);
			holder.ratingbar = (RatingBar)rowview.findViewById(R.id.ratingBar1);
			holder.ratingText =  (TextView) rowview.findViewById(R.id.ratingText);
			
			rowview.setTag(holder);
			
		}
		else
		{
			holder = (ViewHolder)rowview.getTag();	
		}
				
		MovieInfo movieInfo = posters.get(position);
		
		if (movieInfo != null) {			
			holder.image.setImageBitmap(movieInfo.image);	
			holder.descripcion.setText(movieInfo.name) ;
			holder.ratingbar.setRating(Float.valueOf(movieInfo.rating));
			holder.ratingText.setText(movieInfo.rating+"/10");
		}
		return rowview;
	}	
}
