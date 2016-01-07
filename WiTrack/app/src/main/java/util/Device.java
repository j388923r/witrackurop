package util;

/**
 * Created by j388923r on 1/5/16.
 */
public class Device {
    public boolean realtime_access;
    public int id, setup_id;
    public String setup_title, title;

    public Device(String title, String setup_title, int id, int setup_id, boolean realtime_access) {
        this.title = title;
        this.setup_title = setup_title;
        this.id = id;
        this.setup_id = setup_id;
        this.realtime_access = realtime_access;
    }
}
