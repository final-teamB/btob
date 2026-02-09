<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<div class="mx-4 my-6 space-y-6">
    <div>
        <h1 class="text-2xl font-bold text-gray-800 dark:text-white">${pageTitle}</h1>
    </div>

    <div class="grid grid-cols-1 gap-4">
        <c:set var="finalTotalSum" value="0" />
        
        <c:forEach var="c" items="${cartList}">
            <c:set var="finalTotalSum" value="${finalTotalSum + c.total_price}" />
            
            <div id="cart-row-${c.cart_id}" class="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-100 dark:border-gray-700 p-5 transition hover:shadow-md">
                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                    
                    <div class="flex-1">
                        <div class="flex items-center gap-2 mb-1">
                            <h3 class="text-lg font-bold text-gray-900 dark:text-white">${c.fuel_nm}</h3>
                            <c:if test="${not empty c.order_status and fn:endsWith(c.order_status, '999')}">
                                <span class="px-2 py-0.5 text-xs font-semibold text-red-600 bg-red-50 rounded-full">반려됨</span>
                            </c:if>
                        </div>
                        <p class="text-sm font-medium text-indigo-500 dark:text-indigo-400">
                            ${not empty c.etp_stts_nm ? c.etp_stts_nm : '장바구니 담김'}
                        </p>
                        <p class="text-xs text-gray-400 mt-1">단가: ₩<fmt:formatNumber value="${c.base_unit_prc}" pattern="#,###" /></p>
                    </div>

                    <div class="flex items-center gap-3 bg-gray-50 dark:bg-gray-700/50 p-2 rounded-lg w-fit">
                        <c:choose>
                            <c:when test="${c.cart_status == 'PENDING' or (not empty c.order_status and fn:endsWith(c.order_status, '999'))}">
                                <button type="button" class="w-8 h-8 flex items-center justify-center bg-white dark:bg-gray-600 rounded shadow-sm hover:bg-gray-100"
                                        onclick="decreaseQty(${c.cart_id}, ${c.base_unit_prc})">−</button>
                                
                                <input type="number" id="qty-${c.cart_id}" value="${c.total_qty}" min="1"
                                       class="w-12 text-center bg-transparent font-bold text-gray-900 dark:text-white focus:outline-none"
                                       onchange="updateCartQty(${c.cart_id}, this.value, ${c.base_unit_prc})">

                                <button type="button" class="w-8 h-8 flex items-center justify-center bg-white dark:bg-gray-600 rounded shadow-sm hover:bg-gray-100"
                                        onclick="increaseQty(${c.cart_id}, ${c.base_unit_prc})">+</button>
                            </c:when>
                            <c:otherwise>
                                <span class="px-4 font-medium text-gray-900 dark:text-white text-sm">확정수량: ${c.total_qty}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="flex items-center justify-between md:justify-end gap-6 md:w-48">
                        <div class="text-right">
                            <p class="text-xs text-gray-400 uppercase tracking-wider">Total</p>
                            <p class="text-xl font-black text-indigo-600 dark:text-indigo-400" id="total-${c.cart_id}">
                                ₩<fmt:formatNumber value="${c.total_price}" pattern="#,###" />
                            </p>
                        </div>
                        
                        <c:if test="${c.cart_status == 'PENDING' or (not empty c.order_status and fn:endsWith(c.order_status, '999'))}">
                            <button type="button" onclick="deleteCartItem(${c.cart_id})" 
                                    class="p-2 text-gray-400 hover:text-red-500 transition-colors">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                </svg>
                            </button>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty cartList}">
            <div class="bg-white dark:bg-gray-800 rounded-xl p-20 text-center border-2 border-dashed border-gray-200 dark:border-gray-700">
                <p class="text-gray-400">거래바구니가 비어있습니다.</p>
            </div>
        </c:if>
    </div>

  <c:if test="${not empty cartList}">
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-indigo-100 dark:border-indigo-900/30 overflow-hidden">
            <div class="p-6 flex flex-col md:flex-row justify-between items-center gap-6">
                <div>
                    <p class="text-sm text-gray-500 dark:text-gray-400 mb-1">최종 결제 예정 금액</p>
                    <h2 class="text-3xl font-black text-indigo-600 dark:text-indigo-400" id="final-total">
                        ₩<fmt:formatNumber value="${finalTotalSum}" pattern="#,###" />
                    </h2>
                </div>
                
                <%-- 공통 변수 설정 --%>
                <c:set var="orderNo" value="${cartList[0].order_no}" />
                <c:set var="status" value="${cartList[0].order_status}" />
                <c:set var="cStatus" value="${cartList[0].cart_status}" />
                
                <div class="flex flex-wrap justify-center gap-3">
                    <c:choose>
                        <%-- 1. 신규 작성이거나 반려된 상태 (PENDING 또는 끝자리가 999인 반려 상태) --%>
	                     <c:when test="${cStatus == 'PENDING' or fn:endsWith(status, '999')}">
						    <c:choose>
						        <%-- 일반 사용자: 견적/주문 승인 요청 필요 --%>
						        <c:when test="${userType == 'USER'}">
						            <button type="button" onclick="fn_openPreview('EST')"
						                    class="px-8 py-3 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl transition shadow-lg">
						                견적 승인 요청
						            </button>
						            <button type="button" onclick="fn_openPreview('ORD')"
						                    class="px-8 py-3 bg-green-600 hover:bg-green-700 text-white font-bold rounded-xl transition shadow-lg">
						                주문 승인 요청
						            </button>
						        </c:when>
						
						        <%-- 마스터: 견적 생략 가능, 바로 주문 진행 --%>
						        <c:when test="${userType == 'MASTER'}">
						            <button type="button" onclick="fn_openPreview('ORD')"
						                    class="px-10 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl transition shadow-lg">
						                주문 요청 (즉시 진행)
						            </button>
						        </c:when>
						    </c:choose>
						</c:when>

                        <%-- 2. 요청 진행 중 (REQ) 상태 --%>
						<c:when test="${cStatus == 'REQ'}">
						    <c:choose>
						        <%-- 2-1. 견적 승인 완료(et003) -> 주문 승인 요청(od001)으로 이동 --%>
						        <c:when test="${status == 'et003'}">
						            <c:if test="${userType == 'USER'}">
						                <button type="button" onclick="fn_processWorkflow('ORDER', 'od001', '${orderNo}')" 
						                        class="px-8 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl transition shadow-lg">
						                    대표 승인 요청 (주문)
						                </button>
						            </c:if>
						        </c:when>
						
						        <%-- 2-2. [추가] 주문 승인 완료(od002) -> 구매 승인 요청(pr001)으로 이동 --%>
						        <c:when test="${status == 'od002'}">	
						            <button type="button" onclick="fn_processWorkflow('PURCHASE', 'pr001', '${orderNo}')" 
						                    class="px-8 py-3 bg-teal-600 hover:bg-teal-700 text-white font-bold rounded-xl transition shadow-lg">
						                구매 승인 요청 (최종)
						            </button>
						        </c:when>
						
						        <%-- 2-3. 구매 승인 완료(pr002) -> 결제 진행 --%>
						        <c:when test="${status == 'pr002'}">
						            <button type="button" onclick="location.href='${pageContext.request.contextPath}/payment/firstPayment?orderNo=${orderNo}'" 
						                    class="px-12 py-4 bg-orange-500 hover:bg-orange-600 text-white text-lg font-black rounded-xl transition shadow-xl transform hover:-translate-y-1">
						                1차 결제하기
						            </button>
						        </c:when>
						
						        <%-- 2-4. 그 외 승인 대기 단계 (et002, od001, pr001 등) --%>
						        <c:otherwise>
						            <div class="flex items-center gap-2 px-8 py-3 bg-amber-50 dark:bg-amber-900/20 text-amber-700 dark:text-amber-400 rounded-xl font-bold border border-amber-100 dark:border-amber-800">
						                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 animate-spin" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
						                </svg>
						                [${not empty cartList[0].etp_stts_nm ? cartList[0].etp_stts_nm : '승인 대기'}] 단계 진행 중...
						            </div>
						        </c:otherwise>
						    </c:choose>
						</c:when>

                        <c:otherwise>
                            <div class="px-8 py-3 bg-gray-100 dark:bg-gray-700 text-gray-500 rounded-xl font-bold italic text-sm">
                                주문 처리가 완료되었습니다.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </c:if>
</div>

<script>
	function fn_openPreview(type) {
	    const cartIds = [];
	    // 화면에 있는 장바구니 ID들만 수집
	    document.querySelectorAll('[id^="cart-row-"]').forEach(row => {
	        cartIds.push(row.id.replace('cart-row-', ''));
	    });
	
	    if (cartIds.length === 0) {
	        alert("상품이 없습니다.");
	        return;
	    }
	
	    const popupName = type === 'EST' ? "previewEst" : "PreviewOrder";
	    window.open("", popupName, "width=1200, height=900, scrollbars=yes");
	
	    const form = document.createElement('form');
	    form.method = 'POST';
	    form.target = popupName;
	    form.action = type === 'EST' 
	        ? "${pageContext.request.contextPath}/cart/estimateReq" 
	        : "${pageContext.request.contextPath}/cart/orderReq";
	
	    // 서버에 필요한 최소한의 정보만 전달
	    const payload = {
	        "cartIds": cartIds.join(','),
	        "userType": "${userType}",
	        "totalSum": document.getElementById('final-total').innerText.replace(/[^0-9]/g, '')
	    };
	
	    for (let key in payload) {
	        const input = document.createElement('input');
	        input.type = 'hidden';
	        input.name = key;
	        input.value = payload[key];
	        form.appendChild(input);
	    }
	
	    document.body.appendChild(form);
	    form.submit();
	    document.body.removeChild(form);
	}
	
	/**
	 * 워크플로우 상태 변경 처리 함수
	 * @param systemId - ESTIMATE, ORDER, PURCHASE 등
	 * @param nextStatus - et002, od001, pr001 등
	 * @param orderNo - 통합 관리용 주문번호(refId)
	 */
	 /**
	  * 1. 즉시 워크플로우 처리 (견적 요청, 대표 승인 요청 등)
	  */
	  function fn_processWorkflow(systemId, nextStatus, orderNo) {
		    if (!orderNo) {
		        alert("유효한 주문 번호가 없습니다.");
		        return;
		    }
	
		    if (!confirm("해당 단계로 진행하시겠습니까?")) return;
	
		    const requestData = {
		        systemId: systemId,
		        refId: orderNo,
		        approvalStatus: 'APPROVED',
		        requestEtpStatus: nextStatus
		    };
	
		    $.ajax({
		        url: "${pageContext.request.contextPath}/order/modifyStatus",
		        type: "POST",
		        contentType: "application/json",
		        data: JSON.stringify(requestData),
		        success: function(res) {
		            alert("정상적으로 처리되었습니다.");
		            
		            // 페이지 이동 대신 현재 장바구니 페이지 새로고침
		            // 새로고침되면 JSTL 조건문에 의해 '진행 중' 상태 UI로 자동 변경됩니다.
		            location.reload(); 
		        },
		        error: function(err) {
		            alert(err.responseJSON ? err.responseJSON.message : "처리 중 오류가 발생했습니다.");
		        }
		    });
		}
	
	function updateFinalTotal() {
	    let sum = 0;
	    document.querySelectorAll('[id^="total-"]').forEach(el => {
	        const price = parseInt(el.innerText.replace(/[^0-9]/g, '') || 0);
	        sum += price;
	    });
	    document.getElementById('final-total').innerText = '₩' + sum.toLocaleString();
	}
	
	function increaseQty(cartId, unitPrice) {
	    const input = document.getElementById(`qty-\${cartId}`);
	    let qty = parseInt(input.value) + 1;
	    input.value = qty;
	    updateCartQty(cartId, qty, unitPrice);
	}
	
	function decreaseQty(cartId, unitPrice) {
	    const input = document.getElementById(`qty-\${cartId}`);
	    let qty = parseInt(input.value);
	    if(qty > 1) {
	        qty -= 1;
	        input.value = qty;
	        updateCartQty(cartId, qty, unitPrice);
	    }
	}
	
	function updateCartQty(cartId, qty, unitPrice) {
	    fetch(`${pageContext.request.contextPath}/cart/update`, {
	        method: 'POST',
	        headers: { 'Content-Type': 'application/json' },
	        body: JSON.stringify({ cartId: cartId, total_qty: qty })
	    })
	    .then(res => res.json())
	    .then(data => {
	        if(data.result === 'success') {
	            document.getElementById(`total-\${cartId}`).innerText = '₩' + (unitPrice * qty).toLocaleString();
	            updateFinalTotal();
	        } else {
	            alert('수량 변경 실패');
	        }
	    });
	}
	
	function deleteCartItem(cartId) {
	    if(!confirm('정말 삭제하시겠습니까?')) return;
	    fetch(`${pageContext.request.contextPath}/cart/delete?cartId=\${cartId}`, { method: 'POST' })
	        .then(res => res.json())
	        .then(data => {
	            if(data.result === 'success') {
	                const row = document.getElementById(`cart-row-\${cartId}`);
	                if(row) row.remove();
	                updateFinalTotal();
	                // 항목이 하나도 없으면 새로고침하여 '비어있음' UI 표시
	                if(document.querySelectorAll('[id^="cart-row-"]').length === 0) {
	                    location.reload();
	                }
	            } else {
	                alert('삭제 실패');
	            }
	        })
	        .catch(err => console.error(err));
	}
</script>