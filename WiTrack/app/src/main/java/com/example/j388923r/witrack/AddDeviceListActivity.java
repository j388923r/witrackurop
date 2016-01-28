package com.example.j388923r.witrack;

import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.AppCompatActivity;
import android.widget.ExpandableListView;

import java.util.ArrayList;

import customUI.AddDeviceAdapter;
import customUI.SettingsAdapter;
import util.Device;

public class AddDeviceListActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_device_list);

        ExpandableListView elv = (ExpandableListView)findViewById(R.id.settings_list);

        AddDeviceAdapter sa = new AddDeviceAdapter(this, new ArrayList<Device>());

        elv.setAdapter(sa);

        if (sa.getChildrenCount(0) != 0)
            elv.expandGroup(0);
        if (sa.getChildrenCount(1) != 0)
            elv.expandGroup(1);
        if (sa.getChildrenCount(2) != 0)
            elv.expandGroup(2);
    }

}
