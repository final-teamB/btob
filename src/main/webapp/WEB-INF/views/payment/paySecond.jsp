<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>유류 수입 2차 결제</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body::-webkit-scrollbar { display: none; }
        .sticky-bottom { position: sticky; bottom: 0; background: white; border-top: 1px solid #e5e7eb; }
    </style>
</head>
<body class="bg-gray-50 text-gray-900 antialiased">

<div class="min-h-screen flex flex-col">
    <div class="bg-white border-b px-6 py-5 sticky top-0 z-10">
        <h2 class="text-xl font-bold text-gray-800">2차 결제(정산) 안내</h2>
        <p class="text-xs text-blue-600 mt-1 font-semibold">통관 완료에 따른 유류세 및 물류비용 확정</p>
    </div>

    <div class="p-6 space-y-6 flex-1">
     
 <section class="bg-white rounded-xl p-8 border border-gray-200 shadow-sm text-center relative">
    <div class="relative">
        <p class="text-gray-500 text-xs font-bold uppercase tracking-widest mb-3">최종 납부 금액</p>
        
        <div class="flex items-baseline justify-center space-x-1">
            <h1 class="text-5xl font-black text-gray-900 tracking-tighter">
                <fmt:formatNumber value="${paymentView.amount}" pattern="#,###"/>
            </h1>
            <span class="text-2xl font-bold text-gray-400">원</span>
        </div>

        <div class="mt-5 inline-flex items-center rounded-full bg-blue-50 px-4 py-1.5 border border-blue-100">
            <span class="relative flex h-2 w-2 mr-2">
                <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-blue-400 opacity-75"></span>
                <span class="relative inline-flex rounded-full h-2 w-2 bg-blue-500"></span>
            </span>
            <span class="text-xs font-bold text-blue-700">관부가세 및 물류비 정산 확정액</span>
        </div>
    </div>
</section>

        <section class="space-y-3">
            <h3 class="text-sm font-bold text-gray-700 flex items-center px-1">
                <span class="w-1 h-3 bg-slate-900 mr-2 rounded-full"></span>정산 세부 내역
            </h3>
            <div class="bg-white border border-gray-200 rounded-xl overflow-hidden shadow-sm">
                <div class="px-5 py-4 flex justify-between border-b border-gray-50 text-sm">
                    <span class="text-gray-500">교통·에너지·환경세 등</span>
                    <span class="font-bold text-gray-900">5,500,000원</span>
                </div>
                <div class="px-5 py-4 flex justify-between border-b border-gray-50 text-sm">
                    <span class="text-gray-500">수입 관세 (8%)</span>
                    <span class="font-bold text-gray-900">1,200,000원</span>
                </div>
                <div class="px-5 py-4 flex justify-between border-b border-gray-50 text-sm">
                    <span class="text-gray-500">저유소 보관 및 상하차비</span>
                    <span class="font-bold text-gray-900">300,000원</span>
                </div>
                <div class="px-5 py-4 flex justify-between text-sm">
                    <span class="text-gray-500">탱크로리 배송비 (20kL)</span>
                    <span class="font-bold text-gray-900">500,000원</span>
                </div>
            </div>
            <p class="text-[11px] text-gray-400 px-1">* 위 금액은 관세법 및 관련 법령에 의거하여 산출된 실제 비용입니다.</p>
        </section>

        <section class="space-y-3">
            <h3 class="text-sm font-bold text-gray-700 flex items-center px-1">
                <span class="w-1 h-3 bg-slate-900 mr-2 rounded-full"></span>결제 수단
            </h3>
            <div class="grid grid-cols-1 gap-2">
                <label class="flex items-center p-4 bg-white border border-gray-200 rounded-xl cursor-pointer has-[:checked]:border-blue-600 has-[:checked]:bg-blue-50">
                    <input type="radio" name="payMethod" value="카드" class="h-5 w-5 text-blue-600" checked>
                    <span class="ml-4 font-bold text-gray-900">신용/체크카드</span>
                </label>
                <label class="flex items-center p-4 bg-white border border-gray-200 rounded-xl cursor-pointer has-[:checked]:border-blue-600 has-[:checked]:bg-blue-50">
                    <input type="radio" name="payMethod" value="가상계좌" class="h-5 w-5 text-blue-600">
                    <span class="ml-4 font-bold text-gray-900">가상계좌 (무통장)</span>
                </label>
            </div>
        </section>
    </div>

    <div class="sticky-bottom p-6 bg-white border-t">
        <button id="checkoutBtn" class="w-full py-4 bg-blue-600 hover:bg-blue-700 text-white text-lg font-bold rounded-xl shadow-lg transition-all active:scale-[0.98]">
            결제하기
        </button>
        <button onclick="window.close()" class="w-full mt-3 py-2 text-sm text-gray-400 hover:text-gray-600 font-medium transition">
            창 닫기
        </button>
    </div>
</div>

<script src="https://js.tosspayments.com/v1/payment"></script>
<script>
    const clientKey = '${tossCk}'; 
    const tossPayments = TossPayments(clientKey);

    document.getElementById('checkoutBtn').addEventListener('click', function () {
        const method = document.querySelector('input[name="payMethod"]:checked').value;
        const btn = this;
        
        // 데이터가 숫자인지 문자열인지 확실히 구분해서 할당
        const amount = Number('${paymentView.amount}'); // 문자열로 받아서 숫자로 변환 (안전)
        const orderNo = '${paymentView.orderNo}';
        const orderId = '${paymentView.orderId}'; // int라도 따옴표로 감싸면 자바스크립트 에러 방지 가능
       

        if (!amount || amount <= 0) {
            alert("결제 금액이 올바르지 않습니다.");
            return;
        }

        const timestamp = new Date().toISOString().replace(/[-:T.Z]/g, "").slice(0, 14);
        const safeOrderNo = orderNo.replace(/[^a-zA-Z0-9-_]/g, '');
        const tossOrderId = "PAY-" + safeOrderNo + "-" + timestamp;

        btn.disabled = true;
        btn.innerHTML = `<span class="flex items-center justify-center">
            <svg class="animate-spin h-5 w-5 mr-3 text-white" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            결제 요청 중...
        </span>`;

        tossPayments.requestPayment(method, {
            amount: amount,
            orderId: tossOrderId,
            orderNo: orderNo,
            orderName: '유류 2차 관부가세 및 물류비',
            successUrl: window.location.origin + '${pageContext.request.contextPath}/payment/success' 
                + '?payStep=SECOND'
                + '&orderNo=' + encodeURIComponent(orderNo)
                + '&orderId=' + orderId
                + '&tossOrderId=' + tossOrderId,
            failUrl: window.location.origin + '${pageContext.request.contextPath}/payment/fail'
            	+ '?orderNo=' + encodeURIComponent(orderNo) + '&payStep=SECOND',
            customerName: '${paymentView.userName}',
        }).catch(function (error) {
            btn.disabled = false;
            btn.innerText = "결제하기";
            console.error("결제 에러:", error);
            if (error.code !== 'USER_CANCEL') {
                alert(error.message);
            }
        });
    });
</script>
</body>
</html>