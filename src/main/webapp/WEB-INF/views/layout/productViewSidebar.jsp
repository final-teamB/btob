<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* 사이드바 전체 그림자 및 부드러운 전환 */
    .filter-card {
        transition: all 0.3s ease;
        min-height: 800px; /* 세로 길이를 충분히 확보 */
    }

    .filter-section {
        border-bottom: 1px solid #f1f5f9;
        padding-bottom: 2rem;
        margin-bottom: 2rem;
    }
    .filter-section:last-child {
        border-bottom: none;
    }

    /* 체크박스 커스텀: 더 크고 선명하게 */
    .custom-checkbox {
        appearance: none;
        width: 1.4rem;
        height: 1.4rem;
        border: 2px solid #cbd5e1;
        border-radius: 0.375rem;
        background-color: #fff;
        cursor: pointer;
        position: relative;
        transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .custom-checkbox:checked {
        background-color: #2563eb;
        border-color: #2563eb;
        transform: scale(1.1);
    }
    .custom-checkbox:checked::after {
        content: '';
        position: absolute;
        top: 2px;
        left: 6px;
        width: 6px;
        height: 11px;
        border: solid white;
        border-width: 0 2.5px 2.5px 0;
        transform: rotate(45deg);
    }

    /* 아이콘 배경 스타일 */
    .icon-box {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 32px;
        height: 32px;
        background: #eff6ff;
        border-radius: 8px;
        margin-right: 12px;
        color: #2563eb;
    }

    /* 스크롤바 디자인 */
    .custom-scrollbar::-webkit-scrollbar {
        width: 6px;
    }
    .custom-scrollbar::-webkit-scrollbar-track {
        background: #f1f5f9;
    }
    .custom-scrollbar::-webkit-scrollbar-thumb {
        background: #cbd5e1;
        border-radius: 10px;
    }
</style>

<aside class="w-full lg:w-96 flex-shrink-0">
    <div class="sticky top-8 bg-white dark:bg-gray-800 p-8 rounded-3xl border border-gray-100 dark:border-gray-700 shadow-xl filter-card">
        
        <%-- 상단 헤더: 초기화 버튼 강조 --%>
        <div class="flex justify-between items-center mb-10">
            <div>
                <h4 class="text-2xl font-black text-gray-900 dark:text-white tracking-tight">
                    Search Filter
                </h4>
                <p class="text-xs text-gray-400 mt-1">상세 조건을 선택하세요</p>
            </div>
            <button onclick="resetFilters()" class="p-2 bg-gray-50 hover:bg-red-50 text-gray-400 hover:text-red-500 rounded-full transition-all">
                <i class="ri-refresh-line text-xl"></i>
            </button>
        </div>

        <div class="flex flex-col">
            <div class="filter-section">
                <div class="flex items-center mb-5">
                    <div class="icon-box"><i class="ri-gas-station-fill"></i></div>
                    <h5 class="text-lg font-bold text-gray-800 dark:text-gray-200">유류 종류</h5>
                </div>
                <div class="grid grid-cols-1 gap-3">
                    <c:forEach var="item" items="${selectBoxes.fuelCatList}">
                        <label class="filter-label flex items-center p-3 rounded-xl border border-transparent hover:border-blue-100 hover:bg-blue-50/50 group cursor-pointer transition-all">
                            <input type="checkbox" name="fuelCatList" value="${item.value}" 
                                   onchange="loadUserProducts(0)"
                                   class="custom-checkbox">
                            <span class="ml-4 text-sm font-semibold text-gray-600 group-hover:text-blue-700">
                                ${item.text}
                            </span>
                        </label>
                    </c:forEach>
                </div>
            </div>

            <div class="filter-section">
                <div class="flex items-center mb-5">
                    <div class="icon-box"><i class="ri-earth-fill"></i></div>
                    <h5 class="text-lg font-bold text-gray-800 dark:text-gray-200">원산지 지역</h5>
                </div>
                <div class="space-y-2 max-h-80 overflow-y-auto pr-3 custom-scrollbar">
                    <c:forEach var="item" items="${selectBoxes.countryList}">
                        <label class="filter-label flex items-center p-2 rounded-lg hover:bg-gray-50 group cursor-pointer transition-all">
                            <input type="checkbox" name="countryList" value="${item.value}" 
                                   onchange="loadUserProducts(0)"
                                   class="custom-checkbox">
                            <span class="ml-4 text-sm font-medium text-gray-600 group-hover:text-gray-900">
                                ${item.text}
                            </span>
                        </label>
                    </c:forEach>
                </div>
            </div>

            <div class="filter-section">
                <div class="flex items-center mb-5">
                    <div class="icon-box"><i class="ri-checkbox-circle-fill"></i></div>
                    <h5 class="text-lg font-bold text-gray-800 dark:text-gray-200">판매 상태</h5>
                </div>
                <div class="space-y-3">
                    <c:forEach var="item" items="${selectBoxes.itemSttsList}">
                        <label class="filter-label flex items-center group cursor-pointer">
                            <div class="relative flex items-center justify-center">
                                <input type="checkbox" name="sttsList" value="${item.value}" 
                                       onchange="loadUserProducts(0)"
                                       class="custom-checkbox">
                            </div>
                            <span class="ml-4 text-sm font-semibold text-gray-600 group-hover:text-blue-600 transition-colors">
                                ${item.text}
                            </span>
                        </label>
                    </c:forEach>
                </div>
            </div>
            
            <%-- 하단 안내 이미지/문구 (필요시) --%>
            <div class="mt-4 p-5 bg-gradient-to-br from-blue-600 to-indigo-700 rounded-2xl text-white">
                <p class="text-xs opacity-80 mb-1">도움이 필요하신가요?</p>
                <p class="text-sm font-bold">전문 상담가에게 문의하세요</p>
                <i class="ri-customer-service-2-line text-3xl mt-3 opacity-30 float-right"></i>
            </div>
        </div>
    </div>
</aside>