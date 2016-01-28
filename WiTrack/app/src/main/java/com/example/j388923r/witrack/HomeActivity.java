package com.example.j388923r.witrack;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.View;

import com.parse.Parse;
import com.parse.ParseInstallation;

public class HomeActivity extends ActionBarActivity {

    String token;
    int userId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);

        SharedPreferences prefs = this.getSharedPreferences("login", Context.MODE_PRIVATE);
        userId = prefs.getInt(getString(R.string.userId), -1);
        token = prefs.getString(getString(R.string.token), "");

        Parse.initialize(this, "qUFOUjf6omK7m3qy3o38YBP9s8XbrGYgoER5YvRM", "waBDv05GCS7v9DiJQc0PraAsZDgOnDEds1gu9eqI");
        ParseInstallation.getCurrentInstallation().saveInBackground();
    }

    public void openTracking(View v) {
        Intent i = new Intent(this, DeviceSelectorActivity.class);
        i.putExtra("token", token);
        i.putExtra("userId", userId);

        startActivity(i);
    }

    public void openStats(View v) {
        Intent i = new Intent(this, StatsHomeActivity.class);
        i.putExtra("token", token);
        i.putExtra("userId", userId);

        startActivity(i);
    }

    public void openAlerts(View v) {
        Intent i = new Intent(this, AlertsHomeActivity.class);
        i.putExtra("token", token);
        i.putExtra("userId", userId);

        startActivity(i);
    }

    public void openSettings(View v) {
        Intent i = new Intent(this, SettingsActivity.class);
        i.putExtra("token", token);
        i.putExtra("userId", userId);

        startActivity(i);
    }
}
