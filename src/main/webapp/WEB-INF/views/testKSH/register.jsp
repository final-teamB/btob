<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        .section-title { font-size: 0.9rem; color: #4a90e2; font-weight: bold; margin-bottom: 15px; display: flex; align-items: center; }
        .form-control { border-radius: 10px; padding: 12px; border: 1px solid #e1e5eb; }
        .btn-register { background-color: #3b5bdb; color: white; border: none; border-radius: 10px; padding: 12px; font-weight: bold; }
    </style>
</head>
<body>
<div class="register-container">
    <form action="/register" method="post" id="registerForm">
        <h3 class="fw-bold text-center mb-4">회원가입</h3>
        <div class="section-title"><i class="bi bi-person-plus-fill"></i> 계정 정보</div>
        <div class="mb-3">
            <label class="form-label">아이디 *</label>
            <input type="text" class="form-control" name="userId" required>
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
            <input type="text" class="form-control" name="position" value="${user.position}" required>
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
    function execPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                document.getElementById('postcode').value = data.zonecode;
                document.getElementById("address").value = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
                document.getElementById("detailAddress").focus();
            }
        }).open();
    }
</script>
</body>
</html>