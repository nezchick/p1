package wifi;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class dbcontrol {
	public static void main(String[] args) {

		String localdb = "jdbc:sqlite:wifi.db";

		
			// 1. 드라이버 로드 (SQLite JDBC 체크)
			try {
				Class.forName("org.sqlite.JDBC");
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			// 2. 커넥션 객체 생성 (SQLite 데이터베이스 파일에 연결)
			Connection connection;
			try {
				connection = DriverManager.getConnection(localdb);
				// 3. 스테이트먼트 객체 생성
				/*
				 1. Statement 
				 2. preparedStatement -> 주로 이걸 사용
				 파라먼트 처리 가능
				 3. CallableStatement
				 */
				Statement stat = connection.createStatement();
				
				String sql = "select * from wifi";
				
				ResultSet rs = stat.executeQuery(sql);
				
				while(rs.next()) {
					System.out.print(rs.getString("mgr_no") + " ");
					System.out.print(rs.getString("wrdofc") + " ");
					System.out.print(rs.getString("main_nm") + " ");
					System.out.print(rs.getString("adres1") + " ");
					System.out.print(rs.getString("adres2") + " ");
					System.out.print(rs.getString("instl_floor") + " ");
					System.out.print(rs.getString("instl_ty") + " ");
					System.out.print(rs.getString("instl_mby") + " ");
					System.out.print(rs.getString("svc_se") + " ");
					System.out.print(rs.getString("cmcwr") + " ");
					System.out.print(rs.getString("cnstc_year") + " ");
					System.out.print(rs.getString("inout_door") + " ");
					System.out.print(rs.getString("remars3") + " ");
					System.out.print(rs.getString("lat") + " ");
					System.out.print(rs.getString("lnt") + " ");
					System.out.print(rs.getString("work_dttm") + " ");
					System.out.println();
					
				}
				
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
}
