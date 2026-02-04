<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>거래 내역서 미리보기</title>
<style>
    /* 3. 전체 요소에 폰트 강제 적용 */
    * { 
        font-family: 'NanumGothic', sans-serif !important; 
    }
    
    table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
    th { background-color: #f5f5f5; }
    .memo-box { border: 1px solid #ddd; padding: 10px; background-color: #fafafa; margin-top: 10px; }
    
    @media print {
        .no-print { display: none; }
    }
</style>
</head>
<body>

<h2>거래 내역서 미리보기</h2>

<table>
    <tr>
        <th>문서번호</th>
        <td>${doc.docNo}</td>
        <th>담당자</th>
        <td>${doc.userName}</td>
    </tr>
    <tr>
        <th>주문번호</th>
        <td>${doc.orderNo}</td>
        <th>주문상태</th>
        <td>${doc.orderStatus}</td>
    </tr>
</table>

<h3>장바구니 내역</h3>
<table>
    <thead>
        <tr>
            <th>상품명</th>
            <th>수량</th>
            <th>총금액</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="item" items="${doc.cartItems}">
            <tr>
                <td>${item.fuelName}</td>
                <td>${item.totalQty}</td>
                <td>${item.totalPrice}</td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<h3>특이사항</h3>
<div class="memo-box">
    <c:out value="${doc.memo}" default="없음"/>
</div>

<!-- PDF 변환 버튼 -->
<button class="no-print" onclick="exportPdf(${doc.docId})">다운로드</button>

<script>
function exportPdf(docId) {
	window.location.href = "${pageContext.request.contextPath}/document/exportPdf?docId=" + docId;
}
</script>

</body>
</html>
