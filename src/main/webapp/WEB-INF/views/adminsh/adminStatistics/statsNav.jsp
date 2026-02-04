<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    /* 1. 전체 가로지르는 선은 제거 */
    .stats-nav { 
        margin-bottom: 30px; 
        padding: 10px 0; 
        display: flex; 
        align-items: center; 
        justify-content: space-between; 
        border-bottom: none; /* 전체 밑줄 제거 */
    }
    
    /* 2. 개별 링크 스타일 (배치 유지) */
    .nav-links a { 
        margin-right: 20px; 
        text-decoration: none; 
        color: #9ca3af; 
        font-weight: bold; 
        padding: 5px 10px; 
        transition: 0.3s;
        border-bottom: 2px solid transparent; /* 공간 확보용 투명 선 */
    }
    
    /* 3. 호버 시 */
    .nav-links a:hover { 
        color: #111827; 
    }
    
    /* 4. Active 상태: 초록색 대신 Charcoal 색상의 '개별 밑줄' 유지 */
    .active { 
        color: #111827 !important; 
        border-bottom: 2px solid #111827 !important; /* 개별 밑줄은 Charcoal로 유지 */
    }
    
    /* 다크모드 대응 */
    .dark .nav-links a { color: #6b7280; }
    .dark .nav-links a:hover { color: #f9fafb; }
    .dark .active { 
        color: #f9fafb !important; 
        border-bottom-color: #f9fafb !important; 
    }
</style>

<div class="stats-nav">
    <div class="nav-links">
        <a href="/admin/stats/main" id="nav-main">대시보드</a>
        <a href="/admin/stats/order" id="nav-order">주문현황</a>
        <a href="/admin/stats/delivery" id="nav-delivery">배송현황</a>
        <a href="/admin/stats/user" id="nav-user">사용자</a>
        <a href="/admin/stats/product" id="nav-product">상품</a>
    </div>
</div>

<script>
    (function() {
        const path = window.location.pathname;
        if(path.includes('main')) document.getElementById('nav-main').classList.add('active');
        if(path.includes('order')) document.getElementById('nav-order').classList.add('active');
        if(path.includes('delivery')) document.getElementById('nav-delivery').classList.add('active');
        if(path.includes('user')) document.getElementById('nav-user').classList.add('active');
        if(path.includes('product')) document.getElementById('nav-product').classList.add('active');
    })();
</script>