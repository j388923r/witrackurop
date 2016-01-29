package com.example.j388923r.witrack;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.internal.widget.AppCompatPopupWindow;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

import util.Util;
import util.Device;

public class DeviceSelectorActivity extends AppCompatActivity implements Util.AsyncArrayResponse, AdapterView.OnItemClickListener {

    String token;
    int userId;
    ArrayList<Device> deviceList = new ArrayList<Device>();
    ListView listView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.device_selector_layout);

        token = getIntent().getStringExtra(getString(R.string.token));
        userId = getIntent().getIntExtra("userId", -1);

        Toolbar toolbar = (Toolbar) findViewById(R.id.devicestoolbar);
        setSupportActionBar(toolbar);

        Util.GetDevicesTask getDevices = new Util.GetDevicesTask(this);

        getDevices.execute("https://www.devemerald.com/api/v1/user/devices", token);
    }


    @Override
    public void processFinish(JSONArray array) {

        listView = (ListView) findViewById(R.id.device_list_view);

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
                deviceList.add(device);
                deviceNameArray[i] = device.title;
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        final ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, R.layout.device_selection_item, R.id.device_label, deviceNameArray);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(this);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_add) {
            Intent i = new Intent(this, AddDeviceListActivity.class);
            i.putExtra(getString(R.string.token), token);
            i.putExtra(getString(R.string.userId), userId);

            startActivity(i);
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    public void onItemClick(AdapterView<?> parent, final View view, int position, long id) {
        Device device = deviceList.get(position);

        Intent i = new Intent(this, ViewControllerActivity.class);
        i.putExtra("token", token);
        i.putExtra("deviceId", device.id);
        i.putExtra("deviceSetupId", device.setup_id);
        i.putExtra("deviceTitle", device.title);
        i.putExtra("deviceSetupTitle", device.setup_title);

        startActivity(i);
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();

        SharedPreferences prefs = this.getSharedPreferences("login", Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = prefs.edit();
        editor.putString(getString(R.string.token), "");
        editor.putInt(getString(R.string.userId), -1);
        editor.commit();

        finish();
    }
}
