<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<html>
<head>
    <title>게시글 작성</title>
    <link rel="stylesheet" href="/css/board.css" />
</head>
<body>
<div class="page-wrap">
    <%@ include file="/WEB-INF/views/fragments/header.jsp" %>
    <a class="back-link" href="/posts">← 목록으로</a>

    <c:set var="actionUrl" value="${postId != null ? '/posts/'.concat(postId).concat('/edit') : '/posts'}" />

    <div class="post-form">
        <h1>${postId != null ? '게시글 수정' : '게시글 작성'}</h1>

        <form action="${actionUrl}" method="post" enctype="multipart/form-data">
            <%@ include file="/WEB-INF/views/fragments/csrf.jsp" %>

            <div class="form-group">
                <span class="field-label">카테고리</span>
                <select name="categoryId">
                    <c:forEach var="category" items="${categories}">
                        <option value="${category.id}" <c:if test="${category.id == postForm.categoryId}">selected</c:if>>
                            ${category.name}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <span class="field-label">제목</span>
                <input type="text" name="title" value="${fn:escapeXml(postForm.title)}" />
            </div>

            <div class="form-group">
                <span class="field-label">내용</span>
                <textarea name="content">${fn:escapeXml(postForm.content)}</textarea>
            </div>

            <c:if test="${not empty existingImages}">
                <div class="image-box">
                    <p class="box-label">기존 이미지 (대표 선택 / 삭제)</p>
                    <div class="image-grid">
                        <c:forEach var="img" items="${existingImages}">
                            <div class="image-item">
                                <img src="${img.filePath}" />
                                <label>
                                    <input type="radio" name="thumbnailImageId" value="${img.id}"
                                        <c:if test="${img.thumbnail}">checked</c:if> />
                                    대표
                                </label>
                                <label class="remove-line">
                                    <input type="checkbox" name="removeImageIds" value="${img.id}" />
                                    삭제
                                </label>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <div class="image-box">
                <p class="box-label">새 이미지 첨부 (선택, 최대 5장)</p>
                <input type="file" name="images" id="imagesInput" accept=".jpg,.jpeg,.png,.webp" multiple />
                <div class="image-grid" id="newImagePreview"></div>
            </div>
            <button type="submit" class="btn-block">저장</button>
        </form>
    </div>

</div>

<script>
document.getElementById('imagesInput').addEventListener('change', function (e) {
    var files = Array.from(e.target.files);
    var preview = document.getElementById('newImagePreview');
    preview.innerHTML = '';

    files.forEach(function (file, index) {
        var reader = new FileReader();
        reader.onload = function (event) {
            var item = document.createElement('div');
            item.className = 'image-item';
            item.innerHTML =
                '<img src="' + event.target.result + '" />' +
                '<label><input type="radio" name="newThumbnailIndex" value="' + index + '" /> 대표</label>';
            preview.appendChild(item);
        };
        reader.readAsDataURL(file);
    });
});
</script>
</body>
</html>