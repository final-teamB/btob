<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* [1] TUI Grid 강제 생성 번호(No.) 컬럼 물리적 박멸 */
    /* 헤더와 바디의 번호 셀을 숨기고 너비를 0으로 만듭니다. */
    .tui-grid-cell-row-header, 
    .tui-grid-column-rownum,
    [data-column-name="_number"] {
        display: none !important;
        width: 0 !important;
        min-width: 0 !important;
        border: none !important;
    }

    /* 번호 컬럼이 사라진 왼쪽 여백을 0으로 당깁니다. */
    .tui-grid-rside-area {
        margin-left: 0 !important;
        width: 100% !important;
    }
    .tui-grid-lside-area {
        display: none !important;
    }

    /* [2] 텍스트 노드로 삐져나오는 'No.' 및 숫자 유령 방어 */
    #dg-container-wrapper .p-2 {
        font-size: 0 !important;
        line-height: 0 !important;
        color: transparent !important;
    }

    /* 실제 그리드 영역만 폰트 복구 */
    #clean-grid-canvas {
        font-size: 0.875rem !important;
        line-height: normal !important;
        color: initial !important;
    }
    
    /* 그리드 내부 글자 강제 복구 */
    .tui-grid-cell-content {
        font-size: 14px !important;
        color: #1f2937 !important;
    }
</style>

<div class="mx-4 my-6 space-y-6">
    <%-- 상단 KPI 섹션 --%>
    <div class="px-8 py-4 flex flex-col md:flex-row justify-between items-center">
        <div>
            <h1 class="text-2xl font-bold text-gray-900">배송 현황 분석</h1>
            <p class="text-sm text-gray-500 mt-1">배송 단계별 실시간 데이터 및 지역 분포를 확인합니다.</p>
        </div>
    </div>
    
    <div class="px-5">
        <%@ include file="statsNav.jsp" %>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 px-5">
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-gray-900">
            <p class="text-sm font-medium text-gray-500">평균 배송 소요시간</p>
            <p id="kpi-avg-time" class="text-3xl font-bold text-gray-900 mt-2">0.0일</p>
        </div>
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-blue-500">
            <p class="text-sm font-medium text-gray-500">현재 배송중 건수</p>
            <p id="kpi-shipping" class="text-3xl font-bold text-blue-600 mt-2">0건</p>
        </div>
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-red-400">
            <p class="text-sm font-medium text-gray-500">배송 지연 (3일↑)</p>
            <p id="kpi-delay" class="text-3xl font-bold text-red-600 mt-2">0건</p>
        </div>
    </div>

    <%-- 차트 섹션 --%>
    <section class="mx-5 p-10 bg-white rounded-lg shadow-sm border border-gray-100 min-h-[600px] flex flex-col">
        <div class="flex justify-between items-center mb-10 w-full">
            <h4 id="chartTitle" class="text-md font-bold text-gray-900 border-l-4 border-gray-900 pl-3">배송 상세 단계별 비중</h4>
            <div class="flex space-x-1" id="deliveryTabGroup">
                <button type="button" onclick="changeMode('status', this)" class="btn-tab px-4 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg shadow-sm">배송 단계</button>
                <button type="button" onclick="changeMode('region', this)" class="btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 ml-1">지역 분포</button>
            </div>
        </div>
        <div class="flex-1 w-full flex justify-center items-center">
            <div class="relative w-full max-w-[650px] h-[450px]">
                <canvas id="deliveryChart"></canvas>
            </div>
        </div>
    </section>
    
    <%-- 데이터 그리드 섹션 --%>
    <c:set var="showSearchArea" value="false" scope="request" />
    <c:set var="showPerPage" value="false" scope="request" />
	
    <div id="dg-container-wrapper" class="bg-white rounded-lg shadow-sm border border-gray-100 mt-6 mx-5 mb-10">
        <div class="p-5 border-b border-gray-50 flex justify-between items-center">
            <h3 id="dg-title" class="text-lg font-bold text-gray-800">최근 배송 상태 변경 내역</h3>
            <button onclick="location.reload()" class="text-xs text-blue-500 hover:underline">필터 초기화</button>
        </div>
        <div class="p-2">
            <div id="clean-grid-canvas"></div>
            <div style="display:none;"><jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp" /></div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="${pageContext.request.contextPath}/js/datagrid.js"></script>

<script>
    let myChart;
    let deliveryGrid;
    let statsData = {}; 

    document.addEventListener("DOMContentLoaded", function() {
        fetch('${pageContext.request.contextPath}/admin/stats/delivery-full-data')
            .then(res => res.json())
            .then(data => {
                statsData = data;
                updateKPI(data.kpi);
                changeMode('status', document.querySelector('.btn-tab'));
                initDeliveryStatsGrid(data.gridList || []);
            });
    });

    function initDeliveryStatsGrid(data) {
        const target = document.getElementById('clean-grid-canvas');
        if (!target) return;

        // 1. 기존 DOM 싹 비우기
        target.innerHTML = '';

        // 2. DataGrid 생성 (datagrid.js 내부의 rowHeaders 설정을 덮어쓰기 위해 빈 배열 전달)
        deliveryGrid = new DataGrid({
            containerId: 'clean-grid-canvas',
            data: data,
            rowHeaders: [], // datagrid.js가 이를 받아준다면 베스트, 아니면 CSS가 해결함
            columns: [
                { header: '주문ID', name: 'orderNo', align: 'center', width: 120 },
                { header: '배송지', name: 'regionName', align: 'center' },
                { header: '상태', name: 'statusName', align: 'center',
                  formatter: ({value}) => `<span class="px-2 py-1 rounded-full text-xs font-semibold bg-gray-100">\${value}</span>` 
                },
                { header: '업데이트 일시', name: 'updateTime', align: 'center', width: 180 }
            ],
            pageOptions: { useClient: true, perPage: 10 }
        });

        // 3. [확인사살] 렌더링 직후 텍스트 노드로 남은 유령 숫자 노드 제거
        setTimeout(() => {
            const walker = document.createTreeWalker(target, NodeFilter.SHOW_TEXT, null, false);
            let node;
            while(node = walker.nextNode()) {
                if (node.nodeValue.includes('No.') || /^\d+$/.test(node.nodeValue.trim())) {
                    node.nodeValue = ''; 
                }
            }
        }, 30);
    }

    // --- KPI 및 차트 핸들링 로직 ---
    function fetchFilteredData(mode, label) {
        let type = (mode === 'status') ? 'status' : 'region';
        let value = label;

        if(mode === 'status') {
            const mapping = {
                '상품준비중': 'READY', '국제운송중': 'L_SHIPPING', '보세창고입고': 'L_WH',
                '통관진행중': 'IN_CUSTOMS', '통관완료': 'C_DONE', '국내배송중': 'D_SHIPPING', '배송완료': 'COMPLETE'
            };
            value = mapping[label] || label;
        }

        document.getElementById('dg-title').innerText = `상세 내역: \${label}`;
        fetch(`${pageContext.request.contextPath}/admin/stats/delivery-list-filtered?type=\${type}&value=\${encodeURIComponent(value)}`)
            .then(res => res.json())
            .then(data => initDeliveryStatsGrid(data));
    }

    function changeMode(mode, btn) {
        if (!btn) return;
        const ctx = document.getElementById('deliveryChart').getContext('2d');
        if(myChart) myChart.destroy(); 

        document.querySelectorAll('.btn-tab').forEach(tab => {
            tab.className = "btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 ml-1";
        });
        btn.className = "btn-tab px-4 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg shadow-sm";

        let options = {
            onClick: (event, elements) => {
                if (elements.length > 0) {
                    const index = elements[0].index;
                    const label = myChart.data.labels[index];
                    fetchFilteredData(mode, label);
                }
            },
            responsive: true, maintainAspectRatio: false,
            plugins: { legend: { position: 'bottom', labels: { padding: 20, usePointStyle: true } } }
        };

        if(mode === 'status') {
            document.getElementById('chartTitle').innerText = "배송 상세 단계별 비중";
            const s = statsData.status || {};
            myChart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['상품준비중', '국제운송중', '보세창고입고', '통관진행중', '통관완료', '국내배송중', '배송완료'],
                    datasets: [{
                        data: [s.READY||0, s.L_SHIPPING||0, s.L_WH||0, s.IN_CUSTOMS||0, s.C_DONE||0, s.D_SHIPPING||0, s.COMPLETE||0],
                        backgroundColor: ['#F1F5F9','#E2E8F0','#CBD5E1','#94A3B8','#64748B','#475569','#1E293B'],
                        cutout: '55%'
                    }]
                },
                options: options
            });
        } else if(mode === 'region') {
            document.getElementById('chartTitle').innerText = "지역별 배송 분포 (Top 5)";
            myChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: statsData.region ? statsData.region.map(r => r.name) : [],
                    datasets: [{ label: '지역별 건수', data: statsData.region ? statsData.region.map(r => r.value) : [], backgroundColor: '#94A3B8' }]
                },
                options: { ...options, indexAxis: 'y' }
            });
        } 
    }

    function updateKPI(kpi) {
        if(!kpi) return;
        document.getElementById('kpi-avg-time').innerText = (kpi.avg_delivery_time || 0) + '일';
        document.getElementById('kpi-shipping').innerText = (kpi.current_shipping || 0) + '건';
        document.getElementById('kpi-delay').innerText = (kpi.delay_count || 0) + '건';
    }
</script>