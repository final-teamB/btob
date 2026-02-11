<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>결제 실패</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 flex items-center justify-center min-h-screen">

<div class="max-w-md w-full bg-white shadow-lg rounded-xl p-10 text-center">
    <div class="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-red-100 mb-6">
        <svg class="h-10 w-10 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
        </svg>
    </div>

    <h2 class="text-2xl font-bold text-gray-800 mb-2">결제에 실패하였습니다</h2>
    <p class="text-gray-500 mb-8">결제 도중 오류가 발생했습니다. 아래 사유를 확인해 주세요.</p>

    <div class="bg-red-50 rounded-lg p-6 mb-8 text-left">
        <div class="mb-2">
            <span class="text-xs font-bold text-red-400 uppercase tracking-wider">Error Code</span>
            <p class="text-sm font-mono text-red-700">${errorCode}</p>
        </div>
        <div>
            <span class="text-xs font-bold text-red-400 uppercase tracking-wider">Reason</span>
            <p class="text-sm text-red-700 font-medium">${errorMessage}</p>
        </div>
    </div>

    <div class="space-y-3">
        <button onclick="location.href='${pageContext.request.contextPath}/payment/payment?orderNo=${orderNo}'" 
		        class="w-full bg-gray-800 text-white font-bold py-3 rounded-lg hover:bg-black transition">
		    다시 결제 시도하기
		</button>
        <button onclick="location.href='${pageContext.request.contextPath}/main'" 
                class="w-full bg-white border border-gray-200 text-gray-600 py-3 rounded-lg hover:bg-gray-50 transition">
            홈으로 이동
        </button>
    </div>
</div>

</body>
</html>