<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* 차트 카드 클릭 유도 스타일 */
    .chart-card {
        cursor: pointer;
        transition: all 0.2s ease-in-out;
    }
    .chart-card:hover {
        transform: translateY(-4px);
        border-color: #111827 !important; /* Charcoal 색상 강조 */
        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
    }
</style>

<%-- [팀 공통 가이드 적용: Charcoal & White 미니멀 스타일] --%>
<div class="mx-4 my-6 space-y-6">

    <%-- [1. 타이틀 영역] --%>
    <div class="px-8 py-4 flex flex-col md:flex-row justify-between items-center">
        <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">종합 통계 대시보드</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">실시간 주문 현황 및 물류/재고 데이터를 시각화합니다.</p>
        </div>
        <div class="flex items-center space-x-3 mt-4 md:mt-0">
            <button type="button" onclick="location.reload()" class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 dark:bg-gray-800 dark:text-gray-300 dark:border-gray-600 dark:hover:bg-gray-700 transition shadow-sm">
                새로고침
            </button>
        </div>
    </div>

    <%-- 네비게이션 포함 (statsNav.jsp) --%>
    <%@ include file="statsNav.jsp" %>

    <%-- [2. KPI 카드 섹션] --%>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 px-5">
        <div class="p-5 bg-white rounded-lg shadow-sm dark:bg-gray-800 border-t-4 border-gray-900 dark:border-gray-500">
            <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400">오늘 주문</h3>
            <div class="text-2xl font-bold text-gray-900 dark:text-white mt-2" id="kpi-order">-</div>
        </div>
        
        <div class="p-5 bg-white rounded-lg shadow-sm dark:bg-gray-800 border-t-4 border-gray-400 dark:border-gray-600">
            <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400">평균 배송일</h3>
            <div class="text-2xl font-bold text-gray-900 dark:text-white mt-2" id="kpi-delivery">-</div>
        </div>
        
        <div class="p-5 bg-white rounded-lg shadow-sm dark:bg-gray-800 border-t-4 border-red-500">
            <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400">재고 부족 상품</h3>
            <div class="text-2xl font-bold text-red-600 mt-2" id="kpi-product">-</div>
        </div>
        
        <div class="p-5 bg-white rounded-lg shadow-sm dark:bg-gray-800 border-t-4 border-gray-300 dark:border-gray-700">
            <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400">활성 유저</h3>
            <div class="text-2xl font-bold text-gray-900 dark:text-white mt-2" id="kpi-user">-</div>
        </div>
    </div>

    <%-- [3. 차트 그리드 섹션] --%>
<div class="grid grid-cols-1 lg:grid-cols-2 gap-6 px-5">
    
    <%-- (1) 주문 현황 -> stats/order 이동 --%>
    <section onclick="location.href='${pageContext.request.contextPath}/admin/stats/order'" 
             class="chart-card p-6 bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 dark:border-gray-700">
        <div class="flex justify-between items-center mb-4">
            <h4 class="text-md font-bold text-gray-900 dark:text-white border-l-4 border-gray-900 pl-3">
                최근 7일 주문 건수
            </h4>
            <span class="text-xs text-blue-500 font-medium">상세보기 ></span>
        </div>
        <div class="h-[300px]">
            <canvas id="orderChart"></canvas>
        </div>
    </section>

    <%-- (2) 배송 단계 비율 -> stats/delivery 이동 --%>
    <section onclick="location.href='${pageContext.request.contextPath}/admin/stats/delivery'"
             class="chart-card p-6 bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 dark:border-gray-700">
        <div class="flex justify-between items-center mb-4">
            <h4 class="text-md font-bold text-gray-900 dark:text-white border-l-4 border-gray-900 pl-3">배송 단계 비율</h4>
            <span class="text-xs text-blue-500 font-medium">상세보기 ></span>
        </div>
        <div class="h-[300px] flex justify-center">
            <canvas id="deliveryChart"></canvas>
        </div>
    </section>

    <%-- (3) 지역별 사용자 -> stats/user 이동 --%>
    <section onclick="location.href='${pageContext.request.contextPath}/admin/stats/user'"
             class="chart-card p-6 bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 dark:border-gray-700">
        <div class="flex justify-between items-center mb-4">
            <h4 class="text-md font-bold text-gray-900 dark:text-white border-l-4 border-gray-900 pl-3">지역별 사용자</h4>
            <span class="text-xs text-blue-500 font-medium">상세보기 ></span>
        </div>
        <div class="h-[300px]">
            <canvas id="userChart"></canvas>
        </div>
    </section>

    <%-- (4) 상품 재고 현황 -> stats/product 이동 --%>
    <section onclick="location.href='${pageContext.request.contextPath}/admin/stats/product'"
             class="chart-card p-6 bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 dark:border-gray-700">
        <div class="flex justify-between items-center mb-4">
            <h4 class="text-md font-bold text-gray-900 dark:text-white border-l-4 border-gray-900 pl-3">상품 재고 현황</h4>
            <span class="text-xs text-blue-500 font-medium">상세보기 ></span>
        </div>
        <div class="h-[300px]">
            <canvas id="productChart"></canvas>
        </div>
    </section>
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
document.addEventListener("DOMContentLoaded", async function() {
    const isDark = document.documentElement.classList.contains('dark');
    Chart.defaults.color = isDark ? '#9CA3AF' : '#4B5563';
    Chart.defaults.borderColor = isDark ? '#374151' : '#E5E7EB';

    try {
        const [orderRes, deliveryRes, userRes, productRes] = await Promise.all([
            fetch('/admin/stats/data'),
            fetch('/admin/stats/delivery-full-data'),
            fetch('/admin/stats/user-full-data'),
            fetch('/admin/stats/product-full-data')
        ]);

        const orderData = await orderRes.json();
        const deliveryData = await deliveryRes.json();
        const userData = await userRes.json();
        const productData = await productRes.json();

        // [수정] 최근 7일치 데이터만 추출
        const orderStats = orderData.orderStats || [];
        const recent7Days = orderStats.slice(-7);

        // KPI 업데이트
        if(orderStats.length > 0) {
            document.getElementById('kpi-order').innerText = orderStats[orderStats.length-1].totalOrderCount + "건";
        }
        document.getElementById('kpi-delivery').innerText = (deliveryData.kpi?.avg_delivery_time || 0) + "일";
        document.getElementById('kpi-product').innerText = (productData.kpi?.low_stock || 0) + "건";
        
        const userTrend = userData.trend;
        document.getElementById('kpi-user').innerText = (userTrend && userTrend.length > 0) ? userTrend[userTrend.length-1].statsValue + "명" : "0명";

        // 차트 렌더링 함수 호출
        renderCharts(recent7Days, deliveryData, userData, productData, isDark);
        
    } catch (e) { console.error("데이터 로딩 실패:", e); }
});

// 매개변수 이름을 o로 통일하여 에러 수정
function renderCharts(o, d, u, p, isDark) {
    const commonOptions = {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { labels: { font: { family: 'Pretendard' } } } }
    };

    // 1. 주문 현황 (Line) - 전달받은 o(최근 7일 데이터) 사용
    new Chart(document.getElementById('orderChart'), {
        type: 'line',
        data: {
            // [수정] statsDate 대신 executedAt을 사용하거나 statsDate를 파싱하여 포맷팅
            labels: o.map(x => {
                const date = new Date(x.executedAt || x.statsDate);
                const month = date.getMonth() + 1;
                const day = date.getDate();
                const hours = String(date.getHours()).padStart(2, '0');
                const minutes = String(date.getMinutes()).padStart(2, '0');
                return `\${month}/\${day} \${hours}:\${minutes}`;
            }),
            datasets: [{ 
                label: '주문수(건)', 
                data: o.map(x => x.totalOrderCount), 
                borderColor: '#111827', 
                backgroundColor: 'rgba(17, 24, 39, 0.1)',
                fill: true,
                tension: 0.4,
                pointRadius: 4,
                pointBackgroundColor: '#111827'
            }]
        },
        options: {
            ...commonOptions,
            scales: {
                y: { 
                    beginAtZero: true, 
                    ticks: { 
                        stepSize: 1,
                        callback: v => v.toLocaleString() + '건' 
                    } 
                },
                x: {
                    ticks: {
                        maxRotation: 0, // 라벨 꺾임 방지
                        font: { size: 11 }
                    }
                }
            }
        }
    });

    // 2. 배송 단계 (Doughnut)
    new Chart(document.getElementById('deliveryChart'), {
        type: 'doughnut',
        data: {
            labels: ['상품준비중', '국제운송중', '보세창고입고', '통관진행중', '통관완료', '국내배송중', '배송완료'],
            datasets: [{
                data: [d.status.dv001, d.status.dv002, d.status.dv003, d.status.dv004, d.status.dv005, d.status.dv006, d.status.dv007],
                backgroundColor: ['#F3F4F6', '#E2E8F0', '#CBD5E1', '#94A3B8', '#64748B', '#475569', '#111827'],
                borderWidth: 0,      
                hoverBorderWidth: 0, 
                spacing: 0           
            }]
        },
        options: {
            ...commonOptions,
            plugins: {
                ...commonOptions.plugins,
                legend: {
                    position: 'bottom', // 범례를 아래로 배치
                    labels: {
                        font: { family: 'Pretendard', size: 11 },
                        padding: 20
                    }
                }
            },
        }
    });

    // 3. 지역별 사용자 (Bar)
    new Chart(document.getElementById('userChart'), {
        type: 'bar',
        data: {
            labels: u.region.map(r => r.name),
            datasets: [{ 
                label: '유저수', 
                data: u.region.map(r => r.value), 
                backgroundColor: '#374151',
                borderRadius: 6
            }]
        },
        options: commonOptions
    });

    // 4. 상품 재고 (Horizontal Bar)
    new Chart(document.getElementById('productChart'), {
        type: 'bar',
        data: {
            labels: p.topProducts.map(x => x.name),
            datasets: [{ 
                label: '재고량', 
                data: p.topProducts.map(x => x.value), 
                backgroundColor: [
                    '#111827', 
                    '#374151', 
                    '#4B5563', 
                    '#6B7280', 
                    '#9CA3AF'  
                ],
                borderRadius: 6
            }]
        },
        options: { 
            responsive: true,
            maintainAspectRatio: false,
            indexAxis: 'y',
            plugins: { 
                legend: { 
                    position: 'bottom',
                    labels: { font: { family: 'Pretendard', size: 11 }, padding: 15 } 
                } 
            },
            scales: {
                x: { 
                    beginAtZero: true,
                    grid: { display: true }, // 눈금 유지
                    ticks: { font: { size: 11 } }
                },
                y: { 
                    grid: { display: true }, // 눈금 유지
                    ticks: { font: { size: 11 } }
                }
            }
        }
    });
}
</script>