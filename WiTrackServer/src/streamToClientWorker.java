import java.net.Socket;
import java.util.ArrayList;

import utils.Room;

public class streamToClientWorker implements Runnable {

	Socket socket;
	ArrayList<Room> rooms = new ArrayList<Room>();
	
	public streamToClientWorker(Socket socket) {
		this.socket = socket;
	}
	
	public void run() {
		// TODO Auto-generated method stub

	}

}
