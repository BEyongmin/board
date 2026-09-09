<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head><title>${post.title}</title></head>
<body>
<h1>${post.title}</h1>
<p>카테고리: ${post.category.name} | 작성자: ${post.user.name} | 작성일: ${post.createdAt} | 조회수: ${post.viewCount}</p>
<hr/>
<p>${post.content}</p>
<hr/>

<c:if test="${pageContext.request.userPrincipal != null and pageContext.request.userPrincipal.name == post.user.email}">
    <a href="/posts/${post.id}/edit">수정</a>
    <form action="/posts/${post.id}/delete" method="post" style="display:inline">
        <%@ include file="/WEB-INF/views/fragments/csrf.jsp" %>
        <button type="submit" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
    </form>
</c:if>
<hr/>
<h3>댓글</h3>

<c:forEach var="comment" items="${comments}">
    <p>
        <strong>${comment.user.name}</strong> : ${comment.content}
        <small>(${comment.createdAt})</small>
        <c:if test="${pageContext.request.userPrincipal != null and pageContext.request.userPrincipal.name == comment.user.email}">
            <form action="/comments/${comment.id}/delete" method="post" style="display:inline">
                <%@ include file="/WEB-INF/views/fragments/csrf.jsp" %>
                <input type="hidden" name="postId" value="${post.id}" />
                <button type="submit" onclick="return confirm('댓글을 삭제하시겠습니까?')">삭제</button>
            </form>
        </c:if>
    </p>
</c:forEach>

<c:if test="${pageContext.request.userPrincipal != null}">
    <form action="/posts/${post.id}/comments" method="post">
        <%@ include file="/WEB-INF/views/fragments/csrf.jsp" %>
        <textarea name="content" rows="3" cols="40" placeholder="댓글을 입력하세요"></textarea><br/>
        <button type="submit">댓글 등록</button>
    </form>
</c:if>
<a href="/posts">목록으로</a>
</body>
</html>