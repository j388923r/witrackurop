package customUI;

import android.content.Context;
import android.content.SharedPreferences;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.BaseExpandableListAdapter;
import android.widget.CheckBox;
import android.widget.ListView;
import android.widget.TextView;

import com.example.j388923r.witrack.R;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import util.Device;
import util.Setting;
import util.Util;

/**
 * Created by j388923r on 1/27/16.
 */
public class AddDeviceAdapter extends BaseExpandableListAdapter implements Util.AsyncArrayResponse {

    HashMap<Integer, ArrayList<Device>> deviceMap;
    Context _context;
    JSONArray devices;

    public AddDeviceAdapter(Context context, List<Device> devices, String token) {
        this._context = context;
        deviceMap = new HashMap<>();
        deviceMap.put(0, new ArrayList<Device>());
        deviceMap.put(1, new ArrayList<Device>());
        deviceMap.put(2, new ArrayList<Device>());

        try {
            loadDevices();

            Util.GetDevicesTask getDevices = new Util.GetDevicesTask(this);

            getDevices.execute("https://www.devemerald.com/api/v1/user/devices", token);
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
    public void processFinish(JSONArray array) {
        String[] deviceNameArray = new String[array.length()];

        for(int i = 0; i < array.length(); i++) {
            try {
                JSONObject object = array.getJSONObject(i);
                Device device = new Device(
                    object.getString("title"),
                    object.getString("setupTitle"),
                    object.getInt("id"),
                    object.getInt("setupId"),
                    object.getBoolean("realtimeAccess")
                );

                for(int j = 0; j < devices.length(); j++) {
                    Device obj = (Device)devices.get(i);
                    if (device.id == obj.id && device.title.equals(obj.title)) {
                        deviceMap.get(0).add(device);
                        break;
                    }
                }

                if(device.setup_id >= 0) {
                    deviceMap.get(1).add(device);
                } else {
                    deviceMap.get(2).add(device);
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }

        }

        notifyDataSetChanged();
    }

    public void remove(Device device) {

    }

    public void save(Device device) {

    }

    @Override
    public int getGroupCount() {
        return deviceMap.keySet().size();
    }

    @Override
    public int getChildrenCount(int i) {
        return deviceMap.get(i).size();
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
        return deviceMap.get(i).get(i1);
    }

    @Override
    public long getGroupId(int i) {
        return i;
    }

    @Override
    public long getChildId(int i, int i1) {
        return deviceMap.get(i).get(i1).id;
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
        Device child = (Device) getChild(i, i1);

        if (view == null) {
            LayoutInflater infalInflater = (LayoutInflater) this._context
                    .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            view = infalInflater.inflate(R.layout.device_selection_item, null);
        }

        TextView label = (TextView) view.findViewById(R.id.device_label);
        label.setText(child.title);

        return view;
    }

    @Override
    public boolean isChildSelectable(int i, int i1) {
        return deviceMap.get(i).size() != 0;
    }
}
