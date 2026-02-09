<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="showSearchArea" value="false" scope="request" />
<c:set var="showAddBtn" value="false" scope="request" />

<div class="mx-4 my-6 space-y-6">
    <%-- [1. 상단 타이틀] --%>
    <div class="px-8 py-4">
        <h1 class="text-2xl font-bold text-gray-900">상품 재고 분석</h1>
        <p class="text-sm text-gray-500 mt-1">유종별 실시간 재고 현황 및 상세 내역을 관리합니다.</p>
    </div>
    
    <div class="px-5">
        <%@ include file="statsNav.jsp" %>
    </div>

    <%-- [2. KPI 영역] --%>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 px-5">
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-gray-900">
            <p class="text-sm font-medium text-gray-500">전체 유종 수</p>
            <p id="kpi-total" class="text-3xl font-bold mt-2">0종</p>
        </div>
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-red-400">
            <p class="text-sm font-medium text-gray-500">품절 임박 (안전재고 미달)</p>
            <p id="kpi-low-stock" class="text-3xl font-bold text-red-600 mt-2">0건</p>
        </div>
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-blue-400">
            <p class="text-sm font-medium text-gray-500">오늘 등록 상품</p>
            <p id="kpi-today" class="text-3xl font-bold mt-2">0건</p>
        </div>
    </div>

    <%-- [3. 차트 영역] --%>
    <section class="mx-5 p-10 bg-white rounded-lg shadow-sm border min-h-[500px] flex flex-col">
        <div class="flex justify-between items-center mb-10">
            <h4 id="main-chart-title" class="text-md font-bold border-l-4 border-gray-900 pl-3">재고 현황 분석</h4>
            <div class="flex space-x-1">
                <button type="button" onclick="updateMainChart('top', this)" class="btn-tab px-4 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg">재고 순위</button>
                <button type="button" onclick="updateMainChart('category', this)" class="btn-tab px-4 py-2 text-sm bg-gray-100 rounded-lg ml-1">카테고리 비중</button>
            </div>
        </div>
        <div class="flex-1 flex justify-center items-center">
            <div class="relative w-full max-w-[700px] h-[350px]"><canvas id="mainChart"></canvas></div>
        </div>
    </section>

    <%-- [4. 상세 내역 그리드 영역] --%>
    <div class="mx-5 mt-10 bg-white rounded-lg shadow-sm border mb-10">
        <div class="p-5 border-b flex justify-between items-center">
            <h3 id="dg-title" class="text-lg font-bold text-gray-900">상품 상세 내역 (전체)</h3>
            <button onclick="fetchProductGridData('all', '')" class="text-xs text-blue-500 hover:underline">필터 초기화</button>
        </div>
        <div class="p-4">
            <div id="product-grid-canvas"></div>
            <%-- 중요: datagrid.js 중복 로드 에러 방지를 위해 내부 script 태그가 없는지 확인 필요 --%>
            <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp" />
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<%-- 외부 js 로드는 contextPath 변수 선언보다 위에 있어도 상관없지만, 호출 시점은 중요함 --%>
<script src="${pageContext.request.contextPath}/js/datagrid.js"></script>

<script>
// 전역 변수 설정
const ctxPath = '${pageContext.request.contextPath}'; 
var mainChart;
var productGrid;
var globalProdData = {};
var lastFilterType = 'all'; // 페이징/높이 제어를 위한 상태 저장

document.addEventListener("DOMContentLoaded", function() {
    // 1. 초기 데이터 로드
    fetch(ctxPath + '/admin/stats/product-full-data')
        .then(res => res.json())
        .then(data => {
            globalProdData = data;
            renderKPI(data.kpi);
            updateMainChart('top', document.querySelector('.btn-tab'));
        }).catch(err => console.error("KPI 로드 실패:", err));

    // 2. 초기 그리드 로드
    fetchProductGridData('all', '');
});

function renderKPI(kpi) {
    if(!kpi) return;
    document.getElementById('kpi-total').innerText = (kpi.total_products || 0) + '종';
    document.getElementById('kpi-low-stock').innerText = (kpi.low_stock || 0) + '건';
    document.getElementById('kpi-today').innerText = (kpi.today_new || 0) + '건';
}

function fetchProductGridData(type, value) {
    lastFilterType = type || 'all';
    const v = value || '';
    // JSP 에러 방지를 위해 문자열 결합 방식 사용
    const url = ctxPath + '/admin/stats/product-list-filtered?type=' + lastFilterType + '&value=' + encodeURIComponent(v);

    fetch(url)
        .then(res => res.json())
        .then(data => renderProductGrid(data))
        .catch(err => console.error("그리드 로드 에러:", err));
}

function renderProductGrid(data) {
    const container = document.getElementById('product-grid-canvas');
    if(!container) return;
    container.innerHTML = ''; 

    const isTop5 = (lastFilterType === 'top');
    
    const pageConfig = isTop5 ? false : { useClient: true, perPage: 10 };
    const gridBodyHeight = isTop5 ? 200 : 'auto';
    
    productGrid = new DataGrid({
        containerId: 'product-grid-canvas',
        data: data,
        bodyHeight: gridBodyHeight,
        columns: [
            { header: 'ID', name: 'fuelId', align: 'center', width: 70 },
            { header: '유종명', name: 'fuelName', align: 'left', minWidth: 200 },
            { header: '카테고리', name: 'category', align: 'center', width: 120 },
            { header: '단가', name: 'unitPrice', align: 'right', width: 120, 
              formatter: ({value}) => value ? value.toLocaleString() + '원' : '0원' },
            { header: '현재재고', name: 'stockVol', align: 'right', width: 120,
              formatter: ({value}) => {
                  const colorClass = value < 100 ? 'text-red-500' : '';
                  return '<b class="' + colorClass + '">' + (value || 0).toLocaleString() + '</b>';
              }
            },
            { header: '상태', name: 'status', align: 'center', width: 100 }
        ],
        pageOptions: pageConfig
    });
    
    setTimeout(() => {
        if(productGrid && productGrid.grid) {
            productGrid.grid.refreshLayout();
        }
    }, 100);
}

function updateMainChart(type, btn) {
    if (!btn || !globalProdData.topProducts) return;
    const ctx = document.getElementById('mainChart').getContext('2d');
    if(mainChart) mainChart.destroy();

    document.querySelectorAll('.btn-tab').forEach(tab => {
        tab.className = "btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg ml-1 transition-all";
    });
    btn.className = "btn-tab px-4 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg shadow-sm transition-all";

    let config = {
        options: {
            responsive: true, maintainAspectRatio: false,
            plugins: { legend: { position: 'bottom' } },
            onClick: (evt, elements) => {
                if (elements.length > 0) {
                    const index = elements[0].index;
                    const label = mainChart.data.labels[index];
                    document.getElementById('dg-title').innerText = '상세 내역 (' + label + ')';
                    fetchProductGridData(type, label);
                }
            }
        }
    };

    if(type === 'top') {
        document.getElementById('main-chart-title').innerText = "현시점 재고 상위 유종 TOP 5";
        config.type = 'bar';
        config.data = {
            labels: globalProdData.topProducts.map(p => p.name),
            datasets: [{ label: '현재 재고', data: globalProdData.topProducts.map(p => p.value), backgroundColor: '#94A3B8' }]
        };
        config.options.indexAxis = 'y';
    } else if(type === 'category') {
        document.getElementById('main-chart-title').innerText = "유종 카테고리별 비중";
        config.type = 'doughnut';
        config.data = {
            labels: globalProdData.categoryStats.map(c => c.name),
            datasets: [{ data: globalProdData.categoryStats.map(c => c.value), backgroundColor: ['#CBD5E1', '#94A3B8', '#64748B', '#475569'] }]
        };
    }
    mainChart = new Chart(ctx, config);
}
</script>