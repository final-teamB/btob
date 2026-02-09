<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>배송 상세 관리 | Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/datagrid.css" >
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <style>
	    .max-w-5xl { padding-top: 2rem; }
	    .divide-y th, .divide-y td { padding-top: 1.25rem !important; padding-bottom: 1.25rem !important; vertical-align: middle; }
	    input[type="text"], select { height: 42px; padding: 0 12px !important; transition: all 0.2s ease-in-out; }
	    input[type="text"]:hover, select:hover { border-color: #9ca3af !important; }
	    input[type="text"]:focus, select:focus { border-color: #111827 !important; box-shadow: 0 0 0 3px rgba(17, 24, 39, 0.05) !important; }
        /* 다크모드 포커스 스타일 */
        .dark input[type="text"]:focus, .dark select:focus { border-color: #3b82f6 !important; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2) !important; }
	    button { transition: transform 0.1s ease-in-out; }
	    button:active { transform: scale(0.98); }
	</style>
</head>
<body class="bg-gray-50 dark:bg-gray-900 p-8 transition-colors duration-200">

<div class="max-w-5xl mx-auto">
    <div class="flex justify-between items-end mb-6">
        <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">배송 상세 정보</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">배송 상태 및 운송장 정보를 관리합니다.</p>
        </div>
    </div>

    <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 overflow-hidden">
        <form id="detailForm">
            <input type="hidden" id="deliveryId" value="${deliveryDTO.deliveryId}">
            <table class="w-full text-sm text-left text-gray-600 dark:text-gray-300">
                <thead class="bg-gray-50 dark:bg-gray-700 text-gray-400 dark:text-gray-400 uppercase text-xs font-bold border-b border-gray-100 dark:border-gray-600">
                    <tr>
                        <th class="px-6 py-4 w-1/6">구분</th>
                        <th class="px-6 py-4 w-2/6">내용</th>
                        <th class="px-6 py-4 w-1/6">구분</th>
                        <th class="px-6 py-4 w-2/6">내용</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100 dark:divide-gray-600">
                    <tr>
                        <th class="px-6 py-4 bg-gray-50 dark:bg-gray-700/50 font-semibold text-gray-700 dark:text-gray-200">배송번호</th>
                        <td class="px-6 py-4 font-mono text-blue-600 dark:text-blue-400">${deliveryDTO.deliveryId}</td>
                        <th class="px-6 py-4 bg-gray-50 dark:bg-gray-700/50 font-semibold text-gray-700 dark:text-gray-200">주문일시</th>
                        <td class="px-6 py-4">${deliveryDTO.regDtime}</td>
                    </tr>
                    <tr>
                        <th class="px-6 py-4 bg-gray-50 dark:bg-gray-700/50 font-semibold text-gray-700 dark:text-gray-200">주문번호</th>
                        <td class="px-6 py-4 font-mono">${deliveryDTO.orderId}</td>
                        <th class="px-6 py-4 bg-gray-50 dark:bg-gray-700/50 font-semibold text-gray-700 dark:text-gray-200">배송상태</th>
                        <td class="px-6 py-4">
                            <select id="deliveryStatus" class="w-full bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-white text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 p-2.5">
                                <c:forEach var="status" items="${statusList}">
                                    <option value="${status}" ${deliveryDTO.deliveryStatus == status ? 'selected' : ''}>
                                        ${status.description}
                                    </option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th class="px-6 py-4 bg-gray-50 dark:bg-gray-700/50 font-semibold text-gray-700 dark:text-gray-200">운송장번호</th>
                        <td class="px-6 py-4">
                            <input type="text" id="trackingNo" value="${deliveryDTO.trackingNo}" class="w-full bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-white rounded-lg p-2 outline-none">
                        </td>
                        <th class="px-6 py-4 bg-gray-50 dark:bg-gray-700/50 font-semibold text-gray-700 dark:text-gray-200">택배사</th>
                        <td class="px-6 py-4">
                            <input type="text" id="carrierName" value="${deliveryDTO.carrierName}" class="w-full bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-white rounded-lg p-2 outline-none">
                        </td>
                    </tr>
                    <tr>
					    <th class="px-6 py-4 bg-gray-50 dark:bg-gray-700/50 font-semibold text-gray-700 dark:text-gray-200">수령인 주소</th>
					    <td colspan="3" class="px-6 py-4">
					        <div class="flex flex-col gap-2">
					            <div class="flex gap-2">
					                <input type="text" id="postcode" placeholder="우편번호" readonly class="w-32 border border-gray-300 dark:border-gray-600 rounded-lg p-2 bg-gray-100 dark:bg-gray-600 text-gray-900 dark:text-white outline-none text-sm">
					                <button type="button" onclick="execDaumPostcode()" class="px-4 py-2 bg-gray-700 dark:bg-blue-600 text-white rounded-lg text-xs font-bold hover:bg-gray-600 dark:hover:bg-blue-500 transition">주소 검색</button>
					            </div>
					            <input type="text" id="shipToAddr" value="" readonly class="w-full border border-gray-300 dark:border-gray-600 rounded-lg p-2 bg-gray-100 dark:bg-gray-600 text-gray-900 dark:text-white outline-none text-sm" placeholder="기본 주소">
					            <input type="text" id="shipToAddrDetail" class="w-full bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-white rounded-lg p-2 focus:ring-1 focus:ring-gray-400 outline-none text-sm" placeholder="상세 주소 입력">
					        </div>
					    </td>
					</tr>
                </tbody>
            </table>

            <div class="px-6 py-5 bg-gray-50 dark:bg-gray-700/50 flex justify-between items-center border-t border-gray-200 dark:border-gray-600">
                <button type="button" onclick="fn_delete()" class="text-red-500 hover:text-red-700 dark:text-red-400 dark:hover:text-red-300 text-sm font-bold transition">비활성화(데이터 삭제)</button>
                <div class="flex space-x-3">
                    <button type="button" onclick="location.href='/admin/delivery/list'" class="px-5 py-2.5 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 rounded-lg text-sm font-bold hover:bg-gray-50 dark:hover:bg-gray-700 transition">취소</button>
                    <button type="button" onclick="fn_update()" class="px-8 py-2.5 bg-gray-900 dark:bg-blue-600 text-white rounded-lg text-sm font-bold hover:bg-gray-800 dark:hover:bg-blue-500 shadow-lg transition">수정사항 저장</button>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
    // 스크립트 부분은 기존 로직을 그대로 유지합니다.
    $(document).ready(function() {
        const rawAddr = "${deliveryDTO.shipToAddr}";
        if (rawAddr) {
            if (rawAddr.indexOf('|') !== -1) {
                const parts = rawAddr.split('|');
                $("#postcode").val(parts[0] || '');
                $("#shipToAddr").val(parts[1] || '');
                $("#shipToAddrDetail").val(parts[2] || '');
            } else {
                const postcodeMatch = rawAddr.match(/^\((.*?)\)/);
                let tempAddr = rawAddr;
                if (postcodeMatch) {
                    $("#postcode").val(postcodeMatch[1]);
                    tempAddr = rawAddr.replace(/^\(.*?\)\s*/, '');
                }
                const addrParts = tempAddr.trim().split(/\s{2,}/);
                if (addrParts.length >= 2) {
                    $("#shipToAddr").val(addrParts[0]);
                    $("#shipToAddrDetail").val(addrParts.slice(1).join(' '));
                } else {
                    $("#shipToAddr").val(tempAddr);
                }
            }
        }
    });

    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                let addr = (data.userSelectedType === 'R') ? data.roadAddress : data.jibunAddress;
                $("#postcode").val(data.zonecode);
                $("#shipToAddr").val(addr);
                $("#shipToAddrDetail").val("").focus();
            }
        }).open();
    }

    function fn_update() {
        const combinedAddr = $("#postcode").val() + "|" + $("#shipToAddr").val() + "|" + $("#shipToAddrDetail").val();
        const param = {
            deliveryId: $("#deliveryId").val(),
            deliveryStatus: $("#deliveryStatus").val(),
            trackingNo: $("#trackingNo").val(),
            carrierName: $("#carrierName").val(),
            shipToAddr: combinedAddr
        };
        if(!confirm("수정하시겠습니까?")) return;
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

    function fn_delete() {
        if(!confirm("이 데이터를 비활성화 하시겠습니까?")) return;
        $.post("/admin/delivery/deleteDelivery", { deliveryId: $("#deliveryId").val() }, function(res) {
            alert(res.message);
            if(res.success) location.href = "/admin/delivery/list";
        });
    }
</script>
</body>
</html>