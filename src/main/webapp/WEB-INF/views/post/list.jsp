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

<div>
    <c:if test="${postPage.totalPages > 0}">
        <c:forEach begin="0" end="${postPage.totalPages - 1}" var="i">
            <a href="/posts?page=${i}">${i + 1}</a>
        </c:forEach>
    </c:if>
</div>
</body>
</html>