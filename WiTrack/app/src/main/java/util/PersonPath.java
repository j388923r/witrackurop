package util;

import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Path;
import android.graphics.Point;
import android.graphics.RectF;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by j388923r on 9/30/2015.
 */
public class PersonPath {
    Path path;
    Room currentRoom;
    public int color;
    List<Point> convexHull;

    public PersonPath() {
        this.path = new Path();
        color = Color.BLUE;
        convexHull = new ArrayList<Point>();
    }

    public PersonPath(int color) {
        this.path = new Path();
        this.color = color;
        convexHull = new ArrayList<Point>();
    }

    public PersonPath(int x, int y) {
        this.path = new Path();
        this.path.moveTo(x, y);
        color = Color.BLUE;
        convexHull = new ArrayList<Point>();
    }

    public PersonPath(int x, int y, int color) {
        this.path = new Path();
        this.path.moveTo(x, y);
        this.color = color;
        convexHull = new ArrayList<Point>();
    }

    public void addPoint(int x, int y) {
        if (this.path.isEmpty())
            path.moveTo(x, y);
        else
            path.lineTo(x, y);
        if(convexHull.size() < 3) {
            convexHull.add(new Point(x, y));
        } else {
            Point pPoint = convexHull.get(convexHull.size() - 1);
            Point ppPoint = convexHull.get(convexHull.size() - 2);

        }

    }

    public Path getPath() {
        return path;
    }

    public RectF getBounds() {
        RectF rect = new RectF();
        path.computeBounds(rect, true);
        return rect;
    }

    public List<Point> getConvexHull() {
        return convexHull;
    }

}
