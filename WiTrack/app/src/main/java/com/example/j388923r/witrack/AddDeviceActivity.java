package com.example.j388923r.witrack;

import android.content.res.TypedArray;
import android.graphics.Color;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.TextView;

public class AddDeviceActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_device);

        Toolbar toolbar = (Toolbar) findViewById(R.id.add_device_toolbar);
        setSupportActionBar(toolbar);
        toolbar.setTitle("Add Device");

        findViewById(R.id.access_none).setBackgroundColor(Color.LTGRAY);
        findViewById(R.id.access_public).setBackgroundColor(Color.LTGRAY);
    }

    public void changeRealtimeAccess(View v) {
        TypedArray a = getTheme().obtainStyledAttributes(R.style.AppTheme, new int[] {R.attr.colorPrimary});
        int attributeResourceId = a.getResourceId(0, 0);

        if (v.getId() == R.id.access_none ) {
            v.setBackgroundColor(Color.parseColor("#3F51B5"));
            ((TextView)v).setTextColor(Color.WHITE);
            findViewById(R.id.access_public).setBackgroundColor(Color.LTGRAY);
            ((TextView)findViewById(R.id.access_public)).setTextColor(Color.BLACK);
            findViewById(R.id.access_restricted).setBackgroundColor(Color.LTGRAY);
            ((TextView)findViewById(R.id.access_restricted)).setTextColor(Color.BLACK);
        } else if (v.getId() == R.id.access_public ) {
            v.setBackgroundColor(Color.parseColor("#3F51B5"));
            ((TextView)v).setTextColor(Color.WHITE);
            findViewById(R.id.access_none).setBackgroundColor(Color.LTGRAY);
            ((TextView)findViewById(R.id.access_none)).setTextColor(Color.BLACK);
            findViewById(R.id.access_restricted).setBackgroundColor(Color.LTGRAY);
            ((TextView)findViewById(R.id.access_restricted)).setTextColor(Color.BLACK);
        } else if (v.getId() == R.id.access_restricted) {
            v.setBackgroundColor(Color.parseColor("#3F51B5"));
            ((TextView)v).setTextColor(Color.WHITE);
            findViewById(R.id.access_public).setBackgroundColor(Color.LTGRAY);
            ((TextView)findViewById(R.id.access_public)).setTextColor(Color.BLACK);
            findViewById(R.id.access_none).setBackgroundColor(Color.LTGRAY);
            ((TextView)findViewById(R.id.access_none)).setTextColor(Color.BLACK);
        }
    }

    public void save(View v) {

    }
}
