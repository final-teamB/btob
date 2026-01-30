<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>공지사항 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/classic/ckeditor.js"></script>
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="card shadow-sm">
        <div class="card-body p-5">
            <h3 class="fw-bold mb-4">공지사항 수정</h3>
            <form action="/notice/update" method="post">
                <input type="hidden" name="noticeId" value="${notice.noticeId}">
                
                <div class="mb-3">
                    <label class="form-label fw-bold">제목</label>
                    <input type="text" name="title" class="form-control" value="${notice.title}" required>
                </div>
                
                <div class="mb-3">
                    <label class="form-label fw-bold">내용</label>
                    <textarea name="content" id="editor">${notice.content}</textarea>
                </div>

                <div class="text-end mt-4">
                    <button type="button" class="btn btn-secondary me-2" onclick="history.back()">취소</button>
                    <button type="submit" class="btn btn-primary">수정완료</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    ClassicEditor.create(document.querySelector('#editor'))
        .catch(error => { console.error(error); });
</script>
</body>
</html>