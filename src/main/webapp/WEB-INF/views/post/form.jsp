<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head><title>게시글 작성</title></head>
<body>
<h1>게시글 작성</h1>

<c:set var="actionUrl" value="${postId != null ? '/posts/'.concat(postId).concat('/edit') : '/posts'}" />

<form action="${actionUrl}" method="post" enctype="multipart/form-data">
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

    <!-- 수정 화면이고, 이미 이미지가 있는 경우에만 현재 이미지 + 삭제 옵션 표시 -->
    <c:if test="${currentImagePath != null}">
        <p>현재 이미지:</p>
        <img src="${currentImagePath}" width="150" /><br/>
        <label><input type="checkbox" name="removeImage" value="true" /> 이 이미지 삭제</label><br/>
    </c:if>

    이미지 (교체/신규 등록):
    <input type="file" name="image" id="imageInput" accept=".jpg,.jpeg,.png,.webp" /><br/>

    <!-- 새로 선택한 파일 미리보기 -->
    <img id="previewImg" src="" style="display:none; width:150px;" /><br/>

    <label>
        <input type="checkbox" name="useAsThumbnail" value="true"
               <c:if test="${postForm.useAsThumbnail}">checked</c:if> />
        대표 이미지로 사용
    </label><br/>

    <button type="submit">저장</button>
</form>

<script>
document.getElementById('imageInput').addEventListener('change', function(e) {
    var file = e.target.files[0];
    var preview = document.getElementById('previewImg');
    if (!file) {
        preview.style.display = 'none';
        return;
    }
    var reader = new FileReader();
    reader.onload = function(event) {
        preview.src = event.target.result;
        preview.style.display = 'block';
    };
    reader.readAsDataURL(file);
});
</script>
</body>
</html>