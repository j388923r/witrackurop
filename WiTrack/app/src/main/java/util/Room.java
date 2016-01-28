package util;

import android.graphics.Point;
import android.graphics.Rect;
import android.graphics.RectF;

import java.util.ArrayList;

/**
 * Created by j388923r on 10/7/2015.
 */
public class Room {

    public ArrayList<Point> bounds;
    public String name;

    public Room() {
        this.name = "Default";
    }

    public Room(RectF rect, String name) {
        this.name = name;
    }

    public Room(Point p, String name) {

    }

    public Room(float left, float top, float right, float bottom, String name) {
        this.name = name;
    }

    public boolean inside(float x, float y) {
        return false;
    }

    public boolean entered(float startX, float startY, float endX, float endY) {
        return !inside(startX, startY) && inside(endX, endY);
    }

    public boolean exited(float startX, float startY, float endX, float endY) {
        return inside(startX, startY) && !inside(endX, endY);
    }
}
