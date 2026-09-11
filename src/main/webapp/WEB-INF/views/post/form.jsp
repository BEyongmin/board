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
                <input type="text" name="title" value="${fn:escapeXml(postForm.title)}" maxlength="200" />
            </div>

            <div class="form-group">
                <span class="field-label">내용 <span id="contentCount" class="char-count">0 / 5000</span></span>
                <textarea name="content" maxlength="5000" id="contentTextarea">${fn:escapeXml(postForm.content)}</textarea>
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

                <div class="dropzone" id="dropzone">
                    <p class="dropzone-icon">+</p>
                    <p class="dropzone-text">이미지를 끌어다 놓거나 클릭해서 선택하세요</p>
                    <p class="dropzone-sub">jpg, jpeg, png, webp · 최대 5장</p>
                    <input type="file" id="fileSelector" accept=".jpg,.jpeg,.png,.webp" multiple style="display:none;" />
                </div>

                <!-- 실제 폼 제출에 쓰이는 input. 화면에는 안 보이고, JS가 내용만 채워 넣습니다 -->
                <input type="file" name="images" id="imagesInput" style="display:none;" multiple />

                <div class="image-grid" id="newImagePreview"></div>
            </div>
            <button type="submit" class="btn-block">저장</button>
        </form>
    </div>

</div>

<script>
const contentTextarea = document.getElementById('contentTextarea');
const contentCount = document.getElementById('contentCount');

function updateCount() {
    contentCount.textContent = contentTextarea.value.length + ' / 5000';
}

contentTextarea.addEventListener('input', updateCount);
updateCount(); // 수정 화면 진입 시 기존 글자 수 초기 표시

// 우리가 직접 관리하는 파일 목록 (브라우저 기본 input이 아니라 이 배열이 "진짜 상태"입니다)
let selectedFiles = [];

const dropzone = document.getElementById('dropzone');
const fileSelector = document.getElementById('fileSelector');
const imagesInput = document.getElementById('imagesInput');
const preview = document.getElementById('newImagePreview');

// 1) 드롭존 클릭 시 -> 숨겨진 파일 선택창 열기
dropzone.addEventListener('click', function () {
    fileSelector.click();
});

// 2) 파일 선택창에서 파일을 고른 경우
fileSelector.addEventListener('change', function (e) {
    addFiles(e.target.files);
    fileSelector.value = ''; // 같은 파일을 다시 선택해도 change 이벤트가 또 발생하도록 초기화
});

// 3) 드래그 앤 드롭 동작
dropzone.addEventListener('dragover', function (e) {
    e.preventDefault(); // 브라우저 기본 동작(파일을 열어버리는 것)을 막아야 드롭이 가능해짐
    dropzone.classList.add('dragover');
});

dropzone.addEventListener('dragleave', function () {
    dropzone.classList.remove('dragover');
});

dropzone.addEventListener('drop', function (e) {
    e.preventDefault();
    dropzone.classList.remove('dragover');
    addFiles(e.dataTransfer.files);
});

// 4) 새로 선택/드롭된 파일들을 우리 배열에 추가
function addFiles(fileList) {
    for (let i = 0; i < fileList.length; i++) {
        if (selectedFiles.length >= 5) {
            alert('이미지는 최대 5장까지 첨부할 수 있습니다.');
            break;
        }
        selectedFiles.push(fileList[i]);
    }
    renderPreview();
    syncToRealInput();
}

// 5) 배열 내용을 화면(미리보기 + 삭제버튼 + 대표선택)으로 그리기
function renderPreview() {
    preview.innerHTML = '';

    selectedFiles.forEach(function (file, index) {
        const reader = new FileReader();
        reader.onload = function (event) {
            const item = document.createElement('div');
            item.className = 'image-item';
            item.innerHTML =
                '<img src="' + event.target.result + '" />' +
                '<label><input type="radio" name="newThumbnailIndex" value="' + index + '" /> 대표</label>' +
                '<button type="button" class="remove-btn" data-index="' + index + '">삭제</button>';
            preview.appendChild(item);

            // 삭제 버튼 클릭 이벤트 연결
            item.querySelector('.remove-btn').addEventListener('click', function () {
                removeFile(index);
            });
        };
        reader.readAsDataURL(file);
    });
}

// 6) 배열에서 특정 파일 제거
function removeFile(index) {
    selectedFiles.splice(index, 1);
    renderPreview();
    syncToRealInput();
}

// 7) 배열 내용을 실제 <input type="file">에 반영 (서버 전송용)
function syncToRealInput() {
    const dataTransfer = new DataTransfer();
    selectedFiles.forEach(function (file) {
        dataTransfer.items.add(file);
    });
    imagesInput.files = dataTransfer.files;
}
</script>
</body>
</html>