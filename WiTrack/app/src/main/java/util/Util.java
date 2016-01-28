package util;

import android.graphics.Color;
import android.graphics.Point;
import android.os.AsyncTask;
import android.util.Log;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by j388923r on 10/11/2015.
 */
public class Util {

    public static String tokenGenerationURL = "https://www.devemerald.com/api/v1/token/generate";

    public static String socketURL = "https://www.devemerald.com/";

    public static int[] colorWheel = new int[] {Color.MAGENTA, Color.RED, Color.GRAY, Color.GREEN, Color.BLACK, Color.BLUE, Color.CYAN, Color.YELLOW, Color.LTGRAY, Color.DKGRAY };

    public static long DAY_IN_MS = 1000 * 60 * 60 * 24;

    public static String convertStreamToString(InputStream is) {
        String line = "";
        StringBuilder total = new StringBuilder();
        BufferedReader rd = new BufferedReader(new InputStreamReader(is));
        try {
            while ((line = rd.readLine()) != null) {
                total.append(line);
            }
        } catch (Exception e) {

        }
        return total.toString();
    }

    public List<Point> computeConvexHull(List<Point> points) {
        return new ArrayList<Point>();
    }

    public static class GetDevicesTask extends AsyncTask<String, Integer, JSONArray> {

        AsyncArrayResponse response;

        public GetDevicesTask(AsyncArrayResponse response) {
            this.response = response;
        }

        @Override
        protected JSONArray doInBackground(String... params) {
            // TODO Auto-generated method stub
            HttpClient httpclient = new DefaultHttpClient();
            HttpPost httpPost = new HttpPost(params[0]);
            httpPost.setHeader("X-Token", params[1]);
            try {
                HttpResponse response = httpclient.execute(httpPost);
                if (response != null) {
                    String line = "";
                    InputStream inputstream = response.getEntity().getContent();
                    line = convertStreamToString(inputstream);
                    JSONObject reader = new JSONObject(line);
                    boolean success = reader.getBoolean("success");
                    if (success) {
                        JSONArray data = reader.getJSONArray("data");
                        return data;
                    }
                }
            } catch (ClientProtocolException e) {

            } catch (IOException e) {

            } catch (Exception e) {
                Log.w("ExceptionW", "e=");
                Log.d("ExceptionD", "e: " + e);
            }
            return new JSONArray();
        }

        public void onPostExecute(JSONArray array) {
            response.processFinish(array);
        }
    }

    public static class GetReplayDataTask extends AsyncTask<String, Integer, JSONObject> {

        AsyncResponse response;

        public GetReplayDataTask(AsyncResponse response) {
            this.response = response;
        }

        @Override
        protected JSONObject doInBackground(String... params) {
            // TODO Auto-generated method stub
            HttpClient httpclient = new DefaultHttpClient();
            HttpPost httpPost = new HttpPost(params[0]);
            httpPost.setHeader("X-Token", params[1]);
            List<NameValuePair> formparams = new ArrayList<NameValuePair>();
            formparams.add(new BasicNameValuePair("device", params[2]));
            formparams.add(new BasicNameValuePair("time_start_ms", params[3]));
            try {
                httpPost.setEntity(new UrlEncodedFormEntity(formparams));
            } catch (UnsupportedEncodingException uee) {
                uee.printStackTrace();
            }
            try {
                HttpResponse response = httpclient.execute(httpPost);
                if (response != null) {
                    String line = "";
                    InputStream inputstream = response.getEntity().getContent();
                    line = Util.convertStreamToString(inputstream);
                    JSONObject reader = new JSONObject(line);
                    boolean success = reader.getBoolean("success");
                    if (success) {
                        JSONObject data = reader.getJSONObject("data");
                        return data;
                    }
                }
            } catch (ClientProtocolException e) {

            } catch (IOException e) {

            } catch (Exception e) {
                Log.w("ExceptionW", "e=");
                Log.d("ExceptionD", "e: " + e);
            }
            return new JSONObject();
        }

        public void onPostExecute(JSONObject object) {
            response.processFinish(object);
        }
    }

    public interface AsyncArrayResponse {
        public void processFinish(JSONArray array);
    }

    public static class Vector2D {
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
