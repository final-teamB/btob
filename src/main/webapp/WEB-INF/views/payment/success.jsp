<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>결제 완료</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 flex items-center justify-center min-h-screen">

<div class="max-w-md w-full bg-white shadow-lg rounded-xl p-10 text-center">
    <div class="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-green-100 mb-6">
        <svg class="h-10 w-10 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
        </svg>
    </div>

    <h2 class="text-2xl font-bold text-gray-800 mb-2">결제가 완료되었습니다!</h2>
    <p class="text-gray-500 mb-8">주문하신 상품의 결제가 정상적으로 처리되었습니다.</p>

    <div class="bg-gray-50 rounded-lg p-6 mb-8 space-y-3">
        <div class="flex justify-between text-sm">
            <span class="text-gray-500">주문번호</span>
            <span class="font-semibold text-gray-800">${orderNo}</span>
        </div>
        <div class="flex justify-between text-sm">
            <span class="text-gray-500">결제금액</span>
            <span class="font-bold text-blue-600">${amount}원</span>
        </div>
    </div>

	<div class="space-y-3">
	    <button onclick="goToOrderList()" 
	            class="w-full bg-blue-600 text-white font-bold py-3 rounded-lg hover:bg-blue-700 transition shadow-lg shadow-blue-200">
	        주문 내역 확인하기
	    </button>
	    
	    <button onclick="location.href='${pageContext.request.contextPath}/main'" 
	            class="w-full bg-white border border-gray-200 text-gray-600 py-3 rounded-lg hover:bg-gray-50 transition">
	        홈으로 이동
	    </button>
	</div>	

<script>
	function goToOrderList() {
	    const listUrl = '${pageContext.request.contextPath}/order/list';
	    
	    // 만약 팝업으로 띄웠을 때를 대비한 안전장치 (새창 방식이면 else만 작동)
	    if (window.opener && !window.opener.closed) {
	        if (typeof window.opener.fetchData === 'function') {
	            window.opener.fetchData();
	        } else {
	            window.opener.location.reload();
	        }
	        window.close();
	    } else {
	        location.href = listUrl;
	    }
	}
</script>
</div>
</body>
</html>