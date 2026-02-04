<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="mx-4 my-6 space-y-6">
    <%-- [1. 타이틀 영역] --%>
    <div class="px-8 py-4 flex flex-col md:flex-row justify-between items-center">
        <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">주문 통계 분석</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">주문 건수 및 매출 추이를 상세 분석합니다.</p>
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
    
    <div class="px-5">
        <%@ include file="statsNav.jsp" %>
    </div>

    <%-- [2. 차트 영역 - 요청하신 개별 버튼 스타일 적용] --%>
    <section class="mx-5 p-10 bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 dark:border-gray-700 min-h-[600px] flex flex-col">
        <div class="flex justify-between items-center mb-10 w-full">
            <h4 id="chartTitle" class="text-md font-bold text-gray-900 dark:text-white border-l-4 border-gray-900 pl-3">
                최근 주문 건수 추이
            </h4>
            <%-- 버튼 간격을 띄운 개별 라운드 버튼 형태 --%>
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
        
        <%-- 차트 본체: 부모 flex로 상하좌우 정가운데 고정 --%>
        <div class="flex-1 w-full flex justify-center items-center">
            <div class="relative w-full max-w-[750px] h-[400px]">
                <canvas id="orderChart"></canvas>
            </div>
        </div>
    </section>

    <%-- [3. 상세 내역 그리드] --%>
    <section class="mx-5 p-6 bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 dark:border-gray-700">
        <h4 class="text-md font-bold text-gray-900 dark:text-white mb-4 border-l-4 border-gray-900 pl-3">상세 내역 (최근 7건)</h4>
        <div id="grid" class="w-full text-sm"></div>
    </section>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link rel="stylesheet" href="https://uicdn.toast.com/tui-grid/latest/tui-grid.css" />
<script src="https://uicdn.toast.com/tui-grid/latest/tui-grid.js"></script>

<script>
    let orderGrid, orderChart, chartRawData = []; 

    document.addEventListener('DOMContentLoaded', function() {
        fetch('${pageContext.request.contextPath}/admin/stats/data')
            .then(res => res.json())
            .then(data => {
                const stats = data.orderStats || [];
                chartRawData = [...stats].sort((a, b) => new Date(a.executedAt) - new Date(b.executedAt)).slice(-7);
                createOrderChart(chartRawData);
                createOrderGrid([...stats].sort((a, b) => new Date(b.executedAt) - new Date(a.executedAt)).slice(0, 7));
            });
    });

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
                plugins: { legend: { position: 'bottom', labels: { padding: 20 } } },
                scales: {
                    x: { grid: { display: false } },
                    y: { beginAtZero: true, ticks: { callback: v => v.toLocaleString() + '건' } }
                }
            }
        });
    }

    function updateChart(mode, btn) {
        if (!orderChart) return;
        
        // 버튼 스타일 초기화 (요청하신 개별 버튼 스타일)
        document.querySelectorAll('.btn-tab').forEach(tab => {
            tab.className = "btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 transition-all ml-1";
        });
        // 클릭 버튼 Charcoal 활성화
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

    function createOrderGrid(gridData) {
        orderGrid = new tui.Grid({
            el: document.getElementById('grid'),
            data: gridData,
            scrollX: false, scrollY: false,
            columns: [
                { header: '기준일', name: 'statsDate', align: 'center', formatter: ({value}) => value ? value.split('T')[0] : '-' },
                { header: '최신화 시간', name: 'executedAt', align: 'center', formatter: ({value}) => value ? value.replace('T', ' ').substring(0, 16) : '-' },
                { header: '총 주문', name: 'totalOrderCount', align: 'right', formatter: ({value}) => (value || 0).toLocaleString() + '건' },
                { header: '매출액', name: 'totalSalesAmount', align: 'right', formatter: ({value}) => (value || 0).toLocaleString() + '원' }
            ]
        });
    }
</script>