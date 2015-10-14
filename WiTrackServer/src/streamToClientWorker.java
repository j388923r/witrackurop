import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.util.ArrayList;

import utils.Room;

public class streamToClientWorker implements Runnable {

	Socket socket;
	ArrayList<Room> rooms = new ArrayList<Room>();
	int x = 100, y = 100, direction = 2, unit = 3;
	
	public streamToClientWorker(Socket socket) {
		this.socket = socket;
	}
	
	public void run() {
		// TODO Auto-generated method stub
		try{
		System.out.println("Just connected to "
                + socket.getRemoteSocketAddress());
        DataInputStream in =
              new DataInputStream(socket.getInputStream());
        String[] inputs = in.readUTF().split(" ");
        String username = inputs[1];
        String password = inputs[3];
        String url = "http://witrackurop.azurewebsites.net/api/tempaccount";
  		
  	    String userID = in.readUTF().replaceAll("\"", "");
  	    System.out.println(userID);
  		
        //InputStream notificationresponse = new URL("http://witrackurop.azurewebsites.net/api/notification?key=Userspecific&userID=" + userID).openStream();
      	//System.out.println(notificationresponse.read() + " From Website");
  	    
        DataOutputStream out =
             new DataOutputStream(socket.getOutputStream());
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
	        out.writeInt(x + (int)(Math.random() * 5));
	        out.writeInt(y + (int)(Math.random() * 5));
	        Thread.sleep(200);
          }
       } catch(SocketTimeoutException s) {
          System.out.println("Socket timed out!");
       } catch(IOException e) {
          e.printStackTrace();
       } catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
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
}
