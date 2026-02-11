<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="showSearchArea" value="false" scope="request" />
<c:set var="showAddBtn" value="false" scope="request" />

<style>
    /* [1] 하단 페이징 영역 박스 테두리 제거 및 여백 조정 */
    #product-grid-canvas + div {
        display: flex !important;
        justify-content: center !important; 
        align-items: center !important;
        border-top: none !important;
        background-color: transparent !important;
        margin-top: 0 !important;
        padding: 20px 0 !important; 
        width: 100% !important;
    }

    /* [2] 그리드 외곽선 제거 및 하단 라인 강화 (이미지 피드백 반영) */
    .tui-grid-container {
        border: none !important;
    }
    
    /* 그리드 본체 하단에 회색 라인을 끝까지 추가하여 깔끔하게 마감 */
    .tui-grid-content-area {
        border-bottom: 1px solid #eee !important;
    }

    .tui-grid-pagination {
        border: none !important;
        background-color: transparent !important;
        box-shadow: none !important;
    }

    /* [3] 상세 내역 타이틀 전용 스타일 (차트와 그리드 구분) */
    .stats-detail-header {
        border-top: 1px solid #f3f4f6;
        padding: 24px 32px 12px 32px;
        background-color: #ffffff;
    }

    /* [4] No. 열(Row Header) 디자인 조정 */
    .tui-grid-cell-row-header {
        background-color: #f9fafb !important;
        border-right: 1px solid #eee !important;
    }

    .btn-tab { transition: all 0.2s; }
    
    /* TOP 5 모드일 때 불필요한 요소 제어 */
    .top-grid #product-grid-canvas + div {
	    display: none !important;
	}
    
    .top-grid .tui-grid-pagination, 
    .top-grid .tui-pagination,
    .top-grid [class*="pagination"], /* 클래스명에 pagination이 포함된 모든 것 */
    .top-grid .tui-grid-btn-filter, /* 혹시 남을 수 있는 필터 버튼 등 */
    .top-grid select { 
        display: none !important; 
    }

    /* 하단 여백을 0으로 만들어 바닥 선이 섹션 끝에 딱 붙게 함 */
    .top-grid#grid-wrapper {
        padding-bottom: 0 !important;
        margin-bottom: 0 !important;
    }
</style>

<div class="mx-4 my-6 space-y-6">
    <%-- [1. 상단 타이틀] --%>
    <div class="px-8 py-4">
        <h1 class="text-2xl font-bold text-gray-900">상품 재고 분석</h1>
        <p class="text-sm text-gray-500 mt-1">유종별 실시간 재고 현황 및 상세 내역을 관리합니다.</p>
    </div>
    
    <%@ include file="statsNav.jsp" %>

    <%-- [2. KPI 영역] --%>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 px-5">
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-gray-900">
            <p class="text-sm font-medium text-gray-500">전체 유종 수</p>
            <p id="kpi-total" class="text-3xl font-bold mt-2">0종</p>
        </div>
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-red-500">
            <p class="text-sm font-medium text-gray-500">품절 임박 (안전재고 미달)</p>
            <p id="kpi-low-stock" class="text-3xl font-bold text-red-600 mt-2">0건</p>
        </div>
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-blue-500">
            <p class="text-sm font-medium text-gray-500">오늘 등록 상품</p>
            <p id="kpi-today" class="text-3xl font-bold text-blue-600 mt-2">0건</p>
        </div>
    </div>

    <%-- [3. 차트 + 그리드 통합 섹션] --%>
    <section class="mx-5 bg-white rounded-lg shadow-sm border border-gray-100 overflow-hidden">
        
        <%-- 차트 영역 --%>
        <div class="p-8 pb-4">
            <div class="flex justify-between items-center mb-8 w-full">
                <h4 id="main-chart-title" class="text-md font-bold text-gray-900 border-l-4 border-gray-900 pl-3">
                    재고 현황 분석
                </h4>
                <div class="flex space-x-1">
                    <button type="button" onclick="updateMainChart('top', this)" class="btn-tab px-4 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg shadow-sm">재고 순위</button>
                    <button type="button" onclick="updateMainChart('category', this)" class="btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg ml-1 hover:bg-gray-200">카테고리 비중</button>
                </div>
            </div>
            
            <div class="w-full flex justify-center items-center">
                <div class="relative w-full max-w-[600px] h-[400px]">
                    <canvas id="mainChart"></canvas>
                </div>
            </div>
        </div>

        <%-- [상세 내역 헤더] --%>
        <div id="grid-header-area" class="stats-detail-header">
            <div class="flex justify-between items-center">
                <div class="flex items-center space-x-2">
                    <div class="w-1 h-4 bg-gray-900 rounded-full"></div>
                    <h3 id="dg-title" class="text-sm font-bold text-gray-800 uppercase tracking-tight">상품 상세 내역 (전체)</h3>
                </div>
                <button onclick="fetchProductGridData('all', '')" class="text-xs text-blue-500 hover:underline">필터 초기화</button>
            </div>
        </div>
        
        <div id="grid-wrapper" class="px-5 pb-6 pt-6"> 
            <div id="product-grid-canvas"></div>
            <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp" />
        </div>
    </section>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="${pageContext.request.contextPath}/js/datagrid.js"></script>

<script>
// 전역 변수 설정
const ctxPath = '${pageContext.request.contextPath}'; 
var mainChart;
var productGrid;
var globalProdData = {};
var currentChartType = 'top';  

document.addEventListener("DOMContentLoaded", function() {
    fetch(ctxPath + '/admin/stats/product-full-data')
        .then(res => res.json())
        .then(data => {
            globalProdData = data;
            renderKPI(data.kpi);
            updateMainChart('top', document.querySelector('.btn-tab'));
        }).catch(err => console.error("데이터 로드 실패:", err));
});

function renderKPI(kpi) {
    if(!kpi) return;
    document.getElementById('kpi-total').innerText = (kpi.total_products || 0) + '종';
    document.getElementById('kpi-low-stock').innerText = (kpi.low_stock || 0) + '건';
    document.getElementById('kpi-today').innerText = (kpi.today_new || 0) + '건';
}

function fetchProductGridData(type, value) {
    const url = ctxPath + '/admin/stats/product-list-filtered?type=' + (type || 'all') + '&value=' + encodeURIComponent(value || '');
    fetch(url)
        .then(res => res.json())
        .then(data => renderProductGrid(data))
        .catch(err => console.error("그리드 데이터 에러:", err));
}

function renderProductGrid(data) {
    const container = document.getElementById('product-grid-canvas'); 
    if(!container) return;
    container.innerHTML = ''; 

    const isTopMode = (currentChartType === 'top');
    const gridData = isTopMode ? data.slice(0, 5) : data;
    
    productGrid = new DataGrid({
        containerId: 'product-grid-canvas',
        // [추가] datagrid.jsp에 정의된 셀렉트 박스 ID 연결
        perPageId: 'dg-per-page', 
        data: gridData,
        bodyHeight: 'auto',
        showRowHeaders: ['rowNum'],
        columns: [
            { header: 'ID', name: 'fuelId', align: 'center', width: 70 },
            { header: '유종명', name: 'fuelName', align: 'left', minWidth: 200 },
            { header: '카테고리', name: 'category', align: 'center', width: 120 },
            { header: '단가', name: 'unitPrice', align: 'right', width: 120, 
              formatter: ({value}) => value ? value.toLocaleString() + '원' : '0원' },
            { header: '현재재고', name: 'stockVol', align: 'right', width: 120,
              formatter: ({value}) => {
                  const colorClass = value < 100 ? 'text-red-500 font-bold' : 'text-gray-700';
                  return '<span class="' + colorClass + '">' + (value || 0).toLocaleString() + '</span>';
              }
            },
            { header: '상태', name: 'status', align: 'center', width: 100,
              formatter: ({value}) => `<span class="px-2 py-1 rounded-full text-xs font-semibold bg-gray-100">\${value}</span>`
            }
        ],
        // TOP 모드가 아닐 때만 페이징 활성화
        pageOptions: isTopMode ? null : { useClient: true, perPage: 10 }
    });
    
    // [추가] 갯수 변경(perPage) 이벤트 리스너 수동 연결
    const perPageSelect = document.getElementById('dg-per-page');
    if (perPageSelect && !isTopMode) {
        perPageSelect.addEventListener('change', function() {
            const newPerPage = parseInt(this.value, 10);
            if (productGrid && productGrid.grid) {
                productGrid.grid.setPerPage(newPerPage);
            }
        });
    }
    
    setTimeout(() => {
        if(productGrid && productGrid.grid) {
            productGrid.grid.refreshLayout();
            
            if(isTopMode) {
                const el = document.querySelector('.top-grid .tui-grid-container');
                if(el) el.style.height = 'auto';
            }
        }
    }, 100);
}

function updateMainChart(type, btn) {
    currentChartType = type;
    const wrapper = document.getElementById('grid-wrapper');
    const titleEl = document.getElementById('dg-title');

    if(type === 'top'){
        // [절대 건드리지 않음] 기존 TOP 5 여백 제거 로직 유지
        wrapper.classList.add('top-grid');
        if(titleEl) titleEl.innerText = '상품 상세 내역 (TOP 5)';
        setTimeout(() => {
            const paginationAreas = wrapper.querySelectorAll('.tui-grid-pagination, .tui-pagination, select');
            paginationAreas.forEach(el => {
                if(el.parentElement) el.parentElement.style.display = 'none';
                el.style.display = 'none';
            });
            const extraDiv = document.querySelector('#product-grid-canvas + div');
            if(extraDiv) {
                extraDiv.style.display = 'none';
                extraDiv.style.height = '0';
            }
        }, 200);
        fetchProductGridData('top', '');
    } else {
        // [여기만 수정] 카테고리 비중(전체) 모드일 때 페이징 정렬 복구
        wrapper.classList.remove('top-grid');
        if(titleEl) titleEl.innerText = '상품 상세 내역 (전체)';
        
        const extraDiv = document.querySelector('#product-grid-canvas + div');
        if(extraDiv) {
            // block 대신 flex를 주어야 CSS의 justify-content: center가 먹힙니다.
            extraDiv.style.display = 'flex'; 
            extraDiv.style.height = 'auto'; // top에서 죽였던 높이 복구
            extraDiv.style.padding = '20px 0'; // top에서 사라졌을 수 있는 패딩 복구
        }

        const paginationAreas = wrapper.querySelectorAll('.tui-grid-pagination, .tui-pagination, select');
        paginationAreas.forEach(el => {
            if(el.parentElement) el.parentElement.style.display = 'flex'; // 페이징 부모도 flex
            el.style.display = 'block';
        });
        
        fetchProductGridData('all', '');
    }
    
    // --- 이하 차트 렌더링 로직 (기존과 동일) ---
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
                    const label = mainChart.data.labels[elements[0].index];
                    document.getElementById('dg-title').innerText = '상세 내역 (' + label + ')';
                    fetchProductGridData(type, label);
                }
            }
        }
    };

    if(type === 'top') {
        document.getElementById('main-chart-title').innerText = "현시점 재고 상위 유종 TOP 5";
        
        const stepColors = [
            '#111827', // 1위 (가장 진함)
            '#374151', 
            '#4B5563', 
            '#6B7280', 
            '#9CA3AF'  // 5위 (가장 연함)
        ];  
        
        config.type = 'bar';
        config.data = {
            labels: globalProdData.topProducts.map(p => p.name),
            datasets: [{ 
            	label: '현재 재고', 
            	data: globalProdData.topProducts.map(p => p.value), 
            	backgroundColor: stepColors, 
                borderRadius: 4,           
                barThickness: 25
            }]
        };
        config.options.indexAxis = 'y';
        
    } else if(type === 'category') {
        document.getElementById('main-chart-title').innerText = "유종 카테고리별 비중";
        config.type = 'doughnut';
        config.data = {
            labels: globalProdData.categoryStats.map(c => c.name),
            datasets: [{ data: globalProdData.categoryStats.map(c => c.value), backgroundColor: ['#F1F5F9', '#CBD5E1', '#94A3B8', '#1E293B'], cutout: '60%' }]
        };
    }
    mainChart = new Chart(ctx, config);
}
</script>