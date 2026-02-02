<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>마이페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <style>
        .editable:disabled { background-color: #f8f9fa; border: 1px solid transparent; border-bottom: 1px solid #dee2e6; }
        #searchAddrBtn { display: none; }
    </style>
</head>
<body>
<div class="container mt-5" style="max-width: 600px;">
    <h3 class="mb-4">내 정보 수정</h3>
    <form action="/mypage/update" method="post">
        <div class="mb-3">
            <label class="form-label">이름</label>
            <input type="text" class="form-control editable" name="userName" value="${user.userName}" disabled>
        </div>
        
        <div class="mb-3">
            <label class="form-label">이메일</label>
            <input type="email" class="form-control" value="${user.email}" disabled>
            <input type="hidden" name="email" value="${user.email}">
        </div>

        <div class="mb-3">
            <label class="form-label">연락처</label>
            <input type="tel" class="form-control editable" name="phone" value="${user.phone}" disabled>
        </div>

        <div class="mb-3">
            <label class="form-label">직위</label>
            <input type="text" class="form-control editable" name="position" value="${user.position}" disabled>
        </div>

        <div class="mb-3">
            <label class="form-label">주소</label>
            <div class="input-group mb-2">
                <input type="text" class="form-control" id="postcode" name="postcode" value="${user.postcode}" readonly>
                <button type="button" id="searchAddrBtn" class="btn btn-outline-secondary" onclick="execPostcode()">주소 찾기</button>
            </div>
            <input type="text" class="form-control mb-2" id="address" name="address" value="${user.address}" readonly>
            <input type="text" class="form-control editable" name="detailAddress" value="${user.detailAddress}" placeholder="상세주소" disabled>
        </div>

        <c:if test="${user.userType == 'MASTER'}">
        <div class="mb-3 p-3 bg-light rounded border">
            <label class="form-label fw-bold text-primary">사업자 등록번호</label>
            <input type="text" class="form-control editable" name="businessNumber" value="${user.businessNumber}" placeholder="000-00-00000" disabled>
            <input type="hidden" name="isRepresentative" value="Y">
        </div>
        </c:if>

        <hr class="my-4">

        <div id="viewMode">
            <button type="button" class="btn btn-primary w-100" onclick="enableEdit()">수정하기</button>
        </div>

        <div id="editMode" style="display: none;">
            <div class="row g-2">
                <div class="col"><button type="button" class="btn btn-light w-100" onclick="location.reload()">취소</button></div>
                <div class="col"><button type="submit" class="btn btn-success w-100">저장하기</button></div>
            </div>
        </div>
    </form>
</div>
<div class="text-center mt-3">
    <a href="/main" class="text-secondary text-decoration-none small">메인으로 돌아가기</a>
</div>

<script>
    function enableEdit() {
        // 모든 .editable 필드를 활성화
        document.querySelectorAll('.editable').forEach(input => {
            input.disabled = false;
        });
        
        // 버튼 영역 전환
        document.getElementById('viewMode').style.display = 'none';
        document.getElementById('editMode').style.display = 'block';
        document.getElementById('searchAddrBtn').style.display = 'inline-block';
    }

    function execPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                let addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
                document.getElementById("postcode").value = data.zonecode;
                document.getElementById("address").value = addr;
            }
        }).open();
    }
</script>
</body>
</html>