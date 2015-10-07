import java.io.*;
import java.net.*;
import java.util.ArrayList;
import java.util.List;


public class WiTrackServer extends Thread {

	private ServerSocket serverSocket;
	String source = "Jamar's Computer";
	int x = 100, y = 100, direction = 3;
	int unit = 4;
	
	public WiTrackServer() throws IOException {
		
		serverSocket = new ServerSocket(4444);
		
	}
	
	public void run() {
		while(true){
			try
	         {
	            System.out.println("Waiting for client on port " +
	            serverSocket.getLocalPort() + "...");
	            Socket server = serverSocket.accept();
	            System.out.println("Just connected to "
	                  + server.getRemoteSocketAddress());
	            DataInputStream in =
	                  new DataInputStream(server.getInputStream());
	            String[] inputs = in.readUTF().split(" ");
	            String username = inputs[1];
	            String password = inputs[3];
	            String url = "http://witrackurop.azurewebsites.net/api/tempaccount";
	    		
	    	    String userID = in.readUTF().replaceAll("\"", "");
	    	    System.out.println(userID);
	    		
	            InputStream notificationresponse = new URL("http://witrackurop.azurewebsites.net/api/notification?key=Userspecific&userID=" + userID).openStream();
            	System.out.println(notificationresponse.read() + " From Website");
	            DataOutputStream out =
	                 new DataOutputStream(server.getOutputStream());
	            x = 100;
	            y = 100;
	            while(true){
		            if(canMoveRight(x, y, direction)) {
		            	moveRight();
		            } else if(canMoveForward(x,y, direction)){
		            	moveForward();
		            } else if(canMoveLeft(x, y, direction)){
		            	moveLeft();
		            } else if(canMoveBack(x, y, direction)){
		            	moveBack();
		            }
		            System.out.println(x + " " + y);
		            out.writeInt(x);
		            out.writeInt(y);
		            Thread.sleep(200);
	            }
	         }catch(SocketTimeoutException s)
	         {
	            System.out.println("Socket timed out!");
	            break;
	         }catch(IOException e)
	         {
	            e.printStackTrace();
	            break;
	         } catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	public void moveRight() {
		switch(direction) {
		case 0:
			x = x + unit;
			break;
		case 1:
			y =  y + unit;
			break;
		case 2:
			x = x - unit;
			break;
		case 3:
			y = y - unit;
			break;
		}
		direction = (direction + 1) % 4;
	}
	
	public void moveForward() {
		switch(direction) {
		case 0:
			y = y - unit;
			break;
		case 1:
			x = x + unit;
			break;
		case 2:
			y = y + unit;
			break;
		case 3:
			x = x - unit;
			break;
		}
	}

	public void moveLeft() {
		switch(direction) {
		case 0:
			x = x - unit;
			break;
		case 1:
			y = y - unit;
			break;
		case 2:
			x = x + unit;
			break;
		case 3:
			y = y + unit;
			break;
		}
		direction = (direction + 3) % 4;
	}

	public void moveBack() {
		switch(direction) {
		case 0:
			y = y - unit;
			break;
		case 1:
			x = x - unit;
			break;
		case 2:
			y = y + unit;
			break;
		case 3:
			x = x + unit;
			break;
		}
		direction = (direction + 2) % 4;
	}
	
	public boolean canMoveRight(int x, int y, int direction) {
		switch(direction) {
		case 0:
			return isValidLocation(x + unit, y);
		case 1:
			return isValidLocation(x, y + unit);
		case 2:
			return isValidLocation(x - unit, y);
		case 3:
			return isValidLocation(x, y - unit);
		}
		return true;
	}
	
	public boolean canMoveForward(int x, int y, int direction) {
		switch(direction) {
		case 0:
			return isValidLocation(x, y - unit);
		case 1:
			return isValidLocation(x + unit, y);
		case 2:
			return isValidLocation(x, y + unit);
		case 3:
			return isValidLocation(x - unit, y);
		}
		return true;
	}

	public boolean canMoveLeft(int x, int y, int direction) {
		switch(direction) {
		case 0:
			return isValidLocation(x - unit, y);
		case 1:
			return isValidLocation(x, y - unit);
		case 2:
			return isValidLocation(x + unit, y);
		case 3:
			return isValidLocation(x, y + unit);
		}
		return true;
	}

	public boolean canMoveBack(int x, int y, int direction) {
		switch(direction) {
		case 0:
			return isValidLocation(x, y - unit);
		case 1:
			return isValidLocation(x - unit, y);
		case 2:
			return isValidLocation(x, y + unit);
		case 3:
			return isValidLocation(x + unit, y);
		}
		return true;
	}
	
	public boolean isValidLocation(int x, int y) {
		return x >= 100 && x <= 400 && y >= 100 && y <= 400;
	}
	
	public static void main(String args[]){
		try
	      {
	         Thread t = new WiTrackServer();
	         t.start();
	      }catch(IOException e)
	      {
	         e.printStackTrace();
	      }
	}
}
