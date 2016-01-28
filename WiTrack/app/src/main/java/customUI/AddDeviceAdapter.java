package customUI;

import android.content.Context;
import android.content.SharedPreferences;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;

import com.example.j388923r.witrack.R;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import util.Device;
import util.Setting;

/**
 * Created by j388923r on 1/27/16.
 */
public class AddDeviceAdapter extends BaseExpandableListAdapter {

    HashMap<Integer, ArrayList<Device>> deviceMap;
    Context _context;
    JSONArray devices;

    public AddDeviceAdapter(Context context, List<Device> devices) {
        this._context = context;
        deviceMap = new HashMap<>();
        deviceMap.put(0, new ArrayList<Device>());
        deviceMap.put(1, new ArrayList<Device>());
        deviceMap.put(2, new ArrayList<Device>());

        try {
            loadDevices();
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public void loadDevices() throws JSONException {
        SharedPreferences prefs = _context.getSharedPreferences("devices", Context.MODE_PRIVATE);
        devices = new JSONArray(prefs.getString("list", "[]"));
        // token = prefs.getString(_context.getString(R.string.token), "");
    }

    public void saveDevices() {
        SharedPreferences prefs = _context.getSharedPreferences("devices", Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = prefs.edit();
        JSONArray savedDeviceList = new JSONArray();
        editor.putString("list", savedDeviceList.toString());
        editor.commit();
    }

    @Override
    public int getGroupCount() {
        return 3;
    }

    @Override
    public int getChildrenCount(int i) {
        return 0;
    }

    @Override
    public Object getGroup(int i) {
        switch(i) {
            case 0:
                return "Saved Devices";
            case 1:
                return "Setup Devices";
            case 2:
                return "New or Moved Devices";
        }
        return null;
    }

    @Override
    public Object getChild(int i, int i1) {
        /*switch(i) {
            case 0:
                return "Alerts";
            case 1:
                return "Statistics";
            case 2:
                return "Tracking";
        }*/
        return null;
    }

    @Override
    public long getGroupId(int i) {
        return 0;
    }

    @Override
    public long getChildId(int i, int i1) {
        return 0;
    }

    @Override
    public boolean hasStableIds() {
        return false;
    }

    @Override
    public View getGroupView(int i, boolean b, View view, ViewGroup viewGroup) {
        return null;
    }

    @Override
    public View getChildView(int i, int i1, boolean b, View view, ViewGroup viewGroup) {
        return null;
    }

    @Override
    public boolean isChildSelectable(int i, int i1) {
        return false;
    }
}
