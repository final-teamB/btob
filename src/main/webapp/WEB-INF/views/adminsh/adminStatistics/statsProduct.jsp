<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="mx-4 my-6 space-y-6">
    <%-- [1. 타이틀 영역] --%>
    <div class="px-8 py-4">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">상품 분석 대시보드</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">인기 상품 순위 및 재고 현황을 실시간으로 집계합니다.</p>
    </div>
    
    <div class="px-5">
        <%@ include file="statsNav.jsp" %>
    </div>

    <%-- [2. KPI 카드 영역] --%>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 px-5">
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-gray-900 dark:bg-gray-800">
            <p class="text-sm font-medium text-gray-500">전체 상품 수</p>
            <p id="kpi-total" class="text-3xl font-bold text-gray-900 dark:text-white mt-2">0종</p>
        </div>
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-red-400 dark:bg-gray-800">
            <p class="text-sm font-medium text-gray-500">품절 임박</p>
            <p id="kpi-low-stock" class="text-3xl font-bold text-red-600 mt-2">0건</p>
        </div>
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-gray-300 dark:bg-gray-800">
            <p class="text-sm font-medium text-gray-500">오늘 신규 등록</p>
            <p id="kpi-today" class="text-3xl font-bold text-gray-900 dark:text-white mt-2">0건</p>
        </div>
    </div>

    <%-- [3. 차트 영역 - 완벽 정중앙 배치] --%>
    <section class="mx-5 p-10 bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 min-h-[600px] flex flex-col">
        <div class="flex justify-between items-center mb-10 w-full">
            <h4 id="main-chart-title" class="text-md font-bold text-gray-900 dark:text-white border-l-4 border-gray-900 pl-3">재고 상위 유종 TOP 5</h4>
            <div class="flex space-x-1">
                <button type="button" onclick="updateMainChart('top', this)" class="btn-tab px-4 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg shadow-sm">인기 순위</button>
                <button type="button" onclick="updateMainChart('trend', this)" class="btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 ml-1">판매 추이</button>
                <%-- 카테고리 분포 버튼 추가 (요청 대비 확장성) --%>
                <button type="button" onclick="updateMainChart('category', this)" class="btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 ml-1">카테고리</button>
            </div>
        </div>
        
        <%-- 차트 본체: 정가운데 고정 --%>
        <div class="flex-1 w-full flex justify-center items-center">
            <div class="relative w-full max-w-[700px] h-[400px]">
                <canvas id="mainChart"></canvas>
            </div>
        </div>
    </section>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
let mainChart;
let globalData = {};

document.addEventListener("DOMContentLoaded", function() {
    fetch('${pageContext.request.contextPath}/admin/stats/product-full-data')
        .then(res => res.json())
        .then(data => {
            globalData = data;
            renderKPI(data.kpi);
            updateMainChart('top', document.querySelector('.btn-tab'));
        })
        .catch(err => console.error("데이터 로드 실패:", err));
});

function renderKPI(kpi) {
    if(!kpi) return;
    document.getElementById('kpi-total').innerText = (kpi.total_products || 0) + '종';
    document.getElementById('kpi-low-stock').innerText = (kpi.low_stock || 0) + '건';
    document.getElementById('kpi-today').innerText = (kpi.today_new || 0) + '건';
}

function updateMainChart(type, btn) {
    if (!btn) return;
    const ctx = document.getElementById('mainChart').getContext('2d');
    if(mainChart) mainChart.destroy();

    // 버튼 스타일 업데이트
    document.querySelectorAll('.btn-tab').forEach(tab => {
        tab.className = "btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 ml-1 transition-all";
    });
    btn.className = "btn-tab px-4 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg shadow-sm transition-all";

    // ✅ 공통 옵션 고정 (범례 위치 bottom 고정!)
    let commonOptions = {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                display: true,
                position: 'bottom',
                labels: { padding: 25, font: { family: 'Pretendard', size: 13 } }
            }
        }
    };

    let config = { type: '', data: {}, options: commonOptions };

    if(type === 'top') {
        document.getElementById('main-chart-title').innerText = "현시점 재고 상위 유종 TOP 5";
        config.type = 'bar';
        config.data = {
            labels: globalData.topProducts ? globalData.topProducts.map(p => p.name) : [],
            datasets: [{
                label: '현재 재고량',
                data: globalData.topProducts ? globalData.topProducts.map(p => p.value) : [],
                backgroundColor: '#CBD5E1', borderRadius: 5, barThickness: 30
            }]
        };
        config.options.indexAxis = 'y';
        config.options.scales = {
            x: { display: false, grid: { display: false } },
            y: { grid: { display: false }, ticks: { font: { weight: '600' } } }
        };
    } else if(type === 'trend') {
        document.getElementById('main-chart-title').innerText = "일자별 재고 변동 추이 (최근 7일)";
        config.type = 'line';
        config.data = {
            labels: globalData.trend ? globalData.trend.map(t => t.date || t.statsDate) : [],
            datasets: [{
                label: '재고 수치',
                data: globalData.trend ? globalData.trend.map(t => t.value || t.statsValue) : [],
                borderColor: '#334155', backgroundColor: 'rgba(51, 65, 85, 0.05)',
                fill: true, tension: 0.4, pointRadius: 4
            }]
        };
    } else if(type === 'category') {
        document.getElementById('main-chart-title').innerText = "카테고리별 상품 비중";
        config.type = 'doughnut';
        config.data = {
            labels: globalData.categoryStats ? globalData.categoryStats.map(c => c.name) : [],
            datasets: [{
                data: globalData.categoryStats ? globalData.categoryStats.map(c => c.value) : [],
                backgroundColor: ['#F1F5F9', '#E2E8F0', '#CBD5E1', '#94A3B8', '#475569'],
                borderWidth: 2, borderColor: '#ffffff'
            }]
        };
        config.options.layout = { padding: 0 };
    }

    mainChart = new Chart(ctx, config);
}
</script>