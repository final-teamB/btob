<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
/* ===== 1. 전체 사이드바 컨테이너 ===== */
#filterSidebar {
    position: relative;
    width: 210px;
    min-width: 210px;
    transition: width 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    z-index: 10;
}
#filterSidebar.collapsed { 
width: 72px !important; 
min-width: 72px !important;
max-width: 72px !important;
}

/* ===== 2. 스크롤 박스 (버튼과 카드를 한 몸으로 묶음) ===== */
.sidebar-sticky-wrapper {
    position: relative; 
    width: 100%;
}

/* ===== 3. 실제 필터 카드 ===== */
.filter-card {
    width: 100%;
    min-height: auto;
    max-height: calc(100vh - 120px);
    background: #ffffff;
    border-radius: 2.5rem;
    padding: 1.5rem;
    box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
    border: 1px solid #f1f5f9;
    transition: all 0.4s ease;
    /* ✅ 내용이 많아지면 카드 내부에서 스크롤이 생기도록 설정 */
    overflow-y: auto; 
    overflow-x: hidden;
}
#filterSidebar.collapsed .filter-card { padding: 1.5rem 0.5rem; border-radius: 1.5rem; }

/* ===== 4. 🔥 토글 버튼 (완벽 고정) ===== */
.toggle-handle {
    position: absolute;
    top: 2.5rem;
    right: -12px; /* 카드 우측 경계선 정중앙 */
    width: 24px;
    height: 24px;
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    z-index: 9999;
    transition: all 0.4s ease;
    color: #94a3b8;
}
#filterSidebar.collapsed .toggle-handle { transform: rotate(180deg); }

/* ===== 5. 접힘 상태 요소 제어 ===== */
#filterSidebar.collapsed .filter-text,
#filterSidebar.collapsed .filter-header-content { display: none !important; }

#filterSidebar.collapsed .filter-section {
    display: flex;
    justify-content: center;
    margin-bottom: 1.5rem;
}

/* 아이콘 스타일 */
.color-icon-box {
    width: 40px;
    height: 40px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
}
.bg-fuel { background: linear-gradient(135deg, #fff5f5 0%, #ffe3e3 100%); color: #fa5252; }
.bg-origin { background: linear-gradient(135deg, #f0f7ff 0%, #e7f5ff 100%); color: #228be6; }
.bg-status { background: linear-gradient(135deg, #f3f0ff 0%, #f3f0ff 100%); color: #7950f2; }

/* 체크박스 커스텀 */
.custom-checkbox {
    appearance: none;
    width: 1.1rem;
    height: 1.1rem;
    border: 2px solid #cbd5e1;
    border-radius: 5px;
    background-color: #fff;
    cursor: pointer;
}
.custom-checkbox:checked { background-color: #3b82f6; border-color: #3b82f6; }
</style>

<div id="filterSidebar">
    <div class="sidebar-sticky-wrapper">
        
        <div onclick="toggleFilter()" class="toggle-handle">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M15 19l-7-7 7-7" />
            </svg>
        </div>

        <div class="filter-card dark:bg-gray-800 dark:border-gray-700">
        
        <%-- 헤더 --%>
        <div class="flex justify-between items-center mb-8 filter-header-content">
            <div>
                <h4 class="text-xl font-black text-gray-900 dark:text-white tracking-tight">검색 필터</h4>
                <p class="text-[10px] text-gray-400 mt-0.5 font-bold uppercase tracking-wider">Options</p>
            </div>
            <button onclick="resetFilters()" class="text-gray-300 hover:text-blue-600 transition-colors" title="필터 초기화">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                </svg>
            </button>
        </div>

            <%-- 유류 종류 --%>
            <div class="filter-section w-full">
                <div class="flex items-center mb-4 justify-center lg:justify-start">
                    <div class="color-icon-box bg-fuel" title="유류 종류">
                        <svg viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5"><path d="M19,19V5c0-1.1-.9-2-2-2H7C5.9,3,5,3.9,5,5v14H3v2h18v-2H19z M7,5h10v2H7V5z M7,9h10v2H7V9z M7,13h10v2H7V13z M7,19v-2h10v2H7z"/></svg>
                    </div>
                    <h5 class="text-sm font-black text-gray-800 dark:text-gray-200 filter-text">유류 종류</h5>
                </div>
                <div class="space-y-1 filter-text">
                    <c:forEach var="item" items="${selectBoxes.fuelCatList}">
                        <label class="flex items-center p-2 rounded-xl hover:bg-red-50/50 group cursor-pointer transition-all">
                            <input type="checkbox" name="fuelCatList" value="${item.value}" onchange="loadUserProducts(0)" class="custom-checkbox">
                            <span class="ml-3 text-sm font-bold text-gray-400 group-hover:text-red-600">${item.text}</span>
                        </label>
                    </c:forEach>
                </div>
            </div>

            <%-- 원산지 지역 --%>
            <div class="filter-section w-full mt-4">
                <div class="flex items-center mb-4 justify-center lg:justify-start">
                    <div class="color-icon-box bg-origin" title="원산지 지역">
                        <svg viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5"><path d="M12,2C6.48,2,2,6.48,2,12s4.48,10,10,10s10-4.48,10-10S17.52,2,12,2z M11,19.93C7.05,19.44,4,16.08,4,12 c0-0.51,0.05-1.01,0.14-1.49L8.93,15v1c0,1.1,0.9,2,2,2V19.93z"/></svg>
                    </div>
                    <h5 class="text-sm font-black text-gray-800 dark:text-gray-200 filter-text">원산지 지역</h5>
                </div>
                <div class="space-y-1 max-h-40 overflow-y-auto pr-1 filter-text custom-scrollbar">
                    <c:forEach var="item" items="${selectBoxes.countryList}">
                        <label class="flex items-center p-2 rounded-xl hover:bg-blue-50/50 group cursor-pointer transition-all">
                            <input type="checkbox" name="countryList" value="${item.value}" onchange="loadUserProducts(0)" class="custom-checkbox">
                            <span class="ml-3 text-sm font-bold text-gray-400 group-hover:text-blue-700">${item.text}</span>
                        </label>
                    </c:forEach>
                </div>
            </div>

            <%-- 판매 상태 --%>
            <div class="filter-section w-full mt-4">
                <div class="flex items-center mb-4 justify-center lg:justify-start">
                    <div class="color-icon-box bg-status" title="판매 상태">
                        <svg viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5"><path d="M12,1L3,5v6c0,5.55,3.84,10.74,9,12c5.16-1.26,9-6.45,9-12V5L12,1z M10,17l-4-4l1.41-1.41L10,14.17l6.59-6.59L18,9L10,17z"/></svg>
                    </div>
                    <h5 class="text-sm font-black text-gray-800 dark:text-gray-200 filter-text">판매 상태</h5>
                </div>
                <div class="space-y-1 filter-text">
                    <c:forEach var="item" items="${selectBoxes.itemSttsList}">
                        <label class="flex items-center p-2 rounded-xl hover:bg-purple-50/50 group cursor-pointer transition-all">
                            <input type="checkbox" name="sttsList" value="${item.value}" onchange="loadUserProducts(0)" class="custom-checkbox">
                            <span class="ml-3 text-sm font-bold text-gray-400 group-hover:text-purple-600">${item.text}</span>
                        </label>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    function toggleFilter() {
        const sidebar = document.getElementById('filterSidebar');
        sidebar.classList.toggle('collapsed');
    }
</script>