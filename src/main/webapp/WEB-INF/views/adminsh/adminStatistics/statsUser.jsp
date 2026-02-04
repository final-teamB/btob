<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="mx-4 my-6 space-y-6">
    <%-- [1. 타이틀 영역] --%>
    <div class="px-8 py-4">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">사용자 지표 분석</h1>
    </div>
    
    <div class="px-5">
        <%@ include file="statsNav.jsp" %>
    </div>

    <%-- [2. KPI 카드 영역] --%>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 px-5">
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-gray-900 dark:bg-gray-800">
            <p class="text-sm font-medium text-gray-500">전체 활성 사용자</p>
            <p id="kpi-total-active" class="text-3xl font-bold text-gray-900 dark:text-white mt-2">0명</p>
        </div>
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-gray-400 dark:bg-gray-800">
            <p class="text-sm font-medium text-gray-500">가입 승인 대기</p>
            <p id="kpi-pending" class="text-3xl font-bold text-orange-500 mt-2">0건</p>
        </div>
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-gray-200 dark:bg-gray-800">
            <p class="text-sm font-medium text-gray-500">최다 가입 지역</p>
            <p id="kpi-top-region" class="text-3xl font-bold text-gray-900 dark:text-white mt-2">--</p>
        </div>
    </div>

    <%-- [3. 차트 영역 - 완벽 정중앙 배치] --%>
    <section class="mx-5 p-10 bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 min-h-[600px] flex flex-col">
        <div class="flex justify-between items-center mb-10 w-full">
            <h4 id="chartTitle" class="text-md font-bold text-gray-900 dark:text-white border-l-4 border-gray-900 pl-3">가입자 추이</h4>
            <div class="flex space-x-1">
                <button type="button" onclick="changeMode('trend', this)" class="btn-tab px-4 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg shadow-sm">가입 추이</button>
                <button type="button" onclick="changeMode('accStatus', this)" class="btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 ml-1">계정 상태</button>
                <button type="button" onclick="changeMode('region', this)" class="btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 ml-1">지역 분포</button>
                <button type="button" onclick="changeMode('appStatus', this)" class="btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 ml-1">승인 현황</button>
            </div>
        </div>
        
        <div class="flex-1 w-full flex justify-center items-center">
            <div class="relative w-full max-w-[700px] h-[400px]">
                <canvas id="userChart"></canvas>
            </div>
        </div>
    </section>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
let myChart;
let statsData = {}; 

document.addEventListener("DOMContentLoaded", function() {
    fetch('${pageContext.request.contextPath}/admin/stats/user-full-data')
        .then(res => res.json())
        .then(data => {
            statsData = data;
            updateKPI(data);
            changeMode('trend', document.querySelector('.btn-tab'));
        })
        .catch(err => console.error("데이터 로드 실패:", err));
});

function updateKPI(data) {
    const activeData = data.accStatus.find(s => s.name === 'ACTIVE');
    document.getElementById('kpi-total-active').innerText = (activeData ? activeData.value : 0).toLocaleString() + '명';
    document.getElementById('kpi-pending').innerText = (data.appStatus.find(s => s.name === 'PENDING')?.value || 0) + '건';
    document.getElementById('kpi-top-region').innerText = data.region && data.region[0] ? data.region[0].name : '--';
}

function changeMode(mode, btn) {
    if (!btn) return;
    const ctx = document.getElementById('userChart').getContext('2d');
    if(myChart) myChart.destroy(); 
    
    document.querySelectorAll('.btn-tab').forEach(tab => {
        tab.className = "btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 ml-1 transition-all";
    });
    btn.className = "btn-tab px-4 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg shadow-sm transition-all";

    // ✅ 모든 모드에서 공통으로 적용될 옵션 (범례 무조건 아래!)
    let commonOptions = {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                display: true,
                position: 'bottom', // 여기서 아래로 고정
                labels: { padding: 25, font: { size: 13 } }
            }
        }
    };

    let config = { type: '', data: {}, options: commonOptions };
    
    if(mode === 'trend') {
        document.getElementById('chartTitle').innerText = "신규 가입자 추이 (누적 기록)";
        config.type = 'line';
        config.data = {
            labels: statsData.trend.map(t => t.statsDate ? String(t.statsDate).substring(5, 10) : ''),
            datasets: [{
                label: '가입 기록',
                data: statsData.trend.map(t => t.statsValue),
                borderColor: '#334155', backgroundColor: 'rgba(51, 65, 85, 0.05)',
                fill: true, tension: 0.4, pointRadius: 4
            }]
        };
    } else if(mode === 'accStatus') {
        document.getElementById('chartTitle').innerText = "사용자 계정 상태";
        config.type = 'doughnut';
        config.data = {
            labels: statsData.accStatus.map(s => s.name),
            datasets: [{
                data: statsData.accStatus.map(s => s.value),
                backgroundColor: ['#CBD5E1', '#94A3B8', '#475569'],
                borderWidth: 2, borderColor: '#ffffff'
            }]
        };
    } else if(mode === 'region') {
        document.getElementById('chartTitle').innerText = "지역별 사용자 분포 (실시간)";
        config.type = 'bar';
        config.data = {
            labels: statsData.region.map(r => r.name || '기타'),
            datasets: [{
                label: '사용자 수',
                data: statsData.region.map(r => r.value),
                backgroundColor: '#CBD5E1', borderRadius: 5, barThickness: 30
            }]
        };
        // 막대 차트 전용 축 설정 추가 (범례는 commonOptions 유지)
        config.options.indexAxis = 'y';
        config.options.scales = {
            x: { display: false, grid: { display: false } },
            y: { grid: { display: false }, ticks: { font: { weight: '600' } } }
        };
    } else if(mode === 'appStatus') {
        document.getElementById('chartTitle').innerText = "가입 승인 처리 현황";
        config.type = 'pie';
        config.data = {
            labels: statsData.appStatus.map(s => s.name),
            datasets: [{
                data: statsData.appStatus.map(s => s.value),
                backgroundColor: ['#E2E8F0', '#CBD5E1', '#94A3B8'],
                borderWidth: 2, borderColor: '#ffffff'
            }]
        };
    }
    myChart = new Chart(ctx, config);
}
</script>