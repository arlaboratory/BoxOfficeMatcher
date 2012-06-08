package com.arlab.boxofficematcher.connect;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URI;
import java.net.URISyntaxException;

import org.apache.http.HttpResponse;
import org.apache.http.HttpVersion;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.CoreProtocolPNames;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;

import com.arlab.boxofficematcher.AppVariables;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;



/**
 * Class that handles HTTP connections via <b>GET</b> request
 *
 */
public class HttpConnector {
	
	Context mContext;
	HttpClient client;
	
	public HttpConnector(Context ctx) {
		mContext = ctx;		
	}
		
	/**
	 * Start Http GET connection 
	 *
	 *@param url  server url
	 *
	 *@return response in String representation
	 */
	public String getJsonStringFromServer(String url)
	{
		client = new DefaultHttpClient();
        client.getParams().setParameter(CoreProtocolPNames.PROTOCOL_VERSION, HttpVersion.HTTP_1_1);
		HttpGet request = new HttpGet();
		HttpParams params = client.getParams();
	    HttpConnectionParams.setConnectionTimeout(params, AppVariables.CONNECTION_TIMEOUT);
	    HttpConnectionParams.setSoTimeout(params, AppVariables.READ_TIMEOUT);
	    request.setParams(params);
	    request.addHeader("Accept", "application/json");
	    

	   
	    URI uri = null;
		try {
			uri = new  URI(url);
		} catch (URISyntaxException e1) {  }

		HttpResponse response;
		request.setURI(uri);
		try {
			
			response = client.execute(request);
		
			} catch (ClientProtocolException e) {
				Log.e("Elipse", "error :" + e.getMessage());
				return null;
			} catch (IOException e) {
				Log.e("Elipse", "error :" + e.getMessage());
				return null;
			}
		
		InputStream in = null; 	
		
		try {
			int statusCode = response.getStatusLine().getStatusCode();
			if (statusCode == 200) {
				in = response.getEntity().getContent();
			}

		} catch (IllegalStateException e) {
			return null;				
		} catch (Exception e) {
			return null;				
		}
		return  convertStreamToString(in);	
	}
	
	
	
	/**
	 * Start Http GET connection 
	 *
	 *@param url  server url
	 *
	 *@return  downloaded image bitmap
	 */
	public Bitmap getBitmapImageFromServer(String url)
	{
		client = new DefaultHttpClient();
        client.getParams().setParameter(CoreProtocolPNames.PROTOCOL_VERSION, HttpVersion.HTTP_1_1);
		HttpGet request = new HttpGet();
		HttpParams params = client.getParams();
	    HttpConnectionParams.setConnectionTimeout(params, AppVariables.CONNECTION_TIMEOUT);
	    HttpConnectionParams.setSoTimeout(params, AppVariables.READ_TIMEOUT);
	    request.setParams(params);
	       
	    URI uri = null;
		try {
			uri = new  URI(url);
		} catch (URISyntaxException e1) {  }

		HttpResponse response;
		request.setURI(uri);
		try {
			
			response = client.execute(request);
		
			} catch (ClientProtocolException e) {
				Log.e("Elipse", "error :" + e.getMessage());
				return null;
			} catch (IOException e) {
				Log.e("Elipse", "error :" + e.getMessage());
				return null;
			}
		
		InputStream in = null; 	
		
		try {
			int statusCode = response.getStatusLine().getStatusCode();
			if (statusCode == 200) {
				in = response.getEntity().getContent();
			}

		} catch (IllegalStateException e) {
			return null;				
		} catch (Exception e) {
			return null;				
		}
		
		  Bitmap bitmap = null;
		
		 try {	
	           bitmap = BitmapFactory.decodeStream(in);
	           in.close();
	       } catch (Exception e1) {
	       }
				
		return  bitmap;
	}
	
	/**
	 * Transforms Http request input stream to readable string 
	 * 
	 * @param is input stream accepted from http get request
	 * 
	 *  
	 * @return String representation of the request  or "Null" if error occurred
	 */	
	private static String convertStreamToString(InputStream is) {

		BufferedReader reader = new BufferedReader(new InputStreamReader(is));
		StringBuilder sb = new StringBuilder();

		String line = null;
		try {
			while ((line = reader.readLine()) != null) {
				sb.append(line);
			}
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				is.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return sb.toString();
	}
	
	
	
}
