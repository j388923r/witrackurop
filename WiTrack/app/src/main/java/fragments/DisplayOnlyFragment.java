package fragments;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.RectF;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;

import com.example.j388923r.witrack.R;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URISyntaxException;

import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;
import util.PersonPath;
import util.Position;
import util.Util;

/**
 * A simple {@link Fragment} subclass.
 * Use the {@link DisplayOnlyFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class DisplayOnlyFragment extends Fragment {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "token";
    private static final String ARG_PARAM2 = "deviceId";

    // TODO: Rename and change types of parameters
    SurfaceView displayView;
    SurfaceHolder holder;

    private String token, userID;
    private int deviceId;
    public boolean socketAvailable = false;

    float minX = -4.0f;
    float maxX = 4.0f;
    float minY = 0.0f;
    float maxY = 14.0f;
    float pointRadius = 20.0f;

    Socket socket;
    SocketTask streaming;

    public DisplayOnlyFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param token Parameter 1.
     * @param deviceId Parameter 2.
     * @return A new instance of fragment DisplayOnlyFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static DisplayOnlyFragment newInstance(String token, int deviceId) {
        DisplayOnlyFragment fragment = new DisplayOnlyFragment();
        Bundle args = new Bundle();
        args.putString(ARG_PARAM1, token);
        args.putInt(ARG_PARAM2, deviceId);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            token = getArguments().getString(ARG_PARAM1);
            deviceId = getArguments().getInt(ARG_PARAM2);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootView = inflater.inflate(
                R.layout.display_only_layout, container, false);
        Bundle args = getArguments();
        if (args != null) {
            token = getArguments().getString(ARG_PARAM1);
            deviceId = getArguments().getInt(ARG_PARAM2);
        }
        displayView = (SurfaceView) rootView.findViewById(R.id.displayview);
        holder = displayView.getHolder();

        try {
            socket = IO.socket(Util.socketURL);
            streaming = new SocketTask(socket);
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }

        startSocket();

        return rootView;
    }

    public void startSocket() {
        socketAvailable = true;
        if(!socket.connected())
            streaming.execute(Util.socketURL, token, String.valueOf(deviceId), userID);
    }

    public void killSocket(){
        if(socketAvailable)
            socket.disconnect();
    }

    private class SocketTask extends AsyncTask<String, Position, String> {

        boolean recordingPath = false;
        Socket socket;

        public SocketTask(Socket socket) {
            this.socket = socket;
        }

        @Override
        protected String doInBackground(final String... params) {

            final Socket finalSocket = socket;
            Log.v("Connection", "Trying to connect");
            socket.on(Socket.EVENT_CONNECT, new Emitter.Listener() {

                @Override
                public void call(Object... args) {
                    JSONObject connectObject = new JSONObject();
                    try {
                        connectObject.put("deviceId", deviceId);
                        connectObject.put("token", token);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    finalSocket.emit("start", connectObject);
                }

            }).on("frames", new Emitter.Listener() {

                @Override
                public void call(Object... args) {
                    try {
                        JSONArray people = ((JSONObject) args[0]).getJSONArray("people");
                        Position[] positions = new Position[people.length()];
                        for (int i = 0; i < people.length(); i++) {
                            JSONObject obj = (JSONObject) people.getJSONObject(i);
                            positions[i] = new Position((obj.getDouble("x") - minX) / (maxX - minX) * displayView.getMeasuredWidth(),
                                    (obj.getDouble("y") - minY) / (maxY - minY) * displayView.getMeasuredHeight(),  obj.getDouble("z"), obj.getInt("personId"));
                        }
                        publishProgress(positions);
                    }catch (JSONException e) {
                        e.printStackTrace();
                    }
                }

            }).on("boundary", new Emitter.Listener() {

                @Override
                public void call(Object... args) {
                    JSONObject obj = (JSONObject) args[0];
                }

            }).on(Socket.EVENT_DISCONNECT, new Emitter.Listener() {

                @Override
                public void call(Object... args) {
                    Log.v("Connection", "Disconnected");
                }

            });
            socket.connect();

            publishProgress();

            return "Failed Connection";
        }

        @Override
        protected void onProgressUpdate(Position... values) {
            Canvas c = holder.lockCanvas();
            if(c != null) {
                c.drawARGB(255, 234, 243, 234);
                if(values.length > 0) {
                    Paint roomBackgroundPaint = new Paint();
                    roomBackgroundPaint.setColor(Color.LTGRAY);
                    c.drawRect(95, 95, 405, 405, roomBackgroundPaint);

                    Paint oldPathPaint = new Paint();
                    oldPathPaint.setStyle(Paint.Style.STROKE);
                    /* for (PersonPath p : recordedPaths) {
                        oldPathPaint.setColor(p.color);
                        c.drawPath(p.getPath(), oldPathPaint);
                        c.drawRect(p.getBounds(), oldPathPaint);
                    } */

                    for (int i = 0; i < values.length; i++) {
                        Paint colorPaint = new Paint();
                        colorPaint.setColor(Color.BLACK);//Util.colorWheel[i] % Util.colorWheel.length

                        colorPaint.setStyle(Paint.Style.FILL);
                        c.drawOval(new RectF(values[i].x - pointRadius, values[i].y - pointRadius, values[i].x + pointRadius, values[i].y + pointRadius), colorPaint);
                    }

                    holder.unlockCanvasAndPost(c);
                } else {
                    Paint blackPaint = new Paint();
                    blackPaint.setColor(Color.BLACK);
                    blackPaint.setTextSize(60f);
                    c.drawText("No objects detected.", c.getWidth() * 0.25f, c.getHeight() * 0.25f, blackPaint);

                    holder.unlockCanvasAndPost(c);
                }
            }
        }

    }
}
