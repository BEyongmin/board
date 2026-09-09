<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>잠시 후 다시 시도해주세요</title>
    <link rel="stylesheet" href="/css/board.css" />
</head>
<body>
<div class="error-note warn">
    <p class="error-code">429</p>
    <h1>잠시 후 다시 시도해주세요</h1>
    <p class="detail">${message}</p>
    <a href="/posts">목록으로 돌아가기</a>
</div>
</body>
</html>