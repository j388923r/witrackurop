package customUI;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.CheckBox;
import android.widget.ExpandableListAdapter;
import android.widget.TextView;

import com.example.j388923r.witrack.R;

import org.w3c.dom.Text;

import java.util.ArrayList;

import util.Setting;

/**
 * Created by j388923r on 1/23/16.
 */
public class SettingsAdapter extends BaseExpandableListAdapter {

    ArrayList<Setting> alerts;
    ArrayList<Setting> stats;
    ArrayList<Setting> tracking;

    Context _context;

    public SettingsAdapter(Context context) {
        this._context = context;
        alerts = new ArrayList<Setting>();
        stats = new ArrayList<Setting>();
        tracking = new ArrayList<Setting>();

        loadSettings();
    }

    public void loadSettings() {
        alerts.add(new Setting("Interrupt Setup", "Off"));
        alerts.add(new Setting("Interrupt Tracking", "On"));

        stats.add(new Setting("Chart Interaction", "Off"));

        tracking.add(new Setting("Large Multicoloring", "Off"));
        tracking.add(new Setting("3D Height View", "Off"));
        tracking.add(new Setting("External Visibility", "Off"));
    }

    @Override
    public int getGroupCount() {
        return 3;
    }

    @Override
    public int getChildrenCount(int i) {
        switch(i) {
            case 0:
                return alerts.size();
            case 1:
                return stats.size();
            case 2:
                return tracking.size();
        }
        return 0;
    }

    @Override
    public Object getGroup(int i) {
        switch(i) {
            case 0:
                return "Alerts";
            case 1:
                return "Statistics";
            case 2:
                return "Tracking";
        }
        return null;
    }

    @Override
    public Object getChild(int i, int i1) {
        switch(i) {
            case 0:
                return alerts.get(i1);
            case 1:
                return stats.get(i1);
            case 2:
                return tracking.get(i1);
        }

        return null;
    }

    @Override
    public long getGroupId(int i) {
        return i;
    }

    @Override
    public long getChildId(int i, int i1) {
        return i * 5 + i1;
    }

    @Override
    public boolean hasStableIds() {
        return false;
    }

    @Override
    public View getGroupView(int i, boolean b, View view, ViewGroup viewGroup) {
        String header = (String) getGroup(i);
        if (view == null) {
            LayoutInflater infalInflater = (LayoutInflater) this._context
                    .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            view = infalInflater.inflate(R.layout.settings_group, null);
        }

        TextView headerLabel = (TextView) view.findViewById(R.id.header);
        headerLabel.setText(header);
        return view;
    }

    @Override
    public View getChildView(int i, int i1, boolean b, View view, ViewGroup viewGroup) {
        Setting child = (Setting) getChild(i, i1);

        if (view == null) {
            LayoutInflater infalInflater = (LayoutInflater) this._context
                    .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            view = infalInflater.inflate(R.layout.settings_row, null);
        }

        TextView label = (TextView) view.findViewById(R.id.item);
        label.setText(child.display_name);

        CheckBox check = (CheckBox) view.findViewById(R.id.checked);
        check.setChecked(child.state.equals("On"));

        return view;
    }

    @Override
    public boolean isChildSelectable(int i, int i1) {
        return false;
    }
}
