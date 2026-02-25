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
const cp = "${cp}";
/** 1. 데이터 매핑 (MyBatis 결과를 JS 객체로) **/
const rawData = [
    <c:if test="${not empty pendingList}">
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
        }${status.last ? '' : ','}
        </c:forEach>
    </c:if>
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
                        buttons: [ { text: '열기', action: 'OPEN_DETAIL', color: 'text-blue-500' } ]
                    }
                }
            }
        ],
        data: rawData
    });   
    pendingGrid.initFilters([
    	{ 
    		field: 'docType', 
    		title: '문서',
    		options: [
                { text: '견적 승인대기', value: 'ESTIMATE' },
                { text: '주문 승인대기', value: 'PURCHASE_ORDER' }
            ]
    	}
    ]);
});

window.handleGridAction = function(rawData, action) {
    if(action === 'OPEN_DETAIL') {
        const orderId = rawData.orderId;
        const docType = rawData.docType; // 'ESTIMATE' 또는 'ORDER'
        let targetUrl = "";
        
        if(docType === 'ESTIMATE') {
            // 견적 승인용 상세 페이지 (희망 단가, 총 합계 등 포함)
            targetUrl = cp + "/trade/approveEst?orderId=" + orderId;
        } else {
            // 일반 주문 승인용 상세 페이지
            targetUrl = cp + "/trade/previewOrder?orderId=" + orderId;
        }

        const win = window.open(targetUrl, "_blank");
        // 새 창이 닫혔는지 감지하거나, 새 창에서 부모창을 새로고침하게 유도
        const timer = setInterval(function() {
            if (win.closed) {
                clearInterval(timer);
                // 결재 처리가 되었을 수 있으므로 목록과 카운트를 새로고침
                location.reload(); 
            }
        }, 1000);
    }
};
</script>