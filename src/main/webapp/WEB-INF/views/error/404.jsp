<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<html>
<head>
    <title>페이지를 찾을 수 없습니다</title>
    <link rel="stylesheet" href="/css/board.css" />
</head>
<body class="center-page">
<div class="error-note">
    <p class="error-code">404</p>
    <h1>찾을 수 없는 게시글입니다</h1>
    <p class="detail">${fn:escapeXml(message)}</p>
    <a href="/posts">목록으로 돌아가기</a>
</div>
</body>
</html>