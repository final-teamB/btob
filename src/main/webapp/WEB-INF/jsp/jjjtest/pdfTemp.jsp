<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>${reportTitle}</title>
    <style>
        @page { size: A4; margin: 15mm; }
        body { 
            font-family: 'NanumGothic', sans-serif; 
            line-height: 1.2;
            color: #333;
            margin: 0;
        }
        .header { text-align: center; margin-bottom: 20px; }
        .title { font-size: 22px; font-weight: bold; padding-bottom: 5px; border-bottom: 2px solid #000; display: inline-block; }
        
        table { width: 100%; border-collapse: collapse; table-layout: fixed; margin-top: 10px; }
        th { background-color: #f2f5f8; border: 0.5pt solid #666; padding: 6px 2px; font-size: 10px; font-weight: bold; }
        td { border: 0.5pt solid #666; padding: 5px 3px; font-size: 9px; word-wrap: break-word; vertical-align: middle; }
        
        .section-title { font-size: 13px; font-weight: bold; margin-top: 15px; margin-bottom: 5px; color: #1a365d; }
        .print-info { text-align: right; font-size: 9px; color: #666; margin-bottom: 5px; }
        
        .text-center { text-align: center; }
        .text-right { text-align: right; }
        .bg-gray { background-color: #f9f9f9; }

        .footer { position: fixed; bottom: -5mm; width: 100%; text-align: center; font-size: 8px; color: #999; }
    </style>
</head>
<body>

    <div class="header">
        <div class="title">${reportTitle}</div>
    </div>

    <div class="print-info">출력일시: ${printDate}</div>

    <div class="section-title">■ 데이터 조회 목록</div>
    <table>
        <colgroup>
            <col style="width: 30px;" />
            <col style="width: 80px;" />
            <col style="width: 180px;" />
            <col style="width: 50px;" />
            <col style="width: 70px;" />
            <col style="width: 90px;" />
        </colgroup>
        <thead>
            <tr>
                <th>No</th>
                <th>참조유형/ID</th>
                <th>파일명 (원본파일명)</th>
                <th>확장자</th>
                <th>용량(Byte)</th>
                <th>등록일시</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${dataList}" varStatus="status">
                <tr <c:if test="${status.index % 2 != 0}">class="bg-gray"</c:if>>
                    <td class="text-center">${status.count}</td>
                    <td class="text-center">
                        <strong>${item.refTypeCd}</strong><br/>
                        (${item.refId})
                    </td>
                    <td>${item.orgFileNm}</td>
                    <td class="text-center">${item.fileExt}</td>
                    <td class="text-right">
                        <fmt:formatNumber value="${item.fileSize}" type="number" />
                    </td>
                    <td class="text-center">
                        ${item.regDtimeDisplay}
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty dataList}">
                <tr>
                    <td colspan="6" class="text-center" style="padding: 20px;">데이터가 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <div class="section-title">■ 검인 내역</div>
    <div style="border: 0.5pt solid #666; padding: 8px; font-size: 10px;">
        본 보고서는 시스템상의 실시간 데이터를 바탕으로 생성되었습니다.<br />
        - 특이사항: 사용여부(use_yn) 'N' 데이터 제외.
    </div>

    <div class="footer">발행일: ${printDate}</div>
</body>
</html>