<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결제 실패</title>
<style>
    body { font-family: 'Malgun Gothic', sans-serif; text-align: center; padding: 50px; }
    .fail-container { border: 1px solid #ffcfcf; padding: 30px; border-radius: 10px; display: inline-block; background-color: #fffafb; }
    .error-icon { font-size: 50px; color: #e74c3c; margin-bottom: 20px; }
    .error-msg { color: #c0392b; font-weight: bold; margin-bottom: 10px; }
    .error-code { color: #7f8c8d; font-size: 14px; }
    .btn-group { margin-top: 30px; }
    .btn { display: inline-block; padding: 10px 20px; text-decoration: none; border-radius: 5px; margin: 0 5px; }
    .btn-retry { background-color: #3182f6; color: white; }
    .btn-home { background-color: #eee; color: #333; }
</style>
</head>
<body>

    <div class="fail-container">
        <div class="error-icon">⚠</div>
        <h1>결제에 실패하였습니다</h1>
        
        <p class="error-msg">${param.message}</p>
        <p class="error-code">에러 코드: ${param.code}</p>

        <div class="btn-group">
            <a href="javascript:history.back();" class="btn btn-retry">다시 시도하기</a>
            <a href="${pageContext.request.contextPath}/testjg/test" class="btn btn-home">장바구니로 돌아가기</a>
        </div>
    </div>

</body>
</html>