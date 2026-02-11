<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- [1] 전체 레이아웃: FAQ 페이지와 동일한 mx-4 my-6 적용 --%>
<div class="mx-4 my-6 space-y-6">
    
    <%-- [2] 제목 영역: FAQ 페이지의 패딩 및 구조와 완벽 통일 (가운데 정렬) --%>
    <div class="px-5 py-4 pb-0 text-center">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">문의 관리 (Chatbot)</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">배송 상태 및 서비스 이용 문의를 실시간으로 도와드립니다.</p>
    </div>

    <%-- [3] 챗봇 메인 카드: shadow-sm으로 그림자 축소 및 레이아웃 중앙 배치 --%>
    <div class="max-w-4xl mx-auto bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl shadow-sm overflow-hidden flex flex-col transition-all">
        
        <%-- 채팅 로그 영역: 배경을 약간 어둡게(gray-50) 하여 말풍선 구분감 부여 --%>
        <div id="chat-window" class="h-[600px] overflow-y-auto p-6 bg-gray-50 dark:bg-gray-900 flex flex-col gap-4 scroll-smooth">
            <%-- 초기 메시지 --%>
            <div class="flex justify-start">
                <div class="flex items-start gap-3 max-w-[80%]">
                    <span class="w-8 h-8 bg-blue-600 text-white rounded-full flex items-center justify-center text-[10px] font-bold flex-shrink-0 shadow-sm">AI</span>
                    <div class="p-4 bg-white dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-2xl rounded-tl-none shadow-sm">
                        <p class="text-sm text-gray-800 dark:text-gray-200 leading-relaxed">안녕하세요! 무엇을 도와드릴까요?</p>
                    </div>
                </div>
            </div>
        </div>
        
        <%-- [4] 하단 입력 영역: FAQ 검색바 스타일과 완전 통일 --%>
        <div class="p-4 bg-white dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700">
            <div class="flex items-center gap-3">
                <input type="text" id="user-input" 
                       class="flex-1 bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-white text-sm rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none p-3 transition-all" 
                       placeholder="메시지를 입력하세요..." 
                       onkeypress="if(event.keyCode==13) sendMessage()">
                
                <button type="button" onclick="sendMessage()" 
                        class="bg-gray-900 dark:bg-blue-600 text-white font-bold rounded-lg text-xs px-6 py-3 hover:bg-black dark:hover:bg-blue-500 transition-all shadow-sm active:scale-95 flex-shrink-0">
                    전송
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    function sendMessage() {
        const input = document.getElementById('user-input');
        const message = input.value.trim();
        if (!message) return;

        appendMessage('user', message);
        input.value = '';

        fetch('/admin/chat', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ message: message })
        })
        .then(response => response.json())
        .then(data => {
            appendMessage('bot', data.answer);
        })
        .catch(error => {
            console.error('Chat Error:', error);
            appendMessage('bot', '서버 통신 중 에러가 발생했습니다.');
        });
    }

    function appendMessage(sender, text) {
        const chatWindow = document.getElementById('chat-window');
        const wrapper = document.createElement('div');
        
        if (sender === 'user') {
            // 사용자 말풍선 (Me 텍스트 삭제)
            wrapper.className = "flex justify-end mb-2";
            wrapper.innerHTML = `
                <div class="max-w-[80%] p-4 bg-slate-800 dark:bg-blue-600 rounded-2xl rounded-tr-none shadow-sm border border-slate-700 dark:border-blue-500">
                    <p class="text-sm font-medium text-white leading-relaxed break-words">\${text}</p>
                </div>
            `;
        } else {
            // 봇 말풍선 (Support Bot 텍스트 삭제)
            wrapper.className = "flex justify-start mb-2";
            wrapper.innerHTML = `
                <div class="flex items-start gap-3 max-w-[80%]">
                    <span class="w-8 h-8 bg-blue-600 text-white rounded-full flex items-center justify-center text-[10px] font-bold flex-shrink-0 shadow-sm">AI</span>
                    <div class="p-4 bg-white dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-2xl rounded-tl-none shadow-sm text-gray-800 dark:text-gray-200">
                        <p class="text-sm leading-relaxed break-words">\${text}</p>
                    </div>
                </div>
            `;
        }
        
        chatWindow.appendChild(wrapper);
        chatWindow.scrollTo({ top: chatWindow.scrollHeight, behavior: 'smooth' });
    }
</script>

<style>
    /* 스크롤바 디자인 */
    #chat-window::-webkit-scrollbar { width: 5px; }
    #chat-window::-webkit-scrollbar-thumb { background: #d1d5db; border-radius: 10px; }
    .dark #chat-window::-webkit-scrollbar-thumb { background: #4b5563; }
</style>