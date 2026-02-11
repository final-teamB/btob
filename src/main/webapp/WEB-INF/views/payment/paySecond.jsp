<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>2차 결제 진행</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        /* 팝업 특유의 스크롤바 숨김 및 디자인 최적화 */
        body::-webkit-scrollbar { display: none; }
        .sticky-bottom { position: sticky; bottom: 0; background: white; border-top: 1px solid #e5e7eb; }
    </style>
</head>
<body class="bg-gray-50 text-gray-900 antialiased">

<div class="min-h-screen flex flex-col">
    <div class="bg-white border-b px-6 py-5 sticky top-0 z-10">
        <h2 class="text-xl font-bold text-gray-800">2차 결제 안내</h2>
        <p class="text-xs text-gray-500 mt-1 font-medium">배송비 및 관세 등 추가 비용을 결제합니다.</p>
    </div>

    <div class="p-6 space-y-8 flex-1">
        <section class="bg-blue-600 rounded-2xl p-7 shadow-xl shadow-blue-100 text-white text-center">
            <p class="text-blue-100 text-sm font-medium opacity-90 mb-2">결제할 총 금액</p>
            <h1 class="text-4xl font-black">
                <fmt:formatNumber value="${paymentView.amount}" pattern="#,###"/>원
            </h1>
        </section>

        <section class="space-y-3">
            <h3 class="text-sm font-bold text-gray-700 flex items-center px-1">
                <span class="w-1 h-3 bg-blue-600 mr-2 rounded-full"></span>항목 상세
            </h3>
            <div class="bg-white border border-gray-200 rounded-xl overflow-hidden shadow-sm text-sm">
                <div class="px-5 py-4 flex justify-between border-b border-gray-50">
                    <span class="text-gray-500">주문 번호</span>
                    <span class="font-bold text-gray-900">${paymentView.orderNo}</span>
                </div>
                <div class="px-5 py-4 flex justify-between">
                    <span class="text-gray-500">결제 항목</span>
                    <span class="text-gray-900 font-medium">물류비 및 대행 수수료</span>
                </div>
            </div>
        </section>

        <section class="space-y-3">
            <h3 class="text-sm font-bold text-gray-700 flex items-center px-1">
                <span class="w-1 h-3 bg-blue-600 mr-2 rounded-full"></span>결제 수단 선택
            </h3>
            <div class="grid grid-cols-1 gap-3">
                <label class="group flex items-center p-4 bg-white border border-gray-200 rounded-xl cursor-pointer hover:border-blue-300 hover:bg-blue-50/30 transition-all has-[:checked]:border-blue-600 has-[:checked]:bg-blue-50">
                    <input type="radio" name="payMethod" value="CARD" class="h-5 w-5 text-blue-600 border-gray-300 focus:ring-blue-500" checked>
                    <div class="ml-4">
                        <p class="font-bold text-gray-900">신용/체크카드</p>
                        <p class="text-xs text-gray-400 group-has-[:checked]:text-blue-500">일시불 / 할부 가능</p>
                    </div>
                </label>
                <label class="group flex items-center p-4 bg-white border border-gray-200 rounded-xl cursor-pointer hover:border-blue-300 hover:bg-blue-50/30 transition-all has-[:checked]:border-blue-600 has-[:checked]:bg-blue-50">
                    <input type="radio" name="payMethod" value="VACCOUNT" class="h-5 w-5 text-blue-600 border-gray-300 focus:ring-blue-500">
                    <div class="ml-4">
                        <p class="font-bold text-gray-900">가상계좌</p>
                        <p class="text-xs text-gray-400 group-has-[:checked]:text-blue-500">무통장 입금 방식</p>
                    </div>
                </label>
            </div>
        </section>
    </div>

    <div class="sticky-bottom p-6 space-y-3">
        <button id="checkoutBtn" class="w-full py-4 bg-gray-900 hover:bg-black text-white text-lg font-extrabold rounded-2xl shadow-lg transition-all active:scale-[0.98]">
           결제하기
        </button>
        <button onclick="window.close()" class="w-full py-2 text-sm text-gray-400 hover:text-gray-600 font-medium transition">
            다음에 결제 (창 닫기)
        </button>
    </div>
</div>

<script src="https://js.tosspayments.com/v2/payment"></script>
<script>
    const clientKey = '${tossCk}'; 
    const tossPayments = TossPayments(clientKey);

    document.getElementById('checkoutBtn').addEventListener('click', async function () {
        const method = document.querySelector('input[name="payMethod"]:checked').value;
        const btn = this;

        btn.disabled = true;
        btn.innerText = "결제창 호출 중...";

        try {
            await tossPayments.requestPayment({
                method: method,
                amount: {
                    currency: "KRW",
                    value: ${paymentView.amount}
                },
                // 1차 결제와 구분하기 위해 _2nd 접미사 추가
                orderId: '${paymentView.orderNo}_2nd', 	
                orderName: '2차 추가비용 결제',
                successUrl: window.location.origin + '${pageContext.request.contextPath}/payment/success' 
                + '?payStep=SECOND'
                + '&orderNo=${paymentView.orderNo}'
                + '&orderId=${paymentView.orderId}' // 이 숫자값이 넘어가야 서버에서 int로 바로 받습니다.
                + '&tossOrderId=${paymentView.orderNo}_2nd', // 승인 API용 문자열 필드
                failUrl: window.location.origin + '${pageContext.request.contextPath}/payment/fail',
                customerName: '${paymentView.userName}',
            });
        } catch (error) {
            console.error(error);
            btn.disabled = false;
            btn.innerText = "결제하기";
            if (error.code !== 'USER_CANCEL') {
                alert("결제 준비 중 오류가 발생했습니다: " + error.message);
            }
        }
    });
</script>

</body>
</html>