<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .tui-grid-cell-row-header, .tui-grid-column-rownum, [data-column-name="_number"] { display: none !important; }
    #user-dg-wrapper .p-2 { font-size: 0 !important; color: transparent !important; }
    #clean-grid-canvas { font-size: 0.875rem !important; color: initial !important; }
</style>

<c:set var="showSearchArea" value="false" scope="request" />
<c:set var="showAddBtn" value="false" scope="request" />

<div class="mx-4 my-6 space-y-6">
    <div class="px-8 py-4"><h1 class="text-2xl font-bold text-gray-900">사용자 지표 분석</h1></div>
    <div class="px-5"><%@ include file="statsNav.jsp" %></div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 px-5">
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-gray-900">
            <p class="text-sm font-medium text-gray-500">전체 활성 사용자</p>
            <p id="kpi-total-active" class="text-3xl font-bold mt-2">0명</p>
        </div>
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-gray-400">
            <p class="text-sm font-medium text-gray-500">가입 승인 대기</p>
            <p id="kpi-pending" class="text-3xl font-bold text-orange-500 mt-2">0건</p>
        </div>
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-gray-200">
            <p class="text-sm font-medium text-gray-500">최다 가입 지역</p>
            <p id="kpi-top-region" class="text-3xl font-bold mt-2">--</p>
        </div>
    </div>

    <section class="mx-5 p-10 bg-white rounded-lg shadow-sm border min-h-[600px] flex flex-col">
        <div class="flex justify-between items-center mb-10">
            <h4 id="chartTitle" class="text-md font-bold border-l-4 border-gray-900 pl-3">계정 상태 분포</h4>
            <div class="flex space-x-1">
                <button class="btn-tab px-4 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg" onclick="changeMode('accStatus', this)">계정 상태</button>
                <button class="btn-tab px-4 py-2 text-sm bg-gray-100 rounded-lg" onclick="changeMode('region', this)">지역 분포</button>
                <button class="btn-tab px-4 py-2 text-sm bg-gray-100 rounded-lg" onclick="changeMode('appStatus', this)">승인 현황</button>
            </div>
        </div>
        <div class="flex-1 flex justify-center items-center">
            <div class="relative w-full max-w-[650px] h-[450px]"><canvas id="userChart"></canvas></div>
        </div>
    </section>

    <div id="user-dg-wrapper" class="mx-5 mt-10 bg-white rounded-lg shadow-sm border mb-10">
        <div class="p-5 border-b flex justify-between items-center">
            <h3 id="dg-title" class="text-lg font-bold text-gray-900">사용자 상세 내역</h3>
            <button onclick="location.reload()" class="text-xs text-blue-500">전체보기</button>
        </div>
        <div class="p-2">
            <div id="clean-grid-canvas"></div>
            <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp" />
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="${pageContext.request.contextPath}/js/datagrid.js"></script>

<script>
// 전역 변수 중복 방지
if (typeof myChart === 'undefined') var myChart;
if (typeof statsData === 'undefined') var statsData = {};
const contextPath = '${pageContext.request.contextPath}';

document.addEventListener("DOMContentLoaded", function() {
    // 1. KPI 및 차트 로드
    fetch(contextPath + '/admin/stats/user-full-data')
        .then(res => res.json())
        .then(data => {
            statsData = data;
            updateKPI(data);
            const firstBtn = document.querySelector('.btn-tab');
            changeMode('accStatus', firstBtn);
        }).catch(e => console.error("KPI Error:", e));

    // 2. 초기 리스트 로드
    fetchUserListData('all', ''); 
});

function fetchUserListData(type, value) {
    const t = type || 'all';
    const v = value || '';
    const url = contextPath + '/admin/stats/user-list-filtered?type=' + t + '&value=' + encodeURIComponent(v);

    fetch(url)
        .then(res => {
            if (!res.ok) throw new Error('Network response was not ok');
            return res.json();
        })
        .then(data => {
            renderUserGrid(data);
        }).catch(err => console.error("Grid Data Fetch Error:", err));
}

function renderUserGrid(data) {
    const container = document.getElementById('clean-grid-canvas');
    if(!container) return;
    container.innerHTML = ''; 

    userGrid = new DataGrid({
        containerId: 'clean-grid-canvas',
        data: data, // 서버에서 가져온 전체 데이터
        columns: [
            { header: '아이디', name: 'userId', align: 'center', width: 130 },
            { header: '성명', name: 'userName', align: 'center', width: 100 },
            { header: '계정상태', name: 'accStatus', align: 'center', width: 100,
              formatter: ({value}) => `<span class="px-2 py-1 rounded-full text-xs font-semibold bg-gray-100">\${value || '-'}</span>`
            },
            { header: '승인상태', name: 'appStatus', align: 'center', width: 100,
                formatter: ({value}) => `<span class="px-2 py-1 rounded-full text-xs font-semibold bg-gray-100">\${value || '-'}</span>`
              },
            { header: '지역', name: 'address', align: 'left' },
            { header: '가입일', name: 'regDate', align: 'center', width: 120 }
        ],
        pageOptions: { 
            useClient: true, 
            perPage: 10     
        }
    });

    setTimeout(() => {
        if(userGrid && userGrid.grid) {
            userGrid.grid.refreshLayout();
        }
        const nodes = document.querySelectorAll('#clean-grid-canvas *');
        nodes.forEach(node => {
            if (node.children.length === 0 && (node.textContent.includes('No.') || /^\d+$/.test(node.textContent.trim()))) {
                node.textContent = '';
            }
        });
    }, 200);
}

function changeMode(mode, btn) {
    if (!btn || !statsData.accStatus) return;
    const ctx = document.getElementById('userChart').getContext('2d');
    if(myChart) myChart.destroy(); 
    
    document.querySelectorAll('.btn-tab').forEach(tab => {
        tab.className = "btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg ml-1";
    });
    btn.className = "btn-tab px-4 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg shadow-sm";

    let config = { 
        type: 'doughnut', 
        data: {}, 
        options: {
            responsive: true, maintainAspectRatio: false,
            plugins: { legend: { position: 'bottom' } },
            onClick: (evt, elements) => {
                if (elements.length > 0) {
                    const index = elements[0].index;
                    const label = myChart.data.labels[index];
                    document.getElementById('dg-title').innerText = "상세 내역 (" + label + ")";
                    fetchUserListData(mode, label); 
                }
            }
        } 
    };

    if(mode === 'accStatus') {
        document.getElementById('chartTitle').innerText = "계정 상태 분포";
        config.data = {
            labels: statsData.accStatus.map(s => s.name),
            datasets: [{ data: statsData.accStatus.map(s => s.value), backgroundColor: ['#CBD5E1', '#94A3B8', '#475569'] }]
        };
    } else if(mode === 'region') {
        document.getElementById('chartTitle').innerText = "지역별 분포";
        config.type = 'bar';
        config.data = {
            labels: statsData.region.map(r => r.name),
            datasets: [{ label: '인원수', data: statsData.region.map(r => r.value), backgroundColor: '#94A3B8' }]
        };
        config.options.indexAxis = 'y';
    } else if(mode === 'appStatus') {
        document.getElementById('chartTitle').innerText = "가입 승인 현황";
        config.type = 'pie';
        config.data = {
            labels: statsData.appStatus.map(s => s.name),
            datasets: [{ data: statsData.appStatus.map(s => s.value), backgroundColor: ['#E2E8F0', '#CBD5E1', '#94A3B8'] }]
        };
    }
    myChart = new Chart(ctx, config);
}

function updateKPI(data) {
    const active = data.accStatus.find(s => s.name === 'ACTIVE')?.value || 0;
    const pending = data.appStatus.find(s => s.name === 'PENDING')?.value || 0;
    document.getElementById('kpi-total-active').innerText = active.toLocaleString() + '명';
    document.getElementById('kpi-pending').innerText = pending.toLocaleString() + '건';
    document.getElementById('kpi-top-region').innerText = data.region && data.region[0] ? data.region[0].name : '--';
}
</script>