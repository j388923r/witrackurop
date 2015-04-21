import java.io.*;
import java.net.*;


public class WiTrackServer extends Thread {

	private ServerSocket serverSocket;
	double x = 100.0, y = 100.0;
	
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
	            System.out.println(in.readUTF());
	            while(true){
		            DataOutputStream out =
		                 new DataOutputStream(server.getOutputStream());
		            x = Math.max(100.0, Math.min(600.0, x + (Math.random() - 0.4) * 8));
		            y = Math.max(100.0, Math.min(500.0, y + (Math.random() - 0.4) * 8));
		            System.out.println(x + " " + y);
		            out.writeDouble(x);
		            out.writeDouble(y);
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
