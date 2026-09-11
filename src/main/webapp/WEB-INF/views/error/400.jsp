<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<html>
<head>
    <title>잘못된 요청</title>
    <link rel="stylesheet" href="/css/board.css" />
</head>
<body class="center-page">
<div class="error-note">
    <p class="error-code">400</p>
    <h1>잘못된 요청입니다</h1>
    <p class="detail">${fn:escapeXml(message)}</p>
    <a href="/posts">목록으로 돌아가기</a>
</div>
</body>
</html>