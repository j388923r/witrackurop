package com.example.j388923r.witrack;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;

public class AlertsHomeActivity extends AppCompatActivity {

    String token;
    int userId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_alerts_home);

        token = getIntent().getStringExtra("token");
        userId = getIntent().getIntExtra("userId", -1);

        Toolbar toolbar = (Toolbar) findViewById(R.id.alertstoolbar);
        setSupportActionBar(toolbar);
    }
}
