<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head><title>게시판</title></head>
<body>
<h1>게시글 목록</h1>

<c:choose>
    <c:when test="${pageContext.request.userPrincipal != null}">
        <p>
            ${pageContext.request.userPrincipal.name}님 로그인 중
            | <a href="/posts/new">글쓰기</a>
            | <form action="/logout" method="post" style="display:inline">
                <%@ include file="/WEB-INF/views/fragments/csrf.jsp" %>
                <button type="submit">로그아웃</button>
              </form>
        </p>
    </c:when>
    <c:otherwise>
        <p><a href="/login">로그인</a> | <a href="/signup">회원가입</a></p>
    </c:otherwise>
</c:choose>

<!-- 검색 폼 -->
<form action="/posts" method="get">
    <select name="type">
        <option value="TITLE" <c:if test="${type == 'TITLE'}">selected</c:if>>제목</option>
        <option value="AUTHOR" <c:if test="${type == 'AUTHOR'}">selected</c:if>>작성자</option>
    </select>
    <input type="text" name="keyword" value="${keyword}" placeholder="검색어 입력" />
    <input type="hidden" name="sort" value="${sort}" />
    <button type="submit">검색</button>
</form>

<!-- 정렬 링크 (검색 조건은 유지한 채 정렬만 변경) -->
<p>
    <a href="/posts?type=${type}&keyword=${keyword}&sort=LATEST">최신순</a>
    |
    <a href="/posts?type=${type}&keyword=${keyword}&sort=OLDEST">오래된순</a>
</p>

<table border="1" cellpadding="5">
    <tr>
        <th>번호</th><th>대표이미지</th><th>카테고리</th><th>제목</th><th>작성자</th><th>작성일</th><th>조회수</th>
    </tr>
    <c:forEach var="post" items="${postPage.content}">
        <tr>
            <td>${post.id}</td>
            <td>
                <c:if test="${post.thumbnail}">
                    <img src="${post.imagePath}" width="60" height="60" />
                </c:if>
            </td>
            <td>${post.category.name}</td>
            <td><a href="/posts/${post.id}">${post.title}</a></td>
            <td>${post.user.name}</td>
            <td><fmt:formatDate value="${post.createdAtAsDate}" pattern="yyyy-MM-dd HH:mm" /></td>
            <td>${post.viewCount}</td>
        </tr>
    </c:forEach>
</table>

<!-- 페이징: 검색조건 + 정렬조건 유지 -->
<div>
    <c:if test="${postPage.totalPages > 0}">
        <c:set var="currentPage" value="${postPage.number}" />
        <c:set var="totalPages" value="${postPage.totalPages}" />
        <c:set var="pageGroupSize" value="5" />

        <%-- 현재 페이지를 가운데 두고 시작/끝 계산 --%>
        <c:set var="startPage" value="${currentPage - 2}" />
        <c:set var="endPage" value="${currentPage + 2}" />

        <c:if test="${startPage < 0}">
            <c:set var="endPage" value="${endPage - startPage}" />
            <c:set var="startPage" value="0" />
        </c:if>
        <c:if test="${endPage > totalPages - 1}">
            <c:set var="startPage" value="${startPage - (endPage - (totalPages - 1))}" />
            <c:set var="endPage" value="${totalPages - 1}" />
        </c:if>
        <c:if test="${startPage < 0}">
            <c:set var="startPage" value="0" />
        </c:if>

        <%-- 이전 묶음 화살표: 시작 페이지가 0보다 크면 표시 --%>
        <c:if test="${startPage > 0}">
            <a href="/posts?type=${type}&keyword=${keyword}&sort=${sort}&page=${startPage - 1}">&lt;</a>
        </c:if>

        <%-- 페이지 번호 5개 --%>
        <c:forEach begin="${startPage}" end="${endPage}" var="i">
            <c:choose>
                <c:when test="${i == currentPage}">
                    <strong>${i + 1}</strong>
                </c:when>
                <c:otherwise>
                    <a href="/posts?type=${type}&keyword=${keyword}&sort=${sort}&page=${i}">${i + 1}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <%-- 다음 묶음 화살표: 끝 페이지가 마지막 페이지보다 작으면 표시 --%>
        <c:if test="${endPage < totalPages - 1}">
            <a href="/posts?type=${type}&keyword=${keyword}&sort=${sort}&page=${endPage + 1}">&gt;</a>
        </c:if>
    </c:if>
</div>
</body>
</html>