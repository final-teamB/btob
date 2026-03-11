<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ESTIMATE | (주)글로벌 유류 트레이딩</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.tailwindcss.com"></script>
<style>
    @media print {
        @page { margin: 15mm 10mm; }
        .h-full { height: auto !important; min-height: 0 !important; }
        body { 
            -webkit-print-color-adjust: exact !important; 
            print-color-adjust: exact !important; 
            background-color: white !important;
        }
        .no-print { display: none !important; }
        .print-shadow-none { box-shadow: none !important; border: 1px solid #e5e7eb !important; }
        
        /* 합계 박스 가로 폭 강제 통일 */
        .grid-cols-12 { display: flex !important; gap: 1.5rem !important; }
        .col-span-5 { width: 42% !important; }
        .col-span-7 { width: 58% !important; }
    }
    
    body { font-family: 'Pretendard', sans-serif; background-color: #f9fafb; letter-spacing: -0.025em; }
    /* 숫자 폰트 가독성을 위한 설정 */
    .font-mono { font-feature-settings: "tnum"; font-variant-numeric: tabular-nums; }
</style>
</head>
<body class="py-10">
<%-- 이 건이 '반려' 상태인지 체크 (하나라도 해당하면 true) --%>
<c:set var="isRejected" value="${info.orderStatus eq 'et999' || info.orderStatus eq 'od999' || info.orderStatus eq 'pr999'}" />
<%-- 이 건이 '수정 불가능(읽기 전용)' 상태인지 체크 --%>
<c:set var="isReadOnly" value="${not empty info.estNo && !isRejected}" />

    <div class="max-w-screen-2xl mx-auto px-4">
        <div class="bg-white p-12 rounded-xl shadow-lg border border-gray-100 print-shadow-none">
            
            <%-- 1. 상단 헤더 영역 --%>
            <div class="flex justify-between items-end border-b-4 border-gray-800 pb-8 mb-10">
                <div>
                    <h2 class="text-4xl font-black text-gray-900 tracking-tighter uppercase italic">Estimate</h2>
                    <p class="mt-4 text-sm text-gray-500">견적번호: 
                        <span class="font-bold text-gray-800 italic uppercase">
                            <c:out value="${not empty info.estNo ? info.estNo : 'Approval Pending'}" />
                        </span>
                    </p>
                </div>
                <div class="text-right">
                    <h3 class="text-2xl font-bold text-blue-800">(주)글로벌 유류 트레이딩</h3>
                    <p class="text-gray-600 mt-1 font-medium italic">Customer Service: 02-1234-5678</p>
                    <p class="text-xs text-gray-400 font-mono uppercase mt-1 italic">Oil & Gas Trading Div.</p>
                </div>
            </div>

            <%-- 2. 프로젝트 및 승인 정보 영역 (Grid 구조 수정) --%>
            <div class="grid grid-cols-2 gap-8 mb-12">
                <%-- 좌측: 프로젝트 정보 --%>
                <div class="p-8 bg-blue-50 rounded-xl border border-blue-100 shadow-sm">
                    <h4 class="text-xs font-bold text-blue-500 uppercase tracking-widest mb-4">Project & Client Info</h4>
                    <div class="space-y-4">
                        <div>
                            <p class="text-xs text-blue-600 font-bold uppercase tracking-tighter mb-1">Contract Name</p>
                            <p id="displayCtrtNm" class="text-xl font-bold text-gray-800 leading-tight">
                                <c:choose>
                                    <c:when test="${not empty info.ctrtNm}">
                                        <c:out value="${info.ctrtNm}" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:out value="${info.fuelNm}" /> 
                                        <c:if test="${itemList.size() > 1}">외 <c:out value="${itemList.size() - 1}" />건</c:if>
                                        견적 요청의 건
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="pt-4 border-t border-blue-200/60 grid grid-cols-1 gap-y-2">
                            <div class="flex items-start"><span class="text-xs font-bold text-gray-400 w-20 shrink-0 mt-0.5">요청업체</span><span class="text-sm font-bold text-gray-800">${info.companyName}</span></div>
                            <div class="flex items-center"><span class="text-xs font-bold text-gray-400 w-20 shrink-0">회사연락처</span><span class="text-sm text-gray-600">${info.companyPhone}</span></div>
                            <div class="flex items-start"><span class="text-xs font-bold text-gray-400 w-20 shrink-0 mt-0.5">업체주소</span><span class="text-sm text-gray-600 leading-snug">${info.addrKor}</span></div>
                            <div class="flex items-center"><span class="text-xs font-bold text-gray-400 w-20 shrink-0">연락처</span><span class="text-sm text-gray-600">${info.phone}</span></div>
                            <div class="flex items-center"><span class="text-xs font-bold text-gray-400 w-20 shrink-0">담당자</span><span class="text-sm text-gray-800 font-bold">${info.userName}</span></div>
                        </div>
                    </div>
                </div>
                
                <%-- 우측: 승인 권자 정보 --%>
                <div class="p-8 bg-gray-50 rounded-xl border border-gray-200 shadow-sm flex flex-col">
                    <h4 class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-4">Approval Authority</h4>
                    <div class="flex-grow space-y-4">
                        <div class="text-right">
                            <p class="text-sm text-gray-400 mb-1">최종 승인권자</p>
                            <p class="text-2xl font-bold text-gray-800 tracking-tight">이영희 본부장</p>
                        </div>
                        <div class="pt-4 border-t border-gray-200 mt-4 flex flex-col items-end gap-y-1">
                            <p class="text-sm text-gray-600 font-medium">
                                <span class="text-xs font-bold text-gray-400 mr-2 uppercase">Direct</span> 010-5678-1234
                            </p>
                            <p class="text-sm text-gray-600 font-medium">
                                <span class="text-xs font-bold text-gray-400 mr-2 uppercase">Email</span> yh.lee@globalfuel.com
                            </p>
                            <div class="text-right mt-3 space-y-1">
                                <p class="text-xs text-gray-500 leading-relaxed italic font-medium">
                                    ※ 견적 승인 및 반려 관련 문의는 위 승인권자에게 연락 바랍니다.
                                </p>
                                <p class="text-[11px] text-gray-400 leading-tight">
                                    본 전자 견적서는 승인자의 최종 검토 후 승인 시 계약 효력이 발생하며,<br>
                                    반려 시 사유 확인 후 수정 재요청이 필요합니다.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div> <%-- grid 끝 --%>

            <%-- 3. 품목 테이블 영역 --%>
            <div class="mb-12">
                <table class="w-full border-collapse">
                    <thead>
                        <tr class="bg-gray-800 text-white text-sm">
                            <th class="py-3 px-4 text-left rounded-tl-lg">품목명</th>
                            <th class="py-3 px-4 text-center">수량</th>
                            <th class="py-3 px-4 text-right">기존 단가</th>
                            <th class="py-3 px-4 text-right border-r border-gray-600">기존 합계</th>
                            <th class="py-3 px-4 text-right font-bold text-blue-300 bg-gray-700 italic border-l border-gray-600">희망 단가</th>
                            <th class="py-3 px-4 text-right font-bold text-blue-300 bg-gray-700 rounded-tr-lg italic">희망 합계</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200 border-b-2 border-gray-800">
                        <c:forEach var="item" items="${itemList}">
                            <tr class="item-row hover:bg-gray-50 transition" 
                                data-qty="${item.totalQty}" 
                                data-base-prc="${item.baseUnitPrc}"
                                data-cart-id="${item.cartId}">
                                <td class="py-5 px-4 font-bold text-gray-800">${item.fuelNm}</td>
                                <td class="py-5 px-4 text-center text-gray-600 font-mono">${item.totalQty}</td>
                                <td class="py-5 px-4 text-right text-gray-500 font-mono"><fmt:formatNumber value="${item.baseUnitPrc}" pattern="#,###"/></td>
                                <td class="py-5 px-4 text-right text-gray-400 font-mono border-r border-gray-50"><fmt:formatNumber value="${item.totalQty * item.baseUnitPrc}" pattern="#,###"/></td>
                                
                                <td class="py-5 px-4 bg-blue-50/30">
                                    <c:choose>
                                 		 <c:when test="${isReadOnly}">
								            <div class="text-right text-blue-700 font-bold font-mono px-2">
								                <fmt:formatNumber value="${item.targetProductPrc}" pattern="#,###"/>
								                <input type="hidden" class="target-prc-input" value="${item.targetProductPrc}">
								            </div>
								        </c:when>
                                        <c:otherwise>
                                            <input type="number" class="target-prc-input w-full bg-transparent text-right text-blue-700 font-bold font-mono outline-none"
                                                   value="${not empty item.targetProductPrc ? item.targetProductPrc : 0}" 
                                                   onkeypress="return event.charCode >= 48 && event.charCode <= 57"
                                                   oninput="this.value = this.value.replace(/[^0-9]/g, '');">
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="py-5 px-4 text-right text-blue-900 font-black bg-blue-50/50 font-mono italic text-lg">
                                    <span class="target-amt-display">0</span>
                                </td>
                            </tr>                        
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <%-- 4. 하단 메모 및 합계 요약 영역 (비율 조정 및 잘림 방지 반영) --%>
<div class="grid grid-cols-12 gap-8 mb-12 items-stretch">
    <%-- 왼쪽 메모: 비율 축소 (5/12) --%>
    <div class="col-span-5 flex flex-col">
        <p class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 italic">Special Memo</p>
        <div class="p-6 border-2 border-dotted border-gray-200 rounded-xl bg-gray-50 text-gray-700 flex-grow shadow-inner">
            <c:choose>
                <c:when test="${isReadOnly}">
                    <div class="whitespace-pre-wrap leading-relaxed"><c:out value="${info.estdtMemo}" default="별도의 기재 사항이 없습니다." /></div>
                </c:when>
                <c:otherwise>
                    <textarea id="estdtMemo" class="w-full h-full min-h-[120px] bg-transparent outline-none leading-relaxed resize-none" placeholder="메모를 입력하세요.">${info.estdtMemo}</textarea>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <%-- 오른쪽 합계: 비율 확대 (7/12) 및 한 줄 출력 보장 --%>
    <div class="col-span-7">
        <div class="bg-gray-900 rounded-2xl p-8 text-white shadow-2xl relative overflow-hidden ring-4 ring-blue-900/30 h-full flex flex-col justify-center">
            <div class="space-y-4 relative z-10">
                <div class="flex justify-between items-center text-gray-500 border-b border-gray-800/50 pb-3">
                    <span class="text-xs font-medium uppercase italic font-mono text-gray-400">Base Total</span>
                    <span id="baseTotalVal" class="font-mono text-md italic">₩0</span>
                </div>
                <div class="flex justify-between items-center text-gray-400 border-b border-gray-800 pb-3">
                    <span class="text-sm font-medium uppercase italic font-mono">Supply Amount</span>
                    <span id="supplyAmtVal" class="font-mono text-lg italic font-bold text-gray-300">₩0</span>
                </div>
                <div class="flex justify-between items-center text-gray-500 pb-2">
                    <span class="text-xs font-medium uppercase italic font-mono">V.A.T (10%)</span>
                    <span id="vatVal" class="font-mono text-md italic">₩0</span>
                </div>
                
                <%-- 최종 금액 영역: 가로 폭 확보를 위해 flex-col로 변경 --%>
                <div class="pt-4 border-t border-gray-800 flex flex-col items-end gap-1">
				    <%-- 라벨을 왼쪽 상단으로 --%>
				    <span class="text-xl font-black text-blue-400 italic uppercase tracking-tighter self-start">
				        Final Est. Total
				    </span>
				    <div class="text-right leading-none w-full">
				        <p class="text-[10px] text-gray-500 mb-1 font-medium uppercase">VAT 포함 (Estimated)</p>
				        <%-- 금액 숫자가 박스 가로 전체를 쓸 수 있도록 설정 --%>
				        <p id="finalTotalVal" class="text-4xl md:text-5xl font-black text-blue-500 tracking-tighter font-mono italic whitespace-nowrap overflow-visible">
				            ₩0
				        </p>
				    </div>
				</div>
            </div>
        </div>
    </div>
</div>

<%-- 5. 하단 버튼 영역 (c:choose 밖으로 빼서 항상 노출되게 수정) --%>
<div class="mt-8 pt-8 border-t border-gray-100 no-print flex justify-between items-center">
    <button type="button" onclick="window.print()" class="px-4 py-2 text-sm font-bold text-gray-600 bg-white border border-gray-300 rounded-lg hover:bg-gray-100 transition shadow-sm">프린트 / PDF</button>
    
    <div class="flex gap-2">
        <%-- PDF 변환 버튼: 미리보기 모드이거나 이미 승인된 건일 때 노출 --%>
        <c:if test="${mode eq 'preview'}">
            <button type="button" onclick="exportPdf(${not empty doc.docId ? doc.docId : 0})" 
                    class="px-8 py-2 bg-blue-900 text-white text-sm font-bold rounded-lg hover:bg-blue-800 shadow-lg transition">
                PDF 견적서 다운로드
            </button>
        </c:if>

        <%-- 견적 요청 버튼: 작성 중이거나 반려된 건일 때 노출 --%>
        <c:if test="${(empty info.estNo || isRejected) && (userType eq 'USER' || userType eq 'MASTER') && mode ne 'preview'}">
            <button type="button" onclick="fn_confirmOrder()" class="px-8 py-2 text-sm font-bold text-white bg-blue-700 rounded-lg hover:bg-blue-800 shadow-xl transition">
                견적 요청하기
            </button>
        </c:if>
        
        <button type="button" onclick="window.close()" class="px-8 py-2 text-sm font-bold text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 transition">닫기</button>
    </div>
</div>
<script>
    $(document).ready(function() {
        updateCalculations();
        $('.target-prc-input').on('input', updateCalculations);
    });

    function updateCalculations() {
        let totalBase = 0;   // 기존 총액
        let totalSupply = 0; // 희망 공급가액 합계 (수량 * 희망단가)

        $('.item-row').each(function() {
            const qty = parseFloat($(this).data('qty')) || 0;
            const basePrc = parseFloat($(this).data('base-prc')) || 0;
            
            // 입력 필드 혹은 텍스트(승인후)에서 가격 추출
            const targetPrcInput = $(this).find('.target-prc-input');
            const targetPrc = parseFloat(targetPrcInput.val() || targetPrcInput.parent().text().replace(/[^0-9]/g, '')) || 0;
            
            const rowTargetAmt = qty * targetPrc; // 이 행의 희망 합계
            
            totalBase += (qty * basePrc);
            totalSupply += rowTargetAmt;

            // 각 행의 [희망 합계] 텍스트 업데이트
            $(this).find('.target-amt-display').text(rowTargetAmt.toLocaleString());
        });

        // B2B 표준 계산
        // 1. 사용자가 입력한 값의 합계가 곧 최종 금액 (20,300원 예시)
	    const finalTotal = totalSupply; 
	
	    // 2. 부가세는 최종 금액에서 10%를 역산 (포함 개념)
	    const vat = Math.floor(finalTotal - (finalTotal / 1.1)); 
	    
	    // 3. 순수 공급가액 (최종금액 - 부가세)
	    const pureSupplyAmt = finalTotal - vat;
	
	    // 하단 요약 박스 업데이트
	    $('#baseTotalVal').text('₩' + totalBase.toLocaleString());     // 기존가 총합
	    $('#supplyAmtVal').text('₩' + pureSupplyAmt.toLocaleString()); // 부가세 제외 순수 공급가
	    $('#vatVal').text('₩' + vat.toLocaleString());               // 포함된 부가세
	    $('#finalTotalVal').text('₩' + finalTotal.toLocaleString());    // 최종 견적가 (입력 합계와 일치)
    }

    function fn_confirmOrder() {
    	let isValid = true; // 유효성 상태 변수 선언
        const items = [];
        $('.item-row').each(function() {
        	const fuelNm = $(this).find('td:first').text(); // 품목명 추출
            const targetPrcInput = $(this).find('.target-prc-input');
            const targetPrc = Number(targetPrcInput.val()) || 0;
            const qty = Number($(this).data('qty'));
            
        	 // 희망 단가가 0 이하인 경우
            if (targetPrc <= 0) {
                alert("[" + fuelNm + "]의 희망 단가를 입력해주세요.");
                targetPrcInput.focus(); // 해당 입력창으로 포커스 이동
                isValid = false;
                return false; // each 루프 중단
            }
            
            items.push({
                "cartId": $(this).data('cart-id'),
                "targetProductPrc": targetPrc,
                "targetProductAmt": (qty * targetPrc)
            });
        });

     	// 2. 유효성 검사를 통과하지 못했다면 여기서 함수 종료 (서버 전송 안함)
        if (!isValid) return;

        // 3. 모든 데이터가 정상일 때만 confirm창 띄우고 AJAX 실행
        if(!confirm("입력하신 금액으로 견적 요청을 전송하시겠습니까?")) return;
        
        const finalCtrtNm = $('#displayCtrtNm').text().replace(/\s+/g, ' ').trim();

        $.ajax({
            url: "${pageContext.request.contextPath}/order/estSubmit",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify({
                "itemList": items,
                "baseTotalAmount": Number($('#baseTotalVal').text().replace(/[^0-9]/g, '')),
                "targetTotalAmount": Number($('#finalTotalVal').text().replace(/[^0-9]/g, '')),
                "estdtMemo": $('#estdtMemo').val(),
                "ctrtNm": finalCtrtNm,
                "companyName": '<c:out value="${info.companyName}" />', 
                "companyPhone": '<c:out value="${info.companyPhone}" />'
            }),
            success: function() { 
                alert("견적 요청이 완료되었습니다.\n거래바구니 목록으로 이동합니다."); // 목적지 안내
                
                if(window.opener && !window.opener.closed) {
                    // 부모 창 이동
                    window.opener.location.href = "${pageContext.request.contextPath}/cart/cart";
                }
                window.close(); 
            },
            error: function(e) {
                alert("오류가 발생했습니다.");
                console.log(e);
            }
        });
    }
    
    function exportPdf(docId) {
        window.location.href = "${pageContext.request.contextPath}/document/exportPdf?docId=" + docId;
    }
</script>
</body>
</html>