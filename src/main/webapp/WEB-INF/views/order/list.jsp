<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<div class="px-4 py-6 space-y-6">
    <div>
        <h1 class="text-2xl font-bold text-gray-800 dark:text-white">${pageTitle}</h1>
    </div>
    
    <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp"/>

<script>
    const rawData = [
        <c:forEach var="order" items="${orderList}" varStatus="status">
        {
            orderId: "${order.orderId}",
            orderNo: "${order.orderNo}",
            productName: "${order.productName}",
            orderStatus: "${order.orderStatus}", 
            statusNm: "${order.statusNm}",       
            regDtime: "${order.regDtime}",
            deliveryStatusNm: "${not empty order.deliveryStatusNm ? order.deliveryStatusNm : '-'}"
        }${!status.last ? ',' : ''}
        </c:forEach>
    ];
    
    document.addEventListener('DOMContentLoaded', function() {
        const orderGrid = new DataGrid({
            containerId: 'dg-container',
            searchId: 'dg-search-input',
            perPageId: 'dg-per-page',
            btnSearchId: 'dg-btn-search',
     
            columns: [
                { header: '주문번호', name: 'orderNo'},
                { header: '상품명', name: 'productName'},
                { 
                    header: '주문상태', 
                    name: 'statusNm', 
                    align: 'center',
                    renderer: { 
                        type: CustomStatusRenderer, 
                        options: { theme: 'orderStatusNm' } 
                    }
                },
                { 
                    header: '배송현황',
                    name: 'deliveryStatusNm',
                    align: 'center',
                    renderer: { 
                        type: CustomStatusRenderer, 
                        options: { theme: 'deliveryStatus' } 
                    }
                },
                { header: '주문일', name: 'regDtime', align: 'center'},
                { 
                    header: '관리', 
                    name: 'manage', 
                    align: 'center',
                    sortable: false,
                    renderer: { 
                        type: CustomActionRenderer,
                        options: {
                            buttons: [
                                { text: '상세보기', action: 'detail', color: 'text-blue-500' },
                                { 
                                    text: '2차결제', 
                                    action: 'payment', 
                                    color: 'text-green-600',
                                    // 렌더러가 인식할 공통 필터링 조건
                                    visibleIf: { field: 'orderStatus', value: 'pm003' } 
                                }
                            ]
                        }
                    }
                } 
            ],
            data: rawData
        });

        // 주문상태 필터 초기화 (괄호 구조 교정)
        orderGrid.initFilters([
            { 
                field: 'orderStatus',
                title: '주문상태',
                options: [
                    { value: 'pm002', text: '1차 결제완료' },
                    { value: 'pm003', text: '2차 결제요청' },
                    { value: 'pm004', text: '2차 결제완료' }
                ]
            } 
        ]);
    });
    
    	window.handleGridAction = function(data, action) {
    	    if (action === 'detail') {
    	        // [모달 방식] 상세 페이지를 레이어 모달로 띄움 (함수는 아래 정의)
    	        openOrderDetailModal(data.orderId);
    	    } 
    	    else if (action === 'payment') {
    	        // [팝업 방식] 결제 프로세스만 새 창으로 띄움
    	        if(confirm('2차 결제를 진행하시겠습니까?')) {
    	            openPaymentPopup(data.orderNo);
    	        }
    	    }
    	};

    	// 결제 전 전용 팝업 함수
    	function openPaymentPopup(orderNo) {
    		if (!orderNo) {
    	        alert("주문 번호가 올바르지 않습니다.");
    	        return;
    	    }
    		
    	    const url = "${pageContext.request.contextPath}/payment/paySecond?orderNo=" + orderNo;
    	    const name = "paymentPopup";
    	    const specs = "width=540,height=700,top=100,left=100,scrollbars=yes";
    	 
    	    window.open(url, name, specs);
    	}

    	// 모달 오픈 함수 (간단 예시)
    	function openOrderDetailModal(orderId) {
		    const modal = document.getElementById('orderDetailModal');
		    const iframe = document.getElementById('detailIframe');
		    const url = "${pageContext.request.contextPath}/order/detail?orderId=" + orderId;
		
		    // 1. iframe에 URL 설정
		    iframe.src = url;
		
		    // 2. 모달 띄우기 (showModal은 뒷배경 클릭 방지 및 최상위 레이어 보장)
		    modal.showModal();
		    
			 // 배경 클릭 시 닫기
	        modal.addEventListener('click', function(e) {
	            if (e.target === modal) closeOrderDetailModal();
	        }, { once: true });
		}
		
		function closeOrderDetailModal() {
		    const modal = document.getElementById('orderDetailModal');
		    const iframe = document.getElementById('detailIframe');
		    
		    modal.close();
		    iframe.src = ""; // 창 닫을 때 내용 초기화 (메모리 관리)
		}

	    window.fetchData = function() {
	        const keyword = document.getElementById('dg-search-input').value;
	        const orderStatus = document.getElementById('filter-orderStatus')?.value || '';
	        let url = window.location.pathname + "?keyword=" + encodeURIComponent(keyword);
	        if (orderStatus) url += "&orderStatus=" + encodeURIComponent(orderStatus);
	        location.href = url;
	    };
</script>
<dialog id="orderDetailModal" class="rounded-lg shadow-xl w-full max-w-4xl p-0 backdrop:bg-gray-900/50">
    <div class="flex flex-col h-[85vh]"> 
        <div class="flex items-center justify-between p-4 border-b bg-white">
            <h3 class="text-xl font-bold text-gray-800">주문 상세 내역</h3>
            <button onclick="closeOrderDetailModal()" class="text-gray-500 hover:text-gray-700 text-3xl">&times;</button>
        </div>
        <div class="flex-1 bg-gray-50 overflow-hidden">
            <iframe id="detailIframe" src="" class="w-full h-full border-none"></iframe>
        </div>
    </div>
</dialog>
</div>
