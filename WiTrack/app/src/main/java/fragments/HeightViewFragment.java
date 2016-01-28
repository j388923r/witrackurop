package fragments;


import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.RectF;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.example.j388923r.witrack.R;
import com.github.mikephil.charting.charts.BarChart;
import com.github.mikephil.charting.charts.LineChart;
import com.github.mikephil.charting.data.BarData;
import com.github.mikephil.charting.data.BarDataSet;
import com.github.mikephil.charting.data.BarEntry;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.LineData;
import com.github.mikephil.charting.data.LineDataSet;
import com.github.mikephil.charting.formatter.YAxisValueFormatter;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.URISyntaxException;
import java.util.ArrayList;

import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;
import util.PersonPath;
import util.Position;
import util.Util;

/**
 * A simple {@link Fragment} subclass.
 */
public class HeightViewFragment extends Fragment {

    private static final String ARG_PARAM1 = "token";
    private static final String ARG_PARAM2 = "deviceId";

    String socketURL = "https://www.devemerald.com/";
    private String token, userID;
    private int deviceId;
    private BarChart chart;

    Socket socket;
    SocketTask streaming;
    public boolean socketAvailable = false;

    public HeightViewFragment() {
        // Required empty public constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootView = inflater.inflate(
                R.layout.height_view_layout, container, false);
        Bundle args = getArguments();

        if (getArguments() != null) {
            token = getArguments().getString(ARG_PARAM1);
            deviceId = getArguments().getInt(ARG_PARAM2);
        }

        // in this example, a LineChart is initialized from xml
        chart = (BarChart) rootView.findViewById(R.id.heightchart);
        // no description text
        chart.setDescription("Height Values");
        chart.setNoDataTextDescription("There is no data available for this time");

        // startSocket();

        try {
            socket = IO.socket(socketURL);
            streaming = new SocketTask(socket);
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }

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

        public SocketTask(Socket socket){
            this.socket = socket;
        }
        @Override
        protected String doInBackground(final String... params) {

            Socket socket = null;
            try {
                socket = IO.socket(params[0]);
            } catch (URISyntaxException e) {
                e.printStackTrace();
            }
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
                    Position[] positions = new Position[args.length];
                    for (int i = 0; i < args.length; i++) {
                        JSONObject obj = (JSONObject) args[i];
                        try {
                            positions[i] = new Position(obj.getDouble("x"), obj.getDouble("y"), obj.getDouble("z"), obj.getInt("personId"));
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        publishProgress(positions);
                    }
                    publishProgress(positions);
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

            ArrayList<String> xVals = new ArrayList<String>();
            for (int i = 0; i < 6; i++) {
                xVals.add((i) + "");
            }

            ArrayList<BarEntry> yVals = new ArrayList<>();

            for (int i = 0; i < 6; i++) {

                float mult = (27 + 1);
                float val = (float) (Math.random() * mult) + 3;// + (float)
                // ((mult * 0.1) / 10);
                yVals.add(new BarEntry(val, i));
            }

            // create a dataset and give it a type
            BarDataSet set1 = new BarDataSet(yVals, "Height (m)");
            // set1.setFillAlpha(110);
            // set1.setFillColor(Color.RED);

            // set the line to be drawn like this "- - - - - -"
            /* set1.enableDashedLine(10f, 5f, 0f);
            set1.enableDashedHighlightLine(10f, 5f, 0f);
            set1.setColor(Color.BLACK);
            set1.setCircleColor(Color.BLACK);
            set1.setLineWidth(1f);
            set1.setDrawCircleHole(false);
            set1.setValueTextSize(9f);
            set1.setFillAlpha(65);
            set1.setFillColor(Color.BLACK);
            // set1.setDrawFilled(true); */
            // set1.setShader(new LinearGradient(0, 0, 0, mChart.getHeight(),
            // Color.BLACK, Color.WHITE, Shader.TileMode.MIRROR));

            ArrayList<BarDataSet> dataSets = new ArrayList<>();
            dataSets.add(set1); // add the datasets

            // create a data object with the datasets
            BarData data = new BarData(xVals, dataSets);

            // set data
            chart.setData(data);
        }

    }

}
