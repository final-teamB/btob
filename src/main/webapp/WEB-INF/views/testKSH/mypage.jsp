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
        #searchAddrBtn { display: none; } /* 초기엔 숨김 */
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
		    <label class="form-label small">연락처</label>
		    <input type="tel" class="form-control editable" name="phone" value="${user.phone}" disabled required>
		</div>
        <div class="mb-3">
            <label class="form-label">직위</label>
            <input type="text" class="form-control editable" name="position" value="${user.position}" disabled>
        </div>
        <div class="mb-3">
            <label class="form-label">이메일 (ID)</label>
            <input type="email" class="form-control" name="email" value="${user.email}" readonly>
        </div>
        
        <div class="mb-3">
            <label class="form-label">주소</label>
            <div class="input-group">
                <input type="text" id="address" class="form-control editable" name="address" value="${user.address}" readonly disabled>
                <button type="button" id="searchAddrBtn" class="btn btn-secondary" onclick="execPostcode()">주소 검색</button>
            </div>
        </div>

        <div class="mt-4">
            <button type="button" id="editStartBtn" class="btn btn-primary w-100" onclick="toggleEditMode()">정보 수정하기</button>
            <div id="editActionBtns" style="display:none;" class="row g-2">
                <div class="col"><button type="button" class="btn btn-light w-100" onclick="location.reload()">취소</button></div>
                <div class="col"><button type="submit" class="btn btn-success w-100">저장하기</button></div>
            </div>
        </div>
    </form>
</div>
<a href="/main">메인으로</a>

<script>
    function toggleEditMode() {
        document.querySelectorAll('.editable').forEach(el => el.disabled = false);
        document.getElementById('editStartBtn').style.display = 'none';
        document.getElementById('editActionBtns').style.display = 'flex';
        document.getElementById('searchAddrBtn').style.display = 'inline-block';
    }

    function execPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                let addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
                document.getElementById("address").value = addr;
            }
        }).open();
    }
    
    function enableEdit() {
        // 모든 .editable 필드를 활성화 (disabled 제거)
        document.querySelectorAll('.editable').forEach(input => {
            input.disabled = false; // 이 코드가 있어야 서버로 값이 넘어갑니다.
        });
        
        // 주소창은 직접 타이핑 못하게 하려면 readonly로 유지
        document.getElementById("address").readOnly = true;
        
        document.getElementById('viewMode').style.display = 'none';
        document.getElementById('editMode').style.display = 'flex';
    }
</script>
</body>
</html>