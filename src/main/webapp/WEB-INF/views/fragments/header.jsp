<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<div class="board-header">
    <a class="brand" href="/posts">게시판</a>
    <c:choose>
        <c:when test="${pageContext.request.userPrincipal != null}">
            <div class="session">
                <span class="greeting"><sec:authentication property="principal.user.name" />님</span>
                <a href="/posts/new" class="header-btn fill">글쓰기</a>
                <form action="/logout" method="post">
                    <%@ include file="csrf.jsp" %>
                    <button type="submit" class="header-btn outline">로그아웃</button>
                </form>
            </div>
        </c:when>
        <c:otherwise>
            <div class="session">
                <a href="/login" class="header-btn outline">로그인</a>
                <a href="/signup" class="header-btn fill">회원가입</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>