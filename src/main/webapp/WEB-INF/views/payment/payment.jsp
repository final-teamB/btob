<div class="container mx-auto px-4 py-10">
    <div>
        
        <div class="bg-gray-50 px-8 py-6">
            <h2 class="text-2xl font-bold text-gray-800">${pageTitle}</h2>
            <p class="text-sm text-gray-500 mt-1">주문 정보를 확인하신 후 결제 수단을 선택해 주세요.</p>
        </div>

        <div class="p-8 space-y-10">
            
          완성된 Mapper와 DTO 구조에 맞춰서, 리스트 형태의 상세 품목 정보를 출력하는 섹션을 추가하고 코드를 정돈해 드립니다.

itemList가 null이 아닐 때만 반복문을 돌려 상세 내역을 보여주고, 전체적인 스타일은 유지했습니다.

🛠️ 최종 Payment.jsp (상세 품목 리스트 추가 버전)
HTML
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
                    <h3 class="text-lg font-bold text-gray-900">주문 요약</h3>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-px bg-gray-200 border border-gray-200 rounded-md overflow-hidden">
                    <div class="bg-gray-50 p-4 flex justify-between items-center">
                        <span class="text-sm text-gray-600">주문번호</span>
                        <span class="font-semibold text-gray-900">${paymentView.orderNo}</span>
                    </div>
                    <div class="bg-white p-4 flex justify-between items-center">
                        <span class="text-sm text-gray-600">대표 품목</span>
                        <span class="font-semibold text-gray-900">${paymentView.fuelNm}</span>
                    </div>
                    <div class="bg-white p-4 flex justify-between items-center">
                        <span class="text-sm text-gray-600">총 수량</span>
                        <span class="font-semibold text-gray-900">${paymentView.totalQty} UNIT</span>
                    </div>
                    <div class="bg-gray-50 p-4 flex justify-between items-center">
                        <span class="text-sm text-gray-600">최종 결제 금액</span>
                        <span class="text-xl font-bold text-blue-600">${paymentView.totalPrice} 원</span>
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
                                        <c:if test="${not empty item.targetProductPrc}">
                                            <span class="text-[10px] bg-orange-100 text-orange-600 px-1 rounded mr-1">협의가</span>
                                        </c:if>
                                        ${item.apprUnitPrc}원
                                    </td>
                                    <td class="p-4 text-right text-gray-700">${item.totalQty} UNIT</td>
                                    <td class="p-4 text-right font-bold text-gray-900">${item.totalPrice}원</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </section>

            <section>
                <div class="flex items-center mb-4">
                    <div class="w-1 h-6 bg-blue-600 mr-3"></div>
                    <h3 class="text-lg font-bold text-gray-900">결제자 사업자 정보</h3>
                </div>
                <div class="border border-gray-200 rounded-md">
                    <table class="w-full text-sm text-left border-collapse">
                        <tbody>
                            <tr class="border-b border-gray-100">
                                <th class="w-1/4 bg-gray-50 p-4 font-medium text-gray-600">회사명</th>
                                <td class="p-4 text-gray-900">${paymentView.companyName}</td>
                                <th class="w-1/4 bg-gray-50 p-4 font-medium text-gray-600">사업자 번호</th>
                                <td class="p-4 text-gray-900">${paymentView.bizNumber}</td>
                            </tr>
                            <tr class="border-b border-gray-100">
                                <th class="bg-gray-50 p-4 font-medium text-gray-600">대표자</th>
                                <td class="p-4 text-gray-900">${paymentView.masterName}</td>
                                <th class="bg-gray-50 p-4 font-medium text-gray-600">연락처</th>
                                <td class="p-4 text-gray-900">${paymentView.companyPhone}</td>
                            </tr>
                            <tr class="border-b border-gray-100">
                                <th class="bg-gray-50 p-4 font-medium text-gray-600">담당자</th>
                                <td class="p-4 text-gray-900">${paymentView.userName}</td>
                                <th class="bg-gray-50 p-4 font-medium text-gray-600">연락처</th>
                                <td class="p-4 text-gray-900">${paymentView.phone}</td>
                            </tr>
                            <tr class="border-b border-gray-100">
                                <th class="bg-gray-50 p-4 font-medium text-gray-600">회사 주소</th>
                                <td colspan="3" class="p-4 text-gray-900">[${paymentView.zipCode}] ${paymentView.addrKor}</td>
                            </tr>
                            <tr class="border-b border-gray-100">
                                <th class="bg-gray-50 p-4 font-medium text-gray-600">영문 주소</th>
                                <td colspan="3" class="p-4 text-gray-900">${paymentView.addrEng}</td>
                            </tr>
                            <tr>
                                <th class="bg-gray-50 p-4 font-medium text-gray-600">통관 번호</th>
                                <td colspan="3" class="p-4 text-gray-900">${paymentView.customsNum}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </section>

            <section>
                <div class="flex items-center mb-4">
                    <div class="w-1 h-6 bg-blue-600 mr-3"></div>
                    <h3 class="text-lg font-bold text-gray-900">결제 수단 선택</h3>
                </div>
                <div class="grid grid-cols-2 gap-4">
                    <label class="relative flex flex-col p-4 border border-gray-200 rounded-lg cursor-pointer hover:bg-gray-50 has-[:checked]:border-blue-600 has-[:checked]:bg-blue-50 transition">
                        <input type="radio" name="payMethod" value="CARD" class="absolute top-4 right-4 h-4 w-4 text-blue-600 border-gray-300 focus:ring-blue-500" checked>
                        <span class="text-base font-bold text-gray-900">신용/체크카드</span>
                        <span class="text-xs text-gray-500 mt-1">모든 카드사 이용 가능</span>
                    </label>
                    <label class="relative flex flex-col p-4 border border-gray-200 rounded-lg cursor-pointer hover:bg-gray-50 has-[:checked]:border-blue-600 has-[:checked]:bg-blue-50 transition">
                        <input type="radio" name="payMethod" value="VACCOUNT" class="absolute top-4 right-4 h-4 w-4 text-blue-600 border-gray-300 focus:ring-blue-500">
                        <span class="text-base font-bold text-gray-900">가상계좌</span>
                        <span class="text-xs text-gray-500 mt-1">무통장 입금 (지출증빙 가능)</span>
                    </label>
                </div>
            </section>

            <div class="pt-6">
                <button id="checkoutBtn" class="w-full py-4 bg-blue-600 hover:bg-blue-700 text-white text-lg font-bold rounded shadow-md transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
                   1차 결제하기
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://js.tosspayments.com/v2/payment"></script>
네, 맞습니다! 방금 올려주신 Payment.jsp의 UI 구조와 토스페이먼츠 v2 SDK 환경에 맞춰 스크립트 로직을 최종 정리해 드릴게요.

현재 코드에서 세션 스토리지 기반의 로직과 DB 기반의 paymentView 데이터를 혼동하지 않도록 DB 데이터를 우선으로 하되, 동적인 UI 처리를 깔끔하게 보정했습니다.

🛠️ 보정된 Payment.jsp 스크립트 (v2 SDK 기준)
HTML
<script src="https://js.tosspayments.com/v2/payment"></script>
<script>
    // 1. 초기화 (Properties에서 가져온 키 사용)
    const clientKey = '${tossCk}'; 
    const tossPayments = TossPayments(clientKey);

    // 2. 결제 버튼 이벤트
    document.getElementById('checkoutBtn').addEventListener('click', async function () {
        const method = document.querySelector('input[name="payMethod"]:checked').value;
        const btn = this;

        // 중복 클릭 방지
        btn.disabled = true;
        btn.innerText = "결제창을 불러오는 중...";

        try {
            await tossPayments.requestPayment({
                method: method,
                amount: {
                    currency: "KRW",
                    value: ${paymentView.totalPrice}
                },
                orderNo: '${paymentView.orderNo}',
                orderName: '${paymentView.fuelNm}' + 
                           <c:if test="${fn:length(paymentView.itemList) > 1}">
                           ' 외 ${fn:length(paymentView.itemList) - 1}건'
                           </c:if> '',
                successUrl: window.location.origin + '${pageContext.request.contextPath}/payment/success?orderNo=${paymentView.orderNo}',
                failUrl: window.location.origin + '${pageContext.request.contextPath}/payment/fail',
                customerName: '${paymentView.userName}',
                customerEmail: '', // 필요 시 추가 가능
            });
        } catch (error) {
            console.error(error);
            if (error.code === 'USER_CANCEL') {
                // 사용자가 결제창을 닫은 경우
                btn.disabled = false;
                btn.innerText = "1차 결제하기";
            } else {
                alert("결제창 호출 중 오류가 발생했습니다: " + error.message);
                btn.disabled = false;
                btn.innerText = "1차 결제하기";
            }
        }
    });
</script>