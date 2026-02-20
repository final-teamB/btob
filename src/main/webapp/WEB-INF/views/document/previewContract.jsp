<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CONTRACT | (주)글로벌 유류 트레이딩</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.tailwindcss.com"></script>
<style>
    @media print {
        .no-print { display: none !important; }
        body { background: white !important; margin: 0; padding: 0; }
        .print-shadow-none { box-shadow: none !important; border: 1px solid #e5e7eb !important; }
    }
    body { font-family: 'Pretendard', sans-serif; background-color: #f3f4f6; }
</style>
</head>
<body class="py-10">

    <div class="max-w-screen-2xl mx-auto px-4">
        <div class="bg-white p-16 rounded-sm shadow-2xl border-t-[12px] border-gray-900 print-shadow-none relative">
            
            <%-- 1. 상단 헤더: 계약서의 엄중함을 위해 Serif 느낌의 폰트 효과 --%>
            <div class="flex justify-between items-end border-b-2 border-gray-200 pb-8 mb-10">
                <div>
                    <h2 class="text-5xl font-serif font-black text-gray-900 tracking-tight uppercase">Contract</h2>
                    <p class="mt-4 text-sm text-gray-500 font-mono">계약번호: 
                        <span class="font-bold text-gray-800 tracking-widest uppercase">
                            <c:out value="${not empty doc.docNo ? doc.docNo : 'CON-PENDING-000'}" />
                        </span>
                    </p>
                </div>
                <div class="text-right">
                    <h3 class="text-2xl font-bold text-gray-900">(주)글로벌 유류 트레이딩</h3>
                    <p class="text-gray-500 mt-1 text-sm italic font-medium">B2B Energy Solution & Trading</p>
                    <div class="mt-2 inline-block px-3 py-1 border border-gray-900 text-[10px] font-bold uppercase tracking-widest text-gray-900">
                        Official Document
                    </div>
                </div>
            </div>

            <%-- 2. 계약 기본 정보 --%>
            <div class="mb-10 p-8 bg-gray-50 border border-gray-200 rounded-lg">
                <div class="grid grid-cols-12 gap-6">
                    <div class="col-span-8">
                        <label class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-1 block">Contract Title</label>
                        <h4 class="text-2xl font-bold text-gray-900 leading-tight">
						    <c:choose>
						        <c:when test="${not empty doc.docTitle}">
						            <c:out value="${doc.docTitle}" />
						        </c:when>
						        <c:otherwise>
						            <c:out value="${itemList[0].fuelNm}" /> <c:if test="${itemList.size() > 1}">외 ${itemList.size()-1}건</c:if> 물품 공급 계약의 건
						        </c:otherwise>
						    </c:choose>
						</h4>
                    </div>
                    <div class="col-span-4 text-right">
                        <label class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-1 block">Total Contract Amount</label>
                        <p class="text-3xl font-black text-gray-900 font-mono italic">
                            ₩<fmt:formatNumber value="${doc.totalAmt}" pattern="#,###"/>
                        </p>
                        <p class="text-[10px] text-gray-400 mt-1">VAT 포함 총액</p>
                    </div>
                </div>
                
                <div class="mt-8 pt-6 border-t border-gray-200 grid grid-cols-2 gap-10">
                    <div>
                        <h5 class="text-xs font-bold text-gray-500 uppercase mb-3">Party A (Seller)</h5>
                        <p class="text-sm font-bold text-gray-800">(주)글로벌 유류 트레이딩</p>
                        <p class="text-xs text-gray-500 mt-1 leading-relaxed">서울특별시 중구 세종대로 110 (02-1234-5678)</p>
                    </div>
                    <div>
                        <h5 class="text-xs font-bold text-gray-500 uppercase mb-3">Party B (Buyer)</h5>
                        <p class="text-sm font-bold text-gray-800">${info.companyName}</p>
                        <p class="text-xs text-gray-500 mt-1 leading-relaxed">${info.addrKor} (${info.phone})</p>
                    </div>
                </div>
            </div>

            <%-- 3. 계약 세부 내역 --%>
            <div class="mb-10">
                <div class="flex items-center mb-4 border-b border-gray-900 pb-2">
                    <h3 class="text-lg font-bold text-gray-900 uppercase tracking-tighter">Article 1. Product Specification</h3>
                </div>
                <table class="w-full border-collapse text-sm">
                    <thead>
                        <tr class="bg-gray-100 text-gray-600 border-b border-gray-300">
                            <th class="py-3 px-4 text-left">Description</th>
                            <th class="py-3 px-4 text-center">Quantity</th>
                            <th class="py-3 px-4 text-right">Unit Price</th>
                            <th class="py-3 px-4 text-right">Amount</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                     <c:forEach var="item" items="${itemList}">
						    <tr>
						        <td class="py-4 px-4 font-bold text-gray-800">${item.fuelNm}</td>
						        <td class="py-4 px-4 text-center font-mono">${item.totalQty}</td>
						        <%-- 품목별 단가: 어느 테이블에서 왔든 doc_id 조회 시점에 mapper에서 별칭(alias)을 맞춰주면 편합니다 --%>
						        <td class="py-4 px-4 text-right font-mono text-gray-500">
						            <fmt:formatNumber value="${not empty item.targetProductPrc ? item.targetProductPrc : item.baseUnitPrc}" pattern="#,###"/>
						        </td>
						        <td class="py-4 px-4 text-right font-mono font-bold text-gray-900">
						            <fmt:formatNumber value="${not empty item.targetProductAmt ? item.targetProductAmt : item.totalPrice}" pattern="#,###"/>
						        </td>
						    </tr>
						</c:forEach>
                    </tbody>
                </table>
            </div>
            
            <div class="p-8 border border-gray-200 bg-gray-50 text-sm leading-8 text-gray-700">
			    <h5 class="font-bold text-gray-900 mb-2 underline">[제 2조. 대금 지급 및 인도]</h5>
			    <ul class="space-y-2">
			        <li>
			            <strong>1. 1차 물품 대금:</strong> ₩<fmt:formatNumber value="${doc.totalAmt - 7500000}" pattern="#,###"/> 
			            <span class="text-xs text-gray-400">(계약 체결 시 즉시 납부)</span>
			        </li>
			        <li>
			            <strong>2. 2차 제세공과금 및 물류비:</strong> ₩7,500,000 
			            <span class="text-xs text-gray-400">(통관 완료 후 실비 정산액)</span>
			        </li>
			        <li class="pt-2 border-t border-gray-200">
			            <strong>3. 총 계약 합계액:</strong> 
			            <span class="text-lg font-black text-amber-700">₩<fmt:formatNumber value="${doc.totalAmt}" pattern="#,###"/></span>
			        </li>
			    </ul>
			</div>

            <%-- 4. 계약 세부 조항 (doc_content & due_date 활용) --%>
            <div class="grid grid-cols-12 gap-8 mb-10">
                <div class="col-span-12">
                    <div class="flex items-center mb-4 border-b border-gray-900 pb-2">
                        <h3 class="text-lg font-bold text-gray-900 uppercase tracking-tighter">Article 2. Terms and Conditions</h3>
                    </div>
                    <div class="p-8 border border-gray-200 bg-gray-50 text-sm leading-8 text-gray-700">
                        <ul class="list-decimal list-inside space-y-2">
                            <li><strong>납기 기한:</strong> 본 물품의 인도 및 대금 결제는 <span class="text-red-600 font-bold underline"><fmt:formatDate value="${doc.dueDate}" pattern="yyyy년 MM월 dd일"/></span>까지 완료하여야 한다.</li>
                            <c:choose>
                                <c:when test="${not empty doc.docContent}">
                                    <li><strong>특약 사항:</strong> <c:out value="${doc.docContent}" /></li>
                                </c:when>
                                <c:otherwise>
                                    <li><strong>대금 지급:</strong> 매입인은 계약 체결 후 지정된 계좌로 총액의 100%를 입금하여야 발주가 확정된다.</li>
                                    <li><strong>분쟁 해결:</strong> 본 계약에 명시되지 않은 사항은 상관례에 따르며 관할법원은 매도인 주소지 법원으로 한다.</li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>
                </div>
            </div>

            <%-- 하단 직인 영역 --%>
            <div class="flex justify-between items-center mt-12 py-10 border-t border-gray-200 relative">
                <div class="text-gray-400 text-[10px] font-mono italic">
                    Digitally Signed and Secured by Global Fuel Trading System<br>
                    Generated on <fmt:formatDate value="${doc.regDtime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                </div>
                <div class="flex gap-20">
                    <div class="text-center relative">
                        <p class="text-xs text-gray-500 mb-8">(갑) 매도인</p>
                        <p class="font-bold text-gray-900">(주)글로벌 유류 트레이딩 (인)</p>
                        <%-- 도장 이미지 (가상) --%>
                        <div class="absolute -right-4 -bottom-2 w-16 h-16 border-4 border-red-600 rounded-full flex items-center justify-center text-red-600 font-bold text-xs rotate-12 opacity-50">
                            계약인
                        </div>
                    </div>
                    <div class="text-center">
                        <p class="text-xs text-gray-500 mb-8">(을) 매입인</p>
                        <p class="font-bold text-gray-900">${info.companyName} (인)</p>
                    </div>
                </div>
            </div>

            <%-- 5. 하단 버튼 영역 --%>
            <div class="mt-8 pt-8 border-t border-gray-100 no-print flex justify-end gap-2">
                <button type="button" onclick="window.print()" class="px-6 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg hover:bg-black transition shadow-lg">프린트 / PDF 다운로드</button>
                <button type="button" onclick="window.close()" class="px-6 py-2 text-sm font-bold text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 transition">닫기</button>
            </div>
        </div>
    </div>

</body>
</html>