<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="mx-4 my-6 space-y-6">
    <%-- [1. 타이틀 영역] --%>
    <div class="px-8 py-4 flex flex-col md:flex-row justify-between items-center">
        <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">배송 현황 분석</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">배송 단계별 소요 시간 및 지역 분포를 실시간으로 확인합니다.</p>
        </div>
    </div>
    
    <%-- [2. 네비게이션 인클루드] --%>
    <div class="px-5">
        <%@ include file="statsNav.jsp" %>
    </div>

    <%-- [3. KPI 카드 영역] --%>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 px-5">
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-gray-900 dark:bg-gray-800 dark:border-gray-400">
            <p class="text-sm font-medium text-gray-500 dark:text-gray-400">평균 배송 소요시간</p>
            <p id="kpi-avg-time" class="text-3xl font-bold text-gray-900 dark:text-white mt-2">0.0일</p>
        </div>
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-gray-300 dark:bg-gray-800">
            <p class="text-sm font-medium text-gray-500 dark:text-gray-400">현재 배송중 건수</p>
            <p id="kpi-shipping" class="text-3xl font-bold text-gray-900 dark:text-white mt-2">0건</p>
        </div>
        <div class="p-6 bg-white rounded-lg shadow-sm border-l-4 border-red-400 dark:bg-gray-800">
            <p class="text-sm font-medium text-gray-500 dark:text-gray-400">배송 지연 (3일↑)</p>
            <p id="kpi-delay" class="text-3xl font-bold text-red-600 mt-2">0건</p>
        </div>
    </div>

    <%-- [4. 차트 영역 - 정중앙 배치 최적화] --%>
    <section class="mx-5 p-10 bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 dark:border-gray-700 min-h-[600px] flex flex-col">
        <div class="flex justify-between items-center mb-10 w-full">
            <h4 id="chartTitle" class="text-md font-bold text-gray-900 dark:text-white border-l-4 border-gray-900 pl-3">
                배송 상세 단계별 비중
            </h4>
            <div class="flex space-x-1" id="deliveryTabGroup">
                <button type="button" onclick="changeMode('status', this)" 
                        class="btn-tab px-4 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg transition-all shadow-sm">
                    배송 단계
                </button>
                <button type="button" onclick="changeMode('region', this)" 
                        class="btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 transition-all ml-1">
                    지역 분포
                </button>
                <button type="button" onclick="changeMode('trend', this)" 
                        class="btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 transition-all ml-1">
                    완료 추이
                </button>
            </div>
        </div>
        
        <%-- 차트 본체: 부모 flex로 상하좌우 정가운데 고정 --%>
        <div class="flex-1 w-full flex justify-center items-center">
            <div class="relative w-full max-w-[750px] h-[400px]">
                <canvas id="deliveryChart"></canvas>
            </div>
        </div>
    </section>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
let myChart;
let statsData = {}; 

document.addEventListener("DOMContentLoaded", function() {
    fetch('${pageContext.request.contextPath}/admin/stats/delivery-full-data')
        .then(res => res.json())
        .then(data => {
            statsData = data;
            updateKPI(data.kpi);
            // 초기 로딩 시 '배송 단계' 버튼 활성화 상태로 호출
            const firstBtn = document.querySelector('.btn-tab');
            changeMode('status', firstBtn);
        })
        .catch(err => console.error("데이터 로드 실패:", err));
});

function updateKPI(kpi) {
    document.getElementById('kpi-avg-time').innerText = (kpi?.avg_delivery_time || 0) + '일';
    document.getElementById('kpi-shipping').innerText = (kpi?.current_shipping || 0) + '건';
    document.getElementById('kpi-delay').innerText = (kpi?.delay_count || 0) + '건';
}

function changeMode(mode, btn) {
    if (!btn) return;

    const ctx = document.getElementById('deliveryChart').getContext('2d');
    if(myChart) myChart.destroy(); 
    
    // 버튼 스타일 초기화 및 Charcoal 스타일 적용
    document.querySelectorAll('.btn-tab').forEach(tab => {
        tab.className = "btn-tab px-4 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 transition-all ml-1";
    });
    btn.className = "btn-tab px-4 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg transition-all shadow-sm";

    // 공통 차트 설정
    let config = { 
        responsive: true, 
        maintainAspectRatio: false,
        plugins: { 
            legend: { 
                position: 'bottom',
                labels: { 
                    padding: 20,
                    font: { family: 'Pretendard', size: 13 },
                    color: document.documentElement.classList.contains('dark') ? '#9CA3AF' : '#4B5563' 
                } 
            } 
        }
    };
    
    if(mode === 'status') {
        document.getElementById('chartTitle').innerText = "배송 상세 단계별 비중";
        config.type = 'doughnut';
        config.data = {
            labels: ['상품준비', '국내운송', '해외/통관', '최종배송중', '배송완료'],
            datasets: [{
                data: [
                    statsData.status?.READY || 0,
                    (statsData.status?.L_SHIPPING || 0) + (statsData.status?.L_WH || 0),
                    (statsData.status?.ABROAD || 0) + (statsData.status?.IN_CUSTOMS || 0) + (statsData.status?.C_DONE || 0),
                    statsData.status?.D_SHIPPING || 0,
                    statsData.status?.COMPLETE || 0
                ],
                backgroundColor: ['#F1F5F9', '#E2E8F0', '#CBD5E1', '#94A3B8', '#475569'],
                borderWidth: 2,
                borderColor: '#ffffff'
            }]
        };
        // 도넛 차트 전용 중앙 정렬 옵션 추가
        config.options = {
            maintainAspectRatio: false,
            layout: {
                padding: 0 // 패딩을 제거해서 꽉 차게 만듦
            },
            plugins: {
                legend: {
                    position: 'bottom', // 범례를 아래로 보내야 좌우 균형이 맞음
                    align: 'center',
                    labels: { padding: 20 }
                }
            }
        };
        
    } else if(mode === 'region') {
        document.getElementById('chartTitle').innerText = "지역별 배송 분포 (Top 5)";
        config.type = 'bar';
        config.options = { 
            indexAxis: 'y', 
            plugins: { legend: { display: true, position: 'bottom' } }, // 범례 추가!!
            scales: {
                x: { display: false, grid: { display: false } },
                y: { grid: { display: false }, ticks: { color: '#475569', font: { size: 13, weight: '600' } } }
            }
        };
        config.data = {
            labels: statsData.region ? statsData.region.map(r => r.name) : [],
            datasets: [{
                label: '지역별 건수', // 범례에 뜰 이름
                data: statsData.region ? statsData.region.map(r => r.value) : [],
                backgroundColor: '#CBD5E1', // 연한 색 유지
                borderRadius: 5, barThickness: 30
            }]
        };
    } else if(mode === 'trend') {
        document.getElementById('chartTitle').innerText = "최근 7일 배송 완료 추이";
        config.type = 'line';
        config.data = {
            labels: statsData.trend ? statsData.trend.map(t => t.date) : [],
            datasets: [{
                label: '완료 건수',
                data: statsData.trend ? statsData.trend.map(t => t.count) : [],
                borderColor: '#334155',
                backgroundColor: 'rgba(51, 65, 85, 0.05)',
                fill: true,
                tension: 0.4,
                pointRadius: 4,
                pointBackgroundColor: '#334155'
            }]
        };
    }
    myChart = new Chart(ctx, config);
}
</script>