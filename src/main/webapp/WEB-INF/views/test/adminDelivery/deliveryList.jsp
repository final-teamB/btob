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
    
    <div class="search-box" style="border: 1px solid #ccc; padding: 15px; margin-bottom: 20px;">
	    <form action="/admin/delivery/list" method="get">
	        <label>기간: </label>
	        <input type="date" name="searchStartDate" value="${param.searchStartDate}"> ~ 
	        <input type="date" name="searchEndDate" value="${param.searchEndDate}">
	        
	        <select name="deliveryStatus">
	            <option value="">상태</option>
	            <c:forEach var="status" items="${statusList}">
	                <option value="${status}" ${search.deliveryStatus == status ? 'selected' : ''}>
	                    ${status.description}
	                </option>
	            </c:forEach>
	        </select>
	
	        <select name="searchType" style="margin-left:20px;">
	            <option value="orderId" ${param.searchType == 'orderId' ? 'selected' : ''}>주문번호</option>
	            <option value="trackingNo" ${param.searchType == 'trackingNo' ? 'selected' : ''}>송장번호</option>
	        </select>
	        <input type="text" name="searchKeyword" value="${param.searchKeyword}" placeholder="검색어 입력">
	        
	        <button type="submit" style="background:#333; color:#fff;">조회</button>
	        <button type="button" onclick="location.href='/admin/delivery/list'">초기화</button>
	    </form>
	</div>
    
    <table>
        <thead>
            <tr>
                <th>배송번호</th>
                <th>주문일시</th> 
                <th>주문번호</th>
                <th>상태 코드</th> 
                <th>배송 상태(수정)</th> 
                <th>운송장 번호</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>
		    <c:forEach var="item" items="${deliveryList}">
		        <tr id="row-${item.deliveryId}">
		            <td>
						<a href="/admin/delivery/detail/${item.deliveryId}" style="font-weight:bold; color:blue;">
		                    ${item.deliveryId}
		                </a>
					</td>
					<td>${item.regDtime}</td>
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
	        const status = document.getElementById('status-' + id).value;
	
	        const data = {
	            deliveryId: id,
	            trackingNo: trackingNo,
	            deliveryStatus: status
	        };
	
	        fetch('/admin/delivery/deliveryUpdate', { // 또는 /admin/delivery/updateDeliveryDetail (통합됨)
	            method: 'POST',
	            headers: { 'Content-Type': 'application/json' },
	            body: JSON.stringify(data)
	        })
	        .then(response => response.json())
	        .then(res => { // 반환값이 Map이므로 res로 받음
	            if(res.success) { 
	                alert(res.message);
	                
	                // Map 안에 담아준 data(DeliveryDTO)를 꺼냅니다.
	                const updatedItem = res.data; 
	                
	                if(updatedItem) {
	                    const row = document.getElementById('row-' + id);
	                    // 1. 화면의 한글 상태명 업데이트 (statusName)
	                    row.querySelector('td:nth-child(3) strong').innerText = updatedItem.statusName;
	                    // 2. 화면의 영문 코드 업데이트
	                    row.querySelector('td:nth-child(3) small').innerText = "(" + updatedItem.deliveryStatus + ")";
	                }
	            } else {
	                alert("수정 실패: " + res.message);
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