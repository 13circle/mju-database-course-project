<%@ page import="java.sql.*" %>

<%!
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String sql = null;

    String jdbcUrl = "jdbc:oracle:thin:@localhost:1521:xe";
    String userId = "class_a";
    String userPw = "practice";

    public void driverTest() {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
        } catch(ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
            System.out.println("드라이버 로딩 실패");
        }
    }

    public void handleSqlException(SQLException e) {
        e.printStackTrace();
        if(rs != null) {
            try { rs.close(); } catch(SQLException sqle) {}
        }
        if(pstmt != null) {
            try { pstmt.close(); } catch(SQLException sqle) {}
        }
        if(conn != null) {
            try { conn.close(); } catch(SQLException sqle) {}
        }
    }
%>