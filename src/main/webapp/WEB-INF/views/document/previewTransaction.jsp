<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>RECEIPT | (주)글로벌 유류 트레이딩</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.tailwindcss.com"></script>
<style>
    @media print {
        /* 1. 페이지 설정 */
        @page {
            margin: 15mm 10mm;
        }

        /* 2. 요소 잘림 방지: 테이블 행, 정보 박스, 도장 영역 */
        tr, 
        .p-6, 
        .receipt-seal-section {
            page-break-inside: avoid !important;
            break-inside: avoid !important;
        }

        /* 3. 여백 최적화 (0.85 배율 대응) */
        body { padding-top: 0 !important; padding-bottom: 0 !important; }
        .py-10, .py-12, .mb-12 { padding-top: 1rem !important; padding-bottom: 1rem !important; margin-bottom: 1.5rem !important; }
        
        /* 4. PDF 변환 시 불필요한 요소 제거 */
        .no-print { display: none !important; }
        .print-shadow-none { box-shadow: none !important; border: 1px solid #e5e7eb !important; }
         body { -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; }
    }
    body { font-family: 'Pretendard', sans-serif; background-color: #f3f4f6; }
</style>
</head>
<body class="py-10">

    <div class="max-w-screen-xl mx-auto px-4">
        <div class="bg-white p-12 rounded-xl shadow-lg border border-gray-100 print-shadow-none">
            
            <%-- 1. 헤더 영역 (견적서/계약서와 통일) --%>
            <div class="flex justify-between items-end border-b-4 border-blue-900 pb-8 mb-10">
                <div>
                    <h2 class="text-4xl font-black text-blue-900 tracking-tighter uppercase italic">Transaction Receipt</h2>
                    <p class="mt-4 text-sm text-gray-500">문서번호: 
                        <span class="font-bold text-gray-800 italic uppercase">
                            <c:out value="${doc.docNo}" />
                        </span>
                    </p>
                </div>
                <div class="text-right">
                    <h3 class="text-2xl font-bold text-gray-900">(주)글로벌 유류 트레이딩</h3>
                    <p class="text-gray-500 text-sm">사업자번호: 123-45-67890</p>
                    <p class="text-xs text-gray-400 font-mono uppercase mt-1 italic italic">Payment Confirmed</p>
                </div>
            </div>

            <%-- 2. 거래 당사자 정보 --%>
            <div class="grid grid-cols-2 gap-8 mb-12">
                <div class="p-6 bg-gray-50 rounded-xl border border-gray-200">
                    <h4 class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-3">공급받는 자 (Buyer)</h4>
                    <div class="space-y-2 text-sm">
                        <p class="text-sm font-bold text-gray-800">${info.companyName}</p>
					    <p class="text-xs text-gray-500 mt-1 leading-relaxed">
					        ${info.addrKor} <br>
					        T. ${info.companyPhone} </p>
					    <p class="text-[11px] text-blue-600 mt-2 font-medium">
					        담당자: ${info.userName} (${info.phone})
					    </p>
                    </div>
                </div>
                <div class="flex flex-col justify-end text-right p-6">
                    <p class="text-sm text-gray-500 mb-1">거래 일시</p>
                    <p class="text-xl font-bold text-gray-800">
                      	${doc.formattedRegDtime}
                    </p>
                </div>
            </div>

            <%-- 3. 상세 결제 내역 (하드코딩 금액 포함) --%>
            <div class="mb-12">
                <div class="flex items-center mb-4">
                    <div class="w-1.5 h-6 bg-blue-900 mr-3"></div>
                    <h3 class="text-lg font-bold text-gray-800 uppercase tracking-tight">Payment Details</h3>
                </div>
                <table class="w-full border-collapse">
                    <thead>
                        <tr class="bg-gray-800 text-white text-xs uppercase tracking-wider">
                            <th class="py-3 px-4 text-left rounded-tl-lg">Description (항목)</th>
                            <th class="py-3 px-4 text-right rounded-tr-lg">Amount (금액)</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100 border-b-2 border-gray-800">
                        <tr>
                            <td class="py-5 px-4 font-bold text-gray-800"><c:out value="${doc.docTitle}" /></td>
                            <td class="py-5 px-4 text-right font-mono text-gray-700">
                                ₩<fmt:formatNumber value="${doc.firstPaymentAmt}" pattern="#,###"/>
                            </td>
                        </tr>
                        <tr>
                            <td class="py-4 px-4 text-gray-600 pl-8 text-sm italic">└ 유류세 (Oil Tax)</td>
                            <td class="py-4 px-4 text-right font-mono text-gray-500 text-sm">₩5,500,000</td>
                        </tr>
                        <tr>
                            <td class="py-4 px-4 text-gray-600 pl-8 text-sm italic">└ 수입 관세 (Import Duty)</td>
                            <td class="py-4 px-4 text-right font-mono text-gray-500 text-sm">₩1,200,000</td>
                        </tr>
                        <tr>
                            <td class="py-4 px-4 text-gray-600 pl-8 text-sm italic">└ 저유소 보관 및 탱크로리 운송비</td>
                            <td class="py-4 px-4 text-right font-mono text-gray-500 text-sm">₩800,000</td>
                        </tr>
                    </tbody>
                    <tfoot>
                        <tr class="bg-blue-50">
                            <td class="py-6 px-4 font-black text-blue-900 text-lg uppercase">Total Paid Amount</td>
                            <td class="py-6 px-4 text-right">
                                <span class="text-3xl font-black text-blue-900 font-mono tracking-tighter italic">
                                    ₩<fmt:formatNumber value="${doc.totalAmt}" pattern="#,###"/>
                                </span>
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>

            <%-- 4. 하단 영수 확인 도장 영역 --%>
            <div class="receipt-seal-section mt-20 flex flex-col items-center justify-center relative">
                <p class="text-gray-400 text-sm mb-4 italic">위 금액을 정히 영수함에 따라 본 거래 내역서를 발행합니다.</p>
                <div class="relative">
                    <p class="text-4xl font-black border-[6px] border-red-500/70 inline-block px-12 py-4 text-red-500/70 rounded-lg rotate-[-3deg] uppercase tracking-widest">
                        Confirmed
                    </p>
                    <%-- 작은 날짜 인장 (선택사항) --%>
                    <div class="absolute -right-8 -bottom-4 w-16 h-16 border-2 border-red-400 rounded-full flex items-center justify-center text-[10px] text-red-400 font-bold rotate-12 bg-white">
                        	${doc.formattedRegDtime}
                    </div>
                </div>
                <p class="mt-10 font-bold text-gray-900 text-xl serif-title">(주)글로벌 유류 트레이딩 대표이사 김철수</p>
            </div>

            <%-- 5. 하단 버튼 (PDF 다운로드 유지) --%>
            <div class="mt-12 pt-8 border-t border-gray-100 no-print flex justify-end gap-3">
                <button type="button" onclick="exportPdf(${doc.docId})" class="px-8 py-3 bg-blue-900 text-white text-sm font-bold rounded-lg hover:bg-blue-800 shadow-lg transition">
                    PDF 거래내역서 다운로드
                </button>
                <button type="button" onclick="window.close()" class="px-8 py-3 bg-gray-100 text-gray-500 text-sm font-bold rounded-lg hover:bg-gray-200 transition">
                    닫기
                </button>
            </div>
        </div>
    </div>
<script>
	function exportPdf(docId) {
	    window.location.href = "${pageContext.request.contextPath}/document/exportPdf?docId=" + docId;
	}
</script>
</body>
</html>