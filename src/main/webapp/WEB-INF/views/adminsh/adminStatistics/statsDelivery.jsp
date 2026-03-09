<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="showSearchArea" value="false" scope="request" />
<c:set var="showAddBtn" value="false" scope="request" />

<style>
    /* [1] 하단 페이징 영역 박스 스타일 초기화 */
    #dg-container + div {
        border-top: none !important;
        background-color: transparent !important;
        margin-top: 0 !important;
        padding-top: 10px !important;
        padding-bottom: 20px !important;
    }

    /* [2] 그리드 외곽선 제거 */
    .tui-grid-container { border: none !important; }
    .tui-grid-pagination {
        border: none !important;
        background-color: transparent !important;
        box-shadow: none !important;
    }

    /* [3] 상세 내역 타이틀 (다크모드 대응) */
    .stats-detail-header {
        border-top: 1px solid #f3f4f6;
        padding: 24px 32px 12px 32px;
        background-color: #ffffff;
    }
    /* 다크모드일 때 구분선과 배경색 변경 */
    .dark .stats-detail-header {
        border-top: 1px solid #374151;
        background-color: #374151; /* gray-700 */
    }

    .btn-tab { transition: all 0.2s; }
</style>

<div class="my-6 space-y-6">
    <%-- [1. 상단 타이틀] --%>
    <div class="px-9 py-4">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">배송 현황 분석</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">배송 단계별 실시간 데이터 및 지역 분포를 확인합니다.</p>
    </div>
    
    <%@ include file="statsNav.jsp" %>

    <%-- [2. KPI 영역] --%>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 px-5">
        <div class="p-6 bg-white dark:bg-gray-700 rounded-lg shadow-sm border-l-4 border-gray-900 dark:border-gray-500">
            <p class="text-sm font-medium text-gray-500 dark:text-gray-400">평균 배송 소요시간</p>
            <p id="kpi-avg-time" class="text-3xl font-bold mt-2 dark:text-white">0.0일</p>
        </div>
        <div class="p-6 bg-white dark:bg-gray-700 rounded-lg shadow-sm border-l-4 border-blue-500">
            <p class="text-sm font-medium text-gray-500 dark:text-gray-400">현재 배송중 건수</p>
            <p id="kpi-shipping" class="text-3xl font-bold text-blue-600 dark:text-blue-400 mt-2">0건</p>
        </div>
        <div class="p-6 bg-white dark:bg-gray-700 rounded-lg shadow-sm border-l-4 border-red-400">
            <p class="text-sm font-medium text-gray-500 dark:text-gray-400">배송 지연 (3일↑)</p>
            <p id="kpi-delay" class="text-3xl font-bold text-red-600 dark:text-red-400 mt-2">0건</p>
        </div>
    </div>

    <%-- [3. 차트 + 그리드 통합 섹션] --%>
    <section class="mx-5 bg-white dark:bg-gray-700 rounded-lg shadow-sm border border-gray-100 dark:border-gray-700 overflow-hidden">
        
        <%-- 차트 영역 --%>
        <div class="p-8 pb-4">
            <div class="flex justify-between items-center mb-8 w-full">
                <h4 id="chartTitle" class="text-md font-bold text-gray-900 dark:text-white  border-l-4 border-gray-900 dark:border-white pl-3">
                    배송 상세 단계별 비중
                </h4>
                <div class="flex space-x-1">
                    <button type="button" onclick="changeMode('status', this)" 
                            class="btn-tab px-4 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg shadow-sm">
                        배송 단계
                    </button>
                    <button type="button" onclick="changeMode('region', this)" 
                            class="btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 ml-1">
                        지역 분포
                    </button>
                </div>
            </div>
            
            <div class="w-full flex justify-center items-center">
                <div class="relative w-full max-w-[800px] h-[350px]">
                    <canvas id="deliveryChart"></canvas>
                </div>
            </div>
        </div>

        <%-- 상세 내역 그리드 타이틀 --%>
        <div class="stats-detail-header">
            <div class="flex justify-between items-center">
                <div class="flex items-center space-x-2">
                    <div class="w-1 h-4 bg-gray-900 rounded-full"></div>
                    <h3 id="dg-title" class="text-sm font-bold text-gray-800 uppercase tracking-tight">상세 내역 (전체)</h3>
                </div>
				<button type="button" onclick="resetFilter()" class="text-xs text-blue-500 dark:text-blue-400 hover:underline font-medium">
		            필터 초기화
		        </button>
            </div>
        </div>
        
        <%-- 그리드 본체 --%>
        <div class="px-5 pb-6 pt-6"> 
            <div id="delivery-grid-canvas"></div>
            <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp" />
        </div>
    </section>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    const ctxPath = '${pageContext.request.contextPath}'; 
    var myChart;
    var deliveryGrid;
    var statsData = {};
    var currentMode = 'status';

    /* [해결 1] 변수 중복 선언 에러 방지 */
    // window 객체에 붙여서 이미 선언되어 있다면 새로 만들지 않도록 합니다.
    if (typeof window.GRID_STATUS_THEMES === 'undefined') {
        window.GRID_STATUS_THEMES = {
            'deliveryStatus' : { bgColor: 'bg-gray-100', textColor: 'text-gray-600' }
        };
    }

    document.addEventListener("DOMContentLoaded", function() {
    	const isDark = document.documentElement.classList.contains('dark');
    	
        fetch(ctxPath + '/admin/stats/delivery-full-data')
            .then(res => res.json())
            .then(data => {
                statsData = data;
                updateKPI(data.kpi);
                
                changeMode('status', document.querySelector('.btn-tab'));
            });
    });

    function updateKPI(kpi) {
        if(!kpi) return;
        const avgEl = document.getElementById('kpi-avg-time');
        const shipEl = document.getElementById('kpi-shipping');
        const delayEl = document.getElementById('kpi-delay');
        
        if(avgEl) avgEl.innerText = (kpi.avg_delivery_time || 0) + '일';
        if(shipEl) shipEl.innerText = (kpi.current_shipping || 0) + '건';
        if(delayEl) delayEl.innerText = (kpi.delay_count || 0) + '건';
    }

    function renderDeliveryGrid(data) {
    	const isDark = document.documentElement.classList.contains('dark');
    	
        const container = document.getElementById('delivery-grid-canvas'); 
        if(!container) return;
        container.innerHTML = ''; 

        deliveryGrid = new DataGrid({
            containerId: 'delivery-grid-canvas',
            perPageId: 'dg-per-page',
            data: data || [],
            bodyHeight: 'auto',
            columns: [
                { header: '주문ID', name: 'orderNo', align: 'center', width: 220 },
                { header: '배송지', name: 'regionName', align: 'left' },
                { header: '상태', name: 'statusName', align: 'center', width: 150,
                  formatter: ({value}) => {
                	  const bgClass = isDark ? 'bg-gray-700 text-gray-200' : 'bg-gray-100 text-gray-700';
                      return `<span class="px-2 py-1 rounded-full text-xs font-semibold \${bgClass}">\${value}</span>`;
                  } 
                },
                { header: '업데이트 일시', name: 'updateTime', align: 'center', width: 200,
                    formatter: ({value}) => value ? value.replace('T', ' ').substring(0, 19) : '-'
                }
            ],
            pageOptions: { useClient: true, perPage: 10 }
        });
        
        const perPageSelect = document.getElementById('dg-per-page');
        if (perPageSelect) {
            perPageSelect.addEventListener('change', function() {
                const newPerPage = parseInt(this.value, 10);
                if (deliveryGrid && deliveryGrid.grid) {
                    deliveryGrid.grid.setPerPage(newPerPage);
                }
            });
        }
        
        setTimeout(() => {
            if(deliveryGrid && deliveryGrid.grid) deliveryGrid.grid.refreshLayout();
        }, 150);
    }

    function fetchFilteredData(mode, label) {
        let type = (mode === 'status') ? 'status' : 'region';
        const mapping = {
            '상품준비중': 'dv001', '국제운송중': 'dv002', '보세창고입고': 'dv003',
            '통관진행중': 'dv004', '통관완료': 'dv005', '국내배송중': 'dv006', '배송완료': 'dv007'
        };
        let value = (mode === 'status') ? (mapping[label] || label) : label;

        fetch(ctxPath + '/admin/stats/delivery-list-filtered?type=' + type + '&value=' + encodeURIComponent(value))
            .then(res => res.json())
            .then(data => renderDeliveryGrid(data))
            .catch(err => console.error("필터링 실패:", err));
    }
    
    function resetFilter() {
        const titleEl = document.getElementById('dg-title');
        if (titleEl) {
            const originalTitle = (currentMode === 'status') 
                ? '상세 내역 (전체)' 
                : '지역별 배송 상세 내역 (전체)';
            titleEl.innerText = originalTitle;
        }

        if (statsData && statsData.gridList) {
            renderDeliveryGrid(statsData.gridList);
        }

        if (myChart) {
            myChart.setActiveElements([]); 
            myChart.update();
        }
    }

    function changeMode(mode, btn) {
    	currentMode = mode;
        const isDark = document.documentElement.classList.contains('dark');
        const titleEl = document.getElementById('dg-title');

        if(titleEl) {
            titleEl.innerText = (mode === 'status' ? '배송 단계별 상세 내역 (전체)' : '지역별 배송 상세 내역 (전체)');
            // 다크모드 글자색 대응
            titleEl.className = "text-sm font-bold text-gray-800 dark:text-gray-200 uppercase tracking-tight";
        }
        
        if (btn) {
            document.querySelectorAll('.btn-tab').forEach(tab => {
                tab.className = isDark 
                    ? "btn-tab px-4 py-2 text-sm font-medium text-gray-400 bg-gray-700 rounded-lg ml-1 transition-all"
                    : "btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg ml-1 transition-all";
            });
            btn.className = isDark
                ? "btn-tab px-4 py-2 text-sm font-bold text-gray-900 bg-gray-100 rounded-lg shadow-sm transition-all"
                : "btn-tab px-4 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg shadow-sm transition-all";
        }

        setTimeout(() => { initChart(mode); }, 50);
        renderDeliveryGrid(statsData.gridList || []);
    }

    function initChart(mode) {
        const isDark = document.documentElement.classList.contains('dark');
        const ctx = document.getElementById('deliveryChart').getContext('2d');
        if(myChart) myChart.destroy();

        // 공통 테마 설정
        const theme = {
            text: isDark ? '#9CA3AF' : '#6B7280',
            grid: isDark ? 'rgba(255, 255, 255, 0.05)' : '#F3F4F6'
        };

        let config = {
            options: {
                responsive: true, 
                maintainAspectRatio: false,
                plugins: { 
                    legend: { 
                        position: 'bottom',
                        labels: { color: theme.text, font: { family: 'Pretendard' } }
                    } 
                },
                // [복구] 클릭 시 필터링 로직 추가
                onClick: (evt, elements) => {
                    if (elements.length > 0) {
                        const index = elements[0].index;
                        const label = myChart.data.labels[index];
                        const titleEl = document.getElementById('dg-title');
                        if(titleEl) titleEl.innerText = '상세 내역 (' + label + ')';
                        
                        // 실제 필터링 데이터 호출 함수 실행
                        fetchFilteredData(mode, label);
                    }
                },
                scales: mode === 'region' ? {
                    x: { 
                        grid: { color: theme.grid }, 
                        ticks: { color: theme.text } 
                    },
                    y: { 
                        grid: { display: false }, 
                        ticks: { color: theme.text } 
                    }
                } : {}
            }
        };

        if(mode === 'status') {
            document.getElementById('chartTitle').innerText = "배송 상세 단계별 비중";
            const s = statsData.status || {};
            config.type = 'doughnut';
            config.data = {
                labels: ['상품준비중', '국제운송중', '보세창고입고', '통관진행중', '통관완료', '국내배송중', '배송완료'],
                datasets: [{
                    data: [s.dv001||0, s.dv002||0, s.dv003||0, s.dv004||0, s.dv005||0, s.dv006||0, s.dv007||0],
                    backgroundColor: isDark 
                        ? ['#F9FAFB','#E5E7EB','#D1D5DB','#9CA3AF','#6B7280','#4B5563','#111827']
                        : ['#F1F5F9','#E2E8F0','#CBD5E1','#94A3B8','#64748B','#475569','#1E293B'],
                    cutout: '65%',
                    borderWidth: 2,
                    borderColor: isDark ? '#374151' : '#ffffff' // 배경색 gray-700(#374151)과 일치
                }]
            };
        } else {
            document.getElementById('chartTitle').innerText = "지역별 배송 분포 (Top 5)";
            config.type = 'bar';
            config.data = {
                labels: statsData.region ? statsData.region.map(r => r.name) : [],
                datasets: [{ 
                    label: '건수', 
                    data: statsData.region ? statsData.region.map(r => r.value) : [], 
                    backgroundColor: isDark ? '#D1D5DB' : '#374151',
                    borderRadius: 4,
                    barThickness: 25
                }]
            };
            config.options.indexAxis = 'y';
        }
        myChart = new Chart(ctx, config);
    }
</script>