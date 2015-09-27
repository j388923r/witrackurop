package utils;

import java.util.ArrayList;

public class User {
	
	ArrayList<String> roomAccessList;
	String id;
	
	public User(String id){
		this.id = id;
	}
	
	public void addAccess(String roomId) {
		this.roomAccessList.add(roomId);
	}
	
	public void removeAccess(String roomId) {
		this.roomAccessList.remove(roomId);
	}
	
	public ArrayList<String> getAllRooms() {
		ArrayList<String> accessList = new ArrayList<String>();
		accessList.addAll(roomAccessList);
		return accessList;
	}
}