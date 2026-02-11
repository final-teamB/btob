<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* 사이드바 스타일 보정 */
    .filter-card { transition: all 0.3s ease; min-height: 850px; }
    .filter-section { border-bottom: 1px solid #f1f5f9; padding-bottom: 2rem; margin-bottom: 2rem; }
    .filter-section:last-child { border-bottom: none; }

    /* 커스텀 체크박스 */
    .custom-checkbox {
        appearance: none; width: 1.3rem; height: 1.3rem; border: 2px solid #cbd5e1;
        border-radius: 6px; background-color: #fff; cursor: pointer; position: relative;
        transition: all 0.2s ease;
    }
    .custom-checkbox:checked { background-color: #3b82f6; border-color: #3b82f6; }
    .custom-checkbox:checked::after {
        content: ''; position: absolute; top: 2px; left: 5px; width: 5px; height: 9px;
        border: solid white; border-width: 0 2.5px 2.5px 0; transform: rotate(45deg);
    }

    /* 컬러 아이콘 박스 스타일 */
    .color-icon-box {
        display: flex; align-items: center; justify-content: center;
        width: 42px; height: 42px; border-radius: 12px; margin-right: 14px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    }
    
    /* 섹션별 아이콘 배경색 */
    .bg-fuel { background: linear-gradient(135deg, #fff5f5 0%, #ffe3e3 100%); color: #fa5252; }
    .bg-origin { background: linear-gradient(135deg, #f0f7ff 0%, #e7f5ff 100%); color: #228be6; }
    .bg-status { background: linear-gradient(135deg, #f3f0ff 0%, #f3f0ff 100%); color: #7950f2; }

    .custom-scrollbar::-webkit-scrollbar { width: 5px; }
    .custom-scrollbar::-webkit-scrollbar-thumb { background: #e2e8f0; border-radius: 10px; }
</style>

<aside class="w-full lg:w-96 flex-shrink-0">
    <div class="sticky top-8 bg-white dark:bg-gray-800 p-8 rounded-[2.5rem] border border-gray-100 dark:border-gray-700 shadow-xl filter-card">
        
        <%-- 상단 헤더 --%>
        <div class="flex justify-between items-center mb-12">
            <div>
                <h4 class="text-2xl font-black text-gray-900 dark:text-white tracking-tight">검색 필터</h4>
                <p class="text-xs text-gray-400 mt-1 font-bold uppercase tracking-wider">Advanced Options</p>
            </div>
            <button onclick="resetFilters()" class="w-10 h-10 flex items-center justify-center bg-gray-50 hover:bg-gray-100 text-gray-400 hover:text-blue-600 rounded-xl transition-all group">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 group-hover:rotate-180 transition-transform duration-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                </svg>
            </button>
        </div>

        <div class="flex flex-col">
            <div class="filter-section">
                <div class="flex items-center mb-6">
                    <div class="color-icon-box bg-fuel">
                        <svg viewBox="0 0 24 24" class="w-6 h-6" fill="currentColor">
                            <path d="M19,19V5c0-1.1-.9-2-2-2H7C5.9,3,5,3.9,5,5v14H3v2h18v-2H19z M7,5h10v2H7V5z M7,9h10v2H7V9z M7,13h10v2H7V13z M7,19v-2h10v2H7z"/>
                            <rect x="9" y="14" opacity=".3" width="6" height="2"/>
                        </svg>
                    </div>
                    <h5 class="text-lg font-black text-gray-800 dark:text-gray-200 tracking-tight">유류 종류</h5>
                </div>
                <div class="grid grid-cols-1 gap-2">
                    <c:forEach var="item" items="${selectBoxes.fuelCatList}">
                        <label class="flex items-center p-3 rounded-2xl border border-transparent hover:bg-red-50/50 group cursor-pointer transition-all">
                            <input type="checkbox" name="fuelCatList" value="${item.value}" onchange="loadUserProducts(0)" class="custom-checkbox">
                            <span class="ml-4 text-sm font-bold text-gray-500 group-hover:text-red-600">${item.text}</span>
                        </label>
                    </c:forEach>
                </div>
            </div>

            <div class="filter-section">
                <div class="flex items-center mb-6">
                    <div class="color-icon-box bg-origin">
                        <svg viewBox="0 0 24 24" class="w-6 h-6" fill="currentColor">
                            <path d="M12,2C6.48,2,2,6.48,2,12s4.48,10,10,10s10-4.48,10-10S17.52,2,12,2z M11,19.93C7.05,19.44,4,16.08,4,12 c0-0.51,0.05-1.01,0.14-1.49L8.93,15v1c0,1.1,0.9,2,2,2V19.93z M17.9,17.39c-0.26-0.81-1-1.39-1.9-1.39h-1v-3c0-0.55-0.45-1-1-1H8v-2 h2c0.55,0,1-0.45,1-1V7h2c1.1,0,2-0.9,2-2v-0.41C17.95,6.4,20,9.15,20,12C20,13.9,19.21,15.61,17.9,17.39z"/>
                        </svg>
                    </div>
                    <h5 class="text-lg font-black text-gray-800 dark:text-gray-200 tracking-tight">원산지 지역</h5>
                </div>
                <div class="space-y-1 max-h-64 overflow-y-auto pr-2 custom-scrollbar">
                    <c:forEach var="item" items="${selectBoxes.countryList}">
                        <label class="flex items-center p-2.5 rounded-xl hover:bg-blue-50/50 group cursor-pointer transition-all">
                            <input type="checkbox" name="countryList" value="${item.value}" onchange="loadUserProducts(0)" class="custom-checkbox">
                            <span class="ml-4 text-sm font-bold text-gray-500 group-hover:text-blue-700">${item.text}</span>
                        </label>
                    </c:forEach>
                </div>
            </div>

            <div class="filter-section">
                <div class="flex items-center mb-6">
                    <div class="color-icon-box bg-status">
                        <svg viewBox="0 0 24 24" class="w-6 h-6" fill="currentColor">
                            <path d="M12,1L3,5v6c0,5.55,3.84,10.74,9,12c5.16-1.26,9-6.45,9-12V5L12,1z M10,17l-4-4l1.41-1.41L10,14.17l6.59-6.59L18,9L10,17z"/>
                        </svg>
                    </div>
                    <h5 class="text-lg font-black text-gray-800 dark:text-gray-200 tracking-tight">판매 상태</h5>
                </div>
                <div class="space-y-2">
                    <c:forEach var="item" items="${selectBoxes.itemSttsList}">
                        <label class="flex items-center p-2 rounded-xl hover:bg-purple-50/50 group cursor-pointer transition-all">
                            <input type="checkbox" name="sttsList" value="${item.value}" onchange="loadUserProducts(0)" class="custom-checkbox">
                            <span class="ml-4 text-sm font-bold text-gray-500 group-hover:text-purple-600 transition-colors">${item.text}</span>
                        </label>
                    </c:forEach>
                </div>
            </div>

        </div>
    </div>
</aside>