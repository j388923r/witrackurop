package utils;

import java.util.ArrayList;
import java.util.Arrays;

public class Room {
	
	ArrayList<Wall> walls;
	
	public Room() {
		walls = new ArrayList<Wall>();
	}

	public Room(ArrayList<Wall> walls) {
		this.walls = walls;
	}
	
	public Room(Wall... walls) {
		this.walls = (ArrayList<Wall>)Arrays.asList(walls);
	}
}
