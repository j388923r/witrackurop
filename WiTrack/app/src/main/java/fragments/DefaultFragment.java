package fragments;

import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.example.j388923r.witrack.R;

/**
 * Created by j388923r on 1/8/16.
 */
public class DefaultFragment extends Fragment {
    public static final String ARG_OBJECT = "default";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup group, Bundle savedInstanceState) {
        View rootView = inflater.inflate(
                R.layout.activity_position_view, group, false);
        Bundle args = getArguments();
        return rootView;
    }
}
