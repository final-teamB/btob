<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<div class="px-4 py-6 space-y-6">
    <div>
        <h1 class="text-2xl font-bold text-gray-800 dark:text-white">${pageTitle}</h1>
    </div>
    
    <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp"/>
</div>

<script>
/** 1. 데이터 매핑 (MyBatis 결과를 JS 객체로) **/
const rawData = [
    <c:forEach var="p" items="${pendingList}" varStatus="status">
    {
        orderId: "${p.orderId}",
        orderNo: "${p.orderNo}",
        quoteReqId: "${p.quoteReqId}",
        docType: "${p.docType}",
        orderStatus: "${p.orderStatus}",
        cartIds: "${p.cartIds}",
        cartCount: "${p.cartCount}",
        totalQty: "${p.totalQty}",
        totalPrice: "${p.totalPrice}",
        fuelNm: "${p.fuelNm}",
        baseUnitPrc: "${p.baseUnitPrc}",
        userNo: "${p.userNo}",
        userName: "${p.userName}",
        userId: "${p.userId}",
        userPhone: "${p.phone}",
        companyName: "${p.companyName}",
        companyCd: "${p.companyCd}",
        bizNumber: "${p.bizNumber}",
        addrKor: "${p.addrKor}",
        regDtime: "${p.regDtime}"
    }${!status.last ? ',' : ''}
    </c:forEach>
];

document.addEventListener('DOMContentLoaded', function() {
    /** 2. 그리드 초기화 **/
    const pendingGrid = new DataGrid({
        containerId: 'dg-container',
        searchId: 'dg-search-input',
        perPageId: 'dg-per-page',
        btnSearchId: 'dg-btn-search',
        filterField: 'docType',	
        filterSelectId: 'dg-common-filter', 
        
        columns: [
            { 
                header: '구분', 
                name: 'docType', 
                align: 'center',
                width: 140,
                renderer: { 
                    type: CustomStatusRenderer, 
                    options: { theme: 'docType' }
                }
            },
            { 
                header: '문서번호', 
                name: 'orderNo', 
                align: 'left',
                width: 200,
                formatter: (val) => `<span class="font-mono font-bold text-gray-700">\${val}</span>`
            },
            { header: '요청자', name: 'userName'},
            { header: '연락처', name: 'userPhone'},
            { header: '신청일시', name: 'regDtime'},
            { 
                header: '상세검토',
                name: 'action',
                align: 'center',
                sortable: false,
                renderer: {
                    type: CustomActionRenderer,
                    options: {
                        buttons: [ { text: '열기', action: 'OPEN_DETAIL', color: 'text-indigo-600 font-bold' } ]
                    }
                }
            }
        ],
        data: rawData
    });

    /** 4. 상세검토 버튼 클릭 이벤트 (POST 팝업) **/
    pendingGrid.on('actionClick', (e) => {
        if(e.action === 'OPEN_DETAIL') {
            const rowData = e.row;
            const safeOrderNo = rowData.orderNo.replace(/[^a-zA-Z0-9]/g, "");
            const name = "DocPreview_" + safeOrderNo;
            
            const targetUrl = rowData.docType === 'ESTIMATE' 
                              ? `\${pageContext.request.contextPath}/document/previewEst` 
                              : `\${pageContext.request.contextPath}/document/previewOrder`;
			
            const width = 1250;
            const height = 900;
            const left = (window.screen.width / 2) - (width / 2);
            const top = (window.screen.height / 2) - (height / 2);
            const specs = `width=${width}, height=${height}, top=${top}, left=${left}, scrollbars=yes, resizable=yes`;
            window.open("", name, specs);

            const form = document.createElement("form");
            form.method = "POST";
            form.action = targetUrl;
            form.target = name;

            Object.keys(rowData).forEach(key => {
                const input = document.createElement("input");
                input.type = "hidden";
                input.name = key;
                input.value = rowData[key];
                form.appendChild(input);
            });

            document.body.appendChild(form);
            form.submit();
            document.body.removeChild(form);
        }
    });
});
</script>