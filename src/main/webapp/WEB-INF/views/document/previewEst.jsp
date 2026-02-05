<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 더미 데이터 세팅 --%>
<c:if test="${empty dto}">
    <jsp:useBean id="dummyDto" class="java.util.HashMap" scope="request"/>
    <c:set target="${dummyDto}" property="estNo" value="EST-20260205-001"/>
    <c:set target="${dummyDto}" property="estDocId" value="10042"/>
    <c:set target="${dummyDto}" property="companyName" value="(주)글로벌 유류 트레이딩"/>
    <c:set target="${dummyDto}" property="companyPhone" value="02-1234-5678"/>
    <c:set target="${dummyDto}" property="ctrtNm" value="2026년도 상반기 복합 유종 정기 공급 계약"/>
    
    <c:set target="${dummyDto}" property="requestCompanyNm" value="(주)대한물류네트웍스"/>
    <c:set target="${dummyDto}" property="requestCompanyAddr" value="서울특별시 강남구 테헤란로 456, 대한빌딩 12층"/>
    <c:set target="${dummyDto}" property="requestCompanyPhone" value="02-987-6543"/>
    <c:set target="${dummyDto}" property="requestUserNm" value="김철수 과장"/>
    <c:set target="${dummyDto}" property="requestUserId" value="1029"/>
    
    <c:set target="${dummyDto}" property="apprUserNm" value="이영희 본부장"/>
    <c:set target="${dummyDto}" property="apprUserPhone" value="010-5678-1234"/>
    <c:set target="${dummyDto}" property="apprUserEmail" value="yh.lee@globalfuel.com"/>
    
    <c:set target="${dummyDto}" property="estdtMemo" value="최근 홍해 물류 사태로 인한 운임 상승분을 고려하여 희망 단가를 산출하였습니다. 대량 구매 옵션 5% 할인이 적용된 수치입니다."/>
    <c:set target="${dummyDto}" property="baseTotalAmount" value="162000000"/>
    <c:set target="${dummyDto}" property="targetTotalAmount" value="154700000"/>
    <c:set var="dto" value="${dummyDto}" scope="request"/>

    <%
        java.util.List list = new java.util.ArrayList();
        java.util.Map item1 = new java.util.HashMap();
        item1.put("productNm", "항공유 (Jet A-1 / International Standard)");
        item1.put("productQty", 100);
        item1.put("baseProductPrc", 450000);
        item1.put("baseProductAmt", 45000000);
        item1.put("targetProductPrc", 430000);
        item1.put("targetProductAmt", 43000000);
        list.add(item1);
        request.setAttribute("detailList", list);
    %>
</c:if>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ESTIMATE - ${dto.estNo}</title>
<script src="https://cdn.tailwindcss.com"></script>
<style>
    @media print {
        .no-print { display: none !important; }
        body { background: white !important; margin: 0; padding: 0; }
        .print-shadow-none { box-shadow: none !important; border: 1px solid #e5e7eb !important; }
    }
    body { font-family: 'Pretendard', sans-serif; background-color: #f9fafb; }
</style>
</head>
<body class="py-10">

    <div class="max-w-screen-2xl mx-auto px-4">
        <div class="bg-white p-12 rounded-xl shadow-lg border border-gray-100 print-shadow-none">
            
            <div class="flex justify-between items-end border-b-4 border-gray-800 pb-8 mb-10">
                <div>
                    <h2 class="text-4xl font-black text-gray-900 tracking-tighter uppercase italic">Estimate</h2>
                    <div class="mt-4 space-y-1 text-sm text-gray-500">
                        <p>견적번호: <span class="font-bold text-gray-800">${dto.estNo}</span></p>
                        <p>문서 식별 번호: <span class="text-gray-800">${dto.estDocId}</span></p>
                    </div>
                </div>
                <div class="text-right">
                    <h3 class="text-2xl font-bold text-blue-800">${dto.companyName}</h3>
                    <p class="text-gray-600 mt-1 font-medium italic">Customer Service: ${dto.companyPhone}</p>
                    <p class="text-xs text-gray-400 font-mono uppercase mt-1 italic">Oil & Gas Trading Div.</p>
                </div>
            </div>

            <div class="grid grid-cols-2 gap-8 mb-12">
                <div class="p-8 bg-blue-50 rounded-xl border border-blue-100 shadow-sm">
                    <h4 class="text-xs font-bold text-blue-500 uppercase tracking-widest mb-4">Project & Client Info</h4>
                    <div class="space-y-4">
                        <div>
                            <p class="text-xs text-blue-600 font-bold uppercase tracking-tighter mb-1">Contract Name</p>
                            <p class="text-xl font-bold text-gray-800 leading-tight">${dto.ctrtNm}</p>
                        </div>
                        <div class="pt-4 border-t border-blue-200/60 grid grid-cols-1 gap-y-2">
                            <div class="flex items-start">
                                <span class="text-xs font-bold text-gray-400 w-20 shrink-0 mt-0.5">요청업체</span>
                                <span class="text-sm font-bold text-gray-800">${dto.requestCompanyNm}</span>
                            </div>
                            <div class="flex items-start">
                                <span class="text-xs font-bold text-gray-400 w-20 shrink-0 mt-0.5">업체주소</span>
                                <span class="text-sm text-gray-600 leading-snug">${dto.requestCompanyAddr}</span>
                            </div>
                            <div class="flex items-center">
                                <span class="text-xs font-bold text-gray-400 w-20 shrink-0">연락처</span>
                                <span class="text-sm text-gray-600">${dto.requestCompanyPhone}</span>
                            </div>
                            <div class="flex items-center">
                                <span class="text-xs font-bold text-gray-400 w-20 shrink-0">담당자</span>
                                <span class="text-sm text-gray-800 font-bold">${dto.requestUserNm} <span class="text-xs font-normal text-gray-400 ml-1">(ID: ${dto.requestUserId})</span></span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="p-8 bg-gray-50 rounded-xl border border-gray-200 shadow-sm flex flex-col">
                    <h4 class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-4">Approval Authority</h4>
                    <div class="flex-grow space-y-4">
                        <c:choose>
                            <c:when test="${not empty dto.apprUserNm}">
                                <div class="text-right">
                                    <p class="text-sm text-gray-400 mb-1">최종 승인권자</p>
                                    <p class="text-2xl font-bold text-gray-800">${dto.apprUserNm}</p>
                                </div>
                                <div class="pt-4 border-t border-gray-200 mt-4 flex flex-col items-end gap-y-1">
                                    <p class="text-sm text-gray-600 font-medium">
                                        <span class="text-xs font-bold text-gray-400 mr-2">직통번호</span> ${dto.apprUserPhone}
                                    </p>
                                    <p class="text-sm text-gray-600 font-medium">
                                        <span class="text-xs font-bold text-gray-400 mr-2">이메일</span> ${dto.apprUserEmail}
                                    </p>
                                    <div class="text-right mt-2 space-y-1">
                                        <p class="text-xs text-gray-500 leading-relaxed italic font-medium">
                                            ※ 결재 관련 문의는 위 승인권자에게 연락 바랍니다.
                                        </p>
                                        <p class="text-[11px] text-gray-400 leading-tight">
                                            본 전자 견적서는 승인자의 최종 검토 후 승인 시 계약 효력이 발생하며,<br>
                                            반려 시 사유 확인 후 수정 재요청이 필요합니다.
                                        </p>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="h-full flex items-center justify-center">
                                    <p class="text-xl font-bold text-gray-400 italic uppercase">Pending Approval</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="mb-12">
                <div class="flex items-center mb-4">
                    <div class="w-1.5 h-6 bg-blue-700 mr-3"></div>
                    <h3 class="text-xl font-bold text-gray-800 uppercase tracking-tight">Itemized Breakdown</h3>
                </div>
                <table class="w-full border-collapse">
                    <thead>
                        <tr class="bg-gray-800 text-white">
                            <th class="py-3 px-4 text-left text-sm font-medium rounded-tl-lg">품목명 (Description)</th>
                            <th class="py-3 px-4 text-center text-sm font-medium">수량</th>
                            <th class="py-3 px-4 text-right text-sm font-medium">기존 단가</th>
                            <th class="py-3 px-4 text-right text-sm font-medium border-r border-gray-600">기존 합계</th>
                            <th class="py-3 px-4 text-right text-sm font-bold text-blue-300 bg-gray-700 italic">희망 단가</th>
                            <th class="py-3 px-4 text-right text-sm font-bold text-blue-300 bg-gray-700 rounded-tr-lg italic">희망 합계</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200 border-b-2 border-gray-800">
                        <c:forEach var="item" items="${detailList}">
                            <tr class="hover:bg-gray-50 transition font-medium">
                                <td class="py-5 px-4 font-bold text-gray-800">${item.productNm}</td>
                                <td class="py-5 px-4 text-center text-gray-600 font-mono">${item.productQty}</td>
                                <td class="py-5 px-4 text-right text-gray-500"><fmt:formatNumber value="${item.baseProductPrc}" pattern="#,###"/></td>
                                <td class="py-5 px-4 text-right text-gray-500 font-mono border-r border-gray-50"><fmt:formatNumber value="${item.baseProductAmt}" pattern="#,###"/></td>
                                <td class="py-5 px-4 text-right text-blue-700 font-bold bg-blue-50/30 font-mono"><fmt:formatNumber value="${item.targetProductPrc}" pattern="#,###"/></td>
                                <td class="py-5 px-4 text-right text-blue-900 font-black bg-blue-50/50 font-mono"><fmt:formatNumber value="${item.targetProductAmt}" pattern="#,###"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="grid grid-cols-12 gap-8 mb-12">
                <div class="col-span-7">
                    <p class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 italic">Special Memo</p>
                    <div class="p-6 border-2 border-dotted border-gray-200 rounded-xl bg-gray-50 text-gray-700 min-h-[140px] leading-relaxed shadow-inner">
                        <c:out value="${dto.estdtMemo}" default="별도의 기재 사항이 없습니다." />
                    </div>
                </div>
                <div class="col-span-5">
                    <div class="bg-gray-900 rounded-2xl p-8 text-white shadow-2xl relative overflow-hidden ring-4 ring-blue-900/30 h-full flex flex-col justify-center">
                        <div class="absolute top-0 right-0 w-40 h-40 bg-blue-600 opacity-20 -mr-20 -mt-20 rounded-full"></div>
                        <div class="space-y-6 relative z-10">
                            <div class="flex justify-between items-center text-gray-400 border-b border-gray-800 pb-4">
                                <span class="text-sm font-medium uppercase tracking-tighter italic font-mono">Base Total</span>
                                <span class="font-mono text-lg italic font-bold">₩<fmt:formatNumber value="${dto.baseTotalAmount}" pattern="#,###"/></span>
                            </div>
                            <div class="pt-2 flex justify-between items-end">
                                <span class="text-xl font-black text-blue-400 italic uppercase leading-none">Final Est. Total</span>
                                <div class="text-right leading-none">
                                    <p class="text-xs text-gray-500 mb-2">VAT 포함 (Estimated)</p>
                                    <p class="text-5xl font-black text-blue-500 tracking-tighter font-mono">
                                        ₩<fmt:formatNumber value="${dto.targetTotalAmount}" pattern="#,###"/>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mt-8 pt-8 border-t border-gray-100 flex justify-between items-center no-print">
                <div class="flex gap-2">
                    <button type="button" onclick="window.print()" class="px-4 py-2 text-sm font-bold text-gray-600 bg-white border border-gray-300 rounded-lg hover:bg-gray-100 transition flex items-center shadow-sm">프린트 / PDF</button>
                    <button type="button" class="px-4 py-2 text-sm font-bold text-gray-600 bg-white border border-gray-300 rounded-lg hover:bg-gray-100 transition shadow-sm">임시저장</button>
                </div>
                <div class="flex gap-2">
                    <button type="button" class="px-5 py-2 text-sm font-bold text-red-600 bg-white border border-red-200 rounded-lg hover:bg-red-50 transition shadow-sm">반려하기</button>
                    <button type="button" class="px-5 py-2 text-sm font-bold text-emerald-600 bg-white border border-emerald-200 rounded-lg hover:bg-emerald-50 transition shadow-sm">승인하기</button>
                    <button type="button" class="px-8 py-2 text-sm font-bold text-white bg-blue-700 rounded-lg hover:bg-blue-800 shadow-xl shadow-blue-200 transition ring-2 ring-blue-500 ring-offset-2">견적 요청하기</button>
                </div>
            </div>
        </div>
        
        <p class="mt-8 text-center text-xs text-gray-400 no-print tracking-widest uppercase font-medium">Electronic document produced by ${dto.companyName} CRM system</p>
    </div>

</body>
</html>