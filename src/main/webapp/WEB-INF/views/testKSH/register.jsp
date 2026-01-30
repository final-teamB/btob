<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입 - BtoB 서비스</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <style>
        body { background-color: #f0f4f8; min-height: 100vh; padding: 40px 0; }
        .register-container { max-width: 600px; margin: auto; background: white; border-radius: 20px; padding: 30px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); }
        .section-title { font-size: 0.9rem; color: #4a90e2; font-weight: bold; margin-bottom: 15px; display: flex; align-items: center; margin-top: 20px; }
        .form-control { border-radius: 10px; padding: 12px; border: 1px solid #e1e5eb; }
        .btn-register { background-color: #3b5bdb; color: white; border: none; border-radius: 10px; padding: 12px; font-weight: bold; }
        .user-type-group { background: #f8f9fa; padding: 15px; border-radius: 10px; border: 1px solid #e1e5eb; }
    </style>
</head>
<body>
<div class="register-container">
    <form action="/register" method="post" id="registerForm" onsubmit="return validateForm()">
        <h3 class="fw-bold text-center mb-4">회원가입</h3>
        
        <div class="section-title"><i class="bi bi-shield-lock-fill"></i> 사용자 권한 설정 *</div>
        <div class="user-type-group mb-3 text-center">
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="userType" id="typeUser" value="USER" checked onclick="toggleBusinessNum(false)">
                <label class="form-check-label" for="typeUser">일반사용자</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="userType" id="typeMaster" value="MASTER" onclick="toggleBusinessNum(true)">
                <label class="form-check-label" for="typeMaster">대표</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="userType" id="typeAdmin" value="ADMIN" onclick="toggleBusinessNum(false)">
                <label class="form-check-label" for="typeAdmin">관리자</label>
            </div>
        </div>

        <div id="businessNumArea" style="display: none;" class="mb-3">
            <label class="form-label text-primary fw-bold">사업자 등록번호 *</label>
            <input type="text" class="form-control" name="businessNumber" placeholder="000-00-00000">
            <input type="hidden" name="isRepresentative" id="isRepresentative" value="N">
        </div>

        <div class="section-title"><i class="bi bi-person-plus-fill"></i> 계정 정보</div>
        <div class="mb-3">
            <label class="form-label">아이디 *</label>
            <input type="text" class="form-control" name="userId" placeholder="사용하실 아이디를 입력하세요" required>
        </div>
        <div class="row mb-3">
            <div class="col">
                <label class="form-label">비밀번호 *</label>
                <input type="password" class="form-control" name="password" id="password" required>
            </div>
            <div class="col">
                <label class="form-label">비밀번호 확인 *</label>
                <input type="password" class="form-control" id="passwordConfirm" required>
            </div>
        </div>
        
        <div class="mb-3">
            <label class="form-label">이름 *</label>
            <input type="text" class="form-control" name="userName" required>
        </div>
        
        <div class="mb-3">
            <label class="form-label">연락처 *</label>
            <input type="tel" class="form-control" name="phone" placeholder="010-0000-0000" required>
        </div>
        
        <div class="mb-3">
            <label class="form-label">직위 *</label>
            <input type="text" class="form-control" name="position" required>
        </div>

        <div class="mb-3">
            <label class="form-label">이메일 *</label>
            <input type="email" class="form-control" name="email" required>
        </div>

        <div class="mb-3">
            <label class="form-label">주소 *</label>
            <div class="input-group mb-2">
                <input type="text" class="form-control" id="postcode" name="postcode" placeholder="우편번호" readonly>
                <button class="btn btn-outline-secondary" type="button" onclick="execPostcode()">주소 찾기</button>
            </div>
            <input type="text" class="form-control mb-2" id="address" name="address" placeholder="기본 주소" readonly required>
            <input type="text" class="form-control" id="detailAddress" name="detailAddress" placeholder="상세 주소">
        </div>

        <button type="submit" class="btn btn-primary btn-register w-100 mt-4">회원가입</button>
    </form>
</div>

<script>
    // 주소 찾기 API [cite: 17, 18]
    function execPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                document.getElementById('postcode').value = data.zonecode;
                document.getElementById("address").value = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
                document.getElementById("detailAddress").focus();
            }
        }).open();
    }

    // 대표자 선택 시 사업자번호 필드 제어
    function toggleBusinessNum(show) {
        const area = document.getElementById('businessNumArea');
        const isRep = document.getElementById('isRepresentative');
        const bizInput = area.querySelector('input[name="businessNumber"]');
        
        if (show) {
            area.style.display = 'block'; // 입력창 표시
            isRep.value = 'Y';            // 대표자 여부 'Y' 설정
            bizInput.required = true;     // 필수 입력 설정
        } else {
            area.style.display = 'none';  // 입력창 숨김
            isRep.value = 'N';            // 대표자 여부 'N' 설정
            bizInput.required = false;    // 필수 입력 해제
            bizInput.value = '';          // 값 초기화
        }
    }

    // 비밀번호 일치 확인 및 폼 검증 [cite: 19, 20]
    function validateForm() {
        const pw = document.getElementById('password').value;
        const pwConfirm = document.getElementById('passwordConfirm').value;
        
        if(pw !== pwConfirm) {
            alert("비밀번호가 일치하지 않습니다.");
            return false;
        }
        return true;
    }
</script>
</body>
</html>