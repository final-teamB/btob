<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결제하기</title>
<script src="https://js.tosspayments.com/v2/standard"></script>
<style>
    body { font-family: 'Malgun Gothic', sans-serif; padding: 20px; line-height: 1.6; }
    .order-box { border: 1px solid #ddd; padding: 20px; border-radius: 8px; background: #f9f9f9; }
    .method-box { margin-top: 25px; border: 1px solid #eee; padding: 20px; border-radius: 8px; }
    .method-group { margin-bottom: 15px; }
    label { cursor: pointer; margin-right: 15px; font-size: 16px; }
    #checkoutBtn { 
        width: 100%; padding: 15px; background: #3182f6; color: white; 
        border: none; border-radius: 8px; font-size: 18px; font-weight: bold; cursor: pointer;
    }
    #checkoutBtn:hover { background: #1b64da; }
</style>
</head>
<body>
    <h1>주문 결제</h1>

    <div class="order-box">
        <h3>주문 상품 정보</h3>
        <ul id="itemList"></ul>
        <hr>
        <h4>총 결제 금액: <span id="totalPrice" style="color: #3182f6;">0</span>원</h4>
    </div>

    <div class="method-box">
        <h3>결제 수단 선택</h3>
        <div class="method-group">
            <p><strong>일반결제</strong></p>
            <label><input type="radio" name="payMethod" value="CARD" checked> 신용/체크카드</label>
            <label><input type="radio" name="payMethod" value="VACCOUNT"> 가상계좌(무통장)</label>
        </div>
        <br>
        <button id="checkoutBtn">결제하기</button>
    </div>

<script>
        // 1. 세션스토리지 데이터 로드 및 화면 출력
        const selectedData = JSON.parse(sessionStorage.getItem("selectedItems"));
        const itemListEl = document.getElementById("itemList");
        const totalPriceEl = document.getElementById("totalPrice");
        
        let total = 0;
        
     // 화면 출력 및 금액 합산
        if (selectedData && selectedData.length > 0) {
            selectedData.forEach(item => {
                const name = item.name || "상품명 없음";
                const qty = Number(item.qty) || 0;
                const price = Number(item.price) || 0;
                const itemTotal = qty * price;

                const li = document.createElement("li");
                // 변수명이 정확해야 (개), 원이 표시됩니다.
                li.innerText = name + " (" + qty + "개) - " + itemTotal.toLocaleString() + "원";
                itemListEl.appendChild(li);
                
                total += itemTotal;
            });
            totalPriceEl.innerText = total.toLocaleString() + "원";
        } else {
            alert("주문 정보가 없습니다.");
            location.href = "${pageContext.request.contextPath}/testjg/test";
        }
        // 2. 토스페이먼츠 SDK 초기화
        // 컨트롤러에서 보낸 클라이언트 키(${tossCk})를 사용합니다.
        const tossPayments = TossPayments("${tossCk}"); 
        const payment = tossPayments.payment({
            customerKey: 'ANONYMOUS' 
        });

        // 3. 결제 버튼 클릭 이벤트
	document.getElementById("checkoutBtn").addEventListener("click", async () => {
    const selected = document.querySelector('input[name="payMethod"]:checked').value;
    
    // 공통 옵션 (성공/실패 URL 등)
    const baseOptions = {
        amount: { currency: "KRW", value: total },
        orderId: 'order-' + new Date().getTime(),
        orderName: selectedData[0].name + (selectedData.length > 1 ? " 외" : ""),
        successUrl: window.location.origin + "${pageContext.request.contextPath}/testjg/tossSuccess",
        failUrl: window.location.origin + "${pageContext.request.contextPath}/testjg/tossFail",
    };

    try {
        if (selected === "VACCOUNT") {
            // 1. 가상계좌 (무통장 입금) 호출
            await payment.requestPayment({
                method: "VIRTUAL_ACCOUNT",
                ...baseOptions
            });
        } else {
            // 2. 카드, 카카오페이, 토스페이 모두 이쪽(통합창)으로 호출
            // 토스 통합 결제창이 뜨면서 사용자가 그 안에서 카카오/토스를 선택하게 됩니다.
            await payment.requestPayment({
                method: "CARD",
                ...baseOptions
            });
        }
    } catch (error) {
        // 만약 '정의되지 않은 파라미터' 에러가 또 뜨면, 
        // 그냥 가장 단순한 방법으로 호출하도록 유도합니다.
        console.error(error);
        alert("결제창 호출 중 오류가 발생했습니다. 통합 결제창으로 진행합니다.");
        
        await payment.requestPayment({
            method: "CARD",
            ...baseOptions
        });
    }
});
</script>
</body>
</html>