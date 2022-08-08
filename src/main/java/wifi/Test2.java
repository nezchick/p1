package wifi;
import java.util.*;
import java.time.*;

public class Test2 {
	public static void main(String[] arg) {
		double lat_num = 37.5544069;
		double lnt_num = 126.8998666;
		double db_lat_num = 37.55698;
		double db_lnt_num = 126.89872;
		
		
		
		double theta = lnt_num - db_lnt_num;
    	double dist = Math.sin(Math.toRadians(lat_num)) * Math.sin(Math.toRadians(db_lat_num)) + Math.cos(Math.toRadians(lat_num)) * Math.cos(Math.toRadians(db_lat_num)) * Math.cos(Math.toRadians(theta));
    	
    	dist = Math.acos(dist);
    	dist = Math.toDegrees(dist);
    	dist = dist * 60 * 1.1515;
    	dist = dist * 1.609344;
    	
    	System.out.println(dist);
	}

}
