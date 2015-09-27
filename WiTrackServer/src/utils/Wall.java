package utils;

public class Wall {

	int startX, startY, endX, endY;
	double[] normalVectorIn = new double[2];
	
	public Wall(int startX, int startY, int endX, int endY) {
		this.startX = startX;
		this.startY = startY;
		this.endX = endX;
		this.endY = endY;
	}
	
	public Wall(int startX, int startY, int endX, int endY, double insideX, double insideY) {
		this.startX = startX;
		this.startY = startY;
		this.endX = endX;
		this.endY = endY;
	}
}
