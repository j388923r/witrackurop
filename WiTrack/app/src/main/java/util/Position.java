package util;

/**
 * Created by j388923r on 1/12/16.
 */
public class Position {
    public float x, y, z;
    public int personId;

    public Position(double x, double y, double z, int personId){
        this.x = (float)x;
        this.y = (float)y;
        this.z = (float)z;
        this.personId = personId;
    }
}
