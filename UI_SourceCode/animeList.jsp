<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="prereq.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>애니메이션 조회</title>
    <link href="style.css" rel="stylesheet" type="text/css">
    <style>
        .anime { height: 8em; }
        .anime * { margin-left: 5%; }
        .anime p { float: left; }
        .anime button {
            border: 2px solid black;
            width: 7em;
            height: 3em;
            border-radius: 1em;
            margin-right: 5%;
            float: right;
            cursor: pointer;
            position: relative;
            top: -1.5em;
        }
    </style>
    <script>
        let query = location.href.split('?')[1];
        window.onload = function() {
            let a;
            switch(query) {
                case 'orderByViews': a = document.querySelector('.orderByViews'); break;
                case 'groupByGenre': a = document.querySelector('.groupByGenre'); break;
                case 'orderByRate': a = document.querySelector('.orderByRate'); break;
                default: a = document.querySelector('.default');
            }
            a.style.backgroundColor = 'yellow';
        };
        function submitAnime(serial, name, views) {
            document.getElementById('serial').value = serial;
            document.getElementById('name').value = name;
            document.getElementById('views').value = views;
            document.getElementById('Submit').click();
        }
    </script>
</head>
<body>

    <div class="banner">
        <h1>저작권법 무시하는 애니 사이트</h1>
        <div class="menu_wrapper">
            <a href="animeList.jsp" class="default">업로드순</a>
            <a href="animeList.jsp?orderByViews" class="orderByViews">조회수순</a>
            <a href="animeList.jsp?groupByGenre" class="groupByGenre">장르별</a>
            <a href="animeList.jsp?orderByRate" class="orderByRate">평점순</a>
            <a href="searchAnimeForm.jsp">[검색]</a>
            <a href="uploadAnimeForm.jsp">[업로드]</a>
        </div>
    </div>
    <div class="anime_container">
<%

        String name, genre, airdateYear, minDate, maxDate; double rate;
        int serial, views, quarter, lowerRate, upperRate; Date airdate;
        boolean isOrderByViews, isGroupByGenre, isOrderByRate, isEmpty;
        boolean selCompleted, selMovies, selApplyQuarter, selApplyRate;

        driverTest();

        try {

            request.setCharacterEncoding("utf-8");

            name = request.getParameter("name");
            if(name != null) {
                genre = request.getParameter("genre");
                selCompleted = request.getParameter("searchCompleted") != null;
                selMovies = request.getParameter("searchMovies") != null;
                selApplyQuarter = request.getParameter("applyQuarter") != null;
                selApplyRate = request.getParameter("applyRate") != null;
                airdateYear = request.getParameter("airdateYear");
                quarter = Integer.parseInt(request.getParameter("quarter"));
                lowerRate = Integer.parseInt(request.getParameter("lowerRate"));
                upperRate = Integer.parseInt(request.getParameter("upperRate"));

                sql = "WITH ";

                if(!genre.contains("none"))
                    sql += "G AS (SELECT SERIAL, GENRE FROM ANIMATION WHERE GENRE = '" + genre + "'), ";
                if(selCompleted)
                    sql += "C AS (SELECT ANIMATION.SERIAL FROM ANIMATION, COMPLETED_ANIME WHERE ANIMATION.SERIAL = COMPLETED_ANIME.SERIAL), ";
                if(selMovies)
                    sql += "M AS (SELECT ANIME_SERIAL AS SERIAL FROM VIDEO WHERE EPISODE IS NULL), ";
                if(selApplyQuarter && airdateYear.length() > 0) {
                    if(quarter > 0) {
                        minDate = "TO_DATE('" + airdateYear + "-" + (quarter * 3 - 2) + "-1', 'YYYY-MM-DD')";
                        maxDate = "LAST_DAY(TO_DATE('" + airdateYear + "-" + (quarter * 3) + "-1', 'YYYY-MM-DD'))";
                    } else {
                        minDate = "TO_DATE('"+ airdateYear +"-1-1', 'YYYY-MM-DD')";
                        maxDate = "TO_DATE('"+ airdateYear +"-12-31', 'YYYY-MM-DD')";
                    }
                    sql += "D AS (SELECT SERIAL FROM ANIMATION WHERE AIRDATE BETWEEN " + minDate + " AND " + maxDate + "), ";
                }
                if(selApplyRate)
                    sql += "R AS (SELECT * FROM (SELECT SERIAL, ROUND(AVG(RATE),1) AS AVG_RATE FROM ANIME_RATE GROUP BY SERIAL) WHERE AVG_RATE BETWEEN " + lowerRate + " AND " + upperRate + "), ";
                else
                    sql += "R AS (SELECT SERIAL, ROUND(AVG(RATE),1) as AVG_RATE FROM ANIME_RATE GROUP BY SERIAL), ";
                
                if(sql.indexOf(",") == -1) sql = "SELECT * FROM ANIMATION";
                else {
                    sql = sql.replaceFirst("(?s)(.*),", "$1");
                    sql += "SELECT * FROM ANIMATION, R";
                }

                if(!genre.contains("none")) sql += ", G";
                if(selCompleted) sql += ", C";
                if(selMovies) sql += ", M";
                if(selApplyQuarter && airdateYear.length() > 0) sql += ", D";

                sql += " WHERE NAME LIKE '%" + name + "%' AND ANIMATION.SERIAL = R.SERIAL";

                if(!selApplyRate) sql += "(+)";
                if(!genre.contains("none")) sql += " AND ANIMATION.SERIAL = G.SERIAL";
                if(selCompleted) sql += " AND ANIMATION.SERIAL = C.SERIAL";
                if(selMovies) sql += " AND ANIMATION.SERIAL = M.SERIAL";
                if(selApplyQuarter && airdateYear.length() > 0) sql += " AND ANIMATION.SERIAL = D.SERIAL";

            } else {

                if(request.getQueryString() != null) {
                isOrderByViews = request.getQueryString().contains("orderByViews");
                isGroupByGenre = request.getQueryString().contains("groupByGenre");
                isOrderByRate = request.getQueryString().contains("orderByRate");
                } else isOrderByViews = isGroupByGenre = isOrderByRate = false;

                sql = "SELECT * "
                    + "FROM ANIMATION, "
                    + "(SELECT SERIAL AS RATE_SERIAL, ROUND(AVG(RATE),1) as AVG_RATE "
                    + "FROM ANIME_RATE GROUP BY SERIAL) "
                    + "WHERE SERIAL = RATE_SERIAL(+)";

                if(isOrderByViews) sql += " ORDER BY VIEWS DESC";
                else if(isGroupByGenre) sql += " ORDER BY GENRE";
                else if(isOrderByRate) sql += " ORDER BY AVG_RATE DESC";
            }

            conn = DriverManager.getConnection(jdbcUrl, userId, userPw);

            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            isEmpty = true;
            while(rs.next()) {
                serial = rs.getInt("SERIAL");
                name = rs.getString("NAME");
                genre = rs.getString("GENRE");
                airdate = rs.getDate("AIRDATE");
                views = rs.getInt("VIEWS");
                rate = rs.getDouble("AVG_RATE");
%>
                <div class="anime content">
                    <h3><%= name %></h3>
                    <p><%= genre %> | <%= airdate %> | ★<%= rate %> | <%= views %> views</p>
                    <input type="hidden" class="views" value="<%= views %>">
                    <button onclick="submitAnime(<%= serial %>, '<%= name %>', <%= views %>)">WATCH</button>
                </div>
<%
                if(isEmpty) isEmpty = false;
            }

            if(isEmpty) out.println("검색 결과가 없습니다.");

        } catch(SQLException e) {
            handleSqlException(e);
        }
%>

    </div>
    <form name="form1" method="POST" action="animePage.jsp">
        <input type="hidden" name="serial" id="serial">
        <input type="hidden" name="name" id="name">
        <input type="hidden" name="views" id="views">
        <input type="submit" id="Submit" value="" class="hidden_form">
    </form>
</body>
</html>