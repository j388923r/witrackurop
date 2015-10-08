package utils;

import java.awt.Point;
import java.util.ArrayList;
import java.util.Arrays;

public class Room {
	
	ArrayList<Wall> walls;
	ConvexHull convexHull;
	
	public Room() {
		walls = new ArrayList<Wall>();
	}

	public Room(ArrayList<Wall> walls) {
		this.walls = walls;
	}
	
	public Room(Wall... walls) {
		this.walls = (ArrayList<Wall>)Arrays.asList(walls);
	}
	
	public Room(ConvexHull convexHull) {
		
	}
}
