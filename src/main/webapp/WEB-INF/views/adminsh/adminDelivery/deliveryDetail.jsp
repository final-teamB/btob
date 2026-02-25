<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="p-2 space-y-2">
    <div class="px-2 pb-1 border-b">
        <h3 class="font-bold text-blue-600 text-sm uppercase">배송 상세 정보 관리</h3>
        <p class="text-[12px] text-gray-400 mt-1">* 배송 상태와 운송장 정보를 즉시 수정합니다.</p>
    </div>

    <section class="bg-white">
        <form id="detailForm" class="space-y-3">
            <input type="hidden" id="deliveryId" value="${deliveryDTO.deliveryId}">

            <div class="grid grid-cols-1 gap-y-2 px-2">
                <%-- 배송번호 / 주문번호 --%>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">배송번호</label>
                        <div class="px-3 py-2 text-sm bg-gray-50 border border-gray-200 rounded-lg text-blue-600 font-mono">
                            ${deliveryDTO.deliveryId}
                        </div>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">주문번호</label>
                        <div class="px-3 py-2 text-sm bg-gray-50 border border-gray-200 rounded-lg text-gray-600 font-mono">
                            ${deliveryDTO.orderId}
                        </div>
                    </div>
                </div>

                <%-- 배송상태 / 택배사 --%>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">
                            배송상태 <span class="text-red-500">*</span>
                        </label>
                        <select id="deliveryStatus"
                                class="w-full px-3 py-2.5 text-sm border border-gray-300 rounded-lg outline-none focus:ring-1 focus:ring-blue-500 transition-all">
                            <c:forEach var="status" items="${statusList}">
                                <option value="${status}" ${deliveryDTO.deliveryStatus == status ? 'selected' : ''}>
                                    ${status.description}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">택배사</label>
                        <select id="carrierName"
                                class="w-full px-3 py-2.5 text-sm border border-gray-300 rounded-lg outline-none focus:ring-1 focus:ring-blue-500 transition-all">
                            <option value="">선택</option>
                            <option value="CJ대한통운" ${deliveryDTO.carrierName == 'CJ대한통운' ? 'selected' : ''}>CJ대한통운</option>
                            <option value="한진택배"   ${deliveryDTO.carrierName == '한진택배'   ? 'selected' : ''}>한진택배</option>
                            <option value="롯데택배"   ${deliveryDTO.carrierName == '롯데택배'   ? 'selected' : ''}>롯데택배</option>
                            <option value="경동택배"   ${deliveryDTO.carrierName == '경동택배'   ? 'selected' : ''}>경동택배</option>
                            <option value="로젠택배"   ${deliveryDTO.carrierName == '로젠택배'   ? 'selected' : ''}>로젠택배</option>
                        </select>
                    </div>
                </div>

                <%-- 운송장번호 --%>
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1">운송장번호</label>
                    <input type="text" id="trackingNo" value="${deliveryDTO.trackingNo}" placeholder="번호 입력"
                           class="w-full px-3 py-2.5 text-sm border border-gray-300 rounded-lg outline-none focus:ring-1 focus:ring-blue-500 transition-all">
                </div>

                <%-- 배송지 주소 --%>
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1">배송지 주소</label>
                    <div class="flex gap-2 mb-2">
                        <input type="text" id="postcode" value="${deliveryDTO.zipCode}" placeholder="우편번호" readonly
                               class="w-32 px-3 py-2 text-sm bg-gray-50 border border-gray-300 rounded-lg">
                        <button type="button" onclick="execDaumPostcode()"
                                class="px-4 py-2 bg-gray-100 border border-gray-300 text-gray-700 text-xs font-bold rounded-lg hover:bg-gray-200 transition-all">
                            주소 검색
                        </button>
                    </div>
                    <input type="text" id="shipToAddr" value="${deliveryDTO.addrKor}" readonly placeholder="기본 주소"
                           class="w-full px-3 py-2 text-sm bg-gray-50 border border-gray-300 rounded-lg mb-2">
                    <input type="text" id="shipToAddrDetail" value="${deliveryDTO.companyName}" placeholder="상세 주소 및 회사명 입력"
                           class="w-full px-3 py-2.5 text-sm border border-gray-300 rounded-lg outline-none focus:ring-1 focus:ring-blue-500 transition-all">
                </div>
            </div>

            <%-- 하단 액션바 --%>
            <div class="flex items-center justify-between p-4 border-t mt-3">
                <div class="flex items-center gap-3">
                    <button type="button" onclick="fn_update()"
                            class="px-10 py-2.5 text-sm font-bold text-white bg-blue-600 rounded-lg hover:bg-blue-700 shadow-md transition-all active:scale-95">
                        저장하기
                    </button>
                    <button type="button" onclick="fn_delete()"
                            class="text-red-500 hover:text-red-700 text-xs font-semibold">
                        비활성화
                    </button>
                </div>
                <button type="button" onclick="closeDeliveryModal()"
                        class="px-6 py-2.5 text-sm font-medium text-gray-500 bg-white border border-gray-200 rounded-lg hover:bg-gray-50 transition-all shadow-sm">
                    취소
                </button>
            </div>
        </form>
    </section>
</div>

<script>
    $(document).ready(function() {
        const rawAddr = "${deliveryDTO.shipToAddr}";
        if (rawAddr && rawAddr.includes('|')) {
            const parts = rawAddr.split('|');
            $("#shipToAddr").val(parts[0] || '');
            $("#shipToAddrDetail").val(parts[1] || '');
            $("#postcode").val(parts[2] || '');
        }

        const orderStatus = "${deliveryDTO.orderStatus}";
        const $deliverySelect = $("#deliveryStatus");
        if (orderStatus === 'pm002') {
            $deliverySelect.find("option").each(function() {
                const val = $(this).val();
                if (val === 'dv006' || val === 'dv007') $(this).prop('disabled', true);
            });
        } else if (orderStatus === 'pm004') {
            // pm004: dv006, dv007만 활성화 (나머지 전부 비활성화)
            $deliverySelect.find("option").each(function() {
                const val = $(this).val();
                if (val !== 'dv006' && val !== 'dv007') $(this).prop('disabled', true);
            });
            // 현재 선택값이 비활성화 대상이면 dv006으로 강제 이동
            const currentVal = $deliverySelect.val();
            if (currentVal !== 'dv006' && currentVal !== 'dv007') {
                $deliverySelect.val('dv006');
            }
        }
    });

    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                let addr = (data.userSelectedType === 'R') ? data.roadAddress : data.jibunAddress;
                $("#postcode").val(data.zonecode);
                $("#shipToAddr").val(addr);
                $("#shipToAddrDetail").focus();
            }
        }).open();
    }

    function fn_update() {
        const param = {
            deliveryId: $("#deliveryId").val(),
            deliveryStatus: $("#deliveryStatus").val(),
            trackingNo: $("#trackingNo").val(),
            carrierName: $("#carrierName").val(),
            shipToAddr: $("#shipToAddr").val() + "|" + $("#shipToAddrDetail").val() + "|" + $("#postcode").val()
        };
        if (!confirm("수정하시겠습니까?")) return;
        $.ajax({
            url: "/admin/delivery/updateDeliveryDetail",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify(param),
            success: function(res) {
                alert(res.message);
                if (res.success) { closeDeliveryModal(); location.reload(); }
            }
        });
    }

    function fn_delete() {
        if (!confirm("이 데이터를 비활성화 하시겠습니까?")) return;
        $.post("/admin/delivery/deleteDelivery", { deliveryId: $("#deliveryId").val() }, function(res) {
            alert(res.message);
            if (res.success) location.reload();
        });
    }
</script>