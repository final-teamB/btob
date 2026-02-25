<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<div class="p-6 md:p-10 bg-[#f8fafc] dark:bg-gray-950 min-h-screen space-y-8">
    
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">
        
        <div class="lg:col-span-4 bg-white dark:bg-gray-800 rounded-[2rem] p-8 shadow-sm border border-slate-200 dark:border-gray-700 flex flex-col justify-between">
            <div>
                <div class="flex items-center justify-between mb-8">
                    <span class="px-4 py-1.5 text-[11px] font-black uppercase tracking-[0.1em] text-blue-700 bg-blue-50 dark:bg-blue-900/40 rounded-lg border border-blue-100 dark:border-blue-800">
                        ${member.userType} PARTNER
                    </span>
                    <i class="bi bi-shield-check text-blue-500 text-xl"></i>
                </div>
                
                <div class="space-y-4 mb-8 text-center lg:text-left">
                    <h4 class="text-3xl font-[900] text-slate-900 dark:text-white tracking-tight">
                        ${member.userName} <span class="text-lg font-bold text-slate-400 ml-1">${member.position}</span>
                    </h4>
                    <p class="text-slate-500 dark:text-gray-400 font-semibold flex items-center justify-center lg:justify-start">
                        <i class="bi bi-envelope-at mr-2"></i> ${member.userId}
                    </p>
                </div>

                <div class="bg-slate-50 dark:bg-gray-900/80 p-5 rounded-2xl border border-slate-100 dark:border-gray-700">
                    <div class="flex items-center text-slate-700 dark:text-gray-200">
                        <div class="w-10 h-10 bg-white dark:bg-gray-800 rounded-xl flex items-center justify-center shadow-sm mr-4">
                            <i class="bi bi-building text-blue-600"></i>
                        </div>
                        <span class="font-black text-base">${member.companyName}</span>
                    </div>
                </div>
            </div>

            <div class="grid grid-cols-2 gap-4 mt-10">
                <button onclick="location.href='/logout'" class="py-4 text-sm font-black text-slate-500 hover:text-red-600 bg-slate-100 hover:bg-red-50 dark:bg-gray-700 dark:hover:bg-red-900/30 rounded-2xl transition-all">
                    로그아웃
                </button>
                <button onclick="location.href='/account/mypage'" class="py-4 text-sm font-black text-white bg-slate-900 dark:bg-blue-600 hover:bg-slate-800 dark:hover:bg-blue-700 rounded-2xl shadow-lg shadow-slate-200 dark:shadow-none transition-all">
                    정보수정
                </button>
            </div>
        </div>

        <div class="lg:col-span-3 bg-white dark:bg-gray-800 rounded-[2rem] p-8 border-2 border-blue-600 dark:border-blue-500 shadow-xl shadow-blue-50 dark:shadow-none relative overflow-hidden">
            <div class="relative z-10 h-full flex flex-col justify-between">
                <div>
                    <div class="w-12 h-12 bg-blue-600 rounded-2xl flex items-center justify-center mb-6 shadow-lg shadow-blue-200">
                        <i class="bi bi-currency-exchange text-white text-xl"></i>
                    </div>
                    <h3 class="text-slate-400 dark:text-gray-400 text-xs font-black uppercase tracking-widest mb-1">Exchange Rate</h3>
                    <p id="curName" class="text-slate-900 dark:text-white text-lg font-black uppercase leading-none">연동 중...</p>
                </div>
                
                <div id="rateBox" class="transition-all duration-700">
                    <div class="flex items-baseline">
                        <span id="curRate" class="text-5xl font-[1000] text-blue-600 tracking-tighter">---</span>
                        <span class="text-slate-900 dark:text-white font-black ml-2">KRW</span>
                    </div>
                </div>
                
                <div class="pt-4 border-t border-slate-100 dark:border-gray-700">
                    <p class="text-[10px] text-slate-400 font-bold uppercase tracking-tighter italic">Real-time Trading Data</p>
                </div>
            </div>
        </div>

        <div class="lg:col-span-5 bg-white dark:bg-gray-800 rounded-[2rem] p-8 shadow-sm border border-slate-200 dark:border-gray-700">
            <div class="flex justify-between items-center mb-8">
                <h3 class="text-2xl font-black text-slate-900 dark:text-white tracking-tight italic">NOTICE</h3>
                <a href="/notice" class="text-xs font-black text-blue-600 hover:underline">VIEW ALL +</a>
            </div>
            <div class="space-y-3">
                <c:forEach items="${noticeList}" var="notice" end="3">
                    <div class="group flex items-center p-4 bg-slate-50 dark:bg-gray-900 hover:bg-blue-600 rounded-[1.25rem] transition-all cursor-pointer">
                        <div class="flex-1 min-w-0">
                            <p class="text-sm font-bold text-slate-800 dark:text-gray-200 group-hover:text-white truncate transition-colors">${notice.title}</p>
                            <p class="text-[10px] font-bold text-slate-400 group-hover:text-blue-200 mt-1 transition-colors uppercase">${notice.getFormattedRegDate()}</p>
                        </div>
                        <i class="bi bi-chevron-right text-slate-300 group-hover:text-white ml-4"></i>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <div class="bg-white dark:bg-gray-800 rounded-[2rem] p-8 shadow-sm border border-slate-200 dark:border-gray-700">
        <div class="flex items-center justify-between mb-6">
            <div class="flex items-center space-x-3">
                <div class="w-10 h-10 bg-green-50 dark:bg-green-900/20 rounded-xl flex items-center justify-center">
                    <i class="bi bi-graph-up-arrow text-green-600 text-xl"></i>
                </div>
                <h3 class="text-xl font-[900] text-slate-900 dark:text-white uppercase italic tracking-tight">Live Oil Market Analysis</h3>
            </div>
            <span class="flex items-center text-[10px] font-black text-green-600 bg-green-50 dark:bg-green-900/30 px-3 py-1 rounded-full animate-pulse">
                <span class="w-1.5 h-1.5 bg-green-600 rounded-full mr-2"></span> LIVE FEED
            </span>
        </div>

        <div class="tradingview-widget-container" style="height: 600px;">
            <div id="tradingview_oil_chart" style="height: 100%;"></div>
            <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
            <script type="text/javascript">
                new TradingView.MediumWidget({
                    "symbols": [
                        ["WTI 원유 (실시간)", "TVC:USOIL"],      // WTI 원유
                        ["브렌트유 (실시간)", "TVC:UKOIL"],
                        ["원/달러 환율", "FX_IDC:USDKRW"],
                        ["유로/달러", "FX_IDC:EURUSD"],
                        ["달러/엔", "FX_IDC:USDJPY"],
                        ["파운드/달러", "FX_IDC:GBPUSD"],
                        ["금 (Gold)", "TVC:GOLD"],
                        ["은 (Silver)", "TVC:SILVER"],
                        ["백금 (Platinum)", "TVC:PLATINUM"],
                        ["비트코인", "BINANCE:BTCUSDT"],
                        ["이더리움", "BINANCE:ETHUSDT"],
                    ],
                    "chartOnly": false,
                    "width": "100%",
                    "height": "100%",
                    "locale": "kr",
                    "colorTheme": "light",
                    "gridLineColor": "rgba(240, 243, 250, 0)",
                    "fontColor": "#787b86",
                    "isTransparent": true,
                    "autosize": true,
                    "showFloatingTooltip": true,
                    "scalePosition": "no",
                    "scaleMode": "Normal",
                    "fontFamily": "Trebuchet MS, sans-serif",
                    "noOverlays": false,
                    "container_id": "tradingview_oil_chart"
                });
            </script>
        </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <div class="bg-white dark:bg-gray-800 rounded-[2rem] p-8 shadow-sm border border-slate-200 dark:border-gray-700">
            <div class="flex items-center justify-between mb-8">
                <div class="flex items-center space-x-3">
                    <i class="bi bi-newspaper text-2xl text-orange-500"></i>
                    <h3 class="text-xl font-[900] text-slate-900 dark:text-white uppercase">Market News</h3>
                </div>
                <span class="w-2 h-2 bg-red-500 rounded-full animate-pulse"></span>
            </div>
            <div class="grid grid-cols-1 gap-4" id="newsList">
                <p class="text-center py-10 text-slate-400 font-bold">뉴스를 불러오는 중입니다...</p>
            </div>
        </div>

        <div class="bg-white dark:bg-gray-800 rounded-[2rem] p-8 shadow-sm border border-slate-200 dark:border-gray-700">
            <div class="flex items-center space-x-3 mb-8">
                <i class="bi bi-question-circle-fill text-2xl text-purple-600"></i>
                <h3 class="text-xl font-[900] text-slate-900 dark:text-white uppercase">Help Center</h3>
            </div>
            <div class="space-y-4">
                <c:forEach items="${faqList}" var="faq" end="2">
                    <div onclick="location.href='/faq'" class="p-5 bg-slate-50 dark:bg-gray-900 rounded-2xl border-l-4 border-purple-600 hover:bg-slate-100 dark:hover:bg-gray-850 transition-all cursor-pointer group">
                        <div class="flex items-center justify-between">
                            <p class="text-sm font-black text-slate-800 dark:text-gray-200 leading-snug group-hover:text-purple-700 transition-colors">
                                <span class="text-purple-600 mr-2 font-black italic text-lg">Q.</span> ${faq.question}
                            </p>
                            <i class="bi bi-plus-lg text-slate-300 group-hover:rotate-90 transition-transform"></i>
                        </div>
                    </div>
                </c:forEach>
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