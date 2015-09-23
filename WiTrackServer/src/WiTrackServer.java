import java.io.*;
import java.net.*;


public class WiTrackServer extends Thread {

	private ServerSocket serverSocket;
	int x = 100, y = 100, direction = 3;
	
	public WiTrackServer() throws IOException {
		serverSocket = new ServerSocket(4444);
		/*try {
            String host = "localhost";
            int port = 9500;
            String username = "admin";
            String password = "abc123";

            SMSClient osc = new SMSClient(host, port);
            osc.login(username, password);
            
            String line = "Server started";

            System.out.println("SMS message:");

            if(osc.isLoggedIn()) {
                    osc.sendMessage("+8323498362", line);
                    osc.logout();
            }
	    } catch (IOException e) {
	            System.out.println(e.toString());
	            e.printStackTrace();
	    } catch (InterruptedException e) {
	            System.out.println(e.toString());
	            e.printStackTrace();
	    }*/
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
	            System.out.println(in.readUTF());
	            DataOutputStream out =
	                 new DataOutputStream(server.getOutputStream());
	            x = 100;
	            y = 100;
	            while(true){
	            	System.out.println(direction);
		            if(canMoveRight(x, y, direction)) {
		            	System.out.println("right");
		            	moveRight(direction);
		            } else if(canMoveForward(x,y, direction)){
		            	System.out.println("forward");
		            	moveForward(direction);
		            } else if(canMoveLeft(x, y, direction)){
		            	System.out.println("left");
		            	moveLeft(direction);
		            } else if(canMoveBack(x, y, direction)){
		            	System.out.println("back");
		            	moveBack(direction);
		            }
		            System.out.println(x + " " + y);
		            out.writeInt(x);
		            out.writeInt(y);
		            Thread.sleep(200);
	            }
	            //server.close();
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
	
	public void moveRight(int direction) {
		switch(direction) {
		case 0:
			x = x + 1;
			break;
		case 1:
			y =  y + 1;
			break;
		case 2:
			x = x - 1;
			break;
		case 3:
			y = y - 1;
			break;
		}
		direction = (direction + 1) % 4;
	}
	
	public void moveForward(int direction) {
		switch(direction) {
		case 0:
			y = y - 1;
			break;
		case 1:
			x = x + 1;
			break;
		case 2:
			y = y + 1;
			break;
		case 3:
			x = x - 1;
			break;
		}
	}

	public void moveLeft(int direction) {
		switch(direction) {
		case 0:
			x = x - 1;
			break;
		case 1:
			y = y - 1;
			break;
		case 2:
			x = x + 1;
			break;
		case 3:
			y = y + 1;
			break;
		}
		direction = (direction + 3) % 4;
	}

	public void moveBack(int direction) {
		switch(direction) {
		case 0:
			y = y - 1;
			break;
		case 1:
			x = x - 1;
			break;
		case 2:
			y = y + 1;
			break;
		case 3:
			x = x + 1;
			break;
		}
		direction = (direction + 2) % 4;
	}
	
	public boolean canMoveRight(int x, int y, int direction) {
		switch(direction) {
		case 0:
			return isValidLocation(x + 1, y);
		case 1:
			return isValidLocation(x, y + 1);
		case 2:
			return isValidLocation(x - 1, y);
		case 3:
			return isValidLocation(x, y - 1);
		}
		return true;
	}
	
	public boolean canMoveForward(int x, int y, int direction) {
		switch(direction) {
		case 0:
			return isValidLocation(x, y - 1);
		case 1:
			return isValidLocation(x + 1, y);
		case 2:
			return isValidLocation(x, y + 1);
		case 3:
			return isValidLocation(x - 1, y);
		}
		return true;
	}

	public boolean canMoveLeft(int x, int y, int direction) {
		switch(direction) {
		case 0:
			return isValidLocation(x - 1, y);
		case 1:
			return isValidLocation(x, y - 1);
		case 2:
			return isValidLocation(x + 1, y);
		case 3:
			return isValidLocation(x, y + 1);
		}
		return true;
	}

	public boolean canMoveBack(int x, int y, int direction) {
		switch(direction) {
		case 0:
			return isValidLocation(x, y - 1);
		case 1:
			return isValidLocation(x - 1, y);
		case 2:
			return isValidLocation(x, y + 1);
		case 3:
			return isValidLocation(x + 1, y);
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
