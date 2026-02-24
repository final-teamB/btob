<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="showSearchArea" value="false" scope="request" />
<c:set var="showAddBtn" value="false" scope="request" />

<style>
    /* [1] 하단 페이징 영역 박스 스타일 초기화 */
    #clean-grid-canvas + div {
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
    .dark .stats-detail-header {
        border-top: 1px solid #374151;
        background-color: #374151; /* gray-700 */
    }

    .btn-tab { transition: all 0.2s; }
</style>

<div class="my-6 space-y-6">
    <%-- [1. 상단 타이틀] --%>
    <div class="px-9 py-4">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">사용자 지표 분석</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">사용자 가입 추이 및 지역별 분포를 실시간으로 확인합니다.</p>
    </div>
    
    <%@ include file="statsNav.jsp" %>

    <%-- [2. KPI 영역] --%>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 px-5">
        <div class="p-6 bg-white dark:bg-gray-700 rounded-lg shadow-sm border-l-4 border-gray-900 dark:border-gray-500">
            <p class="text-sm font-medium text-gray-500 dark:text-gray-400">전체 활성 사용자</p>
            <p id="kpi-total-active" class="text-3xl font-bold mt-2 dark:text-white">0명</p>
        </div>
        <div class="p-6 bg-white dark:bg-gray-700 rounded-lg shadow-sm border-l-4 border-orange-400">
            <p class="text-sm font-medium text-gray-500 dark:text-gray-400">가입 승인 대기</p>
            <p id="kpi-pending" class="text-3xl font-bold text-orange-600 dark:text-orange-400 mt-2">0건</p>
        </div>
        <div class="p-6 bg-white dark:bg-gray-700 rounded-lg shadow-sm border-l-4 border-blue-500">
            <p class="text-sm font-medium text-gray-500 dark:text-gray-400">최다 가입 지역</p>
            <p id="kpi-top-region" class="text-3xl font-bold text-blue-600 dark:text-blue-400 mt-2">--</p>
        </div>
    </div>

    <%-- [3. 차트 + 그리드 통합 섹션] --%>
    <section class="mx-5 bg-white dark:bg-gray-700 rounded-lg shadow-sm border border-gray-100 dark:border-gray-700 overflow-hidden">
        
        <%-- 차트 영역 --%>
        <div class="p-8 pb-4">
            <div class="flex justify-between items-center mb-8 w-full">
                <h4 id="chartTitle" class="text-md font-bold text-gray-900 dark:text-white border-l-4 border-gray-900 dark:border-white pl-3">
                    계정 상태 분포
                </h4>
                <div class="flex space-x-1">
                    <button type="button" onclick="changeMode('accStatus', this)" 
                            class="btn-tab px-4 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg shadow-sm">
                        계정 상태
                    </button>
                    <button type="button" onclick="changeMode('region', this)" 
                            class="btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 ml-1">
                        지역 분포
                    </button>
                    <button type="button" onclick="changeMode('appStatus', this)" 
                            class="btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 ml-1">
                        승인 현황
                    </button>
                </div>
            </div>
            
            <div class="w-full flex justify-center items-center">
                <div class="relative w-full max-w-[800px] h-[350px]">
                    <canvas id="userChart"></canvas>
                </div>
            </div>
        </div>

        <%-- 상세 내역 그리드 타이틀 --%>
        <div class="stats-detail-header">
            <div class="flex justify-between items-center">
                <div class="flex items-center space-x-2">
                    <div class="w-1 h-4 bg-gray-900 dark:bg-white rounded-full"></div>
                    <h3 id="dg-title" class="text-sm font-bold text-gray-800 dark:text-gray-200 uppercase tracking-tight">사용자 상세 내역 (전체)</h3>
                </div>
                <button type="button" onclick="resetFilter()" class="text-xs text-blue-500 dark:text-blue-400 hover:underline font-medium">
                    필터 초기화
                </button>
            </div>
        </div>
        
        <%-- 그리드 본체 --%>
        <div class="px-5 pb-6 pt-6"> 
            <div id="clean-grid-canvas"></div>
            <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp" />
        </div>
    </section>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    const contextPath = '${pageContext.request.contextPath}';
    var myChart;
    var statsData = {};
    var currentMode = 'accStatus';

    document.addEventListener("DOMContentLoaded", function() {
        const isDark = document.documentElement.classList.contains('dark');
        
        fetch(contextPath + '/admin/stats/user-full-data')
            .then(res => res.json())
            .then(data => {
                statsData = data;
                updateKPI(data);
                changeMode('accStatus', document.querySelector('.btn-tab'));
            }).catch(e => console.error("Data Load Error:", e));
        fetchUserListData('all', '');
    });

    function updateKPI(data) {
        if(!data || !data.accStatus) return;
        const active = data.accStatus.find(s => s.name === 'ACTIVE')?.value || 0;
        const pending = data.appStatus.find(s => s.name === 'PENDING')?.value || 0;
        document.getElementById('kpi-total-active').innerText = active.toLocaleString() + '명';
        document.getElementById('kpi-pending').innerText = pending.toLocaleString() + '건';
        document.getElementById('kpi-top-region').innerText = data.region && data.region[0] ? data.region[0].name : '--';
    }

    function fetchUserListData(type, value) {
        const url = `\${contextPath}/admin/stats/user-list-filtered?type=\${type || 'all'}&value=\${encodeURIComponent(value || '')}`;
        fetch(url)
            .then(res => res.json())
            .then(data => renderUserGrid(data))
            .catch(err => console.error("Grid Error:", err));
    }

    function resetFilter() {
        const titleEl = document.getElementById('dg-title');
        if (titleEl) {
            titleEl.innerText = "사용자 상세 내역 (전체)";
        }
        // 초기 전체 데이터 로드
        fetchUserListData('all', '');
        
        if (myChart) {
            myChart.setActiveElements([]); 
            myChart.update();
        }
    }

    function renderUserGrid(data) {
        const isDark = document.documentElement.classList.contains('dark');
        const container = document.getElementById('clean-grid-canvas');
        if(!container) return;
        container.innerHTML = ''; 

        const userGrid = new DataGrid({
            containerId: 'clean-grid-canvas',
            perPageId: 'dg-per-page',
            data: data || [],
            bodyHeight: 'auto',
            showRowHeaders: ['rowNum'], 
            columns: [
                { header: '아이디', name: 'userId', align: 'center', width: 130 },
                { header: '성명', name: 'userName', align: 'center', width: 100 },
                { header: '계정상태', name: 'accStatus', align: 'center', width: 100,
                  formatter: ({value}) => {
                      const bgClass = isDark ? 'bg-gray-600 text-gray-200' : 'bg-gray-100 text-gray-700';
                      return `<span class="px-2 py-1 rounded-full text-xs font-semibold \${bgClass}">\${value || '-'}</span>`;
                  }
                },
                { header: '승인상태', name: 'appStatus', align: 'center', width: 100,
                  formatter: ({value}) => {
                      const bgClass = isDark ? 'bg-gray-600 text-gray-200' : 'bg-gray-100 text-gray-700';
                      return `<span class="px-2 py-1 rounded-full text-xs font-semibold \${bgClass}">\${value || '-'}</span>`;
                  }
                },
                { header: '지역', name: 'address', align: 'left' },
                { header: '가입일', name: 'regDate', align: 'center', width: 180 }
            ],
            pageOptions: { useClient: true, perPage: 10 }
        });

        setTimeout(() => {
            if(userGrid && userGrid.grid) userGrid.grid.refreshLayout();
        }, 150);
    }

    function changeMode(mode, btn) {
        currentMode = mode;
        const isDark = document.documentElement.classList.contains('dark');
        
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

     	// 탭 변경 시 그리드 데이터를 전체로 비동기 초기화
        const titleEl = document.getElementById('dg-title');
        if (titleEl) {
            titleEl.innerText = "사용자 상세 내역 (전체)";
        }
        fetchUserListData('all', '');
        
        setTimeout(() => { initChart(mode); }, 50);
    }

    function initChart(mode) {
        const isDark = document.documentElement.classList.contains('dark');
        const ctx = document.getElementById('userChart').getContext('2d');
        if(myChart) myChart.destroy(); 

        const theme = {
            text: isDark ? '#9CA3AF' : '#6B7280',
            grid: isDark ? 'rgba(255, 255, 255, 0.05)' : '#F3F4F6'
        };

        let config = { 
            options: {
                responsive: true, maintainAspectRatio: false,
                plugins: { 
                    legend: { 
                        position: 'bottom',
                        labels: { color: theme.text, font: { family: 'Pretendard' } }
                    } 
                },
                onClick: (evt, elements) => {
                    if (elements.length > 0) {
                        const label = myChart.data.labels[elements[0].index];
                        document.getElementById('dg-title').innerText = "상세 내역 (" + label + ")";
                        fetchUserListData(mode, label); 
                    }
                },
                scales: mode === 'region' ? {
                    x: { grid: { color: theme.grid }, ticks: { color: theme.text } },
                    y: { grid: { display: false }, ticks: { color: theme.text } }
                } : {}
            } 
        };

        if(mode === 'accStatus') {
            document.getElementById('chartTitle').innerText = "계정 상태 분포";
            config.type = 'doughnut';
            config.data = {
                labels: statsData.accStatus.map(s => s.name),
                datasets: [{ 
                    data: statsData.accStatus.map(s => s.value), 
                    backgroundColor: isDark 
                        ? ['#F9FAFB', '#D1D5DB', '#6B7280']
                        : ['#F1F5F9', '#CBD5E1', '#475569'],
                    cutout: '65%',
                    borderWidth: 2,
                    borderColor: isDark ? '#374151' : '#ffffff'
                }]
            };
        } else if(mode === 'region') {
            document.getElementById('chartTitle').innerText = "지역별 분포 (Top 5)";
            config.type = 'bar';
            config.data = {
                labels: statsData.region.map(r => r.name),
                datasets: [{ 
                    label: '인원수', 
                    data: statsData.region.map(r => r.value), 
                    backgroundColor: isDark ? '#D1D5DB' : '#111827',
                    borderRadius: 4
                }]
            };
            config.options.indexAxis = 'y';
        } else if(mode === 'appStatus') {
            document.getElementById('chartTitle').innerText = "가입 승인 현황";
            config.type = 'pie';
            config.data = {
                labels: statsData.appStatus.map(s => s.name),
                datasets: [{ 
                    data: statsData.appStatus.map(s => s.value), 
                    backgroundColor: isDark 
                        ? ['#E5E7EB', '#9CA3AF', '#4B5563']
                        : ['#E2E8F0', '#CBD5E1', '#94A3B8'],
                    borderWidth: 2,
                    borderColor: isDark ? '#374151' : '#ffffff'
                }]
            };
        }
        myChart = new Chart(ctx, config);
    }
</script>