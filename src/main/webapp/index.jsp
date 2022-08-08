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
	import="java.lang.*"
	import="java.util.*"
	import="java.time.*"
	import="java.time.format.*"
    %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>와이파이 정보 구하기</title>

<link rel="stylesheet" href="./wifi.css" type="text/css">
<script src="http://code.jquery.com/jquery-1.11.0.js"></script>
<script type="text/javascript" src="location.js"></script>
</head>
<body>
<h1>와이파이 정보 구하기</h1>

<a href="http://localhost:8080/wifi/">홈</a> | <a href="http://localhost:8080/wifi/history.jsp">위치 히스토리 목록</a> | <a href="http://localhost:8080/wifi/loadapi.jsp">Open API 와이파이 정보 가져오기</a>
</br>
<form action="index.jsp" method="get"> LAT: <input type="text" id="lat" value="0.0" name="lat"> LNT: <input id="lnt" value="0.0" name="lnt"> 
<input type="button"  onclick='my_location();' value="내 위치 가져오기"> <input type="submit" onclick="" value="근처 WIFI 정보 보기"> </form>

<table id="customers">
  <tr>
    <th>거리(Km)</th>
    <th>관리번호</th>
    <th>자치구</th>
    <th>와이파이명</th>
    <th>도로명주소</th>
    <th>상세주소</th>
    <th>설치위치(층)</th>
    <th>설치유형</th>
    <th>설치기관</th>
    <th>서비스구분</th>
    <th>망종류</th>
    <th>설치년도</th>
    <th>실내외구분</th>
    <th>WIFI접속환경</th>
    <th>X좌표</th>
    <th>Y좌표</th>
    <th>작업일자</th>
  </tr>
   <%!
    Connection connection = null;
	Statement stat = null;
	PreparedStatement pStat = null;
	ResultSet rs = null;
	double lat_num = 0;
 	double lnt_num = 0;
 	double db_lat_num = 0;
 	double db_lnt_num = 0;
 	double tmp = Double.MAX_VALUE;
 	int cnt = 0;
 	List<Object> distArray = new ArrayList<Object>();
 	LocalDateTime now = LocalDateTime.now();
 	String parseNow = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
	
	String localdb = "jdbc:sqlite:C:/dev/work/workspace/wifi/wifi.db";
	%>
	<%
	
	try {
		Class.forName("org.sqlite.JDBC");
		connection = DriverManager.getConnection(localdb);
		String sql = "select * from wifi";
		stat = connection.createStatement();
		rs = stat.executeQuery(sql);
		String sql_insert = "INSERT INTO history (lat, lnt, view_dttm)"
				   + "VALUES (?, ?, ?);";
		pStat = connection.prepareStatement(sql_insert);
		pStat.setString(1, request.getParameter("lat"));
		pStat.setString(2, request.getParameter("lnt"));
		pStat.setString(3,parseNow);
		
		
		if(request.getParameter("lat") != null && request.getParameter("lnt") != null) {
			
			pStat.executeUpdate();
			
		     while(rs.next()) {
		    	 lat_num = Double.parseDouble(request.getParameter("lat"));
		     	 lnt_num = Double.parseDouble(request.getParameter("lnt"));
		     	 db_lat_num = Double.parseDouble(rs.getString("lat"));
		     	 db_lnt_num = Double.parseDouble(rs.getString("lnt"));
		     	 
		     	 //두 좌표 거리 계산
		     	double theta = lnt_num - db_lnt_num;
		    	double dist = Math.sin(Math.toRadians(lat_num)) * Math.sin(Math.toRadians(db_lat_num)) + Math.cos(Math.toRadians(lat_num)) * Math.cos(Math.toRadians(db_lat_num)) * Math.cos(Math.toRadians(theta));
		    	
		    	dist = Math.acos(dist);
		    	dist = Math.toDegrees(dist);
		    	dist = dist * 60 * 1.1515;
		    	dist = dist * 1.609344;
		    	
		    	
		    	if(tmp >= dist) {
		    		tmp = dist;
		    		
		    		//0, 17
		    		distArray.add(dist);
		    		distArray.add(rs.getString("mgr_no"));
		    		distArray.add(rs.getString("wrdofc"));
		    		distArray.add(rs.getString("main_nm"));
		    		distArray.add(rs.getString("adres1"));
		    		distArray.add(rs.getString("adres2"));
		    		distArray.add(rs.getString("instl_floor"));
		    		distArray.add(rs.getString("instl_ty"));
		    		distArray.add(rs.getString("instl_mby"));
		    		distArray.add(rs.getString("svc_se"));
		    		distArray.add(rs.getString("cmcwr"));
		    		distArray.add(rs.getString("cnstc_year"));
		    		distArray.add(rs.getString("inout_door"));
		    		distArray.add(rs.getString("remars3"));
		    		distArray.add(rs.getString("lat"));
		    		distArray.add(rs.getString("lnt"));
		    		distArray.add(rs.getString("work_dttm"));
		    		
		    		
		   	%>
		  <% }}} else {%>
		  <tr>
			  <td id="index_td" colspan="17">위치 정보를 입력한 후에 조회해주세요.</td>
			  </tr>
		  <% }
		
		tmp = Double.MAX_VALUE;
		
	} catch (SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
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
 	 
 	 		<% for (int i =distArray.size()-17; i>= 0; i = i-17) { %>
		<tr>
		    <td><%  out.print(distArray.get(i)); %></td>
		    <td><%= distArray.get(i+1) %></td>
		    <td><%= distArray.get(i+2) %></td>
		    <td><%= distArray.get(i+3) %></td>
		    <td><%= distArray.get(i+4) %></td>
		    <td><%= distArray.get(i+5) %></td>
		    <td><%= distArray.get(i+6) %></td>
		    <td><%= distArray.get(i+7) %></td>
		    <td><%= distArray.get(i+8) %></td>
		    <td><%= distArray.get(i+9) %></td>
		    <td><%= distArray.get(i+10) %></td>
		    <td><%= distArray.get(i+11) %></td>
		    <td><%= distArray.get(i+12) %></td>
		    <td><%= distArray.get(i+13) %></td>
		    <td><%= distArray.get(i+14) %></td>
		    <td><%= distArray.get(i+15) %></td>
		    <td><%= distArray.get(i+16)%></td>
		    <% cnt++; 
		    if (cnt == 20) {
				cnt = 0;
		    	break;
		    }
		    %>
		    </tr>
		    
		    <%}
 	 		distArray.clear();%>
     
</table>
</body>
</html>