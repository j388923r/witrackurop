package fragments;

import android.app.Dialog;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.TextView;
import android.widget.TimePicker;

import util.AsyncResponse;
import com.example.j388923r.witrack.R;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

import util.Frame;
import util.Position;
import util.Util;

/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link ReplayFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link ReplayFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class ReplayFragment extends Fragment implements AsyncResponse {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "token";
    private static final String ARG_PARAM2 = "deviceId";

    // TODO: Rename and change types of parameters
    private String token, userID;
    private int deviceId = 1;

    private String replayUrl = "https://www.devemerald.com/api/v1/device/frames";
    Timer frameTimer;
    private AsyncResponse ar;
    private DatePicker datePicker;
    private Dialog datetimeDialog;
    private TimePicker timePicker;
    private TextView dateView;
    Calendar calendar;
    long nextTime = 0;
    int frameIndex = 0;

    SurfaceView replayView;
    SurfaceHolder holder;

    private OnFragmentInteractionListener mListener;

    public ReplayFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param token Parameter 1.
     * @param deviceId Parameter 2.
     * @return A new instance of fragment ReplayFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static ReplayFragment newInstance(String token, int deviceId) {
        ReplayFragment fragment = new ReplayFragment();
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
                R.layout.activity_replay, container, false);
        Bundle args = getArguments();
        replayView = (SurfaceView) rootView.findViewById(R.id.replay_surface);
        holder = replayView.getHolder();

        ar = this;

        calendar = Calendar.getInstance();

        datetimeDialog = new Dialog(getActivity());
        datetimeDialog.setContentView(R.layout.datetime_layout);

        datePicker = (DatePicker) datetimeDialog.findViewById(R.id.replay_date);
        dateView = (TextView) datetimeDialog.findViewById(R.id.replay_dateview);
        timePicker = (TimePicker) datetimeDialog.findViewById(R.id.replay_time);

        setupDatetimeDialog(datePicker, timePicker);

        datetimeDialog.setTitle("Pick a date:");

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
                        nextTime = 1449554883000L;

                        Util.GetReplayDataTask task = new Util.GetReplayDataTask(ar);
                        task.execute(replayUrl, token, String.valueOf(deviceId), String.valueOf(nextTime));

                        datetimeDialog.dismiss();

                        break;
                }
            }
        });

        return rootView;
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

    @Override
    public void setUserVisibleHint(boolean visibleHint) {
        super.setUserVisibleHint(visibleHint);
        if(visibleHint)
            datetimeDialog.show();
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

    // TODO: Rename method, update argument and hook method into UI event
    public void onButtonPressed(Uri uri) {
        if (mListener != null) {
            mListener.onFragmentInteraction(uri);
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    @Override
    public void processFinish(JSONObject object) {
        playFrames(getFrames(object));
    }

    private class ReplayTimerTask extends TimerTask {

        ArrayList<Frame> frames;
        ReplayFragment replay;
        public ReplayTimerTask(ArrayList<Frame> frames, ReplayFragment replay) {
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
                task.execute(replayUrl, token, String.valueOf(deviceId), String.valueOf(nextTime));
            }

            holder.unlockCanvasAndPost(c);
        }
    }

    /**
     * This interface must be implemented by activities that contain this
     * fragment to allow an interaction in this fragment to be communicated
     * to the activity and potentially other fragments contained in that
     * activity.
     * <p/>
     * See the Android Training lesson <a href=
     * "http://developer.android.com/training/basics/fragments/communicating.html"
     * >Communicating with Other Fragments</a> for more information.
     */
    public interface OnFragmentInteractionListener {
        // TODO: Update argument type and name
        void onFragmentInteraction(Uri uri);
    }
}
