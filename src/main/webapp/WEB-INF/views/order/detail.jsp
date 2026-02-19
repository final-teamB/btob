<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script src="https://cdn.tailwindcss.com"></script>
<body class="bg-gray-50 p-6">
    <div class="max-w-3xl mx-auto space-y-6">
        
        <div class="bg-white p-4 rounded-lg shadow-sm border border-gray-200">
            <div class="flex justify-between items-center">
                <h2 class="text-lg font-bold text-gray-800">주문 상세 정보</h2>
                <span class="px-3 py-1 bg-blue-100 text-blue-700 rounded-full text-sm font-bold">${order.statusNm}</span>
            </div>
           <p class="text-sm text-gray-500 mt-1">
			    주문번호: ${order.orderNo} | 주문일시: 
			    <fmt:parseDate value="${order.regDtime}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" />
			    <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm:ss" />
			</p>
        </div>

        <div class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
            <div class="px-4 py-3 border-b bg-gray-50 font-bold text-gray-700">구매 상품</div>
            <table class="w-full text-left border-collapse">
                <thead class="bg-gray-50 text-xs uppercase text-gray-500">
                    <tr>
                        <th class="px-4 py-2">상품명</th>
                        <th class="px-4 py-2 text-right">단가</th>
                        <th class="px-4 py-2 text-center">수량</th>
                        <th class="px-4 py-2 text-right">합계</th>
                    </tr>
                </thead>
             <tbody class="divide-y divide-gray-100">
			    <c:forEach var="item" items="${order.itemList}" varStatus="status">
			        <tr>
			            <td class="px-4 py-4 text-sm font-medium text-gray-900">
			                ${item.fuelName}
			            </td>
			            <td class="px-4 py-4 text-sm text-right text-gray-600">
			             <c:choose>
			                    <%-- 견적 주문인 경우 (targetTotalAmount가 있을 때) --%>
			                    <c:when test="${not empty item.targetTotalAmount && item.targetTotalAmount > 0}">
			                        <fmt:formatNumber value="${item.targetTotalAmount/item.totalQty}" pattern="#,###"/>원
			                    </c:when>
			                    <%-- 바로 주문인 경우 (totalPrice 사용) --%>
			                    <c:otherwise>
			                        <fmt:formatNumber value="${item.baseUnitPrc}" pattern="#,###"/>원
			                    </c:otherwise>
			                </c:choose>
			            </td>
			            <td class="px-4 py-4 text-sm text-center text-gray-600">
			                ${item.totalQty}
			            </td>
			            <td class="px-4 py-4 text-sm text-right font-bold text-gray-900">
			                <c:choose>
			                    <%-- 견적 주문인 경우 (targetTotalAmount가 있을 때) --%>
			                    <c:when test="${not empty item.targetTotalAmount && item.targetTotalAmount > 0}">
			                        <fmt:formatNumber value="${item.targetTotalAmount}" pattern="#,###"/>원
			                    </c:when>
			                    <%-- 바로 주문인 경우 (totalPrice 사용) --%>
			                    <c:otherwise>
			                        <fmt:formatNumber value="${item.totalPrice}" pattern="#,###"/>원
			                    </c:otherwise>
			                </c:choose>
			            </td>
			        </tr>
			    </c:forEach>
			    
			    <c:if test="${empty order.itemList}">
			        <tr>
			            <td colspan="4" class="px-4 py-10 text-center text-gray-400 text-sm">
			                주문 상품 내역이 없습니다.
			            </td>
			        </tr>
			    </c:if>
			</tbody>
            </table>
        </div>

      <div class="bg-white rounded-lg shadow-sm border border-gray-200">
		    <div class="px-4 py-3 border-b bg-gray-50 font-bold text-gray-700">배송지 정보</div>
		    <div class="p-4 grid grid-cols-1 md:grid-cols-2 gap-y-4 gap-x-8 text-sm">
		        <c:if test="${not empty order.companyName}">
		            <div class="md:col-span-2">
		                <p class="text-gray-500 mb-1">회사명</p>
		                <p class="font-bold text-gray-900 text-base">${order.companyName}</p>
		            </div>
		        </c:if>
		
		        <div>
		            <p class="text-gray-500 mb-1">담당자(수령인)</p>
		            <p class="font-medium text-gray-900">${order.userName}</p>
		        </div>
		        <div>
		            <p class="text-gray-500 mb-1">연락처</p>
		            <p class="font-medium text-gray-900">${order.phone}</p>
		        </div>
		        <div class="md:col-span-2 border-t pt-3">
		            <p class="text-gray-500 mb-1">배송 주소</p>
		            <p class="font-medium text-gray-900">
		                <span class="text-blue-600 font-bold">[${order.zipCode}]</span> ${order.addrKor}
		            </p>
		        </div>
		    </div>
		</div>

        <div class="border rounded-lg p-4 bg-white shadow-sm">
            <h3 class="font-bold mb-3 text-gray-700 border-b pb-2">최종 결제 내역</h3>
      
	   <div class="flex justify-between text-sm mb-2">
		    <span>1차 결제 금액 (상품가 합계)</span>
		    <span class="font-medium text-gray-900">
		        <c:choose>
		            <%-- 1. 결제 정보가 있는 경우 (결제 완료 후) --%>
		            <c:when test="${not empty order.firstPay.amount}">
		                <fmt:formatNumber value="${order.firstPay.amount}" pattern="#,###"/>원 
		                <span class="text-blue-500 ml-1">
		                    <c:if test="${order.firstPay.status == 'DONE'}">(완료)</c:if>
		                    <c:if test="${order.firstPay.status != 'DONE'}">(진행중)</c:if>
		                </span>
		            </c:when>
		            
		            <%-- 2. 결제 정보가 없는 경우 (결제 전) --%>
		            <c:otherwise>
		                <%-- 주문 마스터에 있는 금액이 있다면 그걸 보여주고, 아니면 0원 --%>
		                <span class="text-gray-400">결제 확인 대기 중</span>
		            </c:otherwise>
		        </c:choose>
		    </span>
		</div>
	
	    <hr class="my-3 border-dashed">
	
	    <c:choose>
	        <%-- 2차 결제가 필요한 상태 (pm003) --%>
	        <c:when test="${order.orderStatus == 'pm003'}">
	            <div class="bg-orange-50 p-4 rounded-lg border border-orange-200">
	                <div class="flex justify-between items-center">
	                    <div>
	                        <p class="text-xs text-orange-600 font-bold uppercase tracking-wider">Action Required</p>
	                        <p class="text-lg font-bold text-gray-900">
	                            2차 결제 금액: <span class="text-orange-600"><fmt:formatNumber value="${order.secondPay.amount}" pattern="#,###"/></span>원
	                        </p>
	                    </div>
	                    <button onclick="window.parent.openPaymentPopup('${order.orderNo}')" 
	                            class="bg-orange-500 hover:bg-orange-600 text-white px-6 py-2 rounded-lg font-bold shadow-md transition-all active:scale-95">
	                        2차 결제
	                    </button>
	                </div>
	            </div>
	        </c:when>
	        
	        <%-- 2차 결제까지 완료된 상태 (pm004) --%>
	        <c:when test="${order.orderStatus == 'pm004'}">
	            <div class="flex justify-between text-sm text-green-600 font-bold bg-green-50 p-3 rounded-lg">
	                <span>2차 결제 금액 (배송비/세금)</span>
	                <span><fmt:formatNumber value="${order.secondPay.amount}" pattern="#,###"/>원 (결제 완료)</span>
	            </div>
	        
	        <div class="mt-4 p-4 bg-gray-900 rounded-lg flex justify-between items-center">
			    <span class="text-white font-bold">최종 총 결제 금액</span>
			    <span class="text-xl font-bold text-yellow-400">
			        <fmt:formatNumber value="${order.firstPay.amount + order.secondPay.amount}" pattern="#,###"/>원
			    </span>
			</div>
	        </c:when>
	        
	        <%-- 그 외 상태 (검수 중 등) --%>
	        <c:otherwise>
	            <div class="text-center py-4 text-gray-400 border-2 border-dashed border-gray-100 rounded-lg">
	                <p class="text-sm">2차 결제 금액이 산정되지 않았습니다.</p>
	                <p class="text-[11px]">현지 검수 완료 후 금액이 확정됩니다.</p>
	            </div>
	        </c:otherwise>
	    </c:choose>
	</div>

    </div>
</body>