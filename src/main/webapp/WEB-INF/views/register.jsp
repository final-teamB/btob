<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입 - BtoB 서비스</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f0f4f8; min-height: 100vh; padding: 40px 0; }
        .register-container { max-width: 600px; margin: auto; background: white; border-radius: 20px; padding: 30px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); }
        .section-title { font-size: 0.9rem; color: #4a90e2; font-weight: bold; margin-bottom: 15px; display: flex; align-items: center; }
        .section-title i { margin-right: 8px; }
        .form-label { font-size: 0.85rem; font-weight: 600; color: #333; }
        .form-control { border-radius: 10px; padding: 12px; border: 1px solid #e1e5eb; margin-bottom: 5px; }
        .btn-register { background-color: #3b5bdb; border: none; border-radius: 10px; padding: 12px; font-weight: bold; }
        .btn-cancel { border-radius: 10px; padding: 12px; border: 1px solid #e1e5eb; background: white; color: #666; }
        .header-logo { text-align: center; margin-bottom: 20px; }
        .header-logo i { font-size: 2.5rem; color: #3b5bdb; }
    </style>
</head>
<body>

<div class="register-container">
    <a href="/login" class="text-decoration-none text-muted mb-4 d-inline-block small">
        <i class="bi bi-arrow-left"></i> 로그인으로 돌아가기
    </a>

    <div class="header-logo">
        <div class="mb-2"><i class="bi bi-building-fill"></i></div>
        <h3 class="fw-bold">회원가입</h3>
        <p class="text-muted small">기업 회원 정보를 입력해주세요</p>
    </div>

    <form action="/register" method="post" id="registerForm">
        <div class="section-title"><i class="bi bi-person-plus-fill"></i> 계정 정보</div>
        <div class="mb-3">
            <label class="form-label">아이디 *</label>
            <input type="text" class="form-control" name="userId" placeholder="아이디를 입력하세요" required>
        </div>
        <div class="row mb-3">
            <div class="col">
                <label class="form-label">비밀번호 *</label>
                <input type="password" class="form-control" name="password" id="password" placeholder="비밀번호" required>
            </div>
            <div class="col">
                <label class="form-label">비밀번호 확인 *</label>
                <input type="password" class="form-control" id="passwordConfirm" placeholder="비밀번호 확인" required>
            </div>
        </div>

        <div class="section-title mt-4"><i class="bi bi-info-circle-fill"></i> 개인 정보</div>
        <div class="row mb-3">
            <div class="col">
                <label class="form-label">이름 *</label>
                <input type="text" class="form-control" name="userName" placeholder="이름" required>
            </div>
            <div class="col">
                <label class="form-label">직위 *</label>
                <input type="text" class="form-control" name="position" placeholder="직위" required>
            </div>
        </div>
        <div class="mb-3">
            <label class="form-label">이메일 *</label>
            <input type="email" class="form-control" name="email" placeholder="example@company.com" required>
        </div>
        <div class="mb-3">
            <label class="form-label">연락처 *</label>
            <input type="tel" class="form-control" name="phone" placeholder="010-1234-5678" required>
        </div>
        <div class="mb-3">
            <label class="form-label">주소 *</label>
            <input type="text" class="form-control" name="address" placeholder="회사 주소를 입력하세요" required>
        </div>

        <div class="section-title mt-4"><i class="bi bi-briefcase-fill"></i> 기업 정보</div>
        <div class="form-check p-3 mb-3" style="background-color: #eef4ff; border-radius: 10px;">
            <input class="form-check-input ms-1" type="checkbox" name="isRepresentative" id="isRep" value="Y">
            <label class="form-check-label ms-2 small fw-bold" for="isRep">
                대표자입니다 (사업자등록번호 입력)
            </label>
        </div>
        
        <div id="bizNumDiv" class="mb-4" style="display: none;">
            <label class="form-label">사업자등록번호 *</label>
            <input type="text" class="form-control" name="businessNumber" placeholder="123-45-67890">
        </div>

        <div class="row g-2">
            <div class="col">
                <button type="button" class="btn btn-cancel w-100" onclick="history.back()">취소</button>
            </div>
            <div class="col">
                <button type="submit" class="btn btn-primary btn-register w-100">회원가입</button>
            </div>
        </div>
    </form>
</div>

<script>
    // 대표자 체크박스 로직
    document.getElementById('isRep').addEventListener('change', function() {
        const bizNumDiv = document.getElementById('bizNumDiv');
        bizNumDiv.style.display = this.checked ? 'block' : 'none';
    });

    // 비밀번호 확인 검사
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        const pw = document.getElementById('password').value;
        const pwConfirm = document.getElementById('passwordConfirm').value;
        if (pw !== pwConfirm) {
            alert('비밀번호가 일치하지 않습니다.');
            e.preventDefault();
        }
    });
</script>
</body>
</html>
