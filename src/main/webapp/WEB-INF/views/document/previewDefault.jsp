<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문서 미리보기 오류</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background: #f5f5f5;
    }
    .error-box {
        width: 600px;
        margin: 100px auto;
        background: #fff;
        border: 1px solid #ddd;
        padding: 40px;
        text-align: center;
        box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }
    .error-box h2 {
        color: #d9534f;
        margin-bottom: 20px;
    }
    .error-box p {
        color: #555;
        line-height: 1.6;
    }
    .error-box button {
        margin-top: 30px;
        padding: 10px 20px;
        border: none;
        background: #444;
        color: #fff;
        cursor: pointer;
    }
    .error-box button:hover {
        background: #222;
    }
</style>
</head>
<body>

<div class="error-box">
    <h2>문서 미리보기 불가</h2>

    <p>
        해당 문서는 미리보기를 지원하지 않거나<br>
        문서 유형이 올바르지 않습니다.
    </p>

    <p>
        문제가 계속 발생하면 관리자에게 문의해주세요.
    </p>

    <button onclick="window.close()">창 닫기</button>
</div>

</body>
</html>
