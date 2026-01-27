<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 - 주문 통계</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://uicdn.toast.com/tui-grid/latest/tui-grid.css" />
    <script src="https://uicdn.toast.com/tui-grid/latest/tui-grid.js"></script>
    <style>
        body { padding: 40px;}
        .chart-box { padding: 20px; border: 1px solid #eee; border-radius: 8px; margin-bottom: 20px; }
        .grid-box { margin-top: 30px; }
    </style>
</head>
<body>

    <h2>통계 대시보드</h2>
    
    <%@ include file="statsNav.jsp" %>
    
    <button id="btnRefresh" style="padding: 10px 15px; background: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">
        데이터 최신화
    </button>
    
    <button onclick="location.href='/admin/stats/order/excel'" 
	        style="padding: 10px 15px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; margin-left: 10px;">
	    엑셀 다운로드
	</button>

    <div class="chart-box">
        <h3>일별 주문 추이</h3>
        <canvas id="orderChart" style="max-height: 400px;"></canvas>
    </div>

    <div class="grid-box">
        <h3>상세 내역</h3>
        <div id="grid"></div>
    </div>

    <script>
	    document.getElementById('btnRefresh').addEventListener('click', function() {
	        if(!confirm("주문 데이터를 최신 상태로 집계하시겠습니까?")) return;
	
	        fetch('/admin/stats/refresh', { method: 'PUT' }) // Controller의 PutMapping과 일치
	            .then(response => response.text())
	            .then(result => {
	                if(result === "success") {
	                    alert("최신화 완료!");
	                    location.reload(); // 화면 새로고침해서 차트 확인
	                } else {
	                    alert("최신화 실패");
	                }
	            })
	            .catch(error => console.error('Error:', error));
	    });
	    
    
        let orderGrid;

        document.addEventListener('DOMContentLoaded', function() {
            fetch('${pageContext.request.contextPath}/admin/stats/data')
                .then(res => res.json())
                .then(data => {
                    const stats = data.orderStats;
                    createOrderChart(stats);
                    createOrderGrid(stats);
                });
        });

        // 차트 생성 함수
        function createOrderChart(stats) {
            new Chart(document.getElementById('orderChart'), {
                type: 'line',
                data: {
                    labels: stats.map(s => s.executedAt),
                    datasets: [{
                        label: '주문수',
                        data: stats.map(s => s.totalOrderCount), 
                        borderColor: '#36A2EB',
                        fill: true
                    }]
                },
            });
        }


        // TOAST UI Grid 생성 함수
		function createOrderGrid(stats) {
		    if(orderGrid) {
		        document.getElementById('grid').innerHTML = '';
		    }
		
		    orderGrid = new tui.Grid({
		        el: document.getElementById('grid'),
		        data: stats,
		        columns: [
		            { 
		                header: '최신화 완료 시간', 
		                name: 'executedAt', 
		                align: 'center', 
		                sortable: true, 
		                formatter: function(obj) {
		                    return obj.value ? obj.value.replace('T', ' ') : '-';
		                }
		            },
		            { 
		                header: '총 주문건수', 
		                name: 'totalOrderCount', 
		                align: 'center', 
		                sortable: true 
		            }
		        ],
		        theme: 'clean'
		    });
}
    </script>
</body>
</html>