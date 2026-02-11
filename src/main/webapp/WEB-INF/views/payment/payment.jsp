<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">

<div class="container mx-auto px-4 py-10">
    <div class="max-w-4xl mx-auto bg-white border border-gray-200 shadow-sm rounded-lg overflow-hidden">
        
        <div class="bg-gray-50 px-8 py-6 border-b border-gray-200">
            <h2 class="text-2xl font-bold text-gray-800">${pageTitle}</h2>
            <p class="text-sm text-gray-500 mt-1">주문 정보를 확인하신 후 결제 수단을 선택해 주세요.</p>
        </div>

        <div class="p-8 space-y-10">
            
        <section>
		    <div class="flex items-center mb-4">
		        <div class="w-1 h-6 bg-blue-600 mr-3"></div>
		        <h3 class="text-lg font-bold text-gray-900">주문 정보</h3>
		    </div>
		    <div class="bg-gray-50 border border-gray-200 rounded-md overflow-hidden">
		        <div class="flex flex-col md:flex-row divide-y md:divide-y-0 md:divide-x divide-gray-200">
		            <div class="flex-1 p-4 flex justify-between items-center bg-white">
		                <span class="text-sm text-gray-600">주문번호</span>
		                <span class="font-semibold text-gray-900">${paymentView.orderNo}</span>
		            </div>
		            <div class="flex-1 p-4 flex justify-between items-center bg-blue-50">
		                <span class="text-sm text-blue-700 font-medium">최종 결제 금액</span>
		                <span class="text-2xl font-black text-blue-600">
		                    <fmt:formatNumber value="${paymentView.totalPrice}" pattern="#,###"/> 원
		                </span>
		            </div>
		        </div>
		    </div>
		</section>

            <section>
                <div class="flex items-center mb-4">
                    <div class="w-1 h-6 bg-blue-600 mr-3"></div>
                    <h3 class="text-lg font-bold text-gray-900">주문 품목 상세</h3>
                </div>
                <div class="border border-gray-200 rounded-md overflow-hidden">
                    <table class="w-full text-sm text-left border-collapse">
                        <thead class="bg-gray-50 border-b border-gray-200 text-gray-600 font-medium">
                            <tr>
                                <th class="p-4">품목명</th>
                                <th class="p-4 text-right">단가</th>
                                <th class="p-4 text-right">수량</th>
                                <th class="p-4 text-right font-bold text-gray-800">소계</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${paymentView.itemList}">
                                <tr class="border-b border-gray-100 last:border-0 hover:bg-gray-50 transition-colors">
                                    <td class="p-4 text-gray-900 font-medium">${item.fuelNm}</td>
                                    <td class="p-4 text-right text-gray-700">
									    <c:choose>
									        <c:when test="${not empty item.targetProductPrc and item.targetProductPrc > 0}">
									            <span class="text-[10px] bg-orange-100 text-orange-600 px-1 rounded mr-1">협의가</span>
									            <fmt:formatNumber value="${item.targetProductPrc}" pattern="#,###"/>원
									        </c:when>
									        <c:otherwise>
									            <fmt:formatNumber value="${item.baseUnitPrc}" pattern="#,###"/>원
									        </c:otherwise>
									    </c:choose>
									</td>
                                    <td class="p-4 text-right text-gray-700">${item.totalQty} UNIT</td>
                                    <td class="p-4 text-right font-bold text-gray-900">
                                        <c:choose>
									        <c:when test="${not empty item.targetProductAmount and item.targetProductAmount > 0}">
									            <span class="text-[10px] bg-orange-100 text-orange-600 px-1 rounded mr-1">협의가</span>
									            <fmt:formatNumber value="${item.targetProductAmount}" pattern="#,###"/>원
									        </c:when>
									        <c:otherwise>
									            <fmt:formatNumber value="${item.totalPrice}" pattern="#,###"/>원
									        </c:otherwise>
									    </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </section>

            <section>
                <div class="flex items-center mb-4">
                    <div class="w-1 h-6 bg-blue-600 mr-3"></div>
                    <h3 class="text-lg font-bold text-gray-900">결제자 정보</h3>
                </div>
                <div class="border border-gray-200 rounded-md overflow-hidden text-sm">
				    <div class="grid grid-cols-4 border-b border-gray-100">
				        <div class="bg-gray-50 p-4 font-medium text-gray-600">회사명 / 대표</div>
				        <div class="p-4 text-gray-900">${paymentView.companyName} / ${paymentView.masterName}</div>
				        <div class="bg-gray-50 p-4 font-medium text-gray-600">사업자 번호</div>
				        <div class="p-4 text-gray-900">${paymentView.bizNumber}</div>
				    </div>
				    <div class="grid grid-cols-4 border-b border-gray-100">
				        <div class="bg-gray-50 p-4 font-medium text-gray-600">담당자 (연락처)</div>
				        <div class="p-4 text-gray-900">${paymentView.userName} (${paymentView.phone})</div>
				        <div class="bg-gray-50 p-4 font-medium text-gray-6:00">회사 연락처</div>
				        <div class="p-4 text-gray-900">${paymentView.companyPhone}</div>
				    </div>
				    <div class="grid grid-cols-4">
				        <div class="bg-gray-50 p-4 font-medium text-gray-600">회사 주소</div>
				        <div class="p-4 text-gray-900 col-span-3">[${paymentView.zipCode}] ${paymentView.addrKor}</div>
				    </div>
				</div>
            </section>

            <section>
                <div class="flex items-center mb-4">
                    <div class="w-1 h-6 bg-blue-600 mr-3"></div>
                    <h3 class="text-lg font-bold text-gray-900">결제 수단 선택</h3>
                </div>
                <div class="grid grid-cols-2 gap-4">
                    <label class="relative flex flex-col p-4 border border-gray-200 rounded-lg cursor-pointer hover:bg-gray-50">
                        <input type="radio" name="payMethod" value="CARD" class="absolute top-4 right-4" checked>
                        <span class="text-base font-bold text-gray-900">신용/체크카드</span>
                        <span class="text-xs text-gray-500 mt-1">모든 카드사 이용 가능</span>
                    </label>
                    <label class="relative flex flex-col p-4 border border-gray-200 rounded-lg cursor-pointer hover:bg-gray-50">
                        <input type="radio" name="payMethod" value="VACCOUNT" class="absolute top-4 right-4">
                        <span class="text-base font-bold text-gray-900">가상계좌</span>
                        <span class="text-xs text-gray-500 mt-1">무통장 입금 (현금영수증 가능)</span>
                    </label>
                </div>
            </section>

            <div class="pt-6">
                <button id="checkoutBtn" class="w-full py-4 bg-blue-600 hover:bg-blue-700 text-white text-lg font-bold rounded shadow-md transition-all active:scale-[0.98]">
                   1차 결제하기
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://js.tosspayments.com/v1/payment"></script>
<script>
    // 페이지와 외부 스크립트가 모두 로드된 후 실행
    window.addEventListener('load', function() {
        const clientKey = '${tossCk}'; 
        
        // 1. 초기화
        const tossPayments = TossPayments(clientKey);
        
        // 2. 주문명 설정
        const displayOrderName = '${paymentView.itemList[0].fuelNm}' + 
    	(${fn:length(paymentView.itemList)} > 1 ? ' 외 ${fn:length(paymentView.itemList) - 1}건' : '');

        // 3. 버튼 클릭 이벤트 등록
        document.getElementById('checkoutBtn').addEventListener('click', async function () {
            const method = document.querySelector('input[name="payMethod"]:checked').value;
            const btn = this;

            btn.disabled = true;
            btn.innerText = "결제창을 불러오는 중...";

            try {
            	await tossPayments.requestPayment(method, {
            	    amount: ${paymentView.totalPrice}, 
            	    orderId: '${paymentView.orderNo}', 
            	    orderName: displayOrderName,
            	    successUrl: window.location.origin + '${pageContext.request.contextPath}/payment/success' 
            	               + '?payStep=FIRST'
            	               + '&orderNo=${paymentView.orderNo}'
            	               + '&dbOrderId=${paymentView.orderId}'
            	               + '&tossOrderId=${paymentView.orderNo}',
            	    failUrl: window.location.origin + '${pageContext.request.contextPath}/payment/fail',
            	    customerName: '${paymentView.userName}'
            	});
            } catch (error) {
                console.error(error);
                btn.disabled = false;
                btn.innerText = "1차 결제하기";
                if (error.code !== 'USER_CANCEL') {
                    alert("결제 중 오류가 발생했습니다: " + error.message);
                }
            }
        });
    });
</script>
</body>
</html>