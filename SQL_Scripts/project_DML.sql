-- SELECT Query 1
-- 애니메이션별 평균평점과 함께 애니메이션 데이터 SELECT
-- 초기에 사용자 평점이 없는 애니메이션도 추출하기 위해
-- Left Outer Join으로 평점이 null인 애니메이션도 SELECT
-- 조회수, 평점별 오름차순 정렬과 장르별 그룹화를
-- 선택적으로 적용하며 사용하는 것이 핵심이다.
SELECT *
FROM ANIMATION,
    (SELECT SERIAL AS RATE_SERIAL, 
            ROUND(AVG(RATE),1) AS AVG_RATE
     FROM ANIME_RATE GROUP BY SERIAL)
WHERE SERIAL = RATE_SERIAL(+);
-- ORDER BY VIEWS DESC;
-- ORDER BY AVG_RATE DESC;
-- GROUP BY GENRE;



-- SELECT Query 2
-- 해당 서비스의 핵심 질의문
-- -------------------------
-- 정적인 질의문 형태를 벗어나기 위해 테이블 변수화
-- 웹UI에서 선택된 검색 항목에 의해 각 항목에 해당하는
-- 테이블에 대한 정보를 삭제하거나 추가하여 질의
-- 예) 평점 검색 적용 해제 시 R 테이블과 관련된 수식 제외
-- (참고: 해당 질의문은 Proposal때의 질의문 3개를 합친 형태)
--
-- 임시 테이블별 세부사항
-- -------------------------
-- G: 장르 검색 결과 테이블
--    -> 웹UI에서 select-option 입력으로 선택한 장르를
--       검색하여 PK인 SERIAL과 장르값 GENRE를 추출
-- C: 완결 애니메이션 테이블
--    -> 완결 애니메이션 테이블은 사실상 아무 정보가 없기 때문에
--       애니메이션 정보와 Equi-Join하여 해당 PK값인 SERIAL만 추출
-- M:극장판 애니메이션 테이블
--    -> 극장판 애니메이션은 에피소드가 없기 때문에
--       비디오 테이블에서 에피소드가 NULL인 튜플의
--       SERIAL만 추출
--       (극장판 애니메이션은 비디오가 1개이기 때문에
--        애니메이션별 여러 비디오가 있는 다른 애니메이션과 달리
--        GROUP BY를 할 필요가 없다)
-- D: 날짜 범위 검색 결과 테이블
--    -> 정확한 일일 범위가 아닌 월 범위로 검색하여
--       분기별로 방영되는 애니메이션을 검색, 해당 PK인 SERIAL 추출
--       (일본 애니메이션의 방영 시기는 분기별로 밀집되기 때문임)
-- R: 평균평점 범위 검색 결과 테이블
--    -> 애니메이션별 평균 평점 검색 결과 테이블로 지정한
--       평균평점 범위 내에 있는 모든 애니메이션에 대하여
--       PK인 SERIAL과 평균평점인 AVG_RATE를 추출
--
-- 주 질의문 세부사항
-- -------------------------
-- 메인 테이블인 ANIMATION과 나머지 G, C, M, D, R을
-- PK인 SERIAL에 대하여 검색 항목에 맞게 Equi-Join 하기도,
-- Equi-Join에서 제외하기도 하면서 LIKE문으로 검색하는
-- 제목 문자열에 대한 부분 문자열 검색 수행 후
-- 해당 결과 애니메이션 튜플 전체 추출
WITH
G AS (
    SELECT SERIAL, GENRE
    FROM ANIMATION
    WHERE GENRE = ?
),
C AS (
    SELECT ANIMATION.SERIAL
    FROM ANIMATION, COMPLETED_ANIME
    WHERE ANIMATION.SERIAL = COMPLETED_ANIME.SERIAL
),
M AS (
    SELECT ANIME_SERIAL AS SERIAL
    FROM VIDEO
    WHERE EPISODE IS NULL
),
D AS (
    SELECT SERIAL
    FROM ANIMATION
    WHERE AIRDATE
    BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND LAST_DAY(TO_DATE(?, 'YYYY-MM-DD'))
),
R AS (
    SELECT * 
    FROM (
        SELECT SERIAL, ROUND(AVG(RATE),1) AS AVG_RATE 
        FROM ANIME_RATE 
        GROUP BY SERIAL
    ) 
    WHERE AVG_RATE BETWEEN ? AND ?
)
SELECT *
FROM ANIMATION, G, C, M, D, R
WHERE NAME LIKE '%?%'
AND ANIMATION.SERIAL = G.SERIAL
AND ANIMATION.SERIAL = C.SERIAL
AND ANIMATION.SERIAL = D.SERIAL
AND ANIMATION.SERIAL = M.SERIAL
AND ANIMATION.SERIAL = R.SERIAL;



-- SELECT Query 3
-- 비디오 열람 페이지에서 해당 애니메이션의 SERIAL을
-- EPISODE, URL과 함께 추출하기 위한 질의문
-- (참고: SERIAL은 메인 조회 페이지에서 POST로 받음)
SELECT EPISODE, URL
FROM VIDEO
WHERE ANIME_SERIAL = ?;



-- SELECT Query 4
-- 애니메이션 업로드 시에 SERIAL을 설정하기 위해
-- 전체 애니메이션의 수를 계산
-- 이후에 계산된 값에 1을 더하여 신규 SERIAL값 설정
SELECT COUNT(SERIAL) AS CNT FROM ANIMATION;



-- 비디오 열람 페이지에서 해당 애니메이션을 조회했기에
-- 해당 애니메이션의 조회수를 변경하기 위한 질의문
-- JSP로는 한 번 방문 시 1씩 증가하도록 설정함
-- (참고: SERIAL은 메인 조회 페이지에서 POST로 받음)
UPDATE ANIMATION SET VIEWS = ? WHERE SERIAL = ?;



-- 애니메이션 등록/추가
-- ANIMATION 테이블과 VIDEO 테이블 별로 튜플 추가
-- VIDEO 테이블에 대한 구문은 에피소드 개수만큼 구문 반복
-- Proposal 때와 달리 비디오의 ID는 32바이트짜리 GUID로 대체
INSERT INTO ANIMATION VALUES(?, ?, ?, ?, ?, ?);
INSERT INTO VIDEO VALUES(SYS_GUID(), ?, ?, ?);



-- 완결 에니메이션 등록
-- 애니메이션 업로드 시 완결 여부에 체크되어 있으면 질의
-- COMPLETED_ANIME 테이블에 튜플 추가
INSERT INTO COMPLETED_ANIME VALUES(?, ?);

