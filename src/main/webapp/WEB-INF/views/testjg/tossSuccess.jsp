<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결제 완료</title>
<style>
    body { font-family: 'Malgun Gothic', sans-serif; text-align: center; padding: 50px; }
    .success-container { border: 1px solid #ddd; padding: 30px; border-radius: 10px; display: inline-block; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
    .check-icon { font-size: 50px; color: #2ecc71; margin-bottom: 20px; }
    .info-table { margin: 20px auto; text-align: left; border-collapse: collapse; }
    .info-table th, .info-table td { padding: 10px; border-bottom: 1px solid #eee; }
    .btn { display: inline-block; padding: 10px 20px; background-color: #3182f6; color: white; text-decoration: none; border-radius: 5px; margin-top: 20px; }
</style>
</head>
<body>

    <div class="success-container">
        <div class="check-icon">✔</div>
        <h1>결제가 완료되었습니다!</h1>
        <p>${msg}</p> <table class="info-table">
            <tr>
                <th>주문번호</th>
                <td>${orderId}</td>
            </tr>
            <tr>
                <th>결제 금액</th>
                <td><strong>${amount}원</strong></td>
            </tr>
        </table>
		
		<c:if test="${not empty accountInfo}">
		    <div style="border: 2px solid blue; padding: 20px;">
		        <h3>입금 대기 안내</h3>
		        <p>은행 및 계좌번호: <strong>${accountInfo}</strong></p>
		        <p>입금하실 금액: <strong>${amount}원</strong></p>
		        <p>입금 기한: <strong>${dueDate}</strong> 까지</p>
		    </div>
		</c:if>
		
        <a href="${pageContext.request.contextPath}/testjg/test" class="btn">다시 쇼핑하러 가기</a>
    </div>

</body>
</html>