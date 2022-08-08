package wifi;

import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.*;
import java.io.BufferedReader;
import java.io.IOException;
import org.json.simple.JSONObject;
import org.json.simple.*;
import org.json.simple.parser.*;

public class ApiExplorer {
	public static void main(String[] args) throws IOException, ParseException {
		StringBuilder urlBuilder = new StringBuilder("http://openapi.seoul.go.kr:8088"); /*URL*/
		urlBuilder.append("/" +  URLEncoder.encode("444677414c736575353350764f6550","UTF-8") ); /*인증키 (sample사용시에는 호출시 제한됩니다.)*/
		urlBuilder.append("/" +  URLEncoder.encode("json","UTF-8") ); /*요청파일타입 (xml,xmlf,xls,json) */
		urlBuilder.append("/" + URLEncoder.encode("TbPublicWifiInfo","UTF-8")); /*서비스명 (대소문자 구분 필수입니다.)*/
		urlBuilder.append("/" + URLEncoder.encode("1","UTF-8")); /*요청시작위치 (sample인증키 사용시 5이내 숫자)*/
		urlBuilder.append("/" + URLEncoder.encode("1000","UTF-8")); /*요청종료위치(sample인증키 사용시 5이상 숫자 선택 안 됨)*/
		// 상위 5개는 필수적으로 순서바꾸지 않고 호출해야 합니다.
		
		// 서비스별 추가 요청 인자이며 자세한 내용은 각 서비스별 '요청인자'부분에 자세히 나와 있습니다.
		urlBuilder.append("/" + URLEncoder.encode("20220301","UTF-8")); /* 서비스별 추가 요청인자들*/
		
		URL url = new URL(urlBuilder.toString());
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-type", "application/xml");
		System.out.println("Response code: " + conn.getResponseCode()); /* 연결 자체에 대한 확인이 필요하므로 추가합니다.*/
		BufferedReader rd;

		// 서비스코드가 정상이면 200~300사이의 숫자가 나옵니다.
		if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
				rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		} else {
				rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
		}
		StringBuilder sb = new StringBuilder();
		String line;
		while ((line = rd.readLine()) != null) {
				sb.append(line);
		}
		rd.close();
		conn.disconnect();
		
		
		JSONObject result = (JSONObject) new JSONParser().parse(sb.toString());
		
		JSONObject one = (JSONObject) result.get("TbPublicWifiInfo");
		JSONArray data = (JSONArray) one.get("row");
		JSONObject target = null;
		
		
//		for(int i = 0; i < data.size(); i++) {
//			
//			target = (JSONObject)data.get(i);
//			System.out.print(target.get("X_SWIFI_MGR_NO"));
//			System.out.print("\t");
//			System.out.print(target.get("X_SWIFI_WRDOFC"));
//			System.out.print("\t");
//			System.out.print(target.get("X_SWIFI_MAIN_NM"));
//			System.out.print("\t");
//			System.out.print(target.get("X_SWIFI_ADRES1"));
//			System.out.print("\t");
//			System.out.print(target.get("X_SWIFI_ADRES2"));
//			System.out.print("\t");
//			System.out.print(target.get("X_SWIFI_INSTL_FLOOR"));
//			System.out.print("\t");
//			System.out.print(target.get("X_SWIFI_INSTL_TY"));
//			System.out.print("\t");
//			System.out.print(target.get("X_SWIFI_INSTL_MBY"));
//			System.out.print("\t");
//			System.out.print(target.get("X_SWIFI_SVC_SE"));
//			System.out.print("\t");
//			System.out.print(target.get("X_SWIFI_CMCWR"));
//			System.out.print("\t");
//			System.out.print(target.get("X_SWIFI_CNSTC_YEAR"));
//			System.out.print("\t");
//			System.out.print(target.get("X_SWIFI_INOUT_DOOR"));
//			System.out.print("\t");
//			System.out.print(target.get("X_SWIFI_REMARS3"));
//			System.out.print("\t");
//			System.out.print(target.get("LAT"));
//			System.out.print("\t");
//			System.out.print(target.get("LNT"));
//			System.out.print("\t");
//			System.out.print(target.get("WORK_DTTM"));
//			System.out.println();
//			
//		}
		
		//db 컨트롤
		

		String localdb = "jdbc:sqlite:wifi.db";

		
			// 1. 드라이버 로드 (SQLite JDBC 체크)
			try {
				Class.forName("org.sqlite.JDBC");
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			// 2. 커넥션 객체 생성 (SQLite 데이터베이스 파일에 연결)
			Connection connection = null;
			PreparedStatement stat = null;
			ResultSet rs = null;
			int insertResult = 0;
			try {
				connection = DriverManager.getConnection(localdb);
				// 3. 스테이트먼트 객체 생성
				/*
				 1. Statement 
				 2. preparedStatement -> 주로 이걸 사용
				 파라먼트 처리 가능
				 3. CallableStatement
				 */
				
				String mgr_no_value = null;
				for(int i = 0; i < data.size(); i++) {
				
					target = (JSONObject)data.get(i);
					mgr_no_value = (String) target.get("X_SWIFI_MGR_NO");
					
					String sql = "INSERT INTO wifi (mgr_no)"
							   + "VALUES (?);";
					
					stat = connection.prepareStatement(sql);
					stat.setString(1, mgr_no_value);
					
					
					//executeQuery -> 수행결과로 ResultSet의 객체의 값을 반환
					//SELECT 구문을 수행할 때 사용
					//executeUpdate -> 수행결과로 Int 타입의 값을 반환
					//SELECT 구문을 제외한 다른 구문을 수행할 때 사용되는 함수
					//INSERT, DELETE, UPDATE 관련해서는 반영된 레코드 건수
					//CREATE/DROP 관련 구문에서는 -1을 반환
					insertResult = stat.executeUpdate();
				}
				
				System.out.println("성공!");
				
				
//				while(rs.next()) {
//					System.out.print(rs.getString("mgr_no") + " ");
//					System.out.print(rs.getString("wrdofc") + " ");
//					System.out.print(rs.getString("main_nm") + " ");
//					System.out.print(rs.getString("adres1") + " ");
//					System.out.print(rs.getString("adres2") + " ");
//					System.out.print(rs.getString("instl_floor") + " ");
//					System.out.print(rs.getString("instl_ty") + " ");
//					System.out.print(rs.getString("instl_mby") + " ");
//					System.out.print(rs.getString("svc_se") + " ");
//					System.out.print(rs.getString("cmcwr") + " ");
//					System.out.print(rs.getString("cnstc_year") + " ");
//					System.out.print(rs.getString("inout_door") + " ");
//					System.out.print(rs.getString("remars3") + " ");
//					System.out.print(rs.getString("lat") + " ");
//					System.out.print(rs.getString("lnt") + " ");
//					System.out.print(rs.getString("work_dttm") + " ");
//					System.out.println();
//					
//				}
				
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				
				try {
					if(connection != null && !connection.isClosed()) {
						connection.close();
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				try {
					if(stat != null && !stat.isClosed()) {
						stat.close();
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				try {
					if(rs != null && !rs.isClosed()) {
						rs.close();
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}
	}
}
