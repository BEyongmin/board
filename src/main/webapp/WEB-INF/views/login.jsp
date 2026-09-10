<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<html>
<head>
    <title>로그인</title>
    <link rel="stylesheet" href="/css/board.css" />
</head>
<body class="center-page">
<div class="auth-note">
    <a class="auth-brand" href="/posts">게시판</a>
    <h1>로그인</h1>

    <c:if test="${param.error != null}">
        <p class="auth-message error">이메일 또는 비밀번호가 올바르지 않습니다.</p>
    </c:if>
    <c:if test="${param.registered != null}">
        <p class="auth-message success">회원가입이 완료되었습니다. 로그인해주세요.</p>
    </c:if>
    <c:if test="${param.logout != null}">
        <p class="auth-message info">로그아웃되었습니다.</p>
    </c:if>

    <form action="/login" method="post">
        <%@ include file="fragments/csrf.jsp" %>
        <input type="email" name="email" placeholder="이메일" required />
        <input type="password" name="password" placeholder="비밀번호" required />
        <button type="submit">로그인</button>
    </form>

    <a class="auth-link" href="/signup">아직 계정이 없으신가요? 회원가입</a>
</div>
</body>
</html>