<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <title>게시판</title>
    <link rel="stylesheet" href="/css/board.css" />
</head>
<body>
<div class="page-wrap">

    <div class="board-header">
        <span class="brand">게시판</span>
        <c:choose>
            <c:when test="${pageContext.request.userPrincipal != null}">
                <div class="session">
                    <span>${pageContext.request.userPrincipal.name}님</span>
                    <a href="/posts/new">글쓰기</a>
                    <form action="/logout" method="post" style="display:inline">
                        <%@ include file="/WEB-INF/views/fragments/csrf.jsp" %>
                        <button type="submit" class="link-btn">로그아웃</button>
                    </form>
                </div>
            </c:when>
            <c:otherwise>
                <div class="session">
                    <a href="/login">로그인</a>
                    <a href="/signup">회원가입</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <form action="/posts" method="get" class="toolbar">
        <select name="type">
            <option value="TITLE" <c:if test="${type == 'TITLE'}">selected</c:if>>제목</option>
            <option value="AUTHOR" <c:if test="${type == 'AUTHOR'}">selected</c:if>>작성자</option>
        </select>
        <input type="text" name="keyword" value="${keyword}" placeholder="검색어 입력" />
        <input type="hidden" name="sort" value="${sort}" />
        <button type="submit">검색</button>
    </form>

    <p class="sort-links">
        <a href="/posts?type=${type}&keyword=${keyword}&sort=LATEST" class="${sort == 'LATEST' ? 'active' : ''}">최신순</a>
        <span class="sep">·</span>
        <a href="/posts?type=${type}&keyword=${keyword}&sort=OLDEST" class="${sort == 'OLDEST' ? 'active' : ''}">오래된순</a>
    </p>

    <div class="post-grid">
        <c:forEach var="post" items="${postPage.content}" varStatus="status">
            <a href="/posts/${post.id}" class="post-card c${status.index % 3 + 1}">
                <span class="cat">${post.category.name}</span>
                <c:if test="${post.thumbnail}">
                    <img class="thumb" src="${post.imagePath}" />
                </c:if>
                <p class="title">${post.title}</p>
                <p class="meta">
                    <span>${post.user.name}</span>
                    <span><fmt:formatDate value="${post.createdAtAsDate}" pattern="MM-dd HH:mm" /></span>
                </p>
            </a>
        </c:forEach>
    </div>

    <div class="pagination">
        <c:if test="${postPage.totalPages > 0}">
            <c:set var="currentPage" value="${postPage.number}" />
            <c:set var="totalPages" value="${postPage.totalPages}" />

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

            <c:if test="${startPage > 0}">
                <a class="pagination-arrow" href="/posts?type=${type}&keyword=${keyword}&sort=${sort}&page=${startPage - 1}">&lt;</a>
            </c:if>

            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <span class="current">${i + 1}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="/posts?type=${type}&keyword=${keyword}&sort=${sort}&page=${i}">${i + 1}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:if test="${endPage < totalPages - 1}">
                <a class="pagination-arrow" href="/posts?type=${type}&keyword=${keyword}&sort=${sort}&page=${endPage + 1}">&gt;</a>
            </c:if>
        </c:if>
    </div>

</div>
</body>
</html>