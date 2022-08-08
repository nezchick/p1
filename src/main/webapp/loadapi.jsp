<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
   
    import="java.io.InputStreamReader"
	import="java.net.HttpURLConnection"
	import="java.net.URL"
	import="java.net.URLEncoder"
	import="java.sql.*"
	import="java.io.BufferedReader"
	import="java.io.IOException"
	import="org.json.simple.*"
	import="org.json.simple.JSONObject"
	import="org.json.simple.JSONArray"
	import="org.json.simple.parser.*"		
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>와이파이 정보 구하기</title>
<link rel="stylesheet" href="./wifi.css" type="text/css">
</head>
<body>
<%
int total_cnt = 1;
int check = 0;
	Connection connection = null;
	PreparedStatement stat = null;
	ResultSet rs = null;
	int insertResult = 0;
	
	String localdb = "jdbc:sqlite:C:/dev/work/workspace/wifi/wifi.db";

	try {
		Class.forName("org.sqlite.JDBC");
		
		connection = DriverManager.getConnection(localdb);
		
		String sql_delete = "DELETE FROM wifi";
		
		stat = connection.prepareStatement(sql_delete);
		
		stat.executeUpdate();
	} catch (ClassNotFoundException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}

	for (int i = 0; i <= total_cnt; i+=1000) {
		
		//api
		
		StringBuilder urlBuilder = new StringBuilder("http://openapi.seoul.go.kr:8088"); /*URL*/
		urlBuilder.append("/" +  URLEncoder.encode("444677414c736575353350764f6550","UTF-8") ); /*인증키 (sample사용시에는 호출시 제한됩니다.)*/
		urlBuilder.append("/" +  URLEncoder.encode("json","UTF-8") ); /*요청파일타입 (xml,xmlf,xls,json) */
		urlBuilder.append("/" + URLEncoder.encode("TbPublicWifiInfo","UTF-8")); /*서비스명 (대소문자 구분 필수입니다.)*/
		urlBuilder.append("/" + URLEncoder.encode(Integer.toString(i+1),"UTF-8")); /*요청시작위치 (sample인증키 사용시 5이내 숫자)*/
		urlBuilder.append("/" + URLEncoder.encode(Integer.toString(i+1000),"UTF-8")); /*요청종료위치(sample인증키 사용시 5이상 숫자 선택 안 됨)*/
		// 상위 5개는 필수적으로 순서바꾸지 않고 호출해야 합니다.
		
		// 서비스별 추가 요청 인자이며 자세한 내용은 각 서비스별 '요청인자'부분에 자세히 나와 있습니다.
		urlBuilder.append("/" + URLEncoder.encode("20220301","UTF-8")); /* 서비스별 추가 요청인자들*/
		
		URL url = new URL(urlBuilder.toString());
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-type", "application/xml");
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
		String total = one.get("list_total_count").toString();
		total_cnt = Integer.parseInt(total);
		JSONArray data = (JSONArray) one.get("row");
		JSONObject target = null;

		
		// db
			

			try {

				String mgr_no_value = null;
				String wrdofc_value = null;
				String main_nm_value = null;
				String adres1_value = null;
				String adres2_value = null;
				String instl_floor_value = null;
				String instl_ty_value = null;
				String instl_mby_value = null;
				String svc_se_value = null;
				String cmcwr_value = null;
				String cnstc_year_value = null;
				String inout_door_value = null;
				String remars3_value = null;
				String lat_value = null;
				String lnt_value = null;
				String work_dttm_value = null;
				
				for(int j = 0; j < data.size(); j++) {
				
					target = (JSONObject)data.get(j);
					mgr_no_value = (String) target.get("X_SWIFI_MGR_NO");
					wrdofc_value = (String) target.get("X_SWIFI_WRDOFC");
					main_nm_value = (String) target.get("X_SWIFI_MAIN_NM");
					adres1_value = (String) target.get("X_SWIFI_ADRES1");
					adres2_value = (String) target.get("X_SWIFI_ADRES2");
					instl_floor_value = (String) target.get("X_SWIFI_INSTL_FLOOR");
					instl_ty_value = (String) target.get("X_SWIFI_INSTL_TY");
					instl_mby_value = (String) target.get("X_SWIFI_INSTL_MBY");
					svc_se_value = (String) target.get("X_SWIFI_SVC_SE");
					cmcwr_value = (String) target.get("X_SWIFI_CMCWR");
					cnstc_year_value = (String) target.get("X_SWIFI_CNSTC_YEAR");
					inout_door_value = (String) target.get("X_SWIFI_INOUT_DOOR");
					remars3_value = (String) target.get("X_SWIFI_REMARS3");
					lat_value = (String) target.get("LAT");
					lnt_value = (String) target.get("LNT");
					work_dttm_value = (String) target.get("WORK_DTTM");
					
					String sql_insert = "INSERT INTO wifi (mgr_no, wrdofc, main_nm, adres1, adres2, instl_floor, instl_ty, "
							+ "instl_mby, svc_se, cmcwr, cnstc_year, inout_door, remars3, lat, lnt, work_dttm)"
							   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
					
					stat = connection.prepareStatement(sql_insert);
					stat.setString(1, mgr_no_value);
					stat.setString(2, wrdofc_value);
					stat.setString(3, main_nm_value);
					stat.setString(4, adres1_value);
					stat.setString(5, adres2_value);
					stat.setString(6, instl_floor_value);
					stat.setString(7, instl_ty_value);
					stat.setString(8, instl_mby_value);
					stat.setString(9, svc_se_value);
					stat.setString(10, cmcwr_value);
					stat.setString(11, cnstc_year_value);
					stat.setString(12, inout_door_value);
					stat.setString(13, remars3_value);
					stat.setString(14, lnt_value);
					stat.setString(15, lat_value);
					stat.setString(16, work_dttm_value);

					stat.executeUpdate();
					check = 1;
				}
				
				
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}
	

		
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
		
%>
<%if (check == 1) {%>

<h1><%=total_cnt%>개의 WIFI 정보를 정상적으로 저장하였습니다.</h1>
<a href="http://localhost:8080/wifi/">홈으로 가기</a>

<%} else { %>

<h1>실~패~</h1>
<a href="http://localhost:8080/wifi/">홈으로 가기</a>

<%} %>
</body>
</html>