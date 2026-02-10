<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="showSearchArea" value="false" scope="request" />
<c:set var="showAddBtn" value="false" scope="request" />

<style>
    /* [1] 10개씩 보기 (셀렉트 박스 영역) 완전히 숨기기 */
    .dg-per-page-wrapper, 
    #dg-per-page,
    #dg-container + div .w-32 { 
        display: none !important; 
    }

    /* [2] 하단 페이징 영역 박스 스타일 초기화 */
    #dg-container + div {
        border-top: none !important;
        padding: 0 !important;
        background-color: transparent !important;
        justify-content: center !important; /* 페이징 버튼만 가운데로 */
    }

    /* [3] 상세 내역 타이틀 전용 스타일 */
    .stats-detail-header {
        border-top: 1px solid #f3f4f6;
        padding: 24px 32px 12px 32px;
        background-color: #ffffff;
    }

    /* [4] 기존 그리드 외곽선 제거 */
    .tui-grid-container {
        border: none !important;
    }
    .tui-grid-pagination {
        border: none !important;
        background-color: transparent !important;
        margin-top: 0 !important;
    }
</style>

<div class="mx-4 my-6 space-y-6">
    <%-- [1. 타이틀 영역] --%>
    <div class="px-8 py-4 flex flex-col md:flex-row justify-between items-center">
        <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">주문 통계 분석</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">주문 건수 및 매출 추이를 한눈에 분석합니다.</p>
        </div>
        <div class="flex items-center space-x-3 mt-4 md:mt-0">
            <button type="button" id="btnRefresh" class="px-4 py-2 text-sm font-semibold text-white bg-gray-900 rounded-lg shadow-md hover:bg-gray-800 transition-all active:scale-95">
                데이터 최신화
            </button>
            <button type="button" onclick="location.href='/admin/stats/order/excel'" class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition shadow-sm">
                엑셀 다운로드
            </button>
        </div>
    </div>
    
    <%@ include file="statsNav.jsp" %>

    <%-- [2. 차트 + 그리드 통합 섹션] --%>
    <section class="mx-5 bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 dark:border-gray-700 overflow-hidden">
        
        <%-- 차트 영역 --%>
        <div class="p-8 pb-4">
            <div class="flex justify-between items-center mb-8 w-full">
                <h4 id="chartTitle" class="text-md font-bold text-gray-900 dark:text-white border-l-4 border-gray-900 pl-3">
                    최근 주문 건수 추이
                </h4>
                <div class="flex space-x-1" id="orderTabGroup">
                    <button type="button" id="btnCount" onclick="updateChart('count', this)" 
                            class="btn-tab px-4 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg shadow-sm transition-all">
                        주문 건수
                    </button>
                    <button type="button" id="btnAmount" onclick="updateChart('amount', this)" 
                            class="btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 transition-all ml-1">
                        매출 금액
                    </button>
                </div>
            </div>
            
            <div class="w-full flex justify-center items-center">
                <div class="relative w-full max-w-[800px] h-[350px]">
                    <canvas id="orderChart"></canvas>
                </div>
            </div>
        </div>

        <%-- 그리드 영역 --%>
		<div class="stats-detail-header">
            <div class="flex items-center space-x-2">
                <div class="w-1 h-4 bg-gray-900 rounded-full"></div>
                <h3 class="text-sm font-bold text-gray-800 uppercase tracking-tight">주문 통계 상세 리포트</h3>
            </div>
        </div>
        
        <div class="px-5 pb-6"> 
            <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp" />
        </div>
    </section>

    <%-- 그리드 설정 --%>
    <c:set var="showSearchArea" value="false" scope="request" />
    <c:set var="showPerPage" value="false" scope="request" />
    <c:set var="showAddBtn" value="false" scope="request" />
    <c:set var="showDownloadBtn" value="false" scope="request" />
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="${pageContext.request.contextPath}/js/datagrid.js"></script>

<script>
    let deliveryGrid, orderChart, chartRawData = []; 

    document.addEventListener('DOMContentLoaded', function() {
        fetch('${pageContext.request.contextPath}/admin/stats/data')
            .then(res => res.json())
            .then(data => {
                const stats = data.orderStats || [];
                // 차트: 시간순 정렬
                chartRawData = [...stats].sort((a, b) => new Date(a.executedAt) - new Date(b.executedAt)).slice(-7);
                createOrderChart(chartRawData);
                
                // 그리드: 최신순 정렬 (7건 고정)
                const gridData = [...stats].sort((a, b) => new Date(b.executedAt) - new Date(a.executedAt)).slice(0, 7);
                initStatsGrid(gridData);
            });
        
        // 데이터 최신화 로직 생략 (기존과 동일)
    });

    function initStatsGrid(gridData) {
        deliveryGrid = new DataGrid({
            containerId: 'dg-container',
            data: gridData,
            rowHeaders: [],
            bodyHeight: 'auto', // 높이를 자동으로 조절하여 차트와 일체감 부여
            columns: [
                { header: '기준일', name: 'statsDate', align: 'center', formatter: ({value}) => value ? value.split('T')[0] : '-' },
                { header: '최신화 시간', name: 'executedAt', align: 'center', formatter: ({value}) => value ? value.replace('T', ' ').substring(0, 16) : '-' },
                { header: '총 주문', name: 'totalOrderCount', align: 'center', formatter: ({value}) => `<span class="font-bold text-gray-900">\${(value || 0).toLocaleString()}건</span>` },
                { header: '총 매출액', name: 'totalSalesAmount', align: 'center', formatter: ({value}) => `<span class="text-blue-600 font-bold">\${(value || 0).toLocaleString()}원</span>` }
            ],
            pageOptions: { useClient: true, perPage: 7 }
        });
    }

    // Chart 생성 및 Update 함수는 기존과 동일하게 유지
    function createOrderChart(stats) {
        const ctx = document.getElementById('orderChart').getContext('2d');
        orderChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: stats.map(s => {
                    const d = new Date(s.executedAt);
                    return (d.getMonth() + 1) + "/" + d.getDate() + " " + d.getHours() + ":" + String(d.getMinutes()).padStart(2, '0');
                }),
                datasets: [{
                    label: '주문 건수(건)',
                    data: stats.map(s => s.totalOrderCount),
                    borderColor: '#111827',
                    backgroundColor: 'rgba(17, 24, 39, 0.05)',
                    fill: true, tension: 0.4, pointRadius: 4, pointBackgroundColor: '#111827'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { position: 'bottom', labels: { font: { family: 'Pretendard' }, padding: 20 } } },
                scales: {
                    x: { grid: { display: false } },
                    y: { beginAtZero: true, ticks: { callback: v => v.toLocaleString() + '건' } }
                }
            }
        });
    }

    function updateChart(mode, btn) {
        if (!orderChart) return;
        document.querySelectorAll('.btn-tab').forEach(tab => {
            tab.className = "btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 transition-all ml-1";
        });
        btn.className = "btn-tab px-4 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg shadow-sm transition-all";

        if (mode === 'amount') {
            document.getElementById('chartTitle').innerText = '최근 매출 금액 추이';
            orderChart.data.datasets[0].label = '매출 금액(원)';
            orderChart.data.datasets[0].data = chartRawData.map(s => s.totalSalesAmount || 0);
            orderChart.options.scales.y.ticks.callback = v => v.toLocaleString() + '원';
        } else {
            document.getElementById('chartTitle').innerText = '최근 주문 건수 추이';
            orderChart.data.datasets[0].label = '주문 건수(건)';
            orderChart.data.datasets[0].data = chartRawData.map(s => s.totalOrderCount);
            orderChart.options.scales.y.ticks.callback = v => v.toLocaleString() + '건';
        }
        orderChart.update();
    }
</script>