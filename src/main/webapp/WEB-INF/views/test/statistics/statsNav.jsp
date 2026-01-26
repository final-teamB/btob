<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    .stats-nav { margin-bottom: 30px; border-bottom: 2px solid #eee; padding: 10px 0; display: flex; align-items: center; justify-content: space-between; }
    .nav-links a { margin-right: 20px; text-decoration: none; color: #666; font-weight: bold; padding: 5px 10px; }
    .nav-links a:hover { color: #4CAF50; }
    .active { color: #4CAF50 !important; border-bottom: 2px solid #4CAF50; }
    #btnRefresh { padding: 10px 15px; background: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; }
</style>

<div class="stats-nav">
    <div class="nav-links">
   	 	<a href="/admin/stats/main" id="nav">대시보드</a>
        <a href="/admin/stats/order" id="nav-order">주문현황</a>
        <a href="/admin/stats/delivery" id="nav-delivery">배송현황</a>
        <a href="/admin/stats/user" id="nav-user">사용자</a>
        <a href="/admin/stats/product" id="nav-product">상품</a>
    </div>
</div>

<script>
    const path = window.location.pathname;
    if(path.includes('nav')) document.getElementById('nav').classList.add('active');
    if(path.includes('order')) document.getElementById('nav-order').classList.add('active');
    if(path.includes('delivery')) document.getElementById('nav-delivery').classList.add('active');
    if(path.includes('user')) document.getElementById('nav-user').classList.add('active');
    if(path.includes('product')) document.getElementById('nav-product').classList.add('active');
</script>