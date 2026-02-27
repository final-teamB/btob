<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="showSearchArea" value="false" scope="request" />
<c:set var="showAddBtn" value="false" scope="request" />

<style>
    /* [기능 유지] 10개씩 보기 및 페이징 영역 스타일 초기화 */
    .dg-per-page-wrapper, #dg-per-page, #dg-container + div .w-32 { 
        display: none !important; 
    }

    #dg-container + div {
        border-top: none !important;
        padding: 10px 0 20px 0 !important;
        background-color: transparent !important;
        display: flex !important;
        justify-content: center !important; 
    }

    /* 상세 내역 타이틀 (다크모드 대응) */
    .stats-detail-header {
        border-top: 1px solid #f3f4f6;
        padding: 24px 32px 12px 32px;
        background-color: #ffffff;
    }
    .dark .stats-detail-header {
        border-top: 1px solid #374151;
        background-color: #374151;
    }

    .btn-tab { transition: all 0.2s; }
</style>

<div class="my-6 space-y-6">
    <%-- [1. 타이틀 영역] --%>
    <div class="px-9 py-4 flex flex-col md:flex-row justify-between items-start md:items-center">
	    <div class="w-full md:w-auto text-left">
	        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">주문 통계 분석</h1>
	        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">주문 건수 및 매출 추이를 한눈에 분석합니다.</p>
	    </div>
	    <div class="flex items-center space-x-3 mt-4 md:mt-0">
	        <button type="button" id="btnRefresh" class="px-4 py-2 text-sm font-semibold text-white bg-gray-900 dark:bg-gray-100 dark:text-gray-900 rounded-lg shadow-md hover:bg-gray-800 transition-all active:scale-95">
	            데이터 최신화
	        </button>
	        <button type="button" onclick="location.href='/admin/stats/order/excel'" class="px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-600 transition shadow-sm">
	            엑셀 다운로드
	        </button>
	    </div>
	</div>
    
    <%@ include file="statsNav.jsp" %>

    <%-- [2. 차트 + 그리드 통합 섹션] --%>
    <section class="mx-5 bg-white dark:bg-gray-700 rounded-lg shadow-sm border border-gray-100 dark:border-gray-700 overflow-hidden">
        
        <%-- 차트 영역 --%>
        <div class="p-8 pb-4">
            <div class="flex justify-between items-center mb-8 w-full">
                <h4 id="chartTitle" class="text-md font-bold text-gray-900 dark:text-white border-l-4 border-gray-900 dark:border-white pl-3">
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

        <%-- 그리드 영역 헤더 --%>
        <div class="stats-detail-header">
            <div class="flex justify-between items-center">
                <div class="flex items-center space-x-2">
                    <div class="w-1 h-4 bg-gray-900 dark:bg-white rounded-full"></div>
                    <h3 id="dg-title" class="text-sm font-bold text-gray-800 dark:text-gray-200 uppercase tracking-tight">주문 통계 상세 리포트 (전체)</h3>
                </div>
                <button type="button" onclick="resetFilter()" class="text-xs text-blue-500 dark:text-blue-400 hover:underline font-medium">
                    필터 초기화
                </button>
            </div>
        </div>
        
        <div class="px-5 pb-6"> 
            <div id="dg-container"></div>
            <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp" />
        </div>
    </section>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    let deliveryGrid, orderChart;
    let chartRawData = []; 
    let currentMode = 'count'; // 초기 모드: 주문 건수

    document.addEventListener('DOMContentLoaded', function() {
        refreshData();
        
        // 최신화 버튼 이벤트
        const btnRefresh = document.getElementById('btnRefresh');
        if(btnRefresh) {
            btnRefresh.addEventListener('click', executeBatch);
        }
    });

    // 1. 실제 데이터 갱신 (서버 배치 실행)
    function executeBatch() {
        const btn = document.getElementById('btnRefresh');
        btn.disabled = true;
        btn.innerText = '갱신 중...';

        fetch('${pageContext.request.contextPath}/admin/stats/refresh', { method: 'PUT' })
            .then(res => res.text())
            .then(result => {
                if (result.trim() === 'success') {
                    alert('데이터 최신화 완료!');
                    refreshData();
                } else {
                    alert('갱신 실패: ' + result);
                }
            })
            .finally(() => {
                btn.disabled = false;
                btn.innerText = '데이터 최신화';
            });
    }

    // 2. 데이터 가져오기 및 화면 초기화
    function refreshData() {
        const isDark = document.documentElement.classList.contains('dark');
        fetch('${pageContext.request.contextPath}/admin/stats/data')
            .then(res => res.json())
            .then(data => {
                const stats = data.orderStats || [];
                if (stats.length === 0) return;

                // 차트용 (과거순)
                chartRawData = [...stats].sort((a, b) => new Date(a.executedAt) - new Date(b.executedAt)).slice(-7);
                // 그리드용 (최신순)
                const gridData = [...stats].sort((a, b) => new Date(b.executedAt) - new Date(a.executedAt)).slice(0, 7);

                createOrderChart(chartRawData, isDark);
                initStatsGrid(gridData, isDark);
                
                // 현재 모드에 맞춰 차트 다시 업데이트 (매출금액 유지 등)
                const activeBtn = (currentMode === 'count') ? document.getElementById('btnCount') : document.getElementById('btnAmount');
                updateChart(currentMode, activeBtn);
            });
    }

    // 3. 차트 생성
    function createOrderChart(stats, isDark) {
        const ctx = document.getElementById('orderChart').getContext('2d');
        if(orderChart) orderChart.destroy();

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
                    borderColor: isDark ? '#F3F4F6' : '#111827',
                    backgroundColor: isDark ? 'rgba(243,244,246,0.1)' : 'rgba(17,24,39,0.05)',
                    fill: true, tension: 0.4, pointRadius: 4, borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: { beginAtZero: true, ticks: { color: isDark ? '#9CA3AF' : '#6B7280' } },
                    x: { ticks: { color: isDark ? '#9CA3AF' : '#6B7280' } }
                }
            }
        });
    }

    // 4. [중요] 매출금액 / 주문건수 전환 기능
    function updateChart(mode, btn) {
        currentMode = mode;
        if (!orderChart || chartRawData.length === 0) return;
        const isDark = document.documentElement.classList.contains('dark');

        // 버튼 스타일 처리
        document.querySelectorAll('.btn-tab').forEach(tab => {
            tab.className = isDark 
                ? "btn-tab px-4 py-2 text-sm font-medium text-gray-400 bg-gray-700 rounded-lg hover:bg-gray-600 transition-all ml-1"
                : "btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 transition-all ml-1";
        });
        btn.className = isDark
            ? "btn-tab px-4 py-2 text-sm font-bold text-gray-900 bg-gray-100 rounded-lg shadow-sm transition-all"
            : "btn-tab px-4 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg shadow-sm transition-all";

        const titleEl = document.getElementById('dg-title');

        if (mode === 'amount') {
            document.getElementById('chartTitle').innerText = '최근 매출 금액 추이';
            if(titleEl) titleEl.innerText = "주문 통계 상세 리포트 (매출 기준)";
            orderChart.data.datasets[0].label = '매출 금액(원)';
            orderChart.data.datasets[0].data = chartRawData.map(s => s.totalSalesAmount || 0);
            orderChart.options.scales.y.ticks.callback = v => v.toLocaleString() + '원';
        } else {
            document.getElementById('chartTitle').innerText = '최근 주문 건수 추이';
            if(titleEl) titleEl.innerText = "주문 통계 상세 리포트 (건수 기준)";
            orderChart.data.datasets[0].label = '주문 건수(건)';
            orderChart.data.datasets[0].data = chartRawData.map(s => s.totalOrderCount);
            orderChart.options.scales.y.ticks.callback = v => v.toLocaleString() + '건';
        }
        orderChart.update();
    }

    // 그리드 생성 (생략된 기존 로직 유지)
    function initStatsGrid(gridData, isDark) {
        const container = document.getElementById('dg-container');
        if(!container) return;
        container.innerHTML = '';
        deliveryGrid = new DataGrid({
            containerId: 'dg-container',
            data: gridData,
            columns: [
                { header: '기준일', name: 'statsDate', align: 'center', formatter: ({value}) => value ? value.substring(0, 10) : '-' },
                { header: '최신화 시간', name: 'executedAt', align: 'center', formatter: ({value}) => value ? value.substring(0, 19).replace('T', ' ') : '-' },
                { header: '총 주문', name: 'totalOrderCount', align: 'center', formatter: ({value}) => `<b>\${value.toLocaleString()}건</b>` },
                { header: '총 매출액', name: 'totalSalesAmount', align: 'center', formatter: ({value}) => `<span class="text-blue-500">\${value.toLocaleString()}원</span>` }
            ],
            pageOptions: { useClient: true, perPage: 7 }
        });
    }
</script>