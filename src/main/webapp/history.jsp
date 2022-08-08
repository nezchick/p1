<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    	import="java.sql.*"
    	%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>와이파이 정보 구하기</title>
<link rel="stylesheet" href="./wifi.css" type="text/css">
<script src="http://code.jquery.com/jquery-1.11.0.js"></script>
<script type="text/javascript" src="deleterow.js"></script>
</head>
<body>
<h1>위치 히스토리 목록</h1>
<a href="http://localhost:8080/wifi/">홈</a> | <a href="http://localhost:8080/wifi/history.jsp">위치 히스토리 목록</a> | <a href="http://localhost:8080/wifi/loadapi.jsp">Open API 와이파이 정보 가져오기</a>

<table id="customers">
<thead>
  <tr>
    <th>ID</th>
    <th>X좌표</th>
    <th>Y좌표</th>
    <th>조회일자</th>
    <th>비고</th>
  </tr>
  </thead>
  <%!
    Connection connection = null;
	Statement stat = null;
	ResultSet rs = null;
	String localdb = "jdbc:sqlite:C:/dev/work/workspace/wifi/wifi.db";
  %>
  <%
  try {
		Class.forName("org.sqlite.JDBC");
		connection = DriverManager.getConnection(localdb);
		String sql = "select * from history";
		stat = connection.createStatement();
		rs = stat.executeQuery(sql);
		while(rs.next()) {%>
		<tbody>
		 <tr>
		    <td><%= rs.getString("id") %></td>
		    <td><%= rs.getString("lat") %></td>
		    <td><%= rs.getString("lnt") %></td>
		    <td><%= rs.getString("view_dttm") %></td>
		    <td> <button type="button" onclick="deleteRow(this);">삭제</button> </td>
		    </tr>
		    </tbody>
			
<% }
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
</table>
</body>
</html>