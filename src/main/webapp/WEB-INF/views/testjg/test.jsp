<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="mx-4 my-6 space-y-6">

    <h1 class="text-2xl font-bold text-gray-900 dark:text-white">테스트 페이지</h1>

    <!-- 데이터 그리드 섹션 -->
    <section class="p-4 bg-white rounded-lg shadow-sm dark:bg-gray-800 border dark:border-gray-700">
        <h2 class="text-lg font-semibold mb-4 text-gray-900 dark:text-white">장바구니 상품 목록</h2>
        <div id="grid"></div>
    </section>

    <div class="flex space-x-2 mt-4">
        <button class="btn btn-secondary" onclick="location.href='${pageContext.request.contextPath}/testjg/pdf'">PDF 보기</button>
        <button class="btn btn-primary" id="payPageBtn">결제하기</button>
    </div>

    <!-- 성공/실패 메시지 -->
    <c:if test="${not empty msg}">
        <div class="p-4 bg-green-100 text-green-800 rounded-lg mt-4">${msg}</div>
    </c:if>
    <c:if test="${not empty failList}">
        <div class="p-4 bg-red-100 text-red-800 rounded-lg mt-4">
            실패한 항목:
            <ul>
                <c:forEach var="item" items="${failList}">
                    <li>${item}</li>
                </c:forEach>
            </ul>
        </div>
    </c:if>

    <!-- 파일 업로드 섹션 -->
    <section class="p-4 bg-white rounded-lg shadow-sm dark:bg-gray-800 border dark:border-gray-700 mt-4">
        <h2 class="text-lg font-semibold mb-2 text-gray-900 dark:text-white">사원 데이터 업로드</h2>
        <form action="${pageContext.request.contextPath}/testjg/test" method="post" enctype="multipart/form-data" class="flex gap-2">
            <input type="file" name="file" accept=".xlsx,.xls" class="border rounded-lg p-2 flex-1"/>
            <button type="submit" class="btn btn-primary">업로드</button>
        </form>
    </section>
</div>

<script>
    const data = [
        { id: 1, name: "상품A", qty: 10, price: 10000 },
        { id: 2, name: "상품B", qty: 5, price: 5000 },
        { id: 3, name: "상품C", qty: 8, price: 8000 },
    ];

    const grid = new tui.Grid({
        el: document.getElementById('grid'),
        data: data,
        rowHeaders: ['checkbox'],
        columns: [
            { header: 'ID', name: 'id', width: 50, sortable: true },
            { header: '상품명', name: 'name', width: 150 },
            { header: '수량', name: 'qty', width: 80 },
            { header: '단가', name: 'price', width: 100 },
            { header: '총액', name: 'total', width: 120,
              formatter: item => (item.row.qty * item.row.price).toLocaleString() + '원'
            }
        ]
    });

    document.getElementById("payPageBtn").addEventListener("click", () => {
        const selectedRows = grid.getCheckedRows();
        if (!selectedRows.length) { alert("상품을 선택하세요."); return; }

        const cleanData = selectedRows.map(row => ({ id: row.id, name: row.name, qty: row.qty, price: row.price }));
        sessionStorage.setItem("selectedItems", JSON.stringify(cleanData));
        location.href = "${pageContext.request.contextPath}/testjg/payment";
    });
</script>
