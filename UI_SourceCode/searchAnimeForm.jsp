<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="prereq.jsp" %>

<!DOCTYPE html>
<html>
    <head>
        <title>애니메이션 검색</title>
        <link href="style.css" rel="stylesheet" type="text/css">
        <style>
            .input_wrapper {
                margin-left: 1.5em;
                margin-bottom: 2em;
            }
            .submit_wrapper, .input_wrapper * { text-align: center; }
            .submit_button {
                border: 2px solid black;
                border-radius: 1em;
                width: 15em;
                height: 3em;
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <div class="banner">
            <h1>애니메이션 검색</h1>
            <div class="menu_wrapper">
                <a href="searchAnimeForm.jsp">[검색]</a>
                <a href="uploadAnimeForm.jsp">[업로드]</a>
                <a href="animeList.jsp">목록으로</a>
            </div>
        </div>
        <form name="form2" method="POST" action="animeList.jsp">
            <div class="input_wrapper">
                <strong>제목</strong> &nbsp; <input type="text" name="name"> &nbsp;&nbsp;
                <strong>장르</strong>  &nbsp; 
                <select name="genre">
                    <option value="none">모든 장르</option>
                    <option value="액션">액션</option>
                    <option value="능력">능력</option>
                    <option value="게임">게임</option>
                    <option value="범죄">범죄</option>
                    <option value="코미디">코미디</option>
                </select> &nbsp;&nbsp;
                <input type="checkbox" name="searchCompleted" id="searchCompleted" value="완결"> <label for="searchCompleted">완결</label>
                &nbsp;&nbsp;
                <input type="checkbox" name="searchMovies" id="searchMovies" value="극장판"> <label for="searchMovies">극장판</label>
            </div>
            <div class="input_wrapper">
                <strong>방영 시기</strong> &nbsp;&nbsp;
                <input type="checkbox" name="applyQuarter" id="applyQuarter" value="분기적용"> <label for="applyQuarter">적용</label>
                &nbsp;&nbsp;
                <input type="text" name="airdateYear" id="airdateYear"> <label for="airdateYear">년도</label>
                &nbsp;&nbsp;
                <select name="quarter">
                    <option value="0">모든 분기 (1월~12월)</option>
                    <option value="1">1분기 (1월~3월)</option>
                    <option value="2">2분기 (4월~6월)</option>
                    <option value="3">3분기 (7월~9월)</option>
                    <option value="4">4분기 (10월~12월)</option>
                </select>
            </div>
            <div class="input_wrapper">
                <strong>평점</strong> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="checkbox" name="applyRate" id="applyRate" value="평점적용"> <label for="applyRate">적용</label>
                &nbsp;&nbsp;
                <select name="lowerRate">
                    <option value="0">0점 (기본값)</option>
                    <option value="0">0점</option>
                    <option value="1">1점</option>
                    <option value="2">2점</option>
                    <option value="3">3점</option>
                    <option value="4">4점</option>
                    <option value="5">5점</option>
                </select>
                <strong>&nbsp; ~ &nbsp;</strong>
                <select name="upperRate">
                    <option value="5">5점 (기본값)</option>
                    <option value="0">0점</option>
                    <option value="1">1점</option>
                    <option value="2">2점</option>
                    <option value="3">3점</option>
                    <option value="4">4점</option>
                    <option value="5">5점</option>
                </select>
            </div>
            <div class="input_wrapper submit_wrapper">
                <input type="submit" class="submit_button" value="검색">
            </div>
        </form>
    </body>
</html>