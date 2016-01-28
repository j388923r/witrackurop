package com.example.j388923r.witrack;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.widget.Toolbar;

import fragments.DisplayOnlyFragment;
import fragments.HeightViewFragment;
import fragments.PositionFragment;
import fragments.ReplayFragment;

public class TutorialActivity extends ActionBarActivity {

    TutorialPager vcPager;
    ViewPager vPager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_tutorial);

        Toolbar toolbar = (Toolbar) findViewById(R.id.tutorial_toolbar);
        setSupportActionBar(toolbar);
        toolbar.setTitle("Tutorial");

        TabLayout tabLayout = (TabLayout) findViewById(R.id.tutorial_tab_layout);
        tabLayout.addTab(tabLayout.newTab().setText("Intro"));
        tabLayout.addTab(tabLayout.newTab().setText("Tracking"));
        tabLayout.addTab(tabLayout.newTab().setText("Floor"));
        tabLayout.addTab(tabLayout.newTab().setText("Room Identification"));
        // tabLayout.setTabGravity(TabLayout.GRAVITY_FILL);
        tabLayout.setTabMode(TabLayout.MODE_SCROLLABLE);

        vPager = (ViewPager) findViewById(R.id.tutorial_pager);
        vcPager = new TutorialPager(getSupportFragmentManager());
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

class TutorialPager extends FragmentPagerAdapter {

    public TutorialPager(FragmentManager fm) {
        super(fm);
    }

    @Override
    public Fragment getItem(int position) {
        return null;
    }

    @Override
    public int getCount() {
        return 0;
    }
}
