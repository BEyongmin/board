<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
                <input type="text" name="title" value="${postForm.title}" />
            </div>

            <div class="form-group">
                <span class="field-label">내용</span>
                <textarea name="content">${postForm.content}</textarea>
            </div>

            <c:if test="${currentImagePath != null}">
                <div class="image-box">
                    <p class="box-label">현재 이미지</p>
                    <img src="${currentImagePath}" />
                    <label class="checkbox-line">
                        <input type="checkbox" name="removeImage" value="true" />
                        이 이미지 삭제
                    </label>
                </div>
            </c:if>

            <div class="image-box">
                <p class="box-label">이미지 ${currentImagePath != null ? '교체' : '첨부'} (선택)</p>
                <input type="file" name="image" id="imageInput" accept=".jpg,.jpeg,.png,.webp" />
                <img id="previewImg" src="" style="display:none;" />
                <label class="checkbox-line" style="margin-top:10px;">
                    <input type="checkbox" name="useAsThumbnail" value="true"
                           <c:if test="${postForm.useAsThumbnail}">checked</c:if> />
                    대표 이미지로 사용
                </label>
            </div>

            <button type="submit" class="btn-block">저장</button>
        </form>
    </div>

</div>

<script>
document.getElementById('imageInput').addEventListener('change', function (e) {
    var file = e.target.files[0];
    var preview = document.getElementById('previewImg');
    if (!file) {
        preview.style.display = 'none';
        return;
    }
    var reader = new FileReader();
    reader.onload = function (event) {
        preview.src = event.target.result;
        preview.style.display = 'block';
    };
    reader.readAsDataURL(file);
});
</script>
</body>
</html>