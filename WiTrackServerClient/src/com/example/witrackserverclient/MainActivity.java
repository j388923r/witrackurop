package com.example.witrackserverclient;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.concurrent.ExecutionException;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

import android.app.Activity;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;


public class MainActivity extends Activity {

	SurfaceView answerView;
	SurfaceHolder holder;
	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        answerView = (SurfaceView)findViewById(R.id.surfaceview);
        holder = answerView.getHolder();
        
        NetworkPingTask ping = new NetworkPingTask();
		ping.execute("http://witrackurop.azurewebsites.net/random");
		Toast.makeText(this, "Pinging", Toast.LENGTH_LONG).show();
		try {
			TextView readValue = (TextView)findViewById(R.id.readValue);
			readValue.setText("Reading Value: " + ping.get());
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			Toast.makeText(this, "Interrupted Exception", Toast.LENGTH_LONG).show();
		} catch (ExecutionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			Toast.makeText(this, "Execution Exception", Toast.LENGTH_LONG).show();
		}
    }

    public void rePing(View view) {
    	NetworkPingTask ping = new NetworkPingTask();
		ping.execute("http://witrackurop.azurewebsites.net/random");
    	TextView readValue = (TextView)findViewById(R.id.readValue);
    	//readValue.setAlpha(1);
    	readValue.setHeight(100);
    	readValue.setTextSize(50);
    	
		try {
			String pingValue = ping.get();
			readValue.setText("Reading Value: " + pingValue);
			Canvas c = holder.lockCanvas();
	        c.drawARGB(255, 234, 243, 234);
	        Paint redPaint = new Paint();
	        redPaint.setColor(Color.RED);
	        c.drawRect(100, 100, 100 + 50 * Float.parseFloat(pingValue), 130, redPaint);
	        holder.unlockCanvasAndPost(c);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ExecutionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
	private String convertStreamToString(InputStream is) {
	    String line = "";
	    StringBuilder total = new StringBuilder();
	    BufferedReader rd = new BufferedReader(new InputStreamReader(is));
	    try {
	        while ((line = rd.readLine()) != null) {
	            total.append(line);
	        }
	    } catch (Exception e) {
	        Toast.makeText(this, "Stream Exception", Toast.LENGTH_LONG).show();
	    }
	    return total.toString();
	}
    
    public String getIPInput() {
    	return "127.0.0.1";
    }
    
    
    private class NetworkPingTask extends AsyncTask<String, Integer, String> {

		@Override
		protected String doInBackground(String... params) {
			// TODO Auto-generated method stub
			HttpClient httpclient = new DefaultHttpClient();
			HttpGet httpget = new HttpGet(params[0]);
			try {
			    HttpResponse response = httpclient.execute(httpget);
			    if(response != null) {
			        String line = "";
			        InputStream inputstream = response.getEntity().getContent();
			        line = convertStreamToString(inputstream);
			        return line;
			    } else {
			        
			    }
			} catch (ClientProtocolException e) {
			    
			} catch (IOException e) {
			    
			} catch (Exception e) {
				Log.w("ExceptionW", "e=");
				Log.d("ExceptionD", "e: " + e);
			}
			return "No Response";
		}
    }
    /*If used action bar
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }*/
}
