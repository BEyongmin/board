<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>회원가입</title>
    <link rel="stylesheet" href="/css/board.css" />
</head>
<body class="center-page">
<div class="auth-note">
    <p class="auth-brand">게시판</p>
    <h1>회원가입</h1>

    <c:if test="${errorMessage != null}">
        <p class="auth-message error">${errorMessage}</p>
    </c:if>

    <form action="/signup" method="post">
        <%@ include file="fragments/csrf.jsp" %>
        <span class="field-label">이메일</span>
        <input type="email" name="email" value="${signupRequest.email}" />
        <span class="field-label">비밀번호</span>
        <input type="password" name="password" />
        <span class="field-label">이름</span>
        <input type="text" name="name" value="${signupRequest.name}" />
        <button type="submit">가입하기</button>
    </form>
</div>
</body>
</html>