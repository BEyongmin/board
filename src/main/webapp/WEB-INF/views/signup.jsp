<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head><title>회원가입</title></head>
<body>
<h1>회원가입</h1>

<c:if test="${errorMessage != null}">
    <p style="color:red">${errorMessage}</p>
</c:if>

<form action="/signup" method="post">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    이메일: <input type="email" name="email" value="${signupRequest.email}" /><br/>
    비밀번호: <input type="password" name="password" /><br/>
    이름: <input type="text" name="name" value="${signupRequest.name}" /><br/>
    <button type="submit">가입하기</button>
</form>
</body>
</html>