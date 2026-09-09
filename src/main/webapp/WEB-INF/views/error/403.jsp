<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>권한이 없습니다</title>
    <link rel="stylesheet" href="/css/board.css" />
</head>
<body>
<div class="error-note">
    <p class="error-code">403</p>
    <h1>권한이 없습니다</h1>
    <p class="detail">${message}</p>
    <a href="/posts">목록으로 돌아가기</a>
</div>
</body>
</html>