<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 - 사용자 통계</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>body { padding: 40px; }</style>
</head>
<body>
    <h2>통계 대시보드</h2>
    <%@ include file="statsNav.jsp" %>

    <div style="border: 1px solid #eee; padding: 20px; border-radius: 8px;">
        <h3>신규 가입자</h3>
        <canvas id="userChart" style="max-height: 400px;"></canvas>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            fetch('/admin/stats/data')
                .then(res => res.json())
                .then(data => {
                    createUserChart(data.userStats);
                });
        });

        function createUserChart(stats) {
            new Chart(document.getElementById('userChart'), {
                type: 'bar',
                data: {
                    labels: stats.map(s => s.statsName || s.typeName),
                    datasets: [{
                        label: '가입수',
                        data: stats.map(s => s.statsValue),
                        backgroundColor: '#4CAF50',
                        borderRadius: 5
                    }]
                },
                options: { plugins: { legend: { display: false } } }
            });
        }
    </script>
</body>
</html>