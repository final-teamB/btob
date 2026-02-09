<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="info" value="${itemList[0]}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ORDER - Approval Pending</title>
<script src="https://cdn.tailwindcss.com"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
    @media print {
        .no-print { display: none !important; }
        body { background: white !important; margin: 0; padding: 0; }
        .print-shadow-none { box-shadow: none !important; border: 1px solid #e5e7eb !important; }
    }
    /* 견적서 원본과 동일한 폰트 스택 적용 */
    body { font-family: 'Pretendard', sans-serif; background-color: #f9fafb; }
</style>
</head>
<body class="py-10">

    <div class="max-w-screen-2xl mx-auto px-4">
        <div class="bg-white p-12 rounded-xl shadow-lg border border-gray-100 print-shadow-none">
            
            <%-- 상단 헤더: 견적서(Estimate) 규격 1:1 매칭 --%>
            <div class="flex justify-between items-end border-b-4 border-gray-800 pb-8 mb-10">
                <div>
                    <h2 class="text-4xl font-black text-gray-900 tracking-tighter uppercase italic">Purchase Order</h2>
                    <div class="mt-4 space-y-1 text-sm text-gray-500">
                        <p>주문번호: <span class="font-bold text-gray-800 italic uppercase">Approval Pending</span></p>                   
                    </div>
                </div>
                <div class="text-right">
                    <h3 class="text-2xl font-bold text-emerald-800">(주)글로벌 유류 트레이딩</h3>
                    <p class="text-gray-600 mt-1 font-medium italic">Customer Service: 02-1234-5678</p>
                    <p class="text-xs text-gray-400 font-mono uppercase mt-1 italic">Oil & Gas Logistics Div.</p>
                </div>
            </div>

            <div class="grid grid-cols-2 gap-8 mb-12">
                <%-- 요청 정보 섹션 (Blue 계열 -> Emerald 계열 치환 / 규격은 동일) --%>
                <div class="p-8 bg-emerald-50 rounded-xl border border-emerald-100 shadow-sm">
                    <h4 class="text-xs font-bold text-emerald-500 uppercase tracking-widest mb-4">Project & Client Info</h4>
                    <div class="space-y-4">
                       <div>
						    <p class="text-xs text-emerald-600 font-bold uppercase tracking-tighter mb-1">Contract Name</p>
						    <p class="text-xl font-bold text-gray-800 leading-tight">
							    <c:out value="${info.fuel_nm}" /> 
							    <c:if test="${itemList.size() > 1}">
							        외 <c:out value="${itemList.size() - 1}" />건 
							    </c:if>
							    구매 발주의 건
							</p>
						</div>
                        <div class="pt-4 border-t border-emerald-200/60 grid grid-cols-1 gap-y-2">
                            <div class="flex items-start">
                                <span class="text-xs font-bold text-gray-400 w-20 shrink-0 mt-0.5">요청업체</span>
                                <span class="text-sm font-bold text-gray-800">${info.company_name}</span>
                            </div>
                            <div class="flex items-start">
                                <span class="text-xs font-bold text-gray-400 w-20 shrink-0 mt-0.5">업체주소</span>
                                <span class="text-sm text-gray-600 leading-snug">${info.addr_kor}</span>
                            </div>
                            <div class="flex items-center">
                                <span class="text-xs font-bold text-gray-400 w-20 shrink-0">연락처</span>
                                <span class="text-sm text-gray-600">${info.user_phone}</span>
                            </div>
                            <div class="flex items-center">
                                <span class="text-xs font-bold text-gray-400 w-20 shrink-0">담당자</span>
                                <span class="text-sm text-gray-800 font-bold">${info.user_name} <span class="text-xs font-normal text-gray-400 ml-1">(ID: ${info.user_id})</span></span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <%-- Approval Authority 섹션: 견적서 원본 텍스트 규격과 완벽 일치 --%>
                <div class="p-8 bg-gray-50 rounded-xl border border-gray-200 shadow-sm flex flex-col">
                    <h4 class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-4">Approval Authority</h4>
                    <div class="flex-grow space-y-4">
                        <div class="text-right">
                            <p class="text-sm text-gray-400 mb-1">최종 승인권자</p>
                            <p class="text-2xl font-bold text-gray-800">이영희 본부장</p>
                        </div>
                        <div class="pt-4 border-t border-gray-200 mt-4 flex flex-col items-end gap-y-1">
                            <p class="text-sm text-gray-600 font-medium">
                                <span class="text-xs font-bold text-gray-400 mr-2">직통번호</span> 010-5678-1234
                            </p>
                            <p class="text-sm text-gray-600 font-medium">
                                <span class="text-xs font-bold text-gray-400 mr-2">이메일</span> yh.lee@globalfuel.com
                            </p>
                            <div class="text-right mt-2 space-y-1">
                                <p class="text-xs text-gray-500 leading-relaxed italic font-medium">
                                    ※ 결재 관련 문의는 위 승인권자에게 연락 바랍니다.
                                </p>
                                <p class="text-[11px] text-gray-400 leading-tight">
                                    본 전자 주문서는 승인자의 최종 검토 후 승인 시 계약 효력이 발생하며,<br>
                                    반려 시 사유 확인 후 수정 재요청이 필요합니다.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- 품목 테이블 --%>
            <div class="mb-12">
                <div class="flex items-center mb-4">
                    <div class="w-1.5 h-6 bg-emerald-700 mr-3"></div>
                    <h3 class="text-xl font-bold text-gray-800 uppercase tracking-tight">Order Details</h3>
                </div>
                <table class="w-full border-collapse">
                    <thead>
                        <tr class="bg-gray-800 text-white">
                            <th class="py-3 px-4 text-left text-sm font-medium rounded-tl-lg">품목명 (Description)</th>
                            <th class="py-3 px-4 text-center text-sm font-medium">수량</th>
                            <th class="py-3 px-4 text-right text-sm font-medium">단가</th>
                            <th class="py-3 px-4 text-right text-sm font-bold bg-emerald-700 rounded-tr-lg italic">합계</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200 border-b-2 border-gray-800">
                        <c:set var="totalSum" value="0" />
                        <c:forEach var="item" items="${itemList}">
                            <tr class="hover:bg-gray-50 transition font-medium">
                                <td class="py-5 px-4 font-bold text-gray-800">${item.fuel_nm}</td>
                                <td class="py-5 px-4 text-center text-gray-600 font-mono">${item.total_qty}</td>
                                <td class="py-5 px-4 text-right text-gray-500 font-mono"><fmt:formatNumber value="${item.base_unit_prc}" pattern="#,###"/></td>
                                <td class="py-5 px-4 text-right text-emerald-900 font-black bg-emerald-50/20 font-mono italic text-lg"><fmt:formatNumber value="${item.total_price}" pattern="#,###"/></td>
                            </tr>
                            <c:set var="totalSum" value="${totalSum + item.total_price}" />
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <%-- 하단 합계 영역 --%>
			<div class="flex justify-end">
			    <div class="w-full md:w-1/2 lg:w-1/3">
			        <div class="bg-gray-900 rounded-2xl p-8 text-white shadow-2xl relative overflow-hidden ring-4 ring-emerald-900/30 h-full flex flex-col justify-center">
			            <div class="absolute top-0 right-0 w-40 h-40 bg-emerald-600 opacity-20 -mr-20 -mt-20 rounded-full"></div>
			            
			            <div class="space-y-4 relative z-10">
			                <%-- 1. 공급가액 (전체 금액의 90/110 또는 단순히 합계에서 역산) --%>
			                <%-- 보통 totalSum이 VAT 포함이라면: 공급가액 = totalSum / 1.1 --%>
			                <div class="flex justify-between items-center text-gray-400 border-b border-gray-800 pb-3">
			                    <span class="text-sm font-medium uppercase tracking-tighter italic font-mono">Supply Amount</span>
			                    <span class="font-mono text-lg italic font-bold text-gray-300">
			                        ₩<fmt:formatNumber value="${totalSum / 1.1}" pattern="#,###"/>
			                    </span>
			                </div>
			
			                <%-- 2. 부가세 (전체 금액의 10/110) --%>
			                <div class="flex justify-between items-center text-gray-500 pb-2">
			                    <span class="text-xs font-medium uppercase tracking-tighter italic font-mono">V.A.T (10%)</span>
			                    <span class="font-mono text-md italic">
			                        ₩<fmt:formatNumber value="${totalSum - (totalSum / 1.1)}" pattern="#,###"/>
			                    </span>
			                </div>
			
			                <%-- 3. 최종 합계 --%>
			                <div class="pt-4 border-t border-gray-800 flex justify-between items-end">
			                    <span class="text-xl font-black text-emerald-400 italic uppercase leading-none tracking-tighter">Final Order. Total</span>
			                    <div class="text-right leading-none">
			                        <p class="text-[10px] text-gray-500 mb-2 font-medium uppercase">VAT 포함 (Order)</p>
			                        <p class="text-5xl font-black text-emerald-500 tracking-tighter font-mono italic">
			                            ₩<fmt:formatNumber value="${totalSum}" pattern="#,###"/>
			                        </p>
			                    </div>
			                </div>
			            </div>
			        </div>
			    </div>
			</div>

      <%-- 하단 버튼 영역 --%>
	<div class="mt-8 pt-8 border-t border-gray-100 no-print">
	    <div class="flex justify-between items-center">
	        <div class="flex gap-2">
	            <button type="button" onclick="window.print()" class="px-4 py-2 text-sm font-bold text-gray-600 bg-white border border-gray-300 rounded-lg hover:bg-gray-100 transition flex items-center shadow-sm">프린트 / PDF</button>
	        </div>
	        
	        <div class="flex gap-2">
	            <c:if test="${user_type eq 'MASTER'}">
	                <c:choose>
	                    <c:when test="${info.orderStatus eq 'od001'}">
	                        <button type="button" onclick="fn_processApproval('REJECT')" 
	                                class="px-5 py-2 text-sm font-bold text-red-600 bg-white border border-red-200 rounded-lg hover:bg-red-50 transition shadow-sm">
	                            반려하기
	                        </button>
	                        <button type="button" onclick="fn_processApproval('APPROVE')" 
	                                class="px-5 py-2 text-sm font-bold text-emerald-600 bg-white border border-emerald-200 rounded-lg hover:bg-emerald-50 transition shadow-sm">
	                            승인하기
	                        </button>
	                    </c:when>
	                    <c:otherwise>
	                        <button type="button" onclick="fn_confirmOrder('MASTER_REQ')"
	                                class="px-8 py-2 text-sm font-bold text-white bg-blue-700 rounded-lg hover:bg-blue-800 shadow-xl transition">
	                            최종 승인 요청
	                        </button>
	                    </c:otherwise>
	                </c:choose>
	            </c:if>
	
	            <c:if test="${user_type eq 'USER'}">
	                <button type="button" onclick="fn_confirmOrder('USER_REQ')"
	                        class="px-8 py-2 text-sm font-bold text-white bg-emerald-700 rounded-lg hover:bg-emerald-800 shadow-xl transition">
	                    주문 승인 요청
	                </button>
	            </c:if>
	        </div>
	    </div>
	
	    <%-- 반려 사유 입력 영역: 버튼 아래에 위치 --%>
	    <div id="rejectArea" class="hidden mt-6 p-6 bg-red-50 border border-red-100 rounded-xl shadow-inner transition-all">
	        <div class="flex items-center mb-3">
	            <div class="w-1 h-4 bg-red-500 mr-2"></div>
	            <label class="text-sm font-black text-red-800 uppercase tracking-tighter">Reason for Rejection</label>
	        </div>
	        <textarea id="rejectReasonText" 
	                  class="w-full p-4 border border-red-200 rounded-lg shadow-sm focus:ring-2 focus:ring-red-500 focus:border-red-500 outline-none text-sm" 
	                  rows="3" 
	                  placeholder="반려 사유를 상세히 입력해 주세요 (예: 품목 단가 재확인 필요 등)"></textarea>
	        <div class="mt-3 flex justify-end gap-2">
	            <button type="button" onclick="$('#rejectArea').addClass('hidden')" class="px-4 py-2 text-xs font-bold text-gray-500 hover:text-gray-700 transition">취소</button>
	            <button type="button" onclick="fn_submitReject()" class="px-6 py-2 bg-red-600 text-white text-xs font-bold rounded-lg hover:bg-red-700 shadow-lg shadow-red-200 transition">반려 확정 및 전송</button>
	        </div>
	    </div>
	</div>
<script>
	function fn_confirmOrder(requestLevel) {
	    const msg = requestLevel === 'USER_REQ' ? "대표님께 승인을 요청하시겠습니까?" : "최종 주문을 요청하시겠습니까?";
	    if (!confirm(msg)) return;
	
	    const requestData = {
	        "cartIds": "${cartIds}",
	        "totalSum": "${totalSum}",
	        "requestLevel": requestLevel // USER_REQ 또는 MASTER_REQ
	    };
	
	    $.ajax({
	        url: "${pageContext.request.contextPath}/order/orderSubmit",
	        type: "POST",
	        contentType: "application/json",
	        data: JSON.stringify(requestData),
	        success: function(res) {
	            alert("요청이 완료되었습니다.");
	            if (window.opener && !window.opener.closed) {
	                window.opener.location.reload(); 
	            }
	            window.close();
	        }, 
	        error: function(err) {
	            alert(err.responseJSON ? err.responseJSON.message : "처리 중 오류가 발생했습니다.");
	        }
	    });
	}
	
	function fn_processApproval(type) {
	    if (type === 'REJECT') {
	        $('#rejectArea').removeClass('hidden');
	        $('#rejectReasonText').focus();
	        // 부드럽게 스크롤 이동
	        document.getElementById('rejectArea').scrollIntoView({ behavior: 'smooth', block: 'center' });
	        return;
	    }
	    
	    if (!confirm("해당 주문을 최종 승인하시겠습니까?")) return;
	    executeApproval('od002', '');
	}

	function fn_submitReject() {
	    const reason = $('#rejectReasonText').val();
	    if (!reason || !reason.trim()) {
	        alert("반려 사유를 입력해 주세요.");
	        $('#rejectReasonText').focus();
	        return;
	    }
	    
	    if(!confirm("입력하신 사유로 반려 처리를 완료하시겠습니까?")) return;
	    executeApproval('od999', reason);
	}

	function executeApproval(status, reason) {
	    const requestData = {
	        "orderId": "${info.orderId}",
	        "orderNo": "${info.orderNo}",
	        "userNo": "${info.userNo}",
	        "status": status,
	        "rejectReason": reason
	    };

	    $.ajax({
	        url: "${pageContext.request.contextPath}/trade/processApproval",
	        type: "POST",
	        contentType: "application/json",
	        data: JSON.stringify(requestData),
	        success: function(res) {
	            alert(res || "처리가 완료되었습니다.");
	            if (window.opener && !window.opener.closed) {
	                window.opener.location.reload();
	            }
	            window.close();
	        },
	        error: function(err) {
	            alert(err.responseText || "처리 중 오류가 발생했습니다.");
	        }
	    });
	}
</script>
</body>
</html>