<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="board-header">
    <a href="/posts/new">게시판 새글작성</a>
    <span class="brand">게시판</span>
    <c:choose>
        <c:when test="${pageContext.request.userPrincipal != null}">
            <div class="session">
                <span>${pageContext.request.userPrincipal.name}님</span>
                <form action="/logout" method="post" style="display:inline">
                    <%@ include file="csrf.jsp" %>
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