package com.example.j388923r.witrack;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import fragments.*;

public class ViewControllerActivity extends AppCompatActivity {

    ViewControllerPager vcPager;
    ViewPager vPager;

    String tokenGenerationURL = "https://www.devemerald.com/api/v1/token/generate";
    String socketURL = "https://www.devemerald.com/";

    String token, title, setupTitle, userID;
    int deviceId, deviceSetupId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.view_controller_layout);

        Intent sender = getIntent();
        token = sender.getStringExtra("token");
        title = sender.getStringExtra("deviceTitle");
        setupTitle = sender.getStringExtra("deviceSetupTitle");
        deviceId = sender.getIntExtra("deviceId", -1);
        deviceSetupId = sender.getIntExtra("deviceSetupId", -1);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        TabLayout tabLayout = (TabLayout) findViewById(R.id.tab_layout);
        tabLayout.addTab(tabLayout.newTab().setText("Display"));
        tabLayout.addTab(tabLayout.newTab().setText("Tracking"));
        tabLayout.addTab(tabLayout.newTab().setText("Height"));
        tabLayout.setTabGravity(TabLayout.GRAVITY_FILL);

        vPager = (ViewPager) findViewById(R.id.pager);
        vcPager = new ViewControllerPager
                (getSupportFragmentManager());
        vPager.setAdapter(vcPager);
        vPager.addOnPageChangeListener(new TabLayout.TabLayoutOnPageChangeListener(tabLayout));
        tabLayout.setOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                vPager.setCurrentItem(tab.getPosition());
            }

            @Override
            public void onTabUnselected(TabLayout.Tab tab) {

            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {

            }
        });
    }

}

class ViewControllerPager extends FragmentPagerAdapter {

    public ViewControllerPager(FragmentManager fm) {
        super(fm);
    }

    @Override
    public Fragment getItem(int position) {
        Bundle bundle = new Bundle();
        bundle.putInt(DefaultFragment.ARG_OBJECT, position);

        switch (position) {
            case 0:
                Fragment display = new DisplayOnlyFragment();
                display.setArguments(bundle);
                return display;
            case 1:
                Fragment tracking = new DefaultFragment();
                tracking.setArguments(bundle);
                return tracking;
            case 2:
                Fragment height = new HeightViewFragment();
                height.setArguments(bundle);
                return height;
            default:
                Fragment fragment = new DefaultFragment();
                fragment.setArguments(bundle);
                return fragment;
        }
    }

    @Override
    public int getCount() {
        return 3;
    }

    @Override
    public CharSequence getPageTitle(int position) {
        switch (position) {
            case 0:
                return "Display Only View";
            case 1:
                return "Tracking View";
            case 2:
                return "Height View";
            default:
                return "initial";
        }
    }
}