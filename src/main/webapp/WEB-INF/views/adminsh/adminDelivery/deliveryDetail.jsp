<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/datagrid.css" >
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<style>
    /* FAQ 스타일과 일치시키기 위한 패딩 및 정렬 조정 */
    .detail-table th { padding: 1.25rem 1rem !important; background-color: transparent !important; }
    .detail-table td { padding: 1.25rem 1rem !important; }
    
    input[type="text"], select { height: 42px; padding: 0 12px !important; transition: all 0.2s ease-in-out; }
    input[type="text"]:focus, select:focus { border-color: #111827 !important; box-shadow: 0 0 0 2px rgba(17, 24, 39, 0.05) !important; }
    .dark input[type="text"]:focus, .dark select:focus { border-color: #3b82f6 !important; }
</style>

<div class="mx-4 my-6 space-y-6">
    
    <%-- [1. 타이틀 영역] --%>
    <div class="px-5 py-4 text-left">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">배송 상세 정보</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">배송 상태 및 운송장 정보를 관리합니다.</p>
    </div>

    <%-- [2. 메인 컨텐츠 영역] 흰색 배경 섹션 --%>
    <section class="p-8 bg-white rounded-xl shadow-sm border border-gray-100 dark:bg-gray-800 dark:border-gray-700">
        <form id="detailForm">
            <input type="hidden" id="deliveryId" value="${deliveryDTO.deliveryId}">
            
            <%-- 표 디자인을 FAQ 입력 폼 느낌으로 변경 --%>
            <div class="w-full">
                <table class="w-full text-sm text-left detail-table">
                    <tbody class="divide-y divide-gray-100 dark:divide-gray-700">
                        <%-- 행 1 --%>
                        <tr class="first:border-t-0">
                            <th class="w-1/6 font-bold text-gray-700 dark:text-gray-300">배송번호</th>
                            <td class="w-2/6 font-mono text-blue-600 dark:text-blue-400">${deliveryDTO.deliveryId}</td>
                            <th class="w-1/6 font-bold text-gray-700 dark:text-gray-300">주문일시</th>
                        	<td class="w-2/6 text-gray-600 dark:text-gray-400">
								${deliveryDTO.regDtime.toString().replace('T',' ')}
							</td>
                        </tr>
                        <%-- 행 2 --%>
                        <tr>
                            <th class="font-bold text-gray-700 dark:text-gray-300">주문번호</th>
                            <td class="font-mono text-gray-600 dark:text-gray-400">${deliveryDTO.orderId}</td>
                            <th class="font-bold text-gray-700 dark:text-gray-300">배송상태</th>
                            <td>
                                <select id="deliveryStatus" class="w-full border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white transition-all">
                                    <c:forEach var="status" items="${statusList}">
                                        <option value="${status}" ${deliveryDTO.deliveryStatus == status ? 'selected' : ''}>
                                            ${status.description}
                                        </option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <%-- 행 3 --%>
                        <tr>
                            <th class="font-bold text-gray-700 dark:text-gray-300">운송장번호</th>
                            <td>
                                <input type="text" id="trackingNo" value="${deliveryDTO.trackingNo}" placeholder="번호 입력"
                                       class="w-full border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white outline-none">
                            </td>
                            <th class="font-bold text-gray-700 dark:text-gray-300">택배사</th>
                            <td>
                                <select id="carrierName" class="w-full border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white transition-all">
                                    <option value="">선택</option>
                                    <option value="CJ대한통운" ${deliveryDTO.carrierName == 'CJ대한통운' ? 'selected' : ''}>CJ대한통운</option>
                                    <option value="한진택배" ${deliveryDTO.carrierName == '한진택배' ? 'selected' : ''}>한진택배</option>
                                    <option value="롯데택배" ${deliveryDTO.carrierName == '롯데택배' ? 'selected' : ''}>롯데택배</option>
                                    <option value="경동택배" ${deliveryDTO.carrierName == '경동택배' ? 'selected' : ''}>경동택배</option>
                                    <option value="로젠택배" ${deliveryDTO.carrierName == '로젠택배' ? 'selected' : ''}>로젠택배</option>
                                </select>
                            </td>
                        </tr>
                        <%-- 행 4 (배송지 주소) --%>
                        <tr>
                            <th class="font-bold text-gray-700 dark:text-gray-300">배송지 주소</th>
                            <td colspan="3">
                                <div class="flex flex-col gap-2 py-2">
                                    <div class="flex gap-2">
                                        <input type="text" id="postcode" value="${deliveryDTO.zipCode}" placeholder="우편번호" readonly 
                                               class="w-32 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-600 dark:text-white text-sm">
                                        <button type="button" onclick="execDaumPostcode()" 
                                                class="px-4 py-2 bg-gray-800 text-white rounded-lg text-xs font-bold hover:bg-gray-700 transition">주소 검색</button>
                                    </div>
                                    <input type="text" id="shipToAddr" value="${deliveryDTO.addrKor}" readonly 
                                           class="w-full border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-600 dark:text-white text-sm" placeholder="기본 주소">
                                    <input type="text" id="shipToAddrDetail" value="${deliveryDTO.companyName}" 
                                           class="w-full border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white text-sm" placeholder="상세 주소(회사명 등) 입력">
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <%-- [3. 하단 액션 버튼] --%>
            <div class="flex justify-between items-center pt-10 mt-4 border-t border-gray-100 dark:border-gray-700">
                <button type="button" onclick="fn_delete()" class="text-red-500 hover:text-red-700 text-sm font-semibold transition">비활성화(데이터 삭제)</button>
                <div class="flex space-x-3">
                    <button type="button" onclick="location.href='/admin/delivery/list'" 
                            class="px-6 py-2.5 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 transition-all">
                        취소
                    </button>
                    <button type="button" onclick="fn_update()" 
                            class="px-8 py-2.5 text-sm font-bold text-white bg-gray-900 rounded-lg hover:bg-gray-800 shadow-md transition-all active:scale-95 dark:bg-blue-600">
                        저장하기
                    </button>
                </div>
            </div>
        </form>
    </section>
</div>

<script>
    /* 기존 스크립트 로직 동일 유지 */
    $(document).ready(function() {
        const rawAddr = "${deliveryDTO.shipToAddr}";
        if (rawAddr && rawAddr.includes('|')) {
            const parts = rawAddr.split('|');
            $("#shipToAddr").val(parts[0] || '');       
            $("#shipToAddrDetail").val(parts[1] || ''); 
            $("#postcode").val(parts[2] || '');   
        } else if (rawAddr && rawAddr.trim() !== "") {
            const postcodeMatch = rawAddr.match(/^\((.*?)\)/);
            let tempAddr = rawAddr;
            if (postcodeMatch) {
                $("#postcode").val(postcodeMatch[1]);
                tempAddr = rawAddr.replace(/^\(.*?\)\s*/, '');
            }
            $("#shipToAddr").val(tempAddr);
        }
        
        const orderStatus = "${deliveryDTO.orderStatus}"; 
        const $deliverySelect = $("#deliveryStatus");   
        if (orderStatus === 'pm002') {
            $deliverySelect.find("option").each(function() {
                const val = $(this).val();
                if (val === 'dv006' || val === 'dv007') {
                    $(this).prop('disabled', true).css('color', '#ccc');
                }
            });
        } else if (orderStatus === 'pm004') {
            $deliverySelect.find("option").each(function() {
                const val = $(this).val();
                if (['dv001', 'dv002', 'dv003', 'dv004'].includes(val)) {
                    $(this).prop('disabled', true).css('color', '#ccc');
                }
            });
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
        const postcode = $("#postcode").val();
        const addr = $("#shipToAddr").val();
        const detail = $("#shipToAddrDetail").val() || "";
        const combinedAddr = addr + "|" + detail + "|" +postcode;
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
            },
            error: function(xhr) { alert("저장 중 오류가 발생했습니다."); }
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