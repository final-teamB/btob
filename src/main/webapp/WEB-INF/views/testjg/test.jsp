<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>테스트 페이지 - 장바구니</title>

<!-- Toast UI Grid -->
<link rel="stylesheet" href="https://uicdn.toast.com/tui-grid/latest/tui-grid.min.css">
<script src="https://uicdn.toast.com/tui-grid/latest/tui-grid.min.js"></script>


<style>
    body { font-family: Arial; padding: 20px; }
    .grid-wrapper { margin-top: 20px; }
    button { margin-top: 10px; margin-right: 10px; }
</style>
</head>
<body>
<h1>장바구니 테스트 페이지</h1>

<div class="grid-wrapper">
    <div id="grid"></div>
</div>

<a href="${pageContext.request.contextPath}/testjg/pdf">pdf</a>
<button id="payPageBtn">결제하기</button>

<form action="${pageContext.request.contextPath}/testjg/test" method="post" enctype="multipart/form-data">
    <input type="file" name="file" accept=".xlsx,.xls"/>
    <button type="submit">사원 업로드</button>
</form>

<!-- 성공 메시지 -->
<c:if test="${not empty msg}">
    <p class="success">${msg}</p>
</c:if>

<!-- 실패 리스트 -->
<c:if test="${not empty failList}">
    <p class="fail">실패한 항목 목록:</p>
    <table>
        <tr>
            <th>항목</th>
        </tr>
        <c:forEach var="item" items="${failList}">
            <tr>
                <td>${item}</td>
            </tr>
        </c:forEach>
    </table>
</c:if>

<script>
// 샘플 데이터 및 그리드 설정은 기존과 동일
const data = [
    { id: 1, name: "상품A", qty: 10, price: 10000 },
    { id: 2, name: "상품B", qty: 5, price: 5000 },
    { id: 3, name: "상품C", qty: 8, price: 8000 }
];

const grid = new tui.Grid({
    el: document.getElementById('grid'),
    data: data,
    scrollX: false,
    scrollY: false,
    rowHeaders: ['checkbox'],
    columns: [
        { header: 'ID', name: 'id', width: 50 },
        { header: '상품명', name: 'name', width: 150 },
        { header: '수량', name: 'qty', width: 80 },
        { header: '단가', name: 'price', width: 100 },
        { header: '총액', name: 'total', width: 120,
          formatter: function(item) { return item.row.qty * item.row.price; } }
    ]
});

//[test.jsp의 결제하기 버튼 이벤트]
document.getElementById("payPageBtn").addEventListener("click", () => {
    const selectedRows = grid.getCheckedRows();
    if (selectedRows.length === 0) return alert("상품을 선택하세요.");

    // [중요] 그리드 전용 속성을 제외하고 딱 필요한 데이터만 추출
    const cleanData = selectedRows.map(row => ({
        id: row.id,
        name: row.name,
        qty: row.qty,
        price: row.price
    }));

    // 가공된 깨끗한 데이터를 저장
    sessionStorage.setItem("selectedItems", JSON.stringify(cleanData));
    
    location.href = "${pageContext.request.contextPath}/testjg/payment";
});
</script>
</body>
</html>
