import java.net.Socket;

public class streamToClientWorker implements Runnable {

	Socket socket;
	
	public streamToClientWorker(Socket socket) {
		this.socket = socket;
	}
	
	public void run() {
		// TODO Auto-generated method stub

	}

}
