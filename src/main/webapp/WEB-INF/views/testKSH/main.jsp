<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="p-6 space-y-6">
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div class="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-lg font-bold text-gray-900 dark:text-white">내 프로필</h3>
                <span class="px-2 py-1 text-xs font-semibold text-blue-600 bg-blue-100 rounded-full">${member.userType}</span>
            </div>
            <div class="space-y-3">
                <div class="flex items-center space-x-3">
                    <div class="w-12 h-12 bg-gray-100 dark:bg-gray-700 rounded-full flex items-center justify-center">
                        <i class="bi bi-person text-2xl text-gray-500"></i>
                    </div>
                    <div>
                        <p class="text-sm font-bold text-gray-900 dark:text-white">${member.userName} <span class="text-gray-500 text-xs font-normal">${member.position}</span></p>
                        <p class="text-xs text-gray-500">${member.email}</p>
                    </div>
                </div>
                <p class="text-sm text-gray-600 dark:text-gray-400 mt-2"><i class="bi bi-building mr-2"></i>${member.companyCd}</p>
                <div class="grid grid-cols-2 gap-2 pt-4">
                    <button class="py-2 text-sm font-bold bg-gray-50 hover:bg-gray-100 text-gray-700 rounded-lg border border-gray-200 transition" onclick="location.href='/mypage'">내 정보</button>
                    <button class="py-2 text-sm font-bold bg-red-50 hover:bg-red-100 text-red-600 rounded-lg transition" onclick="location.href='/logout'">로그아웃</button>
                </div>
            </div>
        </div>

        <div class="lg:col-span-2 bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
            <h3 class="text-lg font-bold text-gray-900 dark:text-white mb-4">자주 결제하는 물품</h3>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-center">
                <div class="p-4 bg-gray-50 dark:bg-gray-900 rounded-xl hover:shadow-md transition cursor-pointer group">
                    <i class="bi bi-fuel-pump text-3xl text-blue-500 mb-2 inline-block"></i>
                    <p class="text-sm font-medium">경유(L)</p>
                </div>
                <div class="p-4 bg-gray-50 dark:bg-gray-900 rounded-xl hover:shadow-md transition cursor-pointer group">
                    <i class="bi bi-droplet text-3xl text-orange-500 mb-2 inline-block"></i>
                    <p class="text-sm font-medium">휘발유</p>
                </div>
                <div class="p-4 bg-gray-50 dark:bg-gray-900 rounded-xl hover:shadow-md transition cursor-pointer group">
                    <i class="bi bi-box-seam text-3xl text-purple-500 mb-2 inline-block"></i>
                    <p class="text-sm font-medium">요소수</p>
                </div>
                <div class="p-4 bg-gray-50 dark:bg-gray-900 rounded-xl hover:shadow-md transition cursor-pointer group">
                    <i class="bi bi-tools text-3xl text-green-500 mb-2 inline-block"></i>
                    <p class="text-sm font-medium">차량정비</p>
                </div>
            </div>
        </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div class="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-lg font-bold text-gray-900 dark:text-white">공지사항</h3>
                <a href="/notice" class="text-xs text-blue-600 font-bold hover:underline">전체보기</a>
            </div>
            <ul class="divide-y divide-gray-100 dark:divide-gray-700">
                <c:forEach items="${noticeList}" var="notice" end="4">
                    <li class="py-3 flex justify-between items-center hover:bg-gray-50 dark:hover:bg-gray-700 px-2 rounded-lg cursor-pointer transition">
                        <span class="text-sm text-gray-700 dark:text-gray-300 truncate mr-4">${notice.title}</span>
                        <span class="text-xs text-gray-400 shrink-0">${notice.getFormattedRegDate()}</span>
                    </li>
                </c:forEach>
            </ul>
        </div>

        <div class="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-lg font-bold text-gray-900 dark:text-white">자주 묻는 질문</h3>
                <a href="/faq" class="text-xs text-blue-600 font-bold hover:underline">전체보기</a>
            </div>
            <div class="space-y-3">
                <c:forEach items="${faqList}" var="faq" end="2">
                    <div class="p-3 bg-blue-50 dark:bg-gray-900 rounded-lg border border-blue-100 dark:border-gray-700">
                        <p class="text-sm font-bold text-gray-800 dark:text-gray-200"><span class="text-blue-600 mr-2">Q.</span>${faq.question}</p>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div class="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
            <h3 class="text-lg font-bold text-gray-900 dark:text-white mb-4">
                <i class="bi bi-currency-exchange mr-2 text-blue-500"></i>실시간 환율
            </h3>
            <div id="rateBox" class="flex flex-col items-center justify-center h-28 transition-opacity duration-700 ease-in-out">
                <p id="curName" class="text-xs text-gray-500 font-bold uppercase mb-1">연동 중...</p>
                <p id="curRate" class="text-3xl font-black text-blue-600">---</p>
            </div>
        </div>

        <div class="lg:col-span-2 bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
            <h3 class="text-lg font-bold text-gray-900 dark:text-white mb-4">
                <i class="bi bi-newspaper mr-2 text-orange-500"></i>유류 시장 뉴스
            </h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4" id="newsList">
                <p class="text-center py-4 text-gray-400 col-span-2">뉴스를 불러오는 중입니다...</p>
            </div>
        </div>
    </div>
</div>

<script>
    let exchangeRates = [];
    let currentIdx = 0;

    document.addEventListener('DOMContentLoaded', function() {
        initExchangeRates();
        initOilNews();
    });

    // 환율 정보 연동
    async function initExchangeRates() {
        try {
            const response = await fetch('/api/external/exchange-rate');
            exchangeRates = await response.json();
            if (exchangeRates && exchangeRates.length > 0) {
                updateRateDisplay();
                setInterval(fadeExchangeRate, 3500); 
            }
        } catch (e) { 
            document.getElementById('curName').innerText = "환율 로드 실패"; 
        }
    }

    function updateRateDisplay() {
        const data = exchangeRates[currentIdx];
        document.getElementById('curName').innerText = data.name + " (" + data.currency + ")";
        document.getElementById('curRate').innerText = data.rate;
    }

    function fadeExchangeRate() {
        const box = document.getElementById('rateBox');
        box.style.opacity = '0';
        setTimeout(() => {
            currentIdx = (currentIdx + 1) % exchangeRates.length;
            updateRateDisplay();
            box.style.opacity = '1';
        }, 700);
    }

    // 유류 뉴스 연동
    async function initOilNews() {
        const listArea = document.getElementById('newsList');
        try {
            const response = await fetch('/api/external/oil-news');
            const items = await response.json();
            
            if (!items || items.length === 0) {
                listArea.innerHTML = '<p class="col-span-2 text-center text-gray-400">관련 뉴스가 없습니다.</p>';
                return;
            }

            listArea.innerHTML = '';
            items.forEach(item => {
                const div = document.createElement('div');
                div.className = "flex items-center space-x-3 p-3 bg-gray-50 dark:bg-gray-900 rounded-lg hover:bg-gray-100 transition cursor-pointer";
                div.onclick = function() { window.open(item.link, '_blank'); };
                
                // HTML 태그 제거 및 기사 제목 정제
                const cleanTitle = item.title.replace(/<[^>]*>?/gm, '');
                
                let content = '';
                content += '<div class="shrink-0 w-10 h-10 bg-white dark:bg-gray-800 border rounded-full flex items-center justify-center text-[10px] font-bold text-blue-500">OIL</div>';
                content += '<div class="flex-1 min-w-0">';
                content += '<p class="text-sm font-bold text-gray-800 dark:text-gray-200 truncate">' + cleanTitle + '</p>';
                content += '<p class="text-[11px] text-gray-400">최신 유류 뉴스</p>';
                content += '</div>';
                
                div.innerHTML = content;
                listArea.appendChild(div);
            });
        } catch (e) {
            listArea.innerHTML = '<p class="col-span-2 text-center text-red-400">뉴스 로딩 오류</p>';
        }
    }
</script>