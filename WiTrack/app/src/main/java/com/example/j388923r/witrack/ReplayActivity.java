package com.example.j388923r.witrack;

import android.app.Dialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.TextView;
import android.widget.TimePicker;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

import util.AsyncResponse;
import util.Frame;
import util.Position;
import util.Util;

public class ReplayActivity extends AppCompatActivity implements AsyncResponse {

    private String replayUrl = "https://www.devemerald.com/api/v1/device/frames";
    String token;
    int deviceId = 1, userId;
    Timer frameTimer;
    private AsyncResponse ar;
    private DatePicker datePicker;
    private TimePicker timePicker;
    private TextView dateView;
    private Calendar calendar;
    private SurfaceHolder holder;
    private ArrayList<Frame> frames1 = new ArrayList<Frame>();
    private ArrayList<Frame> frames2 = new ArrayList<Frame>();
    private int currentIndex = 0, frameIndex = 0;
    private long nextTime = 1449554883000L;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_replay);

        SharedPreferences prefs = this.getSharedPreferences("login", Context.MODE_PRIVATE);
        userId = prefs.getInt(getString(R.string.userId), -1);
        token = prefs.getString(getString(R.string.token), "");

        ar = this;
        SurfaceView surfaceView = (SurfaceView) findViewById(R.id.replay_surface);
        holder = surfaceView.getHolder();

        calendar = Calendar.getInstance();

        final Dialog datetimeDialog = new Dialog(this);
        datetimeDialog.setContentView(R.layout.datetime_layout);

        datePicker = (DatePicker) datetimeDialog.findViewById(R.id.replay_date);
        dateView = (TextView) datetimeDialog.findViewById(R.id.replay_dateview);
        timePicker = (TimePicker) datetimeDialog.findViewById(R.id.replay_time);

        setupDatetimeDialog(datePicker, timePicker);

        datetimeDialog.setTitle("Pick a date:");
        datetimeDialog.show();

        Button next = (Button) datetimeDialog.findViewById(R.id.replay_move);
        next.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Button thisButton = (Button) view;
                switch (thisButton.getText().charAt(0)) {
                    case 'N':
                        datePicker.setVisibility(View.GONE);
                        timePicker.setVisibility(View.VISIBLE);
                        calendar.set(datePicker.getYear(), datePicker.getMonth(), datePicker.getDayOfMonth());
                        SimpleDateFormat format = new SimpleDateFormat("EEE, MMMM d, yyyy");
                        String date = String.format("%s\n%d:%02d %s", format.format(calendar.getTime()), (timePicker.getCurrentHour() % 12 == 0 ? 12 : timePicker.getCurrentHour() % 12), timePicker.getCurrentMinute(), (timePicker.getCurrentHour() < 12 ? "AM" : "PM"));
                        dateView.setText(date);
                        thisButton.setText("Start Replay");
                        break;
                    case 'S':
                        nextTime = calendar.getTimeInMillis() + (1000 * 60 * ((timePicker.getCurrentHour() * 60) + timePicker.getCurrentMinute()));

                        Util.GetReplayDataTask task = new Util.GetReplayDataTask(ar);
                        task.execute(replayUrl, token, String.valueOf(deviceId),String.valueOf(nextTime));

                        datetimeDialog.dismiss();

                        break;
                }
            }
        });
    }

    public void setupDatetimeDialog(DatePicker dp, TimePicker tp) {
        Date date = new Date();
        Date fortnightpast = new Date(date.getTime() - 14 * Util.DAY_IN_MS);
        datePicker.setMinDate(fortnightpast.getTime());
        datePicker.setMaxDate(date.getTime());

        timePicker.setOnTimeChangedListener(new TimePicker.OnTimeChangedListener() {
            @Override
            public void onTimeChanged(TimePicker timePicker, int hour, int minute) {
                SimpleDateFormat format = new SimpleDateFormat("EEE, MMMM d, yyyy");
                String date = String.format("%s\n%d:%02d %s", format.format(calendar.getTime()), (hour % 12 == 0 ? 12 : hour % 12), minute, (hour < 12 ? "AM" : "PM"));
                dateView.setText(date);
            }
        });
    }

    public ArrayList<Frame> getFrames(JSONObject object) {
        ArrayList<Frame> returnFrames = new ArrayList<Frame>();

        try {
            JSONObject data = object.getJSONObject("data");
            nextTime = data.getLong("timeEnd");

            JSONArray frames = data.getJSONArray("frames");
            for(int i = 0; i < frames.length(); ++i) {
                JSONObject f = frames.getJSONObject(i);
                Frame frame = new Frame(f.getString("time"));

                JSONArray positions = f.getJSONArray("people");
                for (int j = 0; j < positions.length(); j++) {
                    JSONObject person = positions.getJSONObject(j);
                    Position p = new Position(person.getDouble("x"), person.getDouble("y"), person.getDouble("z"), person.getInt("personId"));
                    frame.addPerson(p);
                }

                returnFrames.add(frame);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return returnFrames;
    }

    public void playFrames(final ArrayList<Frame> frames) {
        frameIndex = 0;
        frameTimer = new Timer("Play Frames");
        frameTimer.scheduleAtFixedRate(new ReplayTimerTask(frames, this), 30, 30);
    }

    public void processFinish(JSONObject object) {
        playFrames(getFrames(object));
    }

    private class ReplayTimerTask extends TimerTask {

        ArrayList<Frame> frames;
        ReplayActivity replay;
        public ReplayTimerTask(ArrayList<Frame> frames, ReplayActivity replay) {
            this.frames = frames;
            this.replay = replay;
        }

        @Override
        public void run() {
            Canvas c = holder.lockCanvas();
            if (frameIndex < frames.size()) {
                Frame frame = frames.get(frameIndex);
                for (int i = 0; i < frame.getPeople().size(); i++) {
                    Paint color = new Paint();
                    color.setColor(Util.colorWheel[i]);
                    float x = frame.getPeople().get(i).x;
                    float y = frame.getPeople().get(i).y;
                    c.drawOval(new RectF(x - 5, y - 5, x + 5, y + 5), color);
                }
                frameIndex++;
            } else {
                frameTimer.cancel();
                Util.GetReplayDataTask task = new Util.GetReplayDataTask(replay);
                task.execute(replayUrl, token, String.valueOf(deviceId),String.valueOf(nextTime));
            }

            holder.unlockCanvasAndPost(c);
        }
    }
}