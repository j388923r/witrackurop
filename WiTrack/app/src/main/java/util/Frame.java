package util;

import android.widget.ArrayAdapter;

import java.util.ArrayList;

/**
 * Created by j388923r on 1/20/16.
 */
public class Frame {

    ArrayList<Position> people;
    String timeStamp;

    public Frame(String time) {
        this.timeStamp = time;
    }

    public Frame(ArrayList<Position> positions, String time) {
        this.people = positions;
        this.timeStamp = time;
    }

    public void addPerson(Position person) {
        people.add(person);
    }

    public ArrayList<Position> getPeople() {
        return people;
    }

    public String getTimeStamp() {
        return timeStamp;
    }
}
