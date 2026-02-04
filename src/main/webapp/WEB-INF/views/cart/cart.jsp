<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="mx-4 my-6 space-y-6">

    <div>
        <h1 class="text-2xl font-bold text-gray-800 dark:text-white">${pageTitle}</h1>
    </div>
    
    <!-- 장바구니 테이블 -->
     <c:choose>
           <c:otherwise>
            <section class="bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 dark:border-gray-700 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="min-w-full leading-normal">
                        <thead>
                            <tr class="bg-gray-50 dark:bg-gray-700 text-gray-500 dark:text-gray-400 text-xs font-bold uppercase tracking-wider">
                                <th class="px-5 py-3 border-b border-gray-100 dark:border-gray-700 text-left">상품명</th>
                                <th class="px-5 py-3 border-b border-gray-100 dark:border-gray-700 text-left">수량</th>
                                <th class="px-5 py-3 border-b border-gray-100 dark:border-gray-700 text-left">단가</th>
                                <th class="px-5 py-3 border-b border-gray-100 dark:border-gray-700 text-left">합계</th>
                                <th class="px-5 py-3 border-b border-gray-100 dark:border-gray-700 text-center">삭제</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100 dark:divide-gray-700">
                            <c:forEach var="c" items="${cartList}">
                                <tr id="cart-row-${c.cart_id}" class="hover:bg-gray-50 dark:hover:bg-gray-700/50 transition">
                                    <td class="px-5 py-4 text-sm text-gray-900 dark:text-white font-medium">${c.fuel_nm}</td>

                                    <td class="px-5 py-4 text-sm text-gray-600 dark:text-gray-400">
                                        <div class="flex items-center justify-center space-x-2">
		                                  <c:if test="${cartStatus == 'PENDING'}">
											    <button type="button" class="px-2 py-1 bg-gray-200 dark:bg-gray-700 rounded hover:bg-gray-300 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300"
											            onclick="decreaseQty(${c.cart_id}, ${c.base_unit_prc})">-</button>
											
											    <input type="number" id="qty-${c.cart_id}" value="${c.total_qty}" min="1"
											           class="w-12 text-center rounded border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white"
											           onchange="updateCartQty(${c.cart_id}, this.value, ${c.base_unit_prc})">
											
											    <button type="button" class="px-2 py-1 bg-gray-200 dark:bg-gray-700 rounded hover:bg-gray-300 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300"
											            onclick="increaseQty(${c.cart_id}, ${c.base_unit_prc})">+</button>
											</c:if>

                                            <c:if test="${cartStatus != 'PENDING'}">
                                                <input type="number" value="${c.total_qty}" class="w-12 text-center rounded border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white" readonly>
                                            </c:if>
                                        </div>
                                    </td>

                                    <td class="px-5 py-4 text-sm text-gray-600 dark:text-gray-400" id="unit-${c.cart_id}" data-price="${c.base_unit_prc}">₩${c.base_unit_prc}</td>
                                    <td class="px-5 py-4 text-sm text-gray-900 dark:text-white font-medium" id="total-${c.cart_id}">₩${c.total_price}</td>

                                    <td class="px-5 py-4 text-sm text-center">
                                        <c:if test="${cartStatus == 'PENDING'}">
                                            <button type="button"
                                                    class="w-6 h-6 flex items-center justify-center text-white bg-red-500 rounded-full hover:bg-red-600 transition-shadow shadow-sm"
                                                    onclick="deleteCartItem(${c.cart_id})"
                                                    title="삭제">
                                                ×
                                            </button>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty cartList}">
                                <tr>
                                    <td colspan="5" class="px-5 py-10 text-center text-gray-400 dark:text-gray-500">장바구니에 상품이 없습니다.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- 하단 버튼/메시지 영역 -->
                <div class="px-5 py-6 flex justify-end space-x-3 bg-white dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700">
                    <c:choose>
                        <c:when test="${cartStatus == 'PENDING'}">
                            <form action="${pageContext.request.contextPath}/cart/estimate" method="post">
                                <button type="submit" class="px-5 py-2 text-sm font-medium text-white bg-blue-600 rounded-lg hover:bg-blue-500 dark:bg-blue-500 dark:hover:bg-blue-400 transition shadow-sm">
                                    견적 승인 요청
                                </button>
                            </form>
                            <form action="${pageContext.request.contextPath}/cart/order" method="post">
                                <button type="submit" class="px-5 py-2 text-sm font-medium text-white bg-green-600 rounded-lg hover:bg-green-500 dark:bg-green-500 dark:hover:bg-green-400 transition shadow-sm">
                                    주문 승인 요청
                                </button>
                            </form>
                        </c:when>
                        <c:when test="${cartStatus == 'REQ'}">
                            <span class="px-5 py-2 text-sm font-medium text-gray-500 dark:text-gray-400">
                                승인 요청중입니다.
                            </span>
                        </c:when>
                        <c:when test="${cartStatus == 'APPROVED'}">
						    <form action="${pageContext.request.contextPath}/cart/payment">
						        <button type="submit" 
						                class="px-5 py-2 text-sm font-medium text-white bg-green-600 rounded-lg 
						                       hover:bg-green-500 dark:bg-green-500 dark:hover:bg-green-400 transition shadow-sm">
						            결제 요청
						        </button>
						    </form>
						</c:when>
                    </c:choose>
                </div>
            </section>
        </c:otherwise>
    </c:choose>
</div>

<script>
    function increaseQty(cartId, unitPrice) {
        const input = document.getElementById(`qty-${cartId}`);
        let qty = parseInt(input.value) + 1;
        input.value = qty;
        updateCartQty(cartId, qty, unitPrice);
    }

    function decreaseQty(cartId, unitPrice) {
        const input = document.getElementById(`qty-${cartId}`);
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
            if(data.result !== 'success') {
                alert('수량 변경 실패');
            } else {
                document.getElementById(`total-${cartId}`).innerText = '₩' + (unitPrice * qty).toLocaleString();
            }
        });
    }

    function deleteCartItem(cartId) {
        if(!confirm('정말 삭제하시겠습니까?')) return;
        fetch(`${pageContext.request.contextPath}/cart/delete?cartId=${cartId}`, { method: 'POST' })
            .then(res => res.json())
            .then(data => {
                if(data.result === 'success') {
                    document.getElementById(`cart-row-${cartId}`).remove();
                } else {
                    alert('삭제 실패');
                }
            })
            .catch(err => console.error(err));
    }
</script>
