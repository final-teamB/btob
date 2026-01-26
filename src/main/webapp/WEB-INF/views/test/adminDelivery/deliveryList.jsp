<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>배송 관리 시스템</title>
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; border: 1px solid #ccc; text-align: center; }
        th { background-color: #f4f4f4; }
        .btn-save { padding: 5px 10px; cursor: pointer; background-color: #4CAF50; color: white; border: none; border-radius: 3px; }
    </style>
</head>
<body>
    <h2>배송 관리 (Admin)</h2>
    
    <table>
        <thead>
            <tr>
                <th>배송번호</th>
                <th>주문번호</th>
                <th>상태 코드</th> <th>배송 상태(수정)</th> <th>운송장 번호</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>
		    <c:forEach var="item" items="${deliveryList}">
		        <tr id="row-${item.deliveryId}">
		            <td>${item.deliveryId}</td>
		            <td>${item.orderId}</td>
		            <td>
		                <strong>${item.statusName}</strong><br>
		                <small style="color:gray;">(${item.deliveryStatus})</small>
		            </td>
		            <td>
		                <select id="status-${item.deliveryId}">
		                    <option value="READY" ${item.deliveryStatus == 'READY' ? 'selected' : ''}>상품준비중</option>
		                    <option value="L_SHIPPING" ${item.deliveryStatus == 'L_SHIPPING' ? 'selected' : ''}>국내배송중</option>
		                    <option value="L_WH" ${item.deliveryStatus == 'L_WH' ? 'selected' : ''}>국내창고입고</option>
		                    <option value="ABROAD" ${item.deliveryStatus == 'ABROAD' ? 'selected' : ''}>국제운송중</option>
		                    <option value="IN_CUSTOMS" ${item.deliveryStatus == 'IN_CUSTOMS' ? 'selected' : ''}>통관진행중</option>
		                    <option value="C_DONE" ${item.deliveryStatus == 'C_DONE' ? 'selected' : ''}>통관완료</option>
		                    <option value="D_SHIPPING" ${item.deliveryStatus == 'D_SHIPPING' ? 'selected' : ''}>배송중</option>
		                    <option value="COMPLETE" ${item.deliveryStatus == 'COMPLETE' ? 'selected' : ''}>배송완료</option>
		                </select>
		            </td>
		            <td>
		                <input type="text" id="tracking-${item.deliveryId}" value="${item.trackingNo}" placeholder="송장번호 입력">
		            </td>
		            <td>
		                <button type="button" class="btn-save" onclick="updateDelivery('${item.deliveryId}')">저장</button>
		            </td>
		        </tr>
		    </c:forEach>
		</tbody>
    </table>

    <script>
        function updateDelivery(id) {
            const trackingNo = document.getElementById('tracking-' + id).value;
            const status = document.getElementById('status-' + id).value; // 선택된 Enum 코드값

            const data = {
                deliveryId: id,
                trackingNo: trackingNo,
                deliveryStatus: status // DTO의 DeliveryStatus 필드로 매핑됨
            };

            fetch('/admin/delivery/deliveryUpdate', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            })
            .then(response => response.text())
            .then(result => {
                if(result === "성공") {
                    alert("배송 정보(상태/송장)가 수정되었습니다.");
                    location.reload(); // 변경된 한글 상태를 다시 불러오기 위해 새로고침
                } else {
                    alert("수정 실패!");
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert("오류가 발생했습니다.");
            });
        }
    </script>
</body>
</html>