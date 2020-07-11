<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="prereq.jsp" %>

<!DOCTYPE html>
<html>
    <head>
        <title>업로드 완료</title>
        <meta http-equiv="refresh" content="5;url=animeList.jsp">
        <link href="style.css" rel="stylesheet" type="text/css">
    </head>
    <body>
        <div class="banner">
<%
            String name, prod_comp, genre, id; Date airdate;
            String airdateYear, airdateMonth, airdateDate;
            int serial, cnt = 0; String[] urls;
            boolean isCompleted, isMovie;

            driverTest();

            try {

                request.setCharacterEncoding("utf-8");

                name = request.getParameter("name");
                genre = request.getParameter("genre");
                isCompleted = request.getParameter("isCompleted") != null;
                isMovie = request.getParameter("isMovie") != null;
                prod_comp = request.getParameter("prod_comp");
                airdateYear = request.getParameter("airdateYear");
                airdateMonth = request.getParameter("airdateMonth");
                airdateDate = request.getParameter("airdateDate");
                urls = request.getParameterValues("url");

                sql = "SELECT COUNT(SERIAL) AS CNT FROM ANIMATION";

                conn = DriverManager.getConnection(jdbcUrl, userId, userPw);

                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();

                if(rs.next()) cnt = rs.getInt("CNT");
                serial = cnt + 1;
                
                sql = "INSERT INTO ANIMATION VALUES(?, ?, ?, ?, ?, ?)";

                airdate = Date.valueOf(airdateYear + "-" + airdateMonth + "-" + airdateDate);

                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, serial);
                pstmt.setString(2, name);
                pstmt.setString(3, prod_comp);
                pstmt.setString(4, genre);
                pstmt.setDate(5, airdate);
                pstmt.setInt(6, 0);
                pstmt.executeUpdate();

                if(isCompleted) {
                    sql = "INSERT INTO COMPLETED_ANIME VALUES(?, ?)";
                    airdateYear = request.getParameter("lastAirdateYear");
                    airdateMonth = request.getParameter("lastAirdateMonth");
                    airdateDate = request.getParameter("lastAirdateDate");
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, serial);
                    if(airdateYear.length() > 0)
                        airdate = Date.valueOf(airdateYear + "-" + airdateMonth + "-" + airdateDate);
                    pstmt.setDate(2, airdateYear.length() > 0 ? airdate : null);
                    pstmt.executeUpdate();
                }

                sql = "INSERT INTO VIDEO VALUES(SYS_GUID(), ?, ?, ?)";

                for(int i = 0; i < urls.length; i++) {
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, serial);
                    pstmt.setInt(2, !isMovie ? i + 1 : null);
                    pstmt.setString(3, urls[i]);
                    pstmt.executeUpdate();
                }

            } catch(SQLException e) {
                handleSqlException(e);
            }

%>
            <h1>업로드 완료</h1>
            <div class="menu_wrapper">
                <a href="searchAnimeForm.jsp">[검색]</a>
                <a href="uploadAnimeForm.jsp">[업로드]</a>
                <a href="animeList.jsp">목록으로</a>
            </div>
        </div>
        <h3>5초 후에 메인 목록 화면으로 돌아갑니다.</h3>
    </body>
</html>