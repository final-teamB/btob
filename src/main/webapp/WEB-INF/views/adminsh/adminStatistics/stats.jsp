<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
    <div class="px-5">
        <%@ include file="statsNav.jsp" %>
    </div>

    <%-- [2. KPI 카드 섹션 - 재고 부족만 Red 포인트 적용] --%>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 px-5">
        <%-- 오늘 주문: Charcoal --%>
        <div class="p-5 bg-white rounded-lg shadow-sm dark:bg-gray-800 border-t-4 border-gray-900 dark:border-gray-500">
            <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400">오늘 주문</h3>
            <div class="text-2xl font-bold text-gray-900 dark:text-white mt-2" id="kpi-order">-</div>
        </div>
        
        <%-- 평균 배송일: Slate --%>
        <div class="p-5 bg-white rounded-lg shadow-sm dark:bg-gray-800 border-t-4 border-gray-400 dark:border-gray-600">
            <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400">평균 배송일</h3>
            <div class="text-2xl font-bold text-gray-900 dark:text-white mt-2" id="kpi-delivery">-</div>
        </div>
        
        <%-- 재고 부족 상품: 경고 Red 적용 --%>
        <div class="p-5 bg-white rounded-lg shadow-sm dark:bg-gray-800 border-t-4 border-red-500">
            <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400">재고 부족 상품</h3>
            <div class="text-2xl font-bold text-red-600 mt-2" id="kpi-product">-</div>
        </div>
        
        <%-- 활성 유저: Slate --%>
        <div class="p-5 bg-white rounded-lg shadow-sm dark:bg-gray-800 border-t-4 border-gray-300 dark:border-gray-700">
            <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400">활성 유저</h3>
            <div class="text-2xl font-bold text-gray-900 dark:text-white mt-2" id="kpi-user">-</div>
        </div>
    </div>

    <%-- [3. 차트 그리드 섹션] --%>
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 px-5">
        <section class="p-6 bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 dark:border-gray-700">
            <h4 class="text-md font-bold text-gray-900 dark:text-white mb-4 border-l-4 border-gray-900 pl-3">주문 현황 (7일)</h4>
            <div class="h-[300px]">
                <canvas id="orderChart"></canvas>
            </div>
        </section>

        <section class="p-6 bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 dark:border-gray-700">
            <h4 class="text-md font-bold text-gray-900 dark:text-white mb-4 border-l-4 border-gray-900 pl-3">배송 단계 비율</h4>
            <div class="h-[300px] flex justify-center">
                <canvas id="deliveryChart"></canvas>
            </div>
        </section>

        <section class="p-6 bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 dark:border-gray-700">
            <h4 class="text-md font-bold text-gray-900 dark:text-white mb-4 border-l-4 border-gray-900 pl-3">지역별 사용자</h4>
            <div class="h-[300px]">
                <canvas id="userChart"></canvas>
            </div>
        </section>

        <section class="p-6 bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 dark:border-gray-700">
            <h4 class="text-md font-bold text-gray-900 dark:text-white mb-4 border-l-4 border-gray-900 pl-3">상품 재고 현황</h4>
            <div class="h-[300px]">
                <canvas id="productChart"></canvas>
            </div>
        </section>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
document.addEventListener("DOMContentLoaded", async function() {
    // 다크모드 대응을 위한 차트 기본 폰트 색상 설정
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

        // KPI 업데이트
        if(orderData.orderStats && orderData.orderStats.length > 0) {
            document.getElementById('kpi-order').innerText = orderData.orderStats[orderData.orderStats.length-1].totalOrderCount + "건";
        }
        document.getElementById('kpi-delivery').innerText = (deliveryData.kpi?.avg_delivery_time || 0) + "일";
        document.getElementById('kpi-product').innerText = (productData.kpi?.low_stock || 0) + "건";
        
        const userTrend = userData.trend;
        document.getElementById('kpi-user').innerText = (userTrend && userTrend.length > 0) ? userTrend[userTrend.length-1].statsValue + "명" : "0명";

        renderCharts(orderData, deliveryData, userData, productData, isDark);
        
    } catch (e) { console.error("데이터 로딩 실패:", e); }
});

function renderCharts(o, d, u, p, isDark) {
    const commonOptions = {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { labels: { font: { family: 'Pretendard' } } } }
    };

    // 1. 주문 현황 (Line)
    new Chart(document.getElementById('orderChart'), {
        type: 'line',
        data: {
            labels: o.orderStats.map(x => x.statsDate),
            datasets: [{ 
                label: '주문수', 
                data: o.orderStats.map(x => x.totalOrderCount), 
                borderColor: '#111827', 
                backgroundColor: 'rgba(17, 24, 39, 0.1)',
                fill: true,
                tension: 0.4 
            }]
        },
        options: commonOptions
    });

    // 2. 배송 단계 (Doughnut)
    new Chart(document.getElementById('deliveryChart'), {
        type: 'doughnut',
        data: {
            labels: ['준비', '현지', '해외', '국내', '완료'],
            datasets: [{
                data: [d.status.READY, d.status.L_SHIPPING, d.status.ABROAD, d.status.D_SHIPPING, d.status.COMPLETE],
                backgroundColor: ['#F3F4F6', '#9CA3AF', '#4B5563', '#1F2937', '#111827'],
                borderWidth: 0
            }]
        },
        options: commonOptions
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
        options: { ...commonOptions, indexAxis: 'y' },
        data: {
            labels: p.topProducts.map(p => p.name),
            datasets: [{ 
                label: '재고량', 
                data: p.topProducts.map(p => p.value), 
                backgroundColor: '#6B7280',
                borderRadius: 6
            }]
        }
    });
}
</script>