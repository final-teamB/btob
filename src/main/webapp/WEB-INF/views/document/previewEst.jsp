<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="info" value="${not empty itemList ? itemList[0] : dto}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ESTIMATE | (주)글로벌 유류 트레이딩</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.tailwindcss.com"></script>
<style>
    @media print {
        .no-print { display: none !important; }
        body { background: white !important; margin: 0; padding: 0; }
        .print-shadow-none { box-shadow: none !important; border: 1px solid #e5e7eb !important; }
    }
    body { font-family: 'Pretendard', sans-serif; background-color: #f9fafb; }
    input::-webkit-outer-spin-button, input::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }
</style>
</head>
<body class="py-10">

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
                                        <c:when test="${not empty info.estNo}">
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

            <%-- 4. 하단 메모 및 합계 요약 영역 --%>
            <div class="grid grid-cols-12 gap-8 mb-12">
                <div class="col-span-7">
                    <p class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 italic">Special Memo</p>
                    <div class="p-6 border-2 border-dotted border-gray-200 rounded-xl bg-gray-50 text-gray-700 min-h-[140px] shadow-inner">
                        <c:choose>
                            <c:when test="${not empty info.estNo}">
                                <div class="whitespace-pre-wrap leading-relaxed"><c:out value="${info.estdtMemo}" default="별도의 기재 사항이 없습니다." /></div>
                            </c:when>
                            <c:otherwise>
                                <textarea id="estdtMemo" class="w-full h-full min-h-[100px] bg-transparent outline-none leading-relaxed resize-none" placeholder="메모를 입력하세요.">${info.estdtMemo}</textarea>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="col-span-5">
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
                            <div class="pt-4 border-t border-gray-800 flex justify-between items-end">
                                <span class="text-xl font-black text-blue-400 italic uppercase tracking-tighter">Final Est. Total</span>
                                <div class="text-right leading-none">
                                    <p class="text-[10px] text-gray-500 mb-2 font-medium uppercase">VAT 포함 (Estimated)</p>
                                    <p id="finalTotalVal" class="text-5xl font-black text-blue-500 tracking-tighter font-mono italic">₩0</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- 5. 하단 버튼 영역 --%>
            <div class="mt-8 pt-8 border-t border-gray-100 no-print flex justify-between items-center">
                <button type="button" onclick="window.print()" class="px-4 py-2 text-sm font-bold text-gray-600 bg-white border border-gray-300 rounded-lg hover:bg-gray-100 transition shadow-sm">프린트 / PDF</button>
                <div class="flex gap-2">
                    <c:if test="${empty info.estNo && userType eq 'USER'}">
                        <button type="button" onclick="fn_confirmOrder()" class="px-8 py-2 text-sm font-bold text-white bg-blue-700 rounded-lg hover:bg-blue-800 shadow-xl transition">견적 요청하기</button>
                    </c:if>
                    <c:if test="${not empty info.estNo}">
                        <button type="button" onclick="window.close()" class="px-8 py-2 text-sm font-bold text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 transition">닫기</button>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

<script>
    $(document).ready(function() {
        updateCalculations();
        $('.target-prc-input').on('input', updateCalculations);
    });

    function updateCalculations() {
        let totalBase = 0;
        let totalTarget = 0;

        $('.item-row').each(function() {
            // dataset에서 값을 가져올 때는 확실하게 숫자로 변환
            const qty = parseFloat($(this).data('qty')) || 0;
            const basePrc = parseFloat($(this).data('base-prc')) || 0;
            
            // input 값을 가져올 때 .val()이 문자열이므로 숫자로 변환
            const targetPrcVal = $(this).find('.target-prc-input').val();
            const targetPrc = parseFloat(targetPrcVal) || 0;
            
            const targetAmt = qty * targetPrc;
            totalBase += (qty * basePrc);
            totalTarget += targetAmt;

            // 각 행의 합계 업데이트
            $(this).find('.target-amt-display').text(targetAmt.toLocaleString());
        });

        // 하단 요약 영역 업데이트 (VAT 계산 로직 포함)
        const supplyAmt = Math.round(totalTarget / 1.1); // 공급가액
        const vat = totalTarget - supplyAmt;            // 부가세

        $('#baseTotalVal').text('₩' + totalBase.toLocaleString());
        $('#supplyAmtVal').text('₩' + supplyAmt.toLocaleString());
        $('#vatVal').text('₩' + vat.toLocaleString());
        $('#finalTotalVal').text('₩' + totalTarget.toLocaleString());
    }

    function fn_confirmOrder() {
        if(!confirm("입력하신 금액으로 견적 요청을 전송하시겠습니까?")) return;
        
        const items = [];
        $('.item-row').each(function() {
            const qty = Number($(this).data('qty'));
            const targetPrc = Number($(this).find('.target-prc-input').val()) || 0;
            items.push({
                "cartId": $(this).data('cart-id'),
                "targetProductPrc": targetPrc,
                "targetProductAmt": (qty * targetPrc)
            });
        });

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
                "companyName": "${info.companyName}", // 값 추가 및 쉼표 확인
                "companyPhone": "${info.companyPhone}" // 값 추가
            }),
            success: function() { 
                alert("요청되었습니다."); 
                if(window.opener) window.opener.location.reload(); 
                window.close(); 
            },
            error: function(e) {
                alert("오류가 발생했습니다. 콘솔을 확인하세요.");
                console.log(e);
            }
        });
    }
</script>
</body>
</html>