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
        docType: "${p.docType}",
        userNo: "${p.userNo}",
        userName: "${p.userName}",
        userId: "${p.userId}",
        phone: "${p.phone}",
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
                renderer: { 
                    type: CustomStatusRenderer, 
                    options: { theme: 'docType' }
                }
            },
            { header: '문서번호', name: 'orderNo', align: 'left'},
            { header: '요청자', name: 'userName'},
            { header: '연락처', name: 'phone'},
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
});

window.handleGridAction = function(rowData, action) {
    if(action === 'OPEN_DETAIL') {
        const orderId = rowData.orderId;
        const ctx = "${pageContext.request.contextPath}";
       
        const targetUrl = ctx + "/document/previewOrder?orderId=" + orderId;


        // 창 이름을 "_blank"로 주어 별도의 탭에서 열리게 합니다.
        const win = window.open(targetUrl, "_blank");
        if (win) win.focus();
    }
};
</script>