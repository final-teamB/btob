<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>종합 통계 대시보드</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { padding: 40px;}
        .dashboard-grid { 
            display: grid; 
            grid-template-columns: 1fr 1fr; /* 2열 배치 */
            gap: 25px; 
            margin-top: 20px;
        }
        .chart-card { 
            background: white; 
            padding: 20px; 
            border-radius: 12px; 
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            cursor: pointer;
            transition: transform 0.2s;
        }
        .chart-card:hover { transform: translateY(-5px); }
        h4 { margin-top: 0; color: #333; border-left: 4px solid #4CAF50; padding-left: 10px; }
    </style>
</head>
<body>
    <h2>종합 통계 대시보드</h2>
    
    <%@ include file="statsNav.jsp" %>

    <div class="dashboard-grid">
        <div class="chart-card" onclick="location.href='/admin/stats/order'">
            <h4>주문 현황 (상세보기)</h4>
            <canvas id="mainOrderChart"></canvas>
        </div>
        <div class="chart-card" onclick="location.href='/admin/stats/delivery'">
            <h4>배송 상태 (상세보기)</h4>
            <canvas id="mainDeliveryChart"></canvas>
        </div>
        <div class="chart-card" onclick="location.href='/admin/stats/user'">
            <h4>사용자 통계 (상세보기)</h4>
            <canvas id="mainUserChart"></canvas>
        </div>
        <div class="chart-card" onclick="location.href='/admin/stats/product'">
            <h4>상품 통계 (상세보기)</h4>
            <canvas id="mainProductChart"></canvas>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            fetch('/admin/stats/data')
                .then(res => res.json())
                .then(data => {
                    renderChart('mainOrderChart', 'line', data.orderStats, '#36A2EB');
                    renderChart('mainDeliveryChart', 'doughnut', data.deliveryStats, ['#4CAF50', '#FFC107', '#FF5722']);
                    renderChart('mainUserChart', 'bar', data.userStats, '#4CAF50');
                    renderChart('mainProductChart', 'bar', data.productStats, '#FF9800', true);
                });
        });

        function renderChart(id, type, stats, color, isHorizontal = false) {
            new Chart(document.getElementById(id), {
                type: type,
                data: {
                    labels: stats.map(s => s.statsName || s.typeName),
                    datasets: [{
                        label: '데이터',
                        data: stats.map(s => s.statsValue),
                        backgroundColor: color,
                        borderColor: type === 'line' ? color : 'white',
                        tension: 0.3
                    }]
                },
                options: {
                    indexAxis: isHorizontal ? 'y' : 'x',
                    plugins: { legend: { display: type === 'doughnut' } },
                    scales: type === 'doughnut' ? {} : { y: { beginAtZero: true } }
                }
            });
        }
    </script>
</body>
</html>