<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>원유 견적서</title>

<style>
   /* PDF 변환 시 용지 설정 */
    @page {
        size: A4;
        margin: 15mm;
    }

    body {
        font-family: 'NanumGothic';
        margin: 0;
        padding: 0;
    }

    .estimate-wrap {
        /* 800px 대신 100%를 사용하고 최대 너비를 제한하세요 */
        width: 100%; 
        max-width: 700px; 
        margin: 0 auto;
        /* border나 padding이 너비에 포함되도록 설정 */
        box-sizing: border-box; 
    }

    h1 {
        text-align: center;
        margin-bottom: 30px;
    }

    .info-table, .item-table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 25px;
    }

    .info-table th, .info-table td,
    .item-table th, .item-table td {
        border: 1px solid #999;
        padding: 10px;
        font-size: 14px;
    }

    .info-table th {
        background-color: #f2f2f2;
        width: 20%;
        text-align: left;
    }

    .item-table th {
        background-color: #e9ecef;
        text-align: center;
    }

    .item-table td {
        text-align: center;
    }

    .total {
        text-align: right;
        font-size: 16px;
        font-weight: bold;
    }

    .footer {
        margin-top: 40px;
        text-align: right;
    }

    .stamp {
        margin-top: 60px;
        text-align: right;
    }
    
    /* PDF 파일 안에는 버튼이 안 나오게 설정 */
    .no-pdf {
        display: none;
    }
    
    /* 화면에서 볼 때만 버튼 보이게 (선택사항) */
    @media screen {
        .no-pdf {
            display: block;
            margin: 20px auto;
            padding: 10px 20px;
            cursor: pointer;
        }
    }
</style>
</head>

<body>
<div class="estimate-wrap">

    <h1>원유 공급 견적서</h1>

    <!-- 기본 정보 -->
    <table class="info-table">
        <tr>
            <th>견적번호</th>
            <td>EST-2026-001</td>
            <th>견적일자</th>
            <td>2026-01-26</td>
        </tr>
        <tr>
            <th>공급업체</th>
            <td>한국석유무역㈜</td>
            <th>담당자</th>
            <td>김대표</td>
        </tr>
        <tr>
            <th>수신처</th>
            <td colspan="3">OO에너지㈜</td>
        </tr>
    </table>

    <!-- 품목 정보 -->
    <table class="item-table">
        <thead>
            <tr>
                <th>No</th>
                <th>품목명</th>
                <th>규격</th>
                <th>수량 (KL)</th>
                <th>단가 (원)</th>
                <th>금액 (원)</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td>두바이유</td>
                <td>ISO Tank</td>
                <td>100</td>
                <td>1,200,000</td>
                <td>120,000,000</td>
            </tr>
            <tr>
                <td>2</td>
                <td>브렌트유</td>
                <td>Bulk</td>
                <td>50</td>
                <td>1,300,000</td>
                <td>65,000,000</td>
            </tr>
        </tbody>
    </table>

    <!-- 합계 -->
    <p class="total">
        공급가액 합계 : 185,000,000 원<br/>
        부가세 (10%) : 18,500,000 원<br/>
        총 견적금액 : 203,500,000 원
    </p>

    <!-- 비고 -->
    <table class="info-table">
        <tr>
            <th>납기조건</th>
            <td>계약일로부터 7일 이내</td>
        </tr>
        <tr>
            <th>결제조건</th>
            <td>세금계산서 발행 후 30일 이내</td>
        </tr>
        <tr>
            <th>비고</th>
            <td>본 견적서는 발행일로부터 14일간 유효합니다.</td>
        </tr>
    </table>

    <!-- 서명 -->
    <div class="stamp">
        2026년 01월 26일<br/><br/>
        한국석유무역㈜<br/>
        대표이사 김대표 (인)
    </div>

</div>
<button class="no-pdf" onclick="location.href='/testjg/pdfDown'">
    PDF로 변환
</button>
</body>
</html>
