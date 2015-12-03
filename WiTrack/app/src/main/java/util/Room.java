package util;

import android.graphics.Rect;
import android.graphics.RectF;

/**
 * Created by j388923r on 10/7/2015.
 */
public class Room {

    public RectF bounds;
    public String name;

    public Room(RectF rect) {
        this.bounds = rect;
        this.name = "Default";
    }

    public Room(RectF rect, String name) {
        this.bounds = rect;
        this.name = name;
    }

    public Room(float left, float top, float right, float bottom) {
        this.bounds = new RectF(left, top, right, bottom);
        this.name = "Default";
    }

    public Room(float left, float top, float right, float bottom, String name) {
        this.bounds = new RectF(left, top, right, bottom);
        this.name = name;
    }

    public boolean inside(float x, float y) {
        return this.bounds.contains(x, y);
    }

    public boolean entered(float startX, float startY, float endX, float endY) {
        return !inside(startX, startY) && inside(endX, endY);
    }

    public boolean exited(float startX, float startY, float endX, float endY) {
        return inside(startX, startY) && !inside(endX, endY);
    }

    public String toString() {
        return String.format("Room %s %.2f %.2f %.2f %.2f", name, bounds.left, bounds.top, bounds.right, bounds.bottom);
    }
}
