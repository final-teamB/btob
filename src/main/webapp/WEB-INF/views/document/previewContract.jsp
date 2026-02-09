<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:if test="${empty dto}">
    <jsp:useBean id="ctrtDto" class="java.util.HashMap" scope="request"/>
    <c:set target="${ctrtDto}" property="ctrtNo" value="CT-2026-OIL-7721"/>
    <c:set target="${ctrtDto}" property="ctrtNm" value="유류 매매 및 공급에 관한 기본 계약서"/>
    <c:set target="${ctrtDto}" property="sellerNm" value="(주)글로벌 유류 트레이딩"/>
    <c:set target="${ctrtDto}" property="buyerNm" value="(주)대한물류네트웍스"/>
    <c:set target="${ctrtDto}" property="totalAmount" value="154700000"/>
    <c:set var="dto" value="${ctrtDto}" scope="request"/>
</c:if>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>계약서 - ${dto.ctrtNo}</title>
<script src="https://cdn.tailwindcss.com"></script>
<style>
    @media print { .no-print { display: none !important; } body { background: white !important; } }
    body { font-family: 'Pretendard', sans-serif; background-color: #f3f4f6; color: #1f2937; }
    .line-title { border-left: 4px solid #111827; padding-left: 12px; margin-bottom: 16px; font-weight: 800; }
    .contract-table th, .contract-table td { border: 1px solid #d1d5db; padding: 12px; font-size: 14px; }
</style>
</head>
<body class="py-12">

    <div class="max-w-4xl mx-auto bg-white shadow-2xl p-16 border-t-[12px] border-gray-900 relative">
        
        <%-- 상단 헤더 --%>
        <div class="text-center mb-16">
            <h1 class="text-4xl font-black tracking-widest underline underline-offset-8 mb-6">${dto.ctrtNm}</h1>
            <p class="text-sm font-mono text-gray-400">계약번호: ${dto.ctrtNo}</p>
        </div>

        <%-- 당사자 표시 --%>
        <div class="mb-12 leading-loose text-justify">
            <p class="text-lg">
                매도인 <strong>${dto.sellerNm}</strong> (이하 "갑")와 매수인 <strong>${dto.buyerNm}</strong> (이하 "을")은 
                합의된 조건에 따라 유류 매매 계약을 체결하며, 신의성실의 원칙에 따라 본 계약상의 의무를 이행할 것을 확약한다.
            </p>
        </div>

        <%-- 제1조 목적물 명세 (견적/주문서 연동) --%>
        <div class="mb-12">
            <h3 class="line-title text-xl uppercase italic">제 1 조 (계약 목적물 및 대금)</h3>
            <table class="w-full contract-table mb-4">
                <thead>
                    <tr class="bg-gray-50 text-xs">
                        <th>품명 및 규격</th>
                        <th>수량 (BBL)</th>
                        <th>단가 (KRW)</th>
                        <th class="bg-gray-100">공급가액 (VAT별도)</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${detailList}">
                        <tr class="text-center">
                            <td class="font-bold text-left">${item.productNm}</td>
                            <td class="font-mono"><fmt:formatNumber value="${item.productQty}" pattern="#,###"/></td>
                            <td class="text-right font-mono">₩<fmt:formatNumber value="${item.productPrc}" pattern="#,###"/></td>
                            <td class="text-right font-black bg-gray-50/50">₩<fmt:formatNumber value="${item.productAmt}" pattern="#,###"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
                <tfoot>
                    <tr class="bg-gray-900 text-white font-bold">
                        <td colspan="3" class="text-right py-4 px-6">총 합계 금액 (VAT 포함)</td>
                        <td class="text-right py-4 px-6 text-xl">
                            ₩<fmt:formatNumber value="${dto.totalAmount}" pattern="#,###"/>
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>

        <%-- 실무 조항 --%>
        <div class="space-y-10 text-sm leading-relaxed mb-20 text-gray-700">
            <div>
                <h4 class="font-black text-gray-900 mb-2">제 2 조 (인도 및 검수)</h4>
                <p>1. "갑"은 "을"이 지정한 장소 및 납기에 맞춰 목적물을 인도하여야 한다.</p>
                <p>2. 품질 및 수량의 검수는 검사기관(SGS 또는 이에 준하는 공인기관)의 성적서를 기준으로 하며, 인도 완료 시점으로 한다.</p>
            </div>
            <div>
                <h4 class="font-black text-gray-900 mb-2">제 3 조 (대금 결제)</h4>
                <p>1. "을"은 목적물 인수 후 7일 이내에 현금 또는 "갑"이 승인한 결제 수단으로 대금을 지급하여야 한다.</p>
                <p>2. 대금 지급 지연 시 연 12%의 지연 배상금을 가산하여 지급한다.</p>
            </div>
            <div>
                <h4 class="font-black text-gray-900 mb-2">제 4 조 (비밀유지)</h4>
                <p>양 당사자는 본 계약과 관련하여 취득한 상대방의 영업비밀을 제3자에게 누설하여서는 아니 된다.</p>
            </div>
        </div>

        <%-- 서명 날인 --%>
        <div class="grid grid-cols-2 gap-16 pt-12 border-t-2 border-gray-200">
            <%-- 갑 --%>
            <div class="relative">
                <p class="text-xs font-bold text-gray-400 mb-6 uppercase tracking-widest">매도인 (갑)</p>
                <div class="space-y-2">
                    <p class="text-xl font-black">${dto.sellerNm}</p>
                    <p class="text-xs text-gray-500">주소: 서울특별시 중구 세종대로 110</p>
                    <p class="text-sm font-bold mt-4">대표이사: 홍 길 동 (인)</p>
                </div>
                <%-- 법인인감 이미지 --%>
                <div class="absolute -right-4 -bottom-2 opacity-70">
                    <div class="w-20 h-20 border-4 border-red-600 rounded-full flex items-center justify-center text-red-600 font-black text-sm rotate-12 border-double">
                        글로벌<br>트레이딩
                    </div>
                </div>
            </div>

            <%-- 을 --%>
            <div class="relative">
                <p class="text-xs font-bold text-gray-400 mb-6 uppercase tracking-widest">매수인 (을)</p>
                <div class="space-y-2 text-gray-300">
                    <p class="text-xl font-black">${dto.buyerNm}</p>
                    <p class="text-xs">주소: 서울특별시 강남구 테헤란로 456</p>
                    <p class="text-sm font-bold mt-4">대표이사: 이 몽 룡 (인)</p>
                </div>
                <div class="absolute right-4 bottom-0 w-20 h-20 border-2 border-dashed border-gray-300 rounded-full flex items-center justify-center text-[10px] text-gray-300 font-bold">
                    서명 날인
                </div>
            </div>
        </div>

        <%-- 하단 날짜 --%>
        <div class="text-center mt-24">
            <p class="text-2xl font-serif tracking-[0.5em] text-gray-800">2026년 02월 05일</p>
        </div>
    </div>

    <%-- 버튼 --%>
    <div class="max-w-4xl mx-auto mt-10 flex justify-end gap-3 no-print">
        <button type="button" onclick="window.print()" class="px-6 py-2 text-sm font-bold text-gray-600 bg-white border border-gray-300 rounded shadow-sm hover:bg-gray-50 transition">인쇄 및 PDF 저장</button>
        <button type="button" class="px-10 py-2 text-sm font-bold text-white bg-gray-900 rounded shadow-xl hover:bg-black transition ring-2 ring-gray-600 ring-offset-2">전자계약 서명완료</button>
    </div>

</body>
</html>