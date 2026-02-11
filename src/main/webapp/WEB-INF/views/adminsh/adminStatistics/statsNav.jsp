<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    /* [1] 네비게이션 컨테이너: 사용자 관리 시스템의 px-5(20px) 여백 적용 */
    .stats-nav { 
        padding: 0 1.25rem; /* px-5 */
        margin-top: 1.5rem;  /* my-6 */
        margin-bottom: 0.5rem; 
        display: flex; 
        align-items: center; 
        border-bottom: none; /* 전체 가로 선 제거 */
    }
    
    .nav-links {
        display: flex;
        gap: 0.5rem; /* space-x-2 (8px) */
    }

    /* [2] 개별 링크: px-4 py-2 text-sm font-medium 복제 */
    .nav-links a { 
        text-decoration: none; 
        display: inline-block;
        padding: 0.5rem 1rem;   /* px-4(16px) py-2(8px) */
        font-size: 0.875rem;    /* text-sm (14px) */
        font-weight: 500;       /* font-medium */
        color: #6b7280;         /* text-gray-500 */
        transition: all 0.2s;
        border-bottom: 2px solid transparent; /* 밑줄 공간 확보 */
        white-space: nowrap;
    }
    
    /* [3] 호버 시 */
    .nav-links a:hover { 
        color: #374151; /* text-gray-700 */
    }
    
    /* [4] Active 상태: 파란색(blue-600) 글자 + 밑줄 */
    .nav-links a.active { 
        color: #2563eb !important;     /* text-blue-600 */
        border-bottom: 2px solid #2563eb !important; /* border-b-2 border-blue-600 */
        font-weight: 600; /* 활성화 시 명확하게 두껍게 */
    }
    
    /* 다크모드 대응 */
    .dark .nav-links a { color: #9ca3af; }
    .dark .nav-links a.active { 
        color: #60a5fa !important; 
        border-bottom-color: #60a5fa !important; 
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
        // 기존 active 싹 지우기
        document.querySelectorAll('.nav-links a').forEach(el => el.classList.remove('active'));

        // 현재 URL 경로에 맞춰 정확하게 active 추가
        if(path.includes('/stats/main')) document.getElementById('nav-main').classList.add('active');
        else if(path.includes('/stats/order')) document.getElementById('nav-order').classList.add('active');
        else if(path.includes('/stats/delivery')) document.getElementById('nav-delivery').classList.add('active');
        else if(path.includes('/stats/user')) document.getElementById('nav-user').classList.add('active');
        else if(path.includes('/stats/product')) document.getElementById('nav-product').classList.add('active');
    })();
</script>