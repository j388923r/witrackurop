package com.example.j388923r.witrack;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
//import java.net.Socket;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Point;
import android.graphics.RectF;
import android.os.AsyncTask;
import android.os.Bundle;
import android.text.InputType;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.parse.Parse;
import com.parse.ParseInstallation;

import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;
import util.PersonPath;
import util.Util;


public class MainActivity extends Activity implements AsyncResponse {

    String tokenGenerationURL = "https://www.devemerald.com/api/v1/token/generate";
    String username, password, token;
    int userId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        SharedPreferences prefs = this.getPreferences(Context.MODE_PRIVATE);
        userId = prefs.getInt(getString(R.string.userId), -1);
        token = prefs.getString(getString(R.string.token), "");

        JSONObject login = new JSONObject();
        if(userId >= 0 && !token.equals("")) {
            try {
                login.put(getString(R.string.userId), userId);
                login.put(getString(R.string.token), token);
                processFinish(login);
            } catch (Exception e) {}
        }

        //Parse.initialize(this, "qUFOUjf6omK7m3qy3o38YBP9s8XbrGYgoER5YvRM", "waBDv05GCS7v9DiJQc0PraAsZDgOnDEds1gu9eqI");
        //ParseInstallation.getCurrentInstallation().saveInBackground();
    }

    public void login(View view) {
        username = ((EditText)findViewById(R.id.username)).getText().toString();
        password = ((EditText)findViewById(R.id.password)).getText().toString();
        NetworkPingTask login = new NetworkPingTask(this);
        login.execute(tokenGenerationURL, username, password);
    }

    @Override
    public void processFinish(JSONObject object) {
        try {
            token = object.getString("token");
            userId = object.getInt("user");
        } catch (JSONException e) {
            e.printStackTrace();
        }

        SharedPreferences prefs = this.getPreferences(Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = prefs.edit();
        editor.putString(getString(R.string.token), token);
        editor.putInt(getString(R.string.userId), userId);
        editor.commit();

        Intent i = new Intent(this, DeviceSelectorActivity.class);
        i.putExtra("token", token);
        i.putExtra("userId", userId);

        startActivity(i);
    }

    private class NetworkPingTask extends AsyncTask<String, Integer, JSONObject> {

        AsyncResponse response;

        public NetworkPingTask(AsyncResponse response) {
            this.response = response;
        }

        @Override
        protected JSONObject doInBackground(String... params) {
            // TODO Auto-generated method stub
            HttpClient httpclient = new DefaultHttpClient();
            HttpPost httpPost = new HttpPost(params[0]);
            boolean loggedin = false;
            while(!loggedin) {
                List<NameValuePair> formparams = new ArrayList<NameValuePair>();
                formparams.add(new BasicNameValuePair("email", params[1]));
                formparams.add(new BasicNameValuePair("password", params[2]));
                try {
                    httpPost.setEntity(new UrlEncodedFormEntity(formparams));
                } catch (UnsupportedEncodingException uee) {
                    uee.printStackTrace();
                }
                try {
                    HttpResponse response = httpclient.execute(httpPost);
                    if (response != null) {
                        String line = "";
                        InputStream inputstream = response.getEntity().getContent();
                        line = Util.convertStreamToString(inputstream);
                        JSONObject reader = new JSONObject(line);
                        boolean success = reader.getBoolean("success");
                        if (success) {
                            JSONObject data = reader.getJSONObject("data");
                            return data;
                        }
                    }
                } catch (ClientProtocolException e) {

                } catch (IOException e) {

                } catch (Exception e) {
                    Log.w("ExceptionW", "e=");
                    Log.d("ExceptionD", "e: " + e);
                }
            }
            return new JSONObject();
        }

        public void onPostExecute(JSONObject object) {
            response.processFinish(object);
        }
    }

 /*   private class SaveRoomTask extends AsyncTask<String, Integer, String> {

        @Override
        protected String doInBackground(String... params) {
            // TODO Auto-generated method stub
            HttpClient httpclient = new DefaultHttpClient();
            HttpPost httpPost = new HttpPost(params[0]);
            boolean loggedin = false;
            while(!loggedin) {
                List<NameValuePair> formparams = new ArrayList<NameValuePair>();
                formparams.add(new BasicNameValuePair("creator", params[1]));
                formparams.add(new BasicNameValuePair("Name", params[2]));
                formparams.add(new BasicNameValuePair("top", params[3]));
                formparams.add(new BasicNameValuePair("left", params[4]));
                formparams.add(new BasicNameValuePair("bottom", params[5]));
                formparams.add(new BasicNameValuePair("right", params[6]));
                try {
                    httpPost.setEntity(new UrlEncodedFormEntity(formparams));
                } catch (UnsupportedEncodingException uee) {
                    uee.printStackTrace();
                }
                try {
                    HttpResponse response = httpclient.execute(httpPost);
                    if (response != null) {
                        String line = "";
                        InputStream inputstream = response.getEntity().getContent();
                        line = convertStreamToString(inputstream);
                    } else {

                    }
                } catch (ClientProtocolException e) {

                } catch (IOException e) {

                } catch (Exception e) {
                    Log.w("ExceptionW", "e=");
                    Log.d("ExceptionD", "e: " + e);
                }
            }
            return "No Response";
        }
    }

    class InternetTask extends AsyncTask<String, Integer, String> {

        boolean recordingPath = false;
        int x = 100, y = 100;
        PersonPath path;

        public void setPath(PersonPath newPath) {
            path = newPath;
        }

        @Override
        protected String doInBackground(final String... params) {

            Socket socket = null;
            try {
                socket = IO.socket("http://ec2-52-91-83-213.compute-1.amazonaws.com");
            } catch (URISyntaxException e) {
                e.printStackTrace();
            }
            final Socket finalSocket = socket;
            Log.v("Connection", "Trying to connect");
            socket.on(Socket.EVENT_CONNECT, new Emitter.Listener() {

                @Override
                public void call(Object... args) {
                    Log.v("Connection", "Started");
                }

            }).on("frames", new Emitter.Listener() {

                @Override
                public void call(Object... args) {
                    JSONObject obj = (JSONObject) args[0];
                    Log.v("JSONLENGTH", obj.length() + "");
                    while(obj.keys().hasNext()){
                        Log.v("Key ",obj.keys().next());
                    }
                    //x = in.readInt();
                    //y = in.readInt();
                    //recordingPath = recordPoint(x, y);
                    publishProgress(x, y);
                }

            }).on("boundary", new Emitter.Listener() {

                @Override
                public void call(Object... args) {
                    JSONObject obj = (JSONObject)args[0];
                }

            }).on(Socket.EVENT_DISCONNECT, new Emitter.Listener() {

                @Override
                public void call(Object... args) {
                    Log.v("Connection", "Disconnected");
                }

            });
            socket.connect();

            return "Failed Connection";
        }

        @Override
        protected void onProgressUpdate(Integer... values) {
            Canvas c = holder.lockCanvas();
            if(c != null) {
                c.drawARGB(255, 234, 243, 234);
                Paint roomBackgroundPaint = new Paint();
                roomBackgroundPaint.setColor(Color.LTGRAY);
                c.drawRect(95, 95, 405, 405, roomBackgroundPaint);

                Paint oldPathPaint = new Paint();
                oldPathPaint.setStyle(Paint.Style.STROKE);
                for (PersonPath p : recordedPaths) {
                    oldPathPaint.setColor(p.color);
                    c.drawPath(p.getPath(), oldPathPaint);
                    c.drawRect(p.getBounds(), oldPathPaint);
                }

                Paint redPaint = new Paint();
                redPaint.setColor(Color.RED);

                if (recordingPath) {
                    redPaint.setStyle(Paint.Style.STROKE);
                    c.drawPath(path.getPath(), redPaint);
                }

                redPaint.setStyle(Paint.Style.FILL);
                c.drawOval(new RectF(x - 10, y - 10, x + 10, y + 10), redPaint);

                holder.unlockCanvasAndPost(c);
            }
        }

    }
    */

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
