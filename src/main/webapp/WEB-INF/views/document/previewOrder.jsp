<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>PURCHASE ORDER | (주)글로벌 유류 트레이딩</title>
<script src="https://cdn.tailwindcss.com"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
        <div class="bg-white p-12 rounded-xl shadow-lg border border-gray-100 print-shadow-none">

            <%-- 상단 헤더: 견적서(Estimate) 규격 1:1 매칭 --%>
          <div class="flex justify-between items-end border-b-4 border-gray-800 pb-8 mb-10">
		    <div>
		        <h2 class="text-4xl font-black text-gray-900 tracking-tighter uppercase italic">Purchase Order</h2>
		          <div class="mt-4 text-sm text-gray-500">
		            <p>주문번호: 
		                <span class="font-bold text-gray-800 italic uppercase">
		                    <c:choose>
		                        <%-- 실제 주문번호(orderNo)가 있을 경우 출력 --%>
		                        <c:when test="${not empty info.orderNo}">
		                            <c:out value="${info.orderNo}" />
		                        </c:when>
		                        <%-- 번호가 아직 생성되지 않은 경우(승인 전 등) --%>
		                        <c:otherwise>
		                            Approval Pending
		                        </c:otherwise>
		                    </c:choose>
		                </span>
		            </p>                   
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
							    <c:if test="${itemList.size() > 1}">
							        외 <c:out value="${itemList.size() - 1}" />건 
							    </c:if>
							    구매 발주의 건
							</p>
						</div>
                        <div class="pt-4 border-t border-emerald-200/60 grid grid-cols-1 gap-y-2">
                            <div class="flex items-start">
                                <span class="text-xs font-bold text-gray-400 w-20 shrink-0 mt-0.5">요청업체</span>
                                <span class="text-sm font-bold text-gray-800">${info.companyName}</span>
                            </div>
                            <div class="flex items-start">
                                <span class="text-xs font-bold text-gray-400 w-20 shrink-0 mt-0.5">업체주소</span>
                                <span class="text-sm text-gray-600 leading-snug">${info.addrKor}</span>
                            </div>
                            <div class="flex items-center">
                                <span class="text-xs font-bold text-gray-400 w-20 shrink-0">연락처</span>
                                <span class="text-sm text-gray-600">${info.phone}</span>
                            </div>
                            <div class="flex items-center">
                                <span class="text-xs font-bold text-gray-400 w-20 shrink-0">담당자</span>
                                <span class="text-sm text-gray-800 font-bold">${info.userName} <span class="text-xs font-normal text-gray-400 ml-1">(ID: ${info.userId})</span></span>
                            </div>
                        </div>
                    </div>
                </div>
                
               
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
                                <td class="py-5 px-4 font-bold text-gray-800">${item.fuelNm}</td>
                                <td class="py-5 px-4 text-center text-gray-600 font-mono">${item.totalQty}</td>
                                <td class="py-5 px-4 text-right text-gray-500 font-mono"><fmt:formatNumber value="${item.baseUnitPrc}" pattern="#,###"/></td>
                                <td class="py-5 px-4 text-right text-emerald-900 font-black bg-emerald-50/20 font-mono italic text-lg"><fmt:formatNumber value="${item.totalPrice}" pattern="#,###"/></td>
                            </tr>
                            <c:set var="totalSum" value="${totalSum + item.totalPrice}" />
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <%-- 하단 합계 영역 --%>
			<div class="flex justify-end mb-12">
			    <%-- 너비를 1/3에서 1/2 수준으로 확대하여 숫자 공간 확보 --%>
			    <div class="w-full md:w-3/5 lg:w-1/2">
			        <div class="bg-gray-900 rounded-2xl p-8 text-white shadow-2xl relative overflow-hidden ring-4 ring-emerald-900/30 h-full flex flex-col justify-center">
			            <div class="absolute top-0 right-0 w-40 h-40 bg-emerald-600 opacity-10 -mr-20 -mt-20 rounded-full"></div>
			            
			            <div class="space-y-4 relative z-10">
			                <div class="flex justify-between items-center text-gray-500 border-b border-gray-800/50 pb-3">
			                    <span class="text-xs font-medium uppercase tracking-tighter italic font-mono">Supply Amount</span>
			                    <span class="font-mono text-md italic">
			                        ₩<fmt:formatNumber value="${totalSum / 1.1}" pattern="#,###"/>
			                    </span>
			                </div>
			
			                <div class="flex justify-between items-center text-gray-500 pb-2">
			                    <span class="text-xs font-medium uppercase tracking-tighter italic font-mono">V.A.T (10%)</span>
			                    <span class="font-mono text-md italic">
			                        ₩<fmt:formatNumber value="${totalSum - (totalSum / 1.1)}" pattern="#,###"/>
			                    </span>
			                </div>
			
			                <%-- 최종 금액: 텍스트는 왼쪽 위, 숫자는 오른쪽 아래로 배치하여 한 줄 확보 --%>
			                <div class="pt-6 border-t border-gray-800 flex flex-col items-end gap-2">
			                    <span class="text-xl font-black text-emerald-400 italic uppercase tracking-tighter self-start">Final Order Total</span>
			                    <div class="text-right leading-none w-full">
			                        <p class="text-[10px] text-gray-500 mb-2 font-medium uppercase">VAT 포함 (Order)</p>
			                        <p id="finalOrderTotal" class="text-4xl md:text-5xl font-black text-emerald-500 tracking-tighter font-mono italic whitespace-nowrap">
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
	    <c:choose>
	        <%-- 상황 A: 미리보기 모드일 때 (다운로드/닫기만 표시) --%>
	        <c:when test="${mode eq 'preview'}">
	            <div class="mt-8 pt-8 border-t border-gray-100 no-print flex justify-end gap-3">
	                <button type="button" onclick="exportPdf(${doc.docId})" 
	                        class="px-8 py-3 bg-blue-900 text-white text-sm font-bold rounded-lg hover:bg-blue-800 shadow-lg transition">
	                    PDF 발주서 다운로드
	                </button>
	                <button type="button" onclick="window.close()" 
	                        class="px-8 py-3 bg-gray-100 text-gray-500 text-sm font-bold rounded-lg hover:bg-gray-200 transition">
	                    닫기
	                </button>
	            </div>
	        </c:when>
	
	        <%-- 상황 B: 실제 주문/승인 프로세스 --%>
	        <c:otherwise>
	            <div class="flex justify-between items-center">
	                <div class="flex gap-2">
	                    <button type="button" onclick="window.print()" class="px-4 py-2 text-sm font-bold text-gray-600 bg-white border border-gray-300 rounded-lg hover:bg-gray-100 transition flex items-center shadow-sm">프린트 / PDF</button>
	                </div>
	                
	                <div class="flex gap-2">
	                    <c:if test="${userType eq 'MASTER'}">
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
	
	                    <c:if test="${userType eq 'USER'}">
	                        <button type="button" onclick="fn_confirmOrder('USER_REQ')"
	                                class="px-8 py-2 text-sm font-bold text-white bg-emerald-700 rounded-lg hover:bg-emerald-800 shadow-xl transition">
	                            주문 승인 요청
	                        </button>
	                    </c:if>
	                     <button type="button" onclick="window.close()" class="px-8 py-2 text-sm font-bold text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 transition">닫기</button>
	                </div>
	            </div>
	
	            <%-- 반려 사유 입력 영역: '주문 프로세스'일 때만 필요하므로 otherwise 안에 배치 --%>
	              <%-- 반려 모달 --%>
			    <div id="rejectModal" class="hidden fixed inset-0 bg-black/60 flex items-center justify-center z-50">
			        <div class="bg-white rounded-xl shadow-2xl p-8 w-full max-w-md">
			            <h3 class="text-xl font-bold text-gray-900 mb-2">주문 반려</h3>
			            <p class="text-sm text-gray-500 mb-4">반려 사유를 입력해 주세요.</p>
			            <textarea id="rejectReason" class="w-full h-32 p-4 border-2 border-gray-100 rounded-xl focus:ring-2 focus:ring-red-500 outline-none resize-none mb-6" placeholder="사유 입력..."></textarea>
			            <div class="flex justify-end gap-3">
			                <button onclick="fn_hideRejectModal()" class="px-4 py-2 text-gray-400 font-bold">취소</button>
			                <button onclick="fn_reject()" class="px-6 py-2 bg-red-600 text-white rounded-lg font-bold hover:bg-red-700 shadow-lg">반려 처리</button>
			            </div>
			        </div>
			    </div>
	        </c:otherwise>
	    </c:choose>
	</div>
<script>
	function fn_confirmOrder(requestLevel) {
	    const msg = requestLevel === 'USER_REQ' ? "대표님께 승인을 요청하시겠습니까?" : "최종 주문을 요청하시겠습니까?";
	    if (!confirm(msg)) return;
	
		 // 1. cartIds 처리: 문자열로 들어올 경우를 대비해 처리
	    // 만약 [1,2] 형태면 그대로 들어가고, "1,2" 형태면 배열로 변환합니다.
	    let rawCartIds = "${cartIds}";
	    // 2. totalSum 처리: 콤마 제거 후 숫자로 변환
	    let rawTotalSum = "${totalSum}".replace(/,/g, "");

	    const requestData = {
	            // 문자열 "10,5"를 [10, 5] 배열로 변환하는 로직 추가
	            "cartIds": String(rawCartIds).split(',').map(id => Number(id.trim())),
	            "totalSum": Number(rawTotalSum),
	            "requestLevel": requestLevel
        };
	    
	    console.log("전송 데이터:", requestData); // 디버깅용
	
	    $.ajax({
	        url: "${pageContext.request.contextPath}/order/orderSubmit",
	        type: "POST",
	        contentType: "application/json",
	        data: JSON.stringify(requestData),
	        success: function(res) {
	        	 alert("주문 요청이 완료되었습니다.\n거래바구니 목록으로 이동합니다."); // 목적지 안내
	                
	                if(window.opener && !window.opener.closed) {
	                    // 부모 창 이동
	                    window.opener.location.href = "${pageContext.request.contextPath}/cart/cart";
	                }
	            window.close();
	        }, 
	        error: function(err) {
	            alert(err.responseJSON ? err.responseJSON.message : "처리 중 오류가 발생했습니다.");
	        }
	    });
	}
	
	// 반려 모달 열기
	function fn_processApproval(type) {
	    if (type === 'REJECT') {
	        $('#rejectModal').removeClass('hidden'); // ID 매칭: rejectModal
	        $('#rejectReason').focus();              // ID 매칭: rejectReason
	        return;
	    }
	    
	    if (!confirm("해당 주문을 최종 승인하시겠습니까?")) return;
	    executeApproval('od002', '');
	}

	// 반려 모달 닫기
	function fn_hideRejectModal() {
	    $('#rejectModal').addClass('hidden');
	    $('#rejectReason').val(''); // 입력값 초기화
	}

	// 반려 실행 (모달 안의 '반려 처리' 버튼 클릭 시)
	function fn_reject() {
	    const reason = $('#rejectReason').val();	
	    if (!reason || !reason.trim()) {
	        alert("반려 사유를 입력해 주세요.");
	        $('#rejectReason').focus();
	        return;
	    }
	    
	    if(!confirm("입력하신 사유로 반려 처리를 완료하시겠습니까?")) return;
	    executeApproval('od999', reason);
	}
	
	// 모달 배경 클릭 시 닫기
	$('#rejectModal').on('click', function(e) {
	    if (e.target === this) fn_hideRejectModal();
	});

	function executeApproval(status, reason) {
	    const requestData = {
	        "orderId": "${info.orderId}",
	        "orderNo": "${info.orderNo}",
	        "userNo": "${info.userNo}",
	        "userId": "${info.userId}",
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
	
	// PDF 다운로드 요청 함수
    function exportPdf(docId) {
        if(!docId) {
            alert("문서 정보를 찾을 수 없습니다.");
            return;
        }
        window.location.href = "${pageContext.request.contextPath}/document/exportPdf?docId=" + docId;
    }
</script>
</body>
</html>