<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head><title>게시글 작성</title></head>
<body>
<h1>게시글 작성</h1>

<c:set var="actionUrl" value="${postId != null ? '/posts/'.concat(postId).concat('/edit') : '/posts'}" />

<form action="${actionUrl}" method="post">
    <%@ include file="/WEB-INF/views/fragments/csrf.jsp" %>

    카테고리:
    <select name="categoryId">
        <c:forEach var="category" items="${categories}">
            <option value="${category.id}" <c:if test="${category.id == postForm.categoryId}">selected</c:if>>
                ${category.name}
            </option>
        </c:forEach>
    </select><br/>

    제목: <input type="text" name="title" value="${postForm.title}" /><br/>
    내용: <textarea name="content" rows="10" cols="50">${postForm.content}</textarea><br/>

    <button type="submit">저장</button>
</form>
</body>
</html>