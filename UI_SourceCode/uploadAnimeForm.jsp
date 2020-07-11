<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="prereq.jsp" %>

<!DOCTYPE html>
<html>
    <head>
        <title>애니메이션 업로드</title>
        <link href="style.css" rel="stylesheet" type="text/css">
        <style>
            .input_wrapper {
                margin-left: 1.5em;
                margin-bottom: 2em;
            }
            .submit_wrapper, .input_wrapper * { text-align: center; }
            .video_wrapper {
                text-align: left;
                margin-top: 1em;
                margin-bottom: 1em;
            }
            .submit_button {
                border: 2px solid black;
                border-radius: 1em;
                width: 15em;
                height: 3em;
                cursor: pointer;
            }
        </style>
        <script>
            let videos, lastAirdate, episode, isMovie, isCompleted;
            let addVideoButton, delVideoButton;
            window.onload = function() {
                videos = document.getElementById('videos');
                lastAirdate = document.getElementById('lastAirdate');
                addVideoButton = document.getElementById('addVideoButton');
                delVideoButton = document.getElementById('delVideoButton');
                episode = 0, isMovie = isCompleted = false;
                addVideo(); lastAirdate.style.display = 'none';
            };
            function addVideo() {
                let video_wrapper = document.createElement('div');
                let video_title = document.createElement('strong');
                let url = document.createElement('input');

                video_wrapper.className = 'video_wrapper';
                videos.appendChild(video_wrapper);

                video_title.innerHTML = (!isMovie ? 'EP #' + ++episode : 'MOVIE')
                                      + '&nbsp;&nbsp;-&nbsp;&nbsp;'
                                      + 'URL &nbsp;';
                video_wrapper.appendChild(video_title);

                url.type = 'text'; url.name = 'url';
                url.style.width = '30em';
                video_wrapper.appendChild(url);
            }
            function delVideo() {
                if(episode > 1) {
                    videos.removeChild(videos.lastChild);
                    episode--;
                }
            }
            function checkCompleted() {
                isCompleted = document.getElementById("isCompleted").checked;
                lastAirdate.style.display = isCompleted ? 'block' : 'none';
            }
            function checkMovie() {
                isMovie = document.getElementById('isMovie').checked;
                addVideoButton.style.display = isMovie ? 'none' : 'inline';
                delVideoButton.style.display = isMovie ? 'none' : 'inline';
                videos.innerHTML = ''; episode = 0; addVideo();
            }
        </script>
    </head>
    <body>
        <div class="banner">
            <h1>애니메이션 업로드</h1>
            <div class="menu_wrapper">
                <a href="searchAnimeForm.jsp">[검색]</a>
                <a href="uploadAnimeForm.jsp">[업로드]</a>
                <a href="animeList.jsp">목록으로</a>
            </div>
        </div>
        <form name="form3" method="POST" action="uploadAnime.jsp">
            <div class="input_wrapper">
                <strong>제목</strong> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="text" name="name"> &nbsp;&nbsp;
                <strong>장르</strong>  &nbsp; 
                <select name="genre">
                    <option value="none">모든 장르</option>
                    <option value="액션">액션</option>
                    <option value="능력">능력</option>
                    <option value="게임">게임</option>
                    <option value="범죄">범죄</option>
                    <option value="코미디">코미디</option>
                </select> &nbsp;&nbsp;
                <input type="checkbox" name="isCompleted" id="isCompleted" value="완결" onclick="checkCompleted()">
                <label for="isCompleted">완결</label>
                &nbsp;&nbsp;
                <input type="checkbox" name="isMovie" id="isMovie" value="극장판" onclick="checkMovie()">
                <label for="isMovie">극장판</label>
            </div>
            <div class="input_wrapper">
                <strong>제작사</strong> &nbsp; <input type="text" name="prod_comp">
            </div>
            <div class="input_wrapper">
                <strong>방영일</strong> &nbsp;
                <input type="text" name="airdateYear" id="airdateYear">
                <label for="airdateYear">년</label>
                &nbsp;&nbsp;&nbsp;
                <select name="airdateMonth">
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="6">6</option>
                    <option value="7">7</option>
                    <option value="8">8</option>
                    <option value="9">9</option>
                    <option value="10">10</option>
                    <option value="11">11</option>
                    <option value="12">12</option>
                </select> 월
                &nbsp;&nbsp;&nbsp;
                <select name="airdateDate">
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="6">6</option>
                    <option value="7">7</option>
                    <option value="8">8</option>
                    <option value="9">9</option>
                    <option value="10">10</option>
                    <option value="11">11</option>
                    <option value="12">12</option>
                    <option value="13">13</option>
                    <option value="14">14</option>
                    <option value="15">15</option>
                    <option value="16">16</option>
                    <option value="17">17</option>
                    <option value="18">18</option>
                    <option value="19">19</option>
                    <option value="20">20</option>
                    <option value="21">21</option>
                    <option value="22">22</option>
                    <option value="23">23</option>
                    <option value="24">24</option>
                    <option value="25">25</option>
                    <option value="26">26</option>
                    <option value="27">27</option>
                    <option value="28">28</option>
                    <option value="29">29</option>
                    <option value="30">30</option>
                    <option value="31">31</option>
                </select> 일
            </div>
            <div class="input_wrapper" id="lastAirdate">
                <strong>종영일</strong> &nbsp;
                <input type="text" name="lastAirdateYear" id="lastAirdateYear">
                <label for="lastAirdateYear">년</label>
                &nbsp;&nbsp;&nbsp;
                <select name="lastAirdateMonth">
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="6">6</option>
                    <option value="7">7</option>
                    <option value="8">8</option>
                    <option value="9">9</option>
                    <option value="10">10</option>
                    <option value="11">11</option>
                    <option value="12">12</option>
                </select> 월
                &nbsp;&nbsp;&nbsp;
                <select name="lastAirdateDate">
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="6">6</option>
                    <option value="7">7</option>
                    <option value="8">8</option>
                    <option value="9">9</option>
                    <option value="10">10</option>
                    <option value="11">11</option>
                    <option value="12">12</option>
                    <option value="13">13</option>
                    <option value="14">14</option>
                    <option value="15">15</option>
                    <option value="16">16</option>
                    <option value="17">17</option>
                    <option value="18">18</option>
                    <option value="19">19</option>
                    <option value="20">20</option>
                    <option value="21">21</option>
                    <option value="22">22</option>
                    <option value="23">23</option>
                    <option value="24">24</option>
                    <option value="25">25</option>
                    <option value="26">26</option>
                    <option value="27">27</option>
                    <option value="28">28</option>
                    <option value="29">29</option>
                    <option value="30">30</option>
                    <option value="31">31</option>
                </select> 일
            </div>
            <div class="input_wrapper">
                <strong>비디오</strong> &nbsp;
                <input type="button" value="+ 비디오 추가" onclick="addVideo()" id="addVideoButton"> &nbsp;
                <input type="button" value="- 비디오 삭제" onclick="delVideo()" id="delVideoButton"> <br>
                <div id="videos"></div>
            </div>
            <div class="input_wrapper submit_wrapper">
                <input type="submit" class="submit_button" value="업로드">
            </div>
        </form>
    </body>
</html>