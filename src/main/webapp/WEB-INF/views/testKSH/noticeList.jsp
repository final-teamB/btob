<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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
        
        <%-- 관리자(ADMIN) 권한이 있는 경우에만 등록 버튼 노출 --%>
        <sec:authorize access="hasRole('ADMIN')">
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#writeModal">공지 등록</button>
        </sec:authorize>
    </div>

    <div class="card mb-4">
        <div class="card-body">
            <form action="/notice" method="get" class="row g-3">
                <div class="col-md-10">
                    <input type="text" name="keyword" class="form-control" placeholder="검색어를 입력하세요" value="${param.keyword}">
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-secondary w-100">검색</button>
                </div>
            </form>
        </div>
    </div>

    <div class="table-responsive bg-white rounded shadow-sm">
        <table class="table table-hover mb-0">
            <thead class="table-light">
                <tr>
                    <th style="width: 80px;" class="text-center">번호</th>
                    <th>제목</th>
                    <th style="width: 120px;">작성자</th>
                    <th style="width: 150px;">등록일</th>
                    <th style="width: 100px;">조회수</th>
                </tr>
            </thead>
			<tbody>
			    <c:forEach var="item" items="${noticeList}">
			    <%-- 경로를 /notice/detail/${item.noticeId} 로 수정하여 컨트롤러와 맞춤 --%>
			    <tr style="cursor: pointer;" onclick="location.href='/notice/detail/${item.noticeId}'">
			        <td class="text-center">${item.noticeId}</td>
			        <td class="fw-bold">${item.title}</td>
			        <td>${item.displayRegId}</td>
			        <td>${item.formattedRegDate}</td>
			        <td>${item.viewCount}</td>
			    </tr>
			    </c:forEach>
			    <c:if test="${empty noticeList}">
			    <tr>
			        <td colspan="5" class="text-center py-5 text-muted">등록된 공지사항이 없습니다.</td>
			    </tr>
			    </c:if>
			</tbody>
        </table>
    </div>
</div>

<div class="container text-center mt-3">
    <a href="/main" class="btn btn-link text-decoration-none text-secondary">메인으로 돌아가기</a>
</div>

<sec:authorize access="hasRole('ADMIN')">
<div class="modal fade" id="writeModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <form action="/notice/write" method="post" enctype="multipart/form-data">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">공지사항 작성</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold">제목</label>
                        <input type="text" name="title" class="form-control" placeholder="제목을 입력하세요" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">내용</label>
                        <textarea name="content" id="editor"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">첨부파일</label>
                        <input type="file" name="files" class="form-control" multiple>
                        <div class="form-text">여러 파일을 선택할 수 있습니다.</div>
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
</sec:authorize>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    if (document.querySelector('#editor')) {
        ClassicEditor.create(document.querySelector('#editor')).catch(error => { console.error(error); });
    }
</script>
</body>
</html>