<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="prereq.jsp" %>

<!DOCTYPE html>
<html>
<head>
	<title></title>
    <link href="style.css" rel="stylesheet" type="text/css">
    <script>
        window.onload = function() {
            let bannerTitle = document.querySelector('.banner h1');
            let title = document.querySelector('title');
            let animeEp = document.querySelector('.video h3').innerText;
            let animeName = animeEp.split(' EP')[0];
            bannerTitle.innerHTML = animeName + ' 다시보기';
            title.innerHTML = bannerTitle.innerHTML;
        };
    </script>
</head>
<body>
    <div class="banner">
        <h1>Loading...</h1>
        <div class="menu_wrapper">
            <a href="searchAnimeForm.jsp">[검색]</a>
            <a href="uploadAnimeForm.jsp">[업로드]</a>
            <a href="animeList.jsp">목록으로</a>
        </div>
    </div>
    <div class="video_container">
<%
        int serial, views; Integer episode;
        String temp, url, name;

        driverTest();

        try {

            request.setCharacterEncoding("utf-8");
            temp = request.getParameter("serial");

            if(temp != null) {

                serial = Integer.parseInt(temp);
                name = request.getParameter("name");
                views = Integer.parseInt(request.getParameter("views"));

                conn = DriverManager.getConnection(jdbcUrl, userId, userPw);

                sql = "SELECT EPISODE, URL FROM VIDEO "
                    + "WHERE ANIME_SERIAL = " + serial;

                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();

                while(rs.next()) {
                    episode = rs.getInt("EPISODE");
                    url = rs.getString("URL");
                    if(episode == 0) temp = name;
                    else temp = name + " EP" + episode;
%>
                    <div class="video content">
                        <h3><%= temp %></h3>
                        <video width="720" height="405" controls>
                            <source src="<%= url %>" type="video/mp4">
                        </video>
                    </div>
<%

                }

                sql = "UPDATE ANIMATION SET VIEWS = ? WHERE SERIAL = " + serial;
                
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, views + 1);
                pstmt.executeUpdate();

            } else {
                 out.println("애니메이션이 선택되지 않았습니다. 목록에서 선택해주세요.");
            }
            
        } catch(SQLException e) {
            handleSqlException(e);
        }
%>
    </div>
</body>
</html>