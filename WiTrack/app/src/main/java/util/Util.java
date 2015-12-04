package util;

import android.graphics.Point;

import java.security.PublicKey;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by j388923r on 10/11/2015.
 */
public class Util {

    public List<Point> computeConvexHull(List<Point> points) {
        return new ArrayList<Point>();
    }

    class Vector2D {
        public float[] coords = new float[2];
        public Vector2D(float x, float y){
            coords[0] = x;
            coords[1] = y;
        }

        public Vector2D add(Vector2D vector) {
            return new Vector2D(vector.coords[0] + this.coords[0], vector.coords[1] + this.coords[1]);
        }

        public float dot(Vector2D vector) {
            return this.coords[0] * vector.coords[0] + this.coords[1] * vector.coords[1];
        }

        public double magnitude() {
            return Math.pow(Math.pow(this.coords[0], 2) + Math.pow(this.coords[1], 2), 0.5);
        }

        public double angleBetween(Vector2D vector) {
            float dotproduct = this.dot(vector);
            return  Math.acos(dotproduct / (this.magnitude() * vector.magnitude()));
        }
    }
}
