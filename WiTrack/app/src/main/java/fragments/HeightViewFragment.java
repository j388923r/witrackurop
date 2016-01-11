package fragments;


import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.example.j388923r.witrack.R;

/**
 * A simple {@link Fragment} subclass.
 */
public class HeightViewFragment extends Fragment {


    public HeightViewFragment() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootView = inflater.inflate(
                R.layout.height_view_layout, container, false);
        Bundle args = getArguments();
        return rootView;
    }

}
