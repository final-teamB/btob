<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <title>자주 묻는 질문</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .faq-question { cursor: pointer; transition: background 0.2s; }
        .faq-question:hover { background-color: #f8f9fa; }
        .faq-answer { display: none; background-color: #fcfcfc; }
        .category-badge { font-size: 0.75rem; vertical-align: middle; }
    </style>
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">자주 묻는 질문 (FAQ)</h2>
        <sec:authorize access="hasRole('ADMIN')">
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#faqModal">FAQ 등록</button>
        </sec:authorize>
    </div>

    <div class="list-group shadow-sm">
        <c:forEach items="${faqList}" var="faq">
            <div class="faq-item border-bottom bg-white">
                <div class="faq-question p-4 d-flex justify-content-between align-items-center" onclick="toggleAnswer(this)">
                    <div>
                        <span class="badge bg-secondary category-badge me-2">${faq.category.label}</span>
                        <span class="fw-medium">Q. ${faq.question}</span>
                    </div>
                    <span class="text-muted small">▼</span>
                </div>
                <div class="faq-answer p-4 border-top">
                    <div class="d-flex">
                        <span class="text-danger fw-bold me-2">A.</span>
                        <div class="text-secondary">${faq.answer}</div>
                    </div>
                    <sec:authorize access="hasRole('ADMIN')">
                        <div class="text-end mt-2">
                            <a href="/faq/delete/${faq.faqId}" class="text-danger small text-decoration-none" onclick="return confirm('삭제하시겠습니까?')">삭제</a>
                        </div>
                    </sec:authorize>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty faqList}">
            <div class="p-5 text-center bg-white">등록된 FAQ가 없습니다.</div>
        </c:if>
    </div>
</div>

<sec:authorize access="hasRole('ADMIN')">
<div class="modal fade" id="faqModal" tabindex="-1">
    <div class="modal-dialog">
        <form action="/faq/write" method="post" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">새 FAQ 등록</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">카테고리</label>
                    <select name="category" class="form-select">
                        <c:forEach items="${categories}" var="cat">
                            <option value="${cat}">${cat.label}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">질문</label>
                    <input type="text" name="question" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">답변</label>
                    <textarea name="answer" class="form-control" rows="5" required></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="submit" class="btn btn-primary">등록하기</button>
            </div>
        </form>
    </div>
</div>
</sec:authorize>

<div>
    <a href="/main">메인으로 돌아가기</a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleAnswer(element) {
        const answerDiv = element.nextElementSibling;
        const arrow = element.querySelector('.text-muted');
        
        if (answerDiv.style.display === 'block') {
            answerDiv.style.display = 'none';
            arrow.innerText = '▼';
        } else {
            answerDiv.style.display = 'block';
            arrow.innerText = '▲';
        }
    }
</script>
</body>
</html>