<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head><title>로그인</title></head>
<body>
<h1>로그인</h1>

<c:if test="${param.error != null}">
    <p style="color:red">이메일 또는 비밀번호가 올바르지 않습니다.</p>
</c:if>
<c:if test="${param.registered != null}">
    <p style="color:green">회원가입이 완료되었습니다. 로그인해주세요.</p>
</c:if>
<c:if test="${param.logout != null}">
    <p style="color:blue">로그아웃되었습니다.</p>
</c:if>

<form action="/login" method="post">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    <input type="email" name="email" placeholder="이메일" required /><br/>
    <input type="password" name="password" placeholder="비밀번호" required /><br/>
    <button type="submit">로그인</button>
</form>

<a href="/signup">회원가입</a>
</body>
</html>