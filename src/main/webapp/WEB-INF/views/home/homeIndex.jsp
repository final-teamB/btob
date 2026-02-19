<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script src="https://cdn.tailwindcss.com"></script>
<script src="https://unpkg.com/lucide@latest"></script>

<style>
    @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100;300;400;500;700;900&display=swap');
    
    body {
        font-family: 'Noto Sans KR', sans-serif;
        margin: 0;
        padding: 0;
        background-color: #0f172a;
    }

    /* 히어로 섹션: 새로운 안정적인 유조선 이미지 주소 적용 */
    .hero-section {
        background-color: #0f172a;
        /* 아래 URL은 Pixabay의 안정적인 직접 이미지 링크입니다 */
        background-image: linear-gradient(rgba(15, 23, 42, 0.7), rgba(15, 23, 42, 0.8)), 
                    url('<c:url value="/resources/images/homeidximg.jpg"/>');
        background-size: cover;
        background-position: center;
        background-attachment: fixed;
        min-height: 85vh;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
    }

    .glass-card {
        background: rgba(255, 255, 255, 0.08);
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        border: 1px solid rgba(255, 255, 255, 0.15);
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    }
    
    .glass-card:hover {
        background: rgba(255, 255, 255, 0.12);
        transform: translateY(-10px);
        border-color: rgba(59, 130, 246, 0.5);
    }

    @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(30px); }
        to { opacity: 1; transform: translateY(0); }
    }
    .animate-up { animation: fadeInUp 0.8s ease-out forwards; }
</style>

<div class="flex flex-col min-h-screen">
    
    <nav class="fixed top-0 w-full z-50 bg-white/95 backdrop-blur-sm border-b border-gray-100">
        <div class="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 bg-blue-600 rounded-xl flex items-center justify-center shadow-lg shadow-blue-200">
                    <i data-lucide="layers" class="text-white w-6 h-6"></i>
                </div>
                <div>
                    <span class="text-xl font-black text-slate-900 tracking-tighter">GDJ-A TradeHuB</span>
                    <p class="text-[10px] text-blue-600 font-bold -mt-1 tracking-tight">GLOBAL OIL TRADING</p>
                </div>
            </div>
            
            <div class="flex items-center gap-8">
                <a href="#" class="text-sm font-bold text-gray-600 hover:text-blue-600 flex items-center gap-2 transition-colors">
                    <i data-lucide="megaphone" class="w-4 h-4 text-gray-400"></i> 공지사항
                </a>
                <button onclick="location.href='<c:url value="/login"/>'" class="min-w-[110px] h-11 bg-blue-600 text-white text-sm font-bold rounded-xl hover:bg-blue-700 transition-all shadow-md shadow-blue-100 flex items-center justify-center gap-2">
				    <i data-lucide="log-in" class="w-4 h-4"></i>
				    <span>로그인</span>
				</button>
            </div>
        </div>
    </nav>

    <section class="hero-section text-center px-6 pt-20">
        <div class="max-w-4xl animate-up">
            <h1 class="text-5xl md:text-7xl font-black text-white leading-tight mb-8 tracking-tight">
                글로벌 유류 무역의<br><span class="text-blue-400 italic">새로운 기준</span>
            </h1>
            <p class="text-lg md:text-xl text-gray-300 font-medium leading-relaxed mb-12 max-w-2xl mx-auto">
                안전하고 투명한 유류 거래 플랫폼으로<br>
                전 세계 에너지 시장을 실시간으로 연결합니다.
            </p>
            
            <div class="flex flex-col sm:flex-row gap-5 justify-center">
                <button onclick="location.href='<c:url value="/login"/>'" class="px-12 py-4 bg-white text-blue-700 font-black rounded-2xl hover:bg-blue-50 transition-all text-lg shadow-2xl">
				    거래 시작하기
				</button>
                <button class="px-12 py-4 bg-white/10 border border-white/30 text-white font-black rounded-2xl hover:bg-white/20 backdrop-blur-md transition-all text-lg">
                    서비스 소개
                </button>
            </div>
        </div>

        <div class="max-w-7xl w-full mx-auto grid grid-cols-1 md:grid-cols-3 gap-8 mt-24 animate-up" style="animation-delay: 0.2s;">
            <div class="glass-card p-10 rounded-[2.5rem] text-left">
                <div class="w-14 h-14 mb-8 bg-blue-500/20 rounded-2xl flex items-center justify-center border border-blue-400/30">
                    <i data-lucide="fuel" class="w-8 h-8 text-blue-400"></i>
                </div>
                <h3 class="text-2xl font-black text-white mb-4">다양한 유류 품목</h3>
                <p class="text-gray-400 text-base leading-relaxed">원유, 경유, 중유 등 산업에 필수적인 모든 유종 제품을 전문적으로 취급합니다.</p>
            </div>

            <div class="glass-card p-10 rounded-[2.5rem] text-left">
                <div class="w-14 h-14 mb-8 bg-blue-500/20 rounded-2xl flex items-center justify-center border border-blue-400/30">
                    <i data-lucide="ship" class="w-8 h-8 text-blue-400"></i>
                </div>
                <h3 class="text-2xl font-black text-white mb-4">글로벌 통합 배송</h3>
                <p class="text-gray-400 text-base leading-relaxed">전 세계 주요 거점 항구로의 최적화된 경로와 가장 안전한 배송 시스템을 보장합니다.</p>
            </div>

            <div class="glass-card p-10 rounded-[2.5rem] text-left">
                <div class="w-14 h-14 mb-8 bg-blue-500/20 rounded-2xl flex items-center justify-center border border-blue-400/30">
                    <i data-lucide="trending-up" class="w-8 h-8 text-blue-400"></i>
                </div>
                <h3 class="text-2xl font-black text-white mb-4">실시간 마켓 시세</h3>
                <p class="text-gray-400 text-base leading-relaxed">글로벌 원유가 및 환율 변동을 실시간 반영하여 최상의 거래 시점을 제시합니다.</p>
            </div>
        </div>
    </section>

    <footer class="bg-[#0f172a] text-gray-400 py-20 px-6 border-t border-slate-800">
        <div class="max-w-7xl mx-auto grid grid-cols-2 md:grid-cols-4 gap-12">
            <div>
                <h5 class="text-white font-bold text-lg mb-8">회사소개</h5>
                <ul class="space-y-4 text-sm">
                    <li><a href="#" class="hover:text-blue-400 transition-colors">TradeHub 비전</a></li>
                    <li><a href="#" class="hover:text-blue-400 transition-colors">오시는 길</a></li>
                    <li><a href="#" class="hover:text-blue-400 transition-colors">인재채용</a></li>
                </ul>
            </div>
            <div>
                <h5 class="text-white font-bold text-lg mb-8">주요 서비스</h5>
                <ul class="space-y-4 text-sm">
                    <li><a href="#" class="hover:text-blue-400 transition-colors">B2B 유류 거래</a></li>
                    <li><a href="#" class="hover:text-blue-400 transition-colors">글로벌 물류 센터</a></li>
                    <li><a href="#" class="hover:text-blue-400 transition-colors">인텔리전스 시세</a></li>
                </ul>
            </div>
            <div>
                <h5 class="text-white font-bold text-lg mb-8">고객지원</h5>
                <ul class="space-y-4 text-sm">
                    <li><a href="#" class="hover:text-blue-400 transition-colors">공지사항</a></li>
                    <li><a href="#" class="hover:text-blue-400 transition-colors">자주 묻는 질문</a></li>
                    <li><a href="#" class="hover:text-blue-400 transition-colors">1:1 파트너십 문의</a></li>
                </ul>
            </div>
            <div>
                <h5 class="text-white font-bold text-lg mb-8">고객센터</h5>
                <p class="text-3xl font-black text-white mb-3 tracking-tighter">1588-0000</p>
                <p class="text-sm leading-relaxed opacity-80 font-medium">
                    평일 09:00 - 18:00<br>
                    (토, 일, 공휴일 휴무)
                </p>
            </div>
        </div>
        <div class="max-w-7xl mx-auto mt-20 pt-8 border-t border-slate-800 text-center text-xs opacity-50 tracking-wider font-medium">
            © 2026 (주)GDJ-A TradeHuB. All rights reserved. | 서울특별시 강남구 테헤란로 123 | 사업자등록번호: 123-45-67890
        </div>
    </footer>
</div>

<script>
    lucide.createIcons();
</script>