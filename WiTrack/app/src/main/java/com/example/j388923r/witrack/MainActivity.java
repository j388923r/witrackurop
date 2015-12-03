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
import org.json.JSONObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
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


public class MainActivity extends Activity {

    SurfaceView answerView;
    SurfaceHolder holder;
    String ipAddress = "127.0.0.1";
    String username, password, userID;
    final InternetTask streaming = new InternetTask();
    List<PersonPath> recordedPaths;
    PersonPath currentPath;
    boolean started = false, tracking = false;
    String pointRecordingMethod = "Corner Marking";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        answerView = (SurfaceView)findViewById(R.id.surfaceview);
        holder = answerView.getHolder();

        Log.v("x, y" , "First");

        currentPath = new PersonPath();
        recordedPaths = new ArrayList<PersonPath>();

        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Server IP Address");

        // Set up the input
        final EditText input = new EditText(this);
        builder.setView(input);

        // Set up the buttons
        builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                ipAddress = input.getText().toString();
                Log.v("ipaddress", ipAddress);
                streaming.execute(ipAddress, username, password, userID);
            }
        });

        builder.show();

        AlertDialog.Builder loginBuilder = new AlertDialog.Builder(this);
        loginBuilder.setTitle("Login");

        final EditText usernameInput = new EditText(this);
        final EditText passwordInput = new EditText(this);

        passwordInput.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);

        LinearLayout lila1 = new LinearLayout(this);
        lila1.setOrientation(LinearLayout.VERTICAL);
        lila1.addView(usernameInput);
        lila1.addView(passwordInput);
        loginBuilder.setView(lila1);

        loginBuilder.setPositiveButton("Ok", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int whichButton) {
                username = usernameInput.getText().toString();
                password = passwordInput.getText().toString();
                Toast.makeText(getApplicationContext(), username, Toast.LENGTH_SHORT).show();
                NetworkPingTask ping = new NetworkPingTask();
                ping.execute("http://witrackurop.azurewebsites.net/api/tempAccount", username, password);

                /*try {
                    setUserID(ping.get());
                } catch (InterruptedException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                } catch (ExecutionException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }*/
            }
        });
        loginBuilder.show();

        Log.v("Starting Stream", "stream");

        Parse.initialize(this, "qUFOUjf6omK7m3qy3o38YBP9s8XbrGYgoER5YvRM", "waBDv05GCS7v9DiJQc0PraAsZDgOnDEds1gu9eqI");
        ParseInstallation.getCurrentInstallation().saveInBackground();
    }

    public void setUserID(String id) {
        userID = id;
        Toast.makeText(getApplicationContext(), id, Toast.LENGTH_SHORT).show();
    }

    public void PrimaryFunction(View v) {
        if(!started) {
            started = true;
            tracking = true;
            ((Button)v).setText("Stop");
            View secondaryButton= findViewById(R.id.secondarybutton);
            ((Button)secondaryButton).setText("Stop Recording");
            streaming.setPath(currentPath);
            Toast.makeText(getApplicationContext(), "Tracking Started", Toast.LENGTH_SHORT).show();
        } else {
            started = false;
            tracking = false;
            ((Button)v).setText("Start");
            View secondaryButton= findViewById(R.id.secondarybutton);
            ((Button)secondaryButton).setText(pointRecordingMethod);
            recordedPaths.add(currentPath);
            RectF bounds = currentPath.getBounds();
            SaveRoomTask ping = new SaveRoomTask();
            ping.execute("http://witrackurop.azurewebsites.net/api/room", userID, "ROM", String.valueOf((int)bounds.top), String.valueOf((int)bounds.left), String.valueOf((int)bounds.bottom), String.valueOf((int)bounds.right));
            currentPath = new PersonPath(Color.rgb((int)(Math.random() * 256), (int)(Math.random() * 256), (int)(Math.random() * 256)));
            streaming.setPath(currentPath);
            Toast.makeText(getApplicationContext(), "Tracking Finished", Toast.LENGTH_SHORT).show();
        }
    }

    public void SecondaryFunction(View v) {
        if(started){
            if(pointRecordingMethod.equals("Corner Marking")) {
                tracking = true;
            } else if(pointRecordingMethod.equals("Continuous")) {
                tracking = !tracking;
                if(tracking)
                    ((Button)v).setText("Pause Recording");
                else
                    ((Button)v).setText("Record");
            }
        } else {
            if(pointRecordingMethod.equals("Corner Marking")) {
                pointRecordingMethod = "Continuous";
            } else if(pointRecordingMethod.equals("Continuous")) {
                pointRecordingMethod = "Corner Marking";
            }
            ((Button)v).setText(pointRecordingMethod);
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
        return "18.189.76.94";
    }

    public boolean recordPoint(int x, int y) {
        if(started && tracking) {
            currentPath.addPoint(x, y);
            if(pointRecordingMethod.equals("Corner Marking")) {
                tracking = false;
            }
        }
        return started;
    }

    /** Called when the user touches the button */
    public void recordRoom(View view) {

    }

    private class NetworkPingTask extends AsyncTask<String, Integer, String> {

        @Override
        protected String doInBackground(String... params) {
            // TODO Auto-generated method stub
            HttpClient httpclient = new DefaultHttpClient();
            HttpPost httpPost = new HttpPost(params[0]);
            boolean loggedin = false;
            while(!loggedin) {
                List<NameValuePair> formparams = new ArrayList<NameValuePair>();
                formparams.add(new BasicNameValuePair("userEmail", params[1]));
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
                        line = convertStreamToString(inputstream);
                        if (!line.startsWith("Please")){
                            loggedin = true;
                            setUserID(line);
                            return line;
                        }
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

    private class SaveRoomTask extends AsyncTask<String, Integer, String> {

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
            /*new Thread(
                new Runnable() {
                    public void run() {
                    try {
                        Log.v("ipaddress", params[0]);
                        Socket socket = new Socket(params[0], 4444);
                        Log.v("Socket", "Connected");
                        DataInputStream in =
                                new DataInputStream(socket.getInputStream());
                        DataOutputStream out =
                                new DataOutputStream(socket.getOutputStream());
                        out.writeUTF("Username " + params[1] + " Password " + params[2]);
                        out.writeUTF(params[3]);
                        x = in.readInt();
                        y = in.readInt();
                        path = new PersonPath(x, y, Color.rgb((int)(Math.random() * 256), (int)(Math.random() * 256), (int)(Math.random() * 256)));
                        publishProgress(x, y);
                        while (true) {
                            x = in.readInt();
                            y = in.readInt();
                            recordingPath = recordPoint(x, y);
                            publishProgress(x, y);
                        }
                    } catch(IOException ioe) {
                        ioe.printStackTrace();
                    }
                    }
                }
            ).start();*/

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

            }).on("positions", new Emitter.Listener() {

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
