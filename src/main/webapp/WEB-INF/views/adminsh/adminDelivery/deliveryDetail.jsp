<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>배송 상세 관리</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <h2>배송 상세 정보 수정</h2>
    <form id="detailForm">
        <input type="hidden" id="deliveryId" value="${deliveryDTO.deliveryId}">
        
        <table border="1">
            <tr>
                <th>배송번호</th><td>${deliveryDTO.deliveryId}</td>
                <th>주문일시</th><td>${deliveryDTO.regDtime}</td>
                <th>주문번호</th><td>${deliveryDTO.orderId}</td>
            </tr>
            <tr>
                <th>배송상태</th>
                <td>
                    <select id="deliveryStatus">
				        <c:forEach var="status" items="${statusList}">
				            <option value="${status}" ${deliveryDTO.deliveryStatus == status ? 'selected' : ''}>
				                ${status.description}
				            </option>
				        </c:forEach>
				    </select>
                </td>
                <th>운송장번호</th>
                <td><input type="text" id="trackingNo" value="${deliveryDTO.trackingNo}"></td>
            </tr>
            <tr>
                <th>택배사</th>
                <td><input type="text" id="carrierName" value="${deliveryDTO.carrierName}"></td>
                <th>수령인 주소</th>
                <td><input type="text" id="shipToAddr" value="${deliveryDTO.shipToAddr}"></td>
            </tr>
        </table>
        
        <div style="margin-top:20px;">
            <button type="button" onclick="fn_update()">수정 저장</button>
            <button type="button" onclick="fn_delete()" style="color:red;">비활성화(삭제)</button>
            <button type="button" onclick="location.href='/admin/delivery/list'">목록으로</button>
        </div>
    </form>

    <script>
        // 수정 처리
        function fn_update() {
            if(!confirm("수정하시겠습니까?")) return;

            const param = {
                deliveryId: $("#deliveryId").val(),
                deliveryStatus: $("#deliveryStatus").val(),
                trackingNo: $("#trackingNo").val(),
                carrierName: $("#carrierName").val(),
                shipToAddr: $("#shipToAddr").val()
            };

            $.ajax({
                url: "/admin/delivery/updateDeliveryDetail",
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(param),
                success: function(res) {
                    alert(res.message);
                    if(res.success) location.reload();
                }
            });
        }

        // 삭제 처리
        function fn_delete() {
            if(!confirm("이 데이터를 비활성화(삭제)하시겠습니까?")) return;

            $.ajax({
                url: "/admin/delivery/deleteDelivery",
                type: "POST",
                data: { deliveryId: $("#deliveryId").val() }, // @RequestParam으로 받으므로 JSON 아님
                success: function(res) {
                    alert(res.message);
                    if(res.success) location.href = "/admin/delivery/list";
                }
            });
        }
    </script>
</body>
</html>