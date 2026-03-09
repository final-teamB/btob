<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ESTIMATE APPROVAL | (주)글로벌 유류 트레이딩</title>
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

    <div class="max-w-screen-2xl mx-auto px-4">
        <%-- 원본과 동일한 shadow-lg border-gray-100 --%>
        <div class="bg-white p-12 rounded-xl shadow-lg border border-gray-100 print-shadow-none">
            
            <%-- 1. 상단 헤더 영역 (동일 디자인) --%>
            <div class="flex justify-between items-end border-b-4 border-gray-800 pb-8 mb-10">
                <div>
                    <h2 class="text-4xl font-black text-gray-900 tracking-tighter uppercase italic">Estimate Approval</h2>
                    <p class="mt-4 text-sm text-gray-500">주문번호: 
                        <span class="font-bold text-gray-800 italic uppercase">
                            <c:out value="${info.orderNo}" />
                        </span>
                    </p>
                </div>
                <div class="text-right">
                    <h3 class="text-2xl font-bold text-blue-800">(주)글로벌 유류 트레이딩</h3>
                    <p class="text-gray-600 mt-1 font-medium italic">Customer Service: 02-1234-5678</p>
                    <p class="text-xs text-gray-400 font-mono uppercase mt-1 italic">Oil & Gas Trading Div.</p>
                </div>
            </div>

            <%-- 2. 프로젝트 정보 영역 (동일 Grid & bg-blue-50) --%>
            <div class="grid grid-cols-2 gap-8 mb-12">
                <div class="p-8 bg-blue-50 rounded-xl border border-blue-100 shadow-sm">
                    <h4 class="text-xs font-bold text-blue-500 uppercase tracking-widest mb-4">Project & Client Info</h4>
                    <div class="space-y-4">
                        <div>
                            <p class="text-xs text-blue-600 font-bold uppercase tracking-tighter mb-1">Contract Name</p>
                            <p class="text-xl font-bold text-gray-800 leading-tight">${info.ctrtNm}</p>
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
            </div> 

            <%-- 3. 품목 테이블 (동일 컬럼 구성 & 스타일) --%>
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
                            <tr class="item-row hover:bg-gray-50 transition">
                                <td class="py-5 px-4 font-bold text-gray-800">${item.fuelNm}</td>
                                <td class="py-5 px-4 text-center text-gray-600 font-mono">${item.totalQty}</td>
                                <td class="py-5 px-4 text-right text-gray-500 font-mono"><fmt:formatNumber value="${item.baseUnitPrc}" pattern="#,###"/></td>
                                <td class="py-5 px-4 text-right text-gray-400 font-mono border-r border-gray-50"><fmt:formatNumber value="${item.totalQty * item.baseUnitPrc}" pattern="#,###"/></td>
                                
                                <%-- 텍스트 전용 희망 단가 --%>
                                <td class="py-5 px-4 bg-blue-50/30 text-right text-blue-700 font-bold font-mono">
                                    <fmt:formatNumber value="${item.targetProductPrc}" pattern="#,###"/>
                                </td>
                                <%-- 텍스트 전용 희망 합계 --%>
                                <td class="py-5 px-4 text-right text-blue-900 font-black bg-blue-50/50 font-mono italic text-lg">
                                    <fmt:formatNumber value="${item.targetProductAmt}" pattern="#,###"/>
                                </td>
                            </tr>                        
                        </c:forEach>
                    </tbody>
                </table>
            </div>
			
			<%-- 4. 하단 메모 및 합계 요약 영역 (비율 조정 및 잘림 방지 반영) --%>
			<div class="grid grid-cols-12 gap-8 mb-12 items-stretch">
			    <%-- 왼쪽 메모: 5/12 비율 --%>
			    <div class="col-span-5 flex flex-col">
			        <p class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 italic">Special Memo</p>
			        <div class="p-6 border-2 border-dotted border-gray-200 rounded-xl bg-gray-50 text-gray-700 flex-grow shadow-inner whitespace-pre-wrap leading-relaxed">
			            <c:out value="${not empty info.estdtMemo ? info.estdtMemo : '별도의 기재 사항이 없습니다.'}" />
			        </div>
			    </div>
			
			    <%-- 오른쪽 합계: 7/12 비율로 확장하여 가로 폭 확보 --%>
			    <div class="col-span-7">
			        <div class="bg-gray-900 rounded-2xl p-8 text-white shadow-2xl relative overflow-hidden ring-4 ring-blue-900/30 h-full flex flex-col justify-center">
			            <div class="space-y-4 relative z-10">
			                <div class="flex justify-between items-center text-gray-500 border-b border-gray-800/50 pb-3">
			                    <span class="text-xs font-medium uppercase italic font-mono text-gray-400">Base Total</span>
			                    <span class="font-mono text-md italic text-gray-400">₩<fmt:formatNumber value="${info.baseTotalAmount}" pattern="#,###"/></span>
			                </div>
			                <div class="flex justify-between items-center text-gray-400 border-b border-gray-800 pb-3">
			                    <span class="text-sm font-medium uppercase italic font-mono">Supply Amount</span>
			                    <span class="font-mono text-lg italic font-bold text-gray-300">₩<fmt:formatNumber value="${info.targetTotalAmount / 1.1}" pattern="#,###"/></span>
			                </div>
			                <div class="flex justify-between items-center text-gray-500 pb-2">
			                    <span class="text-xs font-medium uppercase italic font-mono">V.A.T (10%)</span>
			                    <span class="font-mono text-md italic text-gray-400">₩<fmt:formatNumber value="${info.targetTotalAmount - (info.targetTotalAmount / 1.1)}" pattern="#,###"/></span>
			                </div>
			                
			                <%-- 최종 금액 영역: flex-col로 변경하여 숫자가 가로 전체를 사용하도록 수정 --%>
			                <div class="pt-4 border-t border-gray-800 flex flex-col items-end gap-1">
			                    <%-- 라벨을 왼쪽 상단으로 배치해 공간 확보 --%>
			                    <span class="text-xl font-black text-blue-400 italic uppercase tracking-tighter self-start">Final Est. Total</span>
			                    <div class="text-right leading-none w-full">
			                        <p class="text-[10px] text-gray-500 mb-2 font-medium uppercase">VAT 포함 (Estimated)</p>
			                        <%-- 숫자가 길어져도 한 줄로 쭉 나오게 설정 --%>
			                        <p id="finalTotalVal" class="text-4xl md:text-5xl lg:text-6xl font-black text-blue-500 tracking-tighter font-mono italic whitespace-nowrap overflow-visible">
			                            ₩<fmt:formatNumber value="${info.targetTotalAmount}" pattern="#,###"/>
			                        </p>
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
                    <c:if test="${userType eq 'MASTER' || userType eq 'ADMIN'}">
                        <button type="button" onclick="fn_showRejectModal()" class="px-8 py-2 text-sm font-bold text-red-600 bg-red-50 rounded-lg hover:bg-red-100 transition">반려하기</button>
                        <button type="button" onclick="fn_approve()" class="px-8 py-2 text-sm font-bold text-white bg-indigo-600 rounded-lg hover:bg-indigo-700 shadow-xl transition">승인하기</button>
                    </c:if>
                    <button type="button" onclick="window.close()" class="px-8 py-2 text-sm font-bold text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 transition">닫기</button>
                </div>
            </div>
        </div>
    </div>

    <%-- 반려 모달 --%>
    <div id="rejectModal" class="hidden fixed inset-0 bg-black/60 flex items-center justify-center z-50">
        <div class="bg-white rounded-xl shadow-2xl p-8 w-full max-w-md">
            <h3 class="text-xl font-bold text-gray-900 mb-2">견적 반려</h3>
            <p class="text-sm text-gray-500 mb-4">반려 사유를 입력해 주세요.</p>
            <textarea id="rejectReason" class="w-full h-32 p-4 border-2 border-gray-100 rounded-xl focus:ring-2 focus:ring-red-500 outline-none resize-none mb-6" placeholder="사유 입력..."></textarea>
            <div class="flex justify-end gap-3">
                <button onclick="fn_hideRejectModal()" class="px-4 py-2 text-gray-400 font-bold">취소</button>
                <button onclick="fn_reject()" class="px-6 py-2 bg-red-600 text-white rounded-lg font-bold hover:bg-red-700 shadow-lg">반려 처리</button>
            </div>
        </div>
    </div>

<script>
    function fn_approve() {
        if(!confirm("해당 견적을 최종 승인하시겠습니까?")) return;
        sendAction("od002", "");
    }

    function fn_showRejectModal() { $('#rejectModal').removeClass('hidden'); }
    function fn_hideRejectModal() { $('#rejectModal').addClass('hidden'); $('#rejectReason').val(''); }

    function fn_reject() {
        const reason = $('#rejectReason').val().trim();
        if(!reason) {
            alert("반려 사유를 입력해주세요.");
            $('#rejectReason').focus();
            return;
        }
        
        if(!confirm("입력하신 사유로 반려 처리를 완료하시겠습니까?")) return;
        
        sendAction("od999", reason);
    }

    function sendAction(status, reason) {
        $.ajax({
            url: "${pageContext.request.contextPath}/trade/processApproval",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify({
            	"orderId": "${info.orderId}",
                "orderNo": "${info.orderNo}",
    	        "userNo": "${info.userNo}",
    	        "userId": "${info.userId}",
                "status": status,
                "rejectReason": reason
            }),
            success: function() {
                alert("처리가 완료되었습니다.");
                if(window.opener) window.opener.location.reload();
                window.close();
            },
            error: function() { alert("서버 오류가 발생했습니다."); }
        });
    }
</script>
</body>
</html>