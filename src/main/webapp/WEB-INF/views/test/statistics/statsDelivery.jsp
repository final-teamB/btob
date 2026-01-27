<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 - 배송 통계</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>body { padding: 40px;}</style>
</head>
<body>
    <h2>통계 대시보드</h2>
    <%@ include file="statsNav.jsp" %>

    <div style="border: 1px solid #eee; padding: 20px; border-radius: 8px;">
        <h3>배송 상태 비율</h3>
        <canvas id="deliveryChart" style="max-height: 400px;"></canvas>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            fetch('${pageContext.request.contextPath}/admin/stats/data')
                .then(res => res.json())
                .then(data => {
                    createDeliveryChart(data.deliveryStats);
                });
        });

        function createDeliveryChart(stats) {
            new Chart(document.getElementById('deliveryChart'), {
                type: 'doughnut',
                data: {
                    labels: stats.map(s => s.statsName || s.typeName),
                    datasets: [{
                        data: stats.map(s => s.statsValue),
                        backgroundColor: ['#4CAF50', '#FFC107', '#FF5722', '#9C27B0', '#607D8B'],
                        borderWidth: 0
                    }]
                }
            });
        }
    </script>
</body>
</html>