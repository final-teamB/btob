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
            amount: "${order.amount}",
            regDtime: "${order.regDtime}",
            deliveryStatusNm: "${order.deliveryStatusNm}"
        }${!status.last ? ',' : ''}
        </c:forEach>
    ];
    
    document.addEventListener('DOMContentLoaded', function() {
        const orderGrid = new DataGrid({
            containerId: 'dg-container',
            searchId: 'dg-search-input',
            perPageId: 'dg-per-page',
            btnSearchId: 'dg-btn-search',
            // [개인화 설정] 2026-02-02 저장된 정보 반영
            showSearchArea: true,
            showPerPage: true,
                      
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
                } // 닫는 괄호 추가됨
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
    
    // 상세보기 및 결제 액션 핸들러
    window.handleGridAction = function(data, action) {
        if (action === 'detail') {
            location.href = "/order/detail/" + data.orderId;
        } else if (action === 'payment') {
            if(confirm('2차 결제를 진행하시겠습니까?')) {
                // 결제 모달 호출 등의 로직
                console.log('Payment for:', data.orderId);
            }
        }
    };

    window.fetchData = function() {
        const keyword = document.getElementById('dg-search-input').value;
        const orderStatus = document.getElementById('filter-orderStatus')?.value || '';
        let url = window.location.pathname + "?keyword=" + encodeURIComponent(keyword);
        if (orderStatus) url += "&orderStatus=" + encodeURIComponent(orderStatus);
        location.href = url;
    };
</script>
</div>
