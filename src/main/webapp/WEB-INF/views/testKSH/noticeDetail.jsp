<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <title>공지사항 상세보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .notice-content { min-height: 300px; border-top: 1px solid #eee; padding-top: 20px; }
        .info-bar { font-size: 0.9rem; color: #666; background: #f9f9f9; padding: 10px 15px; border-radius: 5px; }
    </style>
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="card shadow-sm">
        <div class="card-body p-5">
            <h2 class="fw-bold mb-3">${notice.title}</h2>
            
            <div class="info-bar d-flex justify-content-between mb-4">
                <div>
                    <span class="me-3"><strong>작성자:</strong> ${notice.displayRegId}</span>
                    <span><strong>등록일:</strong> ${notice.formattedRegDate}</span>
                </div>
                <div>
                    <span><strong>조회수:</strong> ${notice.viewCount}</span>
                </div>
            </div>

            <div class="notice-content mb-5">
                <c:out value="${notice.content}" escapeXml="false" />
            </div>

            <div class="mb-5">
                <h6 class="fw-bold"><i class="bi bi-paperclip"></i> 첨부파일</h6>
                <ul class="list-unstyled">
                    <%-- 실제 첨부파일 목록 출력 --%>
                    <c:forEach var="file" items="${files}">
                        <li>
                            <a href="/notice/download/${file.savedFileName}" class="text-decoration-none text-primary small">
                                📎 ${file.originName}
                            </a>
                        </li>
                    </c:forEach>
                    <c:if test="${empty files}">
                        <li class="text-muted small">첨부된 파일이 없습니다.</li>
                    </c:if>
                </ul>
            </div>
            <hr>

            <div class="d-flex justify-content-between mt-4">
                <button type="button" class="btn btn-outline-secondary" onclick="location.href='/notice'">목록으로</button>
                
                <sec:authorize access="hasRole('ADMIN')">
                    <div>
                        <button type="button" class="btn btn-warning me-2" onclick="location.href='/notice/edit/${notice.noticeId}'">수정</button>
                        <button type="button" class="btn btn-danger" onclick="deleteNotice(${notice.noticeId})">삭제</button>
                    </div>
                </sec:authorize>
            </div>
        </div>
    </div>
</div>

<script>
function deleteNotice(id) {
    if(confirm("정말 이 공지사항을 삭제하시겠습니까?")) {
        fetch('/notice/delete/' + id, { method: 'GET' }) // Controller 매핑에 맞춰 GET으로 변경
        .then(res => {
            if(res.ok) {
                alert("삭제되었습니다.");
                location.href = '/notice';
            } else {
                alert("삭제 권한이 없습니다.");
            }
        });
    }
}
</script>
</body>
</html>