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

<a href="/posts">목록으로</a>
</body>
</html>