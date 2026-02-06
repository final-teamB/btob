<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="mx-4 my-6 space-y-6">
    <%-- [1] 제목 영역 --%>
    <div class="px-5 py-4 pb-0">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">자주 묻는 질문 (FAQ)</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">궁금하신 내용을 카테고리별로 확인하실 수 있습니다.</p>
    </div>

    <%-- [2] 카테고리 선택 영역 --%>
    <div class="flex flex-wrap gap-2 px-5">
        <button onclick="filterCategory('ALL', this)" class="cat-btn active-cat px-6 py-2 rounded-full border text-sm font-bold transition">전체</button>
        <button onclick="filterCategory('DELIVERY', this)" class="cat-btn px-6 py-2 rounded-full border bg-white dark:bg-gray-800 dark:border-gray-600 dark:text-gray-300 text-gray-600 text-sm font-bold transition">배송</button>
        <button onclick="filterCategory('PAYMENT', this)" class="cat-btn px-6 py-2 rounded-full border bg-white dark:bg-gray-800 dark:border-gray-600 dark:text-gray-300 text-gray-600 text-sm font-bold transition">결제</button>
        <button onclick="filterCategory('PRODUCT', this)" class="cat-btn px-6 py-2 rounded-full border bg-white dark:bg-gray-800 dark:border-gray-600 dark:text-gray-300 text-gray-600 text-sm font-bold transition">상품</button>
        <button onclick="filterCategory('ETC', this)" class="cat-btn px-6 py-2 rounded-full border bg-white dark:bg-gray-800 dark:border-gray-600 dark:text-gray-300 text-gray-600 text-sm font-bold transition">기타</button>
    </div>

    <%-- [3] 검색 영역 --%>
    <div class="p-4 bg-white rounded-lg shadow-sm border border-gray-100 dark:bg-gray-800 dark:border-gray-700 mx-5">
        <div class="flex flex-col gap-1.5">
            <label class="text-xs font-bold text-gray-600 dark:text-gray-400 ml-1">검색어</label>
            <div class="flex items-center gap-2">
                <input type="text" id="user-search-input" placeholder="검색어를 입력하세요" 
                       class="w-72 border border-gray-300 dark:border-gray-600 rounded-lg px-4 py-2 text-sm outline-none focus:ring-2 focus:ring-blue-500 bg-white dark:bg-gray-700 dark:text-white">
                <button onclick="renderUserList(1)" 
                        class="w-fit px-4 py-2 bg-gray-900 dark:bg-blue-600 text-white rounded-lg text-xs font-bold hover:bg-gray-800 dark:hover:bg-blue-500 transition">
                    조회
                </button>
            </div>
        </div>
    </div>

    <%-- [4] 리스트 영역 --%>
    <div class="mx-5 bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 dark:border-gray-700 overflow-hidden">
        <table class="w-full border-collapse table-fixed">
            <thead>
                <tr class="bg-gray-50 dark:bg-gray-700 border-b border-gray-200 dark:border-gray-600">
                    <th class="w-20 px-4 py-4 text-xs font-bold text-gray-500 dark:text-gray-400 uppercase text-center">ID</th>
                    <th class="w-32 px-4 py-4 text-xs font-bold text-gray-500 dark:text-gray-400 uppercase text-center">카테고리</th>
                    <th class="px-4 py-4 text-xs font-bold text-gray-500 dark:text-gray-400 uppercase text-left">질문</th>
                    <th class="w-44 px-4 py-4 text-xs font-bold text-gray-500 dark:text-gray-400 uppercase text-center">등록일</th>
                </tr>
            </thead>
            <tbody id="user-list-body"></tbody>
        </table>
        <div id="no-data" class="hidden py-20 text-center text-gray-400 bg-white dark:bg-gray-800">검색 결과가 없습니다.</div>
    </div>
    
    <%-- [5] 페이징 영역 --%>
    <div class="mx-5 px-5 py-6 flex flex-col md:flex-row justify-between items-center gap-4 border-t border-gray-100 dark:border-gray-700 bg-gray-50/50 dark:bg-gray-800/50">
        <div class="w-32"><select id="user-per-page" onchange="renderUserList(1)" class="w-full rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 py-1.5 px-3 text-xs text-gray-700 dark:text-gray-300 outline-none focus:ring-2 focus:ring-blue-500"><option value="10" selected>10개씩</option><option value="25">25개씩</option><option value="50">50개씩</option></select></div>
        <div id="user-pagination" class="flex justify-center items-center gap-1"></div>
        <div class="hidden md:block w-32"></div>
    </div>
</div>

<div class="fixed bottom-10 right-10 z-50">
    <button onclick="toggleChatbot()" 
            class="group flex items-center justify-center w-14 h-14 bg-gray-900 dark:bg-blue-600 text-white rounded-full shadow-lg hover:scale-110 transition-all active:scale-95">
        <svg id="chat-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-7 h-7">
            <path stroke-linecap="round" stroke-linejoin="round" d="M7.5 8.25h9m-9 3h9m-9 3h3m-6.75 4.125l-.621 3.015 3.015-.621A4.5 4.5 0 0121 15.75V4.875A2.25 2.25 0 0018.75 2.625H5.25A2.25 2.25 0 003 4.875v10.875a2.25 2.25 0 002.25 2.25h1.5a1.125 1.125 0 011.125 1.125z" />
        </svg>
        <svg id="close-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-7 h-7 hidden">
            <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
        </svg>
    </button>
</div>

<div id="chatbot-layer" class="fixed bottom-28 right-10 z-50 w-[420px] h-[600px] hidden shadow-2xl transition-all">
    <div class="w-full h-full bg-white dark:bg-gray-800 rounded-2xl border border-gray-200 dark:border-gray-700 overflow-hidden flex flex-col">
        <%-- 헤더 --%>
        <div class="p-4 bg-gray-900 dark:bg-blue-600 text-white flex justify-between items-center shadow-md">
            <div class="flex items-center gap-2">
                <span class="w-2 h-2 bg-green-400 rounded-full animate-pulse"></span>
                <span class="text-sm font-bold">AI 실시간 상담</span>
            </div>
            <button onclick="toggleChatbot()" class="hover:text-gray-300">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
            </button>
        </div>
        
        <%-- 챗봇 내부 (iframe 대신 직접 구성) --%>
        <div class="flex flex-col h-full overflow-hidden">
            <div id="chat-window" class="flex-1 overflow-y-auto p-4 bg-gray-50 dark:bg-gray-900 flex flex-col gap-4 scroll-smooth">
                <div class="flex justify-start">
                    <div class="flex items-start gap-3 max-w-[85%]">
                        <span class="w-8 h-8 bg-blue-600 text-white rounded-full flex items-center justify-center text-[10px] font-bold flex-shrink-0 shadow-sm">AI</span>
                        <div class="p-3 bg-white dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-2xl rounded-tl-none shadow-sm">
                            <p class="text-sm text-gray-800 dark:text-gray-200">안녕하세요! 무엇을 도와드릴까요?</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="p-4 bg-white dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700">
                <div class="flex items-center gap-2">
                    <input type="text" id="chatbot-input" class="flex-1 bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-sm rounded-lg p-2.5 outline-none focus:ring-2 focus:ring-blue-500" placeholder="메시지 입력..." onkeypress="if(event.keyCode==13) sendChat()">
                    <button onclick="sendChat()" class="bg-gray-900 dark:bg-blue-600 text-white text-xs font-bold px-4 py-2.5 rounded-lg">전송</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>

    // FAQ 기능 스크립트 (기존과 동일)
    const faqData = [<c:forEach var="f" items="${faqList}" varStatus="status">{faqId: "${f.faqId}",category: "${f.category}",question: `<c:out value="${f.question}" />`,answer: `<c:out value="${f.answer}" />`.replace(/`/g, '\\`'),regDtime: "${f.regDtime}"}${!status.last ? ',' : ''}</c:forEach>];
    let currentCategory = 'ALL';
    function filterCategory(cat, btn) { currentCategory = cat; document.querySelectorAll('.cat-btn').forEach(b => { b.classList.remove('active-cat', 'bg-gray-900', 'text-white', 'dark:bg-blue-600'); b.classList.add('bg-white', 'text-gray-600', 'dark:bg-gray-800'); }); btn.classList.add('active-cat', 'bg-gray-900', 'text-white', 'dark:bg-blue-600'); btn.classList.remove('bg-white', 'text-gray-600', 'dark:bg-gray-800'); renderUserList(1); }
    function renderUserList(page) { const kw = document.getElementById('user-search-input').value.toLowerCase(); const perPage = parseInt(document.getElementById('user-per-page').value); const filtered = faqData.filter(d => (currentCategory === 'ALL' || d.category === currentCategory) && (d.question.toLowerCase().includes(kw))); const totalPages = Math.ceil(filtered.length / perPage) || 1; const items = filtered.slice((page - 1) * perPage, page * perPage); const body = document.getElementById('user-list-body'); const noData = document.getElementById('no-data'); if (filtered.length === 0) { body.innerHTML = ''; noData.classList.remove('hidden'); } else { noData.classList.add('hidden'); body.innerHTML = items.map(d => `<tr class="border-b border-gray-100 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-700/50 cursor-pointer transition" onclick="toggleRow(this)"><td class="px-4 py-5 text-sm text-center text-gray-400 dark:text-gray-500">\${d.faqId}</td><td class="px-4 py-5 text-center"><span class="px-2 py-1 rounded text-[11px] font-bold \${getBadgeClass(d.category)}">\${getCatName(d.category)}</span></td><td class="px-4 py-5 text-[15px] font-medium text-gray-900 dark:text-gray-200">\${d.question}</td><td class="px-4 py-5 text-sm text-center text-gray-400 dark:text-gray-500">\${d.regDtime}</td></tr><tr class="hidden bg-gray-50 dark:bg-gray-900/50 faq-answer-row"><td colspan="4" class="px-6 md:px-20 py-8 border-b border-gray-200 dark:border-gray-700"><div class="flex gap-4"><span class="w-6 h-6 bg-gray-900 dark:bg-blue-600 text-white rounded-full flex items-center justify-center text-[10px] font-bold flex-shrink-0">A</span><div class="text-[14px] text-gray-600 dark:text-gray-400 leading-relaxed whitespace-pre-wrap">\${d.answer}</div></div></td></tr>`).join(''); } renderPaging(totalPages, page); }
    function toggleRow(tr) { const next = tr.nextElementSibling; const isHidden = next.classList.contains('hidden'); document.querySelectorAll('.faq-answer-row').forEach(row => row.classList.add('hidden')); if (isHidden) next.classList.remove('hidden'); }
    function renderPaging(total, current) { const pagin = document.getElementById('user-pagination'); let html = ''; for (let i = 1; i <= total; i++) { const active = i === current ? 'bg-gray-900 dark:bg-blue-600 text-white border-gray-900' : 'bg-white dark:bg-gray-800 text-gray-600 dark:text-gray-400 border-gray-300 dark:border-gray-600 hover:bg-gray-100 dark:hover:bg-gray-700'; html += `<button onclick="renderUserList(\${i})" class="mx-0.5 w-8 h-8 rounded border \${active} text-xs font-bold transition shadow-sm">\${i}</button>`; } pagin.innerHTML = html; }
    function getCatName(c) { return {'DELIVERY':'배송','PAYMENT':'결제','PRODUCT':'상품','ETC':'기타'}[c] || c; }
    function getBadgeClass(c) { return { 'DELIVERY':'bg-blue-50 text-blue-600 dark:bg-blue-900/30 dark:text-blue-400', 'PAYMENT':'bg-green-50 text-green-600 dark:bg-green-900/30 dark:text-green-400', 'PRODUCT':'bg-purple-50 text-purple-600 dark:bg-purple-900/30 dark:text-purple-400', 'ETC':'bg-gray-100 text-gray-600 dark:bg-gray-700 dark:text-gray-400' }[c] || ''; }
    
    // 챗봇 토글 함수
    function toggleChatbot() {
        const layer = document.getElementById('chatbot-layer');
        const chatIcon = document.getElementById('chat-icon');
        const closeIcon = document.getElementById('close-icon');
        const isHidden = layer.classList.contains('hidden');
        if (isHidden) { layer.classList.remove('hidden'); chatIcon.classList.add('hidden'); closeIcon.classList.remove('hidden'); }
        else { layer.classList.add('hidden'); chatIcon.classList.remove('hidden'); closeIcon.classList.add('hidden'); }
    }
    document.addEventListener('DOMContentLoaded', () => renderUserList(1));
    
    function sendChat() {
        const input = document.getElementById('chatbot-input');
        const message = input.value.trim();
        if (!message) return;

        appendChat('user', message);
        input.value = '';

        fetch('/admin/chat', { // 데이터만 주고받는 API 호출 
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ message: message })
        })
        .then(res => res.json())
        .then(data => appendChat('bot', data.answer))
        .catch(() => appendChat('bot', '에러가 발생했습니다.'));
    }

    function appendChat(sender, text) {
        const win = document.getElementById('chat-window');
        const msgDiv = document.createElement('div');
        msgDiv.className = sender === 'user' ? "flex justify-end mb-2" : "flex justify-start mb-2";
        
        if(sender === 'user') {
            msgDiv.innerHTML = `<div class="max-w-[85%] p-3 bg-slate-800 dark:bg-blue-600 text-white rounded-2xl rounded-tr-none text-sm">\${text}</div>`;
        } else {
            msgDiv.innerHTML = `<div class="flex items-start gap-3 max-w-[85%]"><span class="w-8 h-8 bg-blue-600 text-white rounded-full flex items-center justify-center text-[10px] font-bold flex-shrink-0">AI</span><div class="p-3 bg-white dark:bg-gray-700 border rounded-2xl rounded-tl-none text-sm text-gray-800 dark:text-gray-200">\${text}</div></div>`;
        }
        win.appendChild(msgDiv);
        win.scrollTo({ top: win.scrollHeight, behavior: 'smooth' });
    }
</script>

<style>
    .active-cat { border-color: #111827 !important; background-color: #111827 !important; color: white !important; }
    .dark .active-cat { border-color: #3b82f6 !important; background-color: #3b82f6 !important; color: white !important; }
</style>