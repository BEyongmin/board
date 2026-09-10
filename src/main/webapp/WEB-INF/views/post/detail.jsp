<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<html>
<head>
    <title>${post.title}</title>
    <link rel="stylesheet" href="/css/board.css" />
</head>
<body>
<div class="page-wrap">
    <%@ include file="/WEB-INF/views/fragments/header.jsp" %>
    <a class="back-link" href="/posts">목록으로</a>
    <div class="detail-note">
        <span class="cat">${post.category.name}</span>
        <h1>${fn:escapeXml(post.title)}</h1>
        <p class="meta">
            ${fn:escapeXml(post.user.name)} ·
            <fmt:formatDate value="${post.createdAtAsDate}" pattern="yyyy-MM-dd HH:mm" /> ·
            조회 ${post.viewCount}
        </p>

        <c:if test="${not empty images}">
            <div class="image-gallery">
                <c:forEach var="img" items="${images}">
                    <div class="${img.thumbnail ? 'thumbnail-badge' : ''}">
                        <img src="${img.filePath}" />
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <p class="body">${fn:escapeXml(post.content)}</p>

        <c:if test="${pageContext.request.userPrincipal != null and pageContext.request.userPrincipal.name == post.user.email}">
            <div class="actions">
                <a class="btn-fill" href="/posts/${post.id}/edit">수정</a>
                <form action="/posts/${post.id}/delete" method="post">
                    <%@ include file="/WEB-INF/views/fragments/csrf.jsp" %>
                    <button type="submit" class="btn-outline" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
                </form>
            </div>
        </c:if>
    </div>

    <p class="comment-heading">댓글 ${comments.size()}개</p>

    <div class="comment-list">
        <c:forEach var="comment" items="${comments}" varStatus="status">
            <div class="comment-note ${status.index % 2 == 0 ? 'blue' : 'clay'}">
                <p class="author">${fn:escapeXml(comment.user.name)}</p>
                <p class="content">${fn:escapeXml(comment.content)}</p>
                <p class="time"><fmt:formatDate value="${comment.createdAtAsDate}" pattern="MM-dd HH:mm" /></p>
                <c:if test="${pageContext.request.userPrincipal != null and pageContext.request.userPrincipal.name == comment.user.email}">
                    <form action="/comments/${comment.id}/delete" method="post">
                        <%@ include file="/WEB-INF/views/fragments/csrf.jsp" %>
                        <input type="hidden" name="postId" value="${post.id}" />
                        <button type="submit" onclick="return confirm('댓글을 삭제하시겠습니까?')">삭제</button>
                    </form>
                </c:if>
            </div>
        </c:forEach>
    </div>

    <c:if test="${pageContext.request.userPrincipal != null}">
        <div class="comment-form-note">
            <form action="/posts/${post.id}/comments" method="post">
                <%@ include file="/WEB-INF/views/fragments/csrf.jsp" %>
                <textarea name="content" placeholder="댓글을 남겨보세요"></textarea>
                <div class="submit-row">
                    <button type="submit">등록</button>
                </div>
            </form>
        </div>
    </c:if>
</div>
</body>
</html>