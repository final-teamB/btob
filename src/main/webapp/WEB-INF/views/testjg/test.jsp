<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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

<button id="pdfBtn">선택 상품 PDF 생성</button>
<button id="tossBtn">선택 상품 토스 결제 테스트</button>
<button id="kakaoBtn">선택 상품 카카오 결제 테스트</button>

<form action="${pageContext.request.contextPath}/test/test" method="post" enctype="multipart/form-data">
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
    // 샘플 데이터
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

    function getSelectedRows() {
        return grid.getCheckedRows();
    }

    function postSelected(url) {
        const selected = getSelectedRows();
        if (selected.length === 0) {
            alert("선택된 상품이 없습니다.");
            return;
        }
        fetch(url, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(selected)
        })
        .then(res => res.text())
        .then(msg => alert(msg))
        .catch(err => alert("실패: " + err));
    }

    document.getElementById("pdfBtn").addEventListener("click", () => {
        postSelected("${pageContext.request.contextPath}/test/pdf");
    });

    document.getElementById("tossBtn").addEventListener("click", () => {
        postSelected("${pageContext.request.contextPath}/test/toss");
    });

    document.getElementById("kakaoBtn").addEventListener("click", () => {
        postSelected("${pageContext.request.contextPath}/test/kakao");
    });
</script>
</body>
</html>
