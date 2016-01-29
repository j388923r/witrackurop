package com.example.j388923r.witrack;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ExpandableListView;

import java.util.ArrayList;

import customUI.AddDeviceAdapter;
import customUI.SettingsAdapter;
import util.Device;

public class AddDeviceListActivity extends AppCompatActivity implements ExpandableListView.OnChildClickListener, DialogInterface.OnClickListener {

    String token;
    int userId;
    AddDeviceAdapter ada;
    Device selectedDevice;
    int selectedDeviceGroup = -1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_device_list);

        token = getIntent().getStringExtra("token");
        userId = getIntent().getIntExtra("userId", -1);

        Toolbar toolbar = (Toolbar) findViewById(R.id.add_devices_toolbar);
        toolbar.setTitle("Edit Devices");
        setSupportActionBar(toolbar);

        ExpandableListView elv = (ExpandableListView)findViewById(R.id.add_device_list);
        elv.setOnChildClickListener(this);

        ada = new AddDeviceAdapter(this, new ArrayList<Device>(), token);

        elv.setAdapter(ada);

        for (int i = 0; i < ada.getGroupCount(); i++) {
            elv.expandGroup(i);
        }
    }

    public void setup(Device device) {
        Intent i = new Intent(this, TutorialActivity.class);

        i.putExtra(getString(R.string.token), token);
        i.putExtra("deviceId", device.id);
        i.putExtra("deviceSetupId", device.setup_id);
        i.putExtra("deviceTitle", device.title);
        i.putExtra("deviceSetupTitle", device.setup_title);

        startActivity(i);
    }

    @Override
    public boolean onChildClick(ExpandableListView expandableListView, View view, int i, int i1, long l) {
        selectedDevice = (Device) ada.getChild(i, i1);
        selectedDeviceGroup = i;

        switch (i) {
            case 0:
                AlertDialog.Builder remove = new AlertDialog.Builder(this);

                remove.setTitle("Remove Device?");
                remove.setMessage("Are you sure you would like remove " + selectedDevice.title + " from your device listing?");
                remove.setCancelable(true);
                remove.setNegativeButton(R.string.Cancel, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        dialog.cancel();
                    }
                });
                remove.setPositiveButton(R.string.OK, this);
                remove.show();
                break;
            case 1:
                AlertDialog.Builder save = new AlertDialog.Builder(this);

                save.setTitle("Save Device?");
                save.setMessage("Would you like to add to " + selectedDevice.title + " your listed devices?");
                save.setCancelable(true);
                save.setPositiveButton(R.string.OK, this);
                save.setNegativeButton(R.string.Cancel, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        dialog.cancel();
                    }
                });
                save.show();
                break;
            case 2:
                AlertDialog.Builder setup = new AlertDialog.Builder(this);

                setup.setTitle("Setup Device?");
                setup.setMessage("Would you like to add to " + selectedDevice.title + " your listed devices?");
                setup.setCancelable(true);
                setup.setPositiveButton(R.string.OK, this);
                setup.setNegativeButton(R.string.Cancel, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        dialog.cancel();
                    }
                });
                setup.show();
                break;
        }

        return true;
    }

    @Override
    public void onClick(DialogInterface dialogInterface, int i) {
        Log.d("onclick", String.valueOf(i));
        switch (selectedDeviceGroup) {
            case 0:
                ada.remove(selectedDevice);
                break;
            case 1:
                ada.save(selectedDevice);
                break;
            case 2:
                setup(selectedDevice);
        }
    }@Override
     public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_add_device, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_add) {
            Intent i = new Intent(this, DeviceSelectorActivity.class);
            i.putExtra(getString(R.string.token), token);
            i.putExtra(getString(R.string.userId), userId);

            startActivity(i);
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
}
