<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>공지사항</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/classic/ckeditor.js"></script>
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">공지사항</h2>
        <c:if test="${userRole == 'ADMIN'}">
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#writeModal">공지 등록</button>
        </c:if>
    </div>

    <div class="card mb-4">
        <div class="card-body">
            <form action="/notice" method="get" class="row g-3">
                <div class="col-md-10">
                    <input type="text" name="keyword" class="form-control" placeholder="제목으로 검색하세요" value="${param.keyword}">
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-dark w-100">검색</button>
                </div>
            </form>
        </div>
    </div>

    <div class="table-responsive bg-white rounded shadow-sm">
        <table class="table table-hover mb-0">
            <thead class="table-light">
                <tr>
                    <th width="80" class="text-center">번호</th>
                    <th class="text-center">제목</th>
                    <th width="120">작성자</th>
                    <th width="150">등록일</th>
                    <th width="80">조회</th>
                </tr>
            </thead>
            <tbody>
			    <c:forEach var="item" items="${notices}">
			    <tr style="cursor:pointer;" onclick="location.href='/notice/${item.noticeId}'">
			        <td class="text-center">${item.noticeId}</td>
			        <td class="text-center">${item.title}</td>
			        
			        <td>${item.displayRegId}</td> 
			        
			        <td>${item.formattedRegDate}</td>
			        <td>${item.viewCount}</td>
			    </tr>
			    </c:forEach>
			</tbody>
        </table>
    </div>
</div>

<a href="/main">메인으로</a>

<div class="modal fade" id="writeModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <form action="/notice/write" method="post" enctype="multipart/form-data">
            <div class="modal-content">
                <div class="modal-header"><h5>공지사항 작성</h5></div>
                <div class="modal-body">
                    <input type="text" name="title" class="form-control mb-3" placeholder="제목을 입력하세요" required>
                    <textarea name="content" id="editor"></textarea> <div class="mt-3">
                        <label class="form-label">첨부파일</label>
                        <input type="file" name="files" class="form-control" multiple>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="submit" class="btn btn-primary">저장하기</button>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
    // CKEditor 초기화
    ClassicEditor.create(document.querySelector('#editor')).catch(error => { console.error(error); });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>