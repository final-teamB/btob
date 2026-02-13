<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<style>
   /* 모달 기본 스타일 보정 */
    #orderDetailModal {
        position: fixed;        /* 화면에 고정 */
        top: 50%;               /* 위에서 50% */
        left: 50%;              /* 왼쪽에서 50% */
        transform: translate(-50%, -50%); /* 정확히 자신의 절반만큼 이동하여 정중앙 배치 */
        
        margin: 0;              /* 기본 margin 제거 */
        border: none;
        outline: none;
        padding: 0;
        display: none;          /* 기본적으로 숨김 (showModal 시 block으로 변경됨) */
    }

    /* 모달이 열렸을 때 표시 설정 */
    #orderDetailModal[open] {
        display: flex;          /* flex로 열기 */
        flex-direction: column;
    }

    /* 뒷배경(Backdrop) 스타일 */
    #orderDetailModal::backdrop {
        background: rgba(0, 0, 0, 0.6);
        backdrop-filter: blur(3px);
    }

    /* 애니메이션 */
    #orderDetailModal[open] {
        animation: modal-pop 0.25s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    }

    @keyframes modal-pop {
        from { opacity: 0; transform: translate(-50%, -45%) scale(0.95); }
        to { opacity: 1; transform: translate(-50%, -50%) scale(1); }
    }
</style>
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
    	        openOrderDetailModal(data.orderNo);
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
		
		    const width = 600;
		    const height = 800;
		
		    // 1. 현재 브라우저 창의 위치와 크기 계산
		    const windowLeft = window.screenLeft || window.screenX; // 브라우저의 왼쪽 좌표
		    const windowTop = window.screenTop || window.screenY;   // 브라우저의 상단 좌표
		    const windowWidth = window.innerWidth || document.documentElement.clientWidth; // 브라우저 내부 가로폭
		    const windowHeight = window.innerHeight || document.documentElement.clientHeight; // 브라우저 내부 높이
		
		    // 2. 브라우저 중앙 좌표 계산
		    const left = windowLeft + (windowWidth / 2) - (width / 2);
		    const top = windowTop + (windowHeight / 2) - (height / 2);
		
		    const url = "${pageContext.request.contextPath}/payment/paySecond?orderNo=" + orderNo;
		    
		    // 3. 팝업 실행
		    const specs = "width=" + width + ",height=" + height + 
		                  ",top=" + top + ",left=" + left + 
		                  ",scrollbars=yes,resizable=yes";
		
		    window.open(url, "paymentPopup", specs);
		}

    	function openOrderDetailModal(orderNo) {
    	    const modal = document.getElementById('orderDetailModal');
    	    const iframe = document.getElementById('detailIframe');
    	    
    	    // 1. URL 설정
    	    iframe.src = "${pageContext.request.contextPath}/order/detail?orderNo=" + orderNo;

    	    // 2. 배경 스크롤 차단 (선택)
    	    document.body.style.overflow = 'hidden';

    	    // 3. 모달 표시
    	    modal.showModal();
    	}

    	function closeOrderDetailModal() {
    	    const modal = document.getElementById('orderDetailModal');
    	    modal.close();
    	    document.body.style.overflow = 'auto'; // 스크롤 복구
    	}

    	// 초기 로드시 배경 클릭 이벤트 1회만 등록
    	document.addEventListener('DOMContentLoaded', function() {
    	    const modal = document.getElementById('orderDetailModal');
    	    modal.addEventListener('click', (e) => {
    	        if (e.target === modal) closeOrderDetailModal();
    	    });
    	});

	    window.fetchData = function() {
	        const keyword = document.getElementById('dg-search-input').value;
	        const orderStatus = document.getElementById('filter-orderStatus')?.value || '';
	        let url = window.location.pathname + "?keyword=" + encodeURIComponent(keyword);
	        if (orderStatus) url += "&orderStatus=" + encodeURIComponent(orderStatus);
	        location.href = url;
	    };
</script>
<dialog id="orderDetailModal" 
        class="w-[95%] max-w-4xl rounded-xl shadow-2xl overflow-hidden">
    <div class="flex flex-col h-[85vh] w-full bg-white"> 
        <div class="flex items-center justify-between p-4 border-b bg-white">
            <h3 class="text-xl font-bold text-gray-800">주문 상세 내역</h3>
            <button onclick="closeOrderDetailModal()" class="text-gray-400 hover:text-gray-600 p-2">
                <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                </svg>
            </button>
        </div>
        <div class="flex-1 bg-gray-50">
            <iframe id="detailIframe" src="" class="w-full h-full border-none"></iframe>
        </div>
    </div>
</dialog>
</div>
