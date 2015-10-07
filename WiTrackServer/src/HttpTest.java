import java.util.*;
import java.io.IOException;
import java.net.*;

import org.apache.http.Consts;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

public class HttpTest {

	public static void main(String args []) throws ClientProtocolException, IOException {
		String url = "http://witrackurop.azurewebsites.net/api/tempaccount";
		
		HttpClient client = HttpClients.createDefault();
		
		List<NameValuePair> formparams = new ArrayList<NameValuePair>();
		formparams.add(new BasicNameValuePair("userEmail", "j388923r@mit.edu"));
		formparams.add(new BasicNameValuePair("password", "12345"));
		UrlEncodedFormEntity requestEntity = new UrlEncodedFormEntity(formparams, Consts.UTF_8);
		HttpPost httppost = new HttpPost(url);
		httppost.setEntity(requestEntity);
		
		HttpResponse response = client.execute(httppost);
	    HttpEntity responseEntity = response.getEntity();
	    System.out.println(100);
	    if (responseEntity != null) {
	        long len = responseEntity.getContentLength();
	        System.out.println(len);
	        if (len != -1 && len < 2048) {
	            System.out.println(EntityUtils.toString(requestEntity));
	        } else {
	            // Stream content out
	        }
	    }
	}
}