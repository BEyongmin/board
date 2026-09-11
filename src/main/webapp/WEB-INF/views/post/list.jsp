<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<html>
<head>
    <title>게시판</title>
    <link rel="stylesheet" href="/css/board.css" />
</head>
<body>
<div class="page-wrap">
    <%@ include file="/WEB-INF/views/fragments/header.jsp" %>
    <div class="category-tabs">
        <a href="/posts?sort=${sort}" class="${categoryId == null ? 'active' : ''}">전체</a>
        <c:forEach var="category" items="${categories}">
            <a href="/posts?categoryId=${category.id}&sort=${sort}"
            class="${categoryId == category.id ? 'active' : ''}">
                ${fn:escapeXml(category.name)}
            </a>
        </c:forEach>
    </div>

    <form action="/posts" method="get" class="toolbar">
        <select name="type">
            <option value="TITLE" <c:if test="${type == 'TITLE'}">selected</c:if>>제목</option>
            <option value="AUTHOR" <c:if test="${type == 'AUTHOR'}">selected</c:if>>작성자</option>
        </select>
        <input type="text" name="keyword" value="${fn:escapeXml(keyword)}" placeholder="검색어 입력" />
        <input type="hidden" name="sort" value="${sort}" />
        <button type="submit">검색</button>
    </form>

    <p class="sort-links">
        <a href="/posts?type=${type}&keyword=${fn:escapeXml(keyword)}&categoryId=${categoryId}&sort=LATEST" class="${sort == 'LATEST' ? 'active' : ''}">최신순</a>
        <span class="sep">·</span>
        <a href="/posts?type=${type}&keyword=${fn:escapeXml(keyword)}&categoryId=${categoryId}&sort=OLDEST" class="${sort == 'OLDEST' ? 'active' : ''}">오래된순</a>
    </p>

    <c:choose>
        <c:when test="${empty postPage.content}">
            <div class="empty-state">
                <p class="empty-icon">🔍</p>
                <p class="empty-text">검색 결과가 없습니다</p>
                <p class="empty-sub">다른 검색어로 다시 시도해보세요</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="post-grid">
                <c:forEach var="post" items="${postPage.content}" varStatus="status">
                    <a href="/posts/${post.id}" class="post-card c${status.index % 3 + 1}">
                        <span class="cat">${post.category.name}</span>
                        <c:set var="thumb" value="${thumbnailMap[post.id]}" />
                        <c:if test="${thumb != null}">
                            <img class="thumb" src="${thumb.filePath}" />
                        </c:if>
                        <p class="title">${fn:escapeXml(post.title)}</p>
                        <p class="meta">
                            <span>${fn:escapeXml(post.user.name)}</span>
                            <span><fmt:formatDate value="${post.createdAtAsDate}" pattern="MM-dd HH:mm" /></span>
                        </p>
                    </a>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

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
            <a class="pagination-arrow" href="/posts?type=${type}&keyword=${fn:escapeXml(keyword)}&categoryId=${categoryId}&sort=${sort}&page=${startPage - 1}">&lt;</a>
        </c:if>

        <c:forEach begin="${startPage}" end="${endPage}" var="i">
            <c:choose>
                <c:when test="${i == currentPage}">
                    <span class="current">${i + 1}</span>
                </c:when>
                <c:otherwise>
                    <a href="/posts?type=${type}&keyword=${fn:escapeXml(keyword)}&categoryId=${categoryId}&sort=${sort}&page=${i}">${i + 1}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <c:if test="${endPage < totalPages - 1}">
            <a class="pagination-arrow" href="/posts?type=${type}&keyword=${fn:escapeXml(keyword)}&categoryId=${categoryId}&sort=${sort}&page=${endPage + 1}">&gt;</a>
        </c:if>
    </c:if>
</div>

</div>
</body>
</html>