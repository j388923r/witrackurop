package com.example.j388923r.witrack;

import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.AppCompatActivity;
import android.widget.ExpandableListView;

import customUI.SettingsAdapter;

public class SettingsActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_settings);

        ExpandableListView elv = (ExpandableListView)findViewById(R.id.settings_list);

        SettingsAdapter sa = new SettingsAdapter(this);

        elv.setAdapter(sa);

        elv.expandGroup(0);
        elv.expandGroup(1);
        elv.expandGroup(2);
    }

}
