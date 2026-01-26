<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>BtoB 서비스 - 로그인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; display: flex; align-items: center; height: 100vh; }
        .login-form { width: 100%; max-width: 400px; padding: 15px; margin: auto; }
    </style>
</head>
<body>

<main class="login-form">
    <div class="card shadow">
        <div class="card-body">
            <h3 class="card-title text-center mb-4">BtoB 로그인</h3>
            
            <c:if test="${param.error != null}">
                <div class="alert alert-danger">
                    이메일 또는 비밀번호가 일치하지 않습니다.
                </div>
            </c:if>

            <form action="/login" method="post">
                <div class="mb-3">
				    <label for="username" class="form-label">이메일 (ID)</label>
				    <input type="email" class="form-control" id="username" name="email" required placeholder="name@example.com">
				</div>
                <div class="mb-3">
                    <label for="password" class="form-label">비밀번호</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
                
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <button class="btn btn-primary w-100" type="submit">로그인</button>
            </form>
            
            <div class="mt-3 text-center">
            	<small><a href="/">아이디 찾기</a></small> | 
            	<small><a href="/">비밀번호 찾기</a></small> | 
                <small><a href="/register">회원가입</a></small>
            </div>
        </div>
    </div>
</main>
</body>
</html>