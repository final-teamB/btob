<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        #chat-window::-webkit-scrollbar { width: 5px; }
        #chat-window::-webkit-scrollbar-thumb { background: #d1d5db; border-radius: 10px; }
        .dark #chat-window::-webkit-scrollbar-thumb { background: #4b5563; }
    </style>
</head>
<body class="bg-white dark:bg-gray-800 antialiased overflow-hidden">
    <div class="flex flex-col h-screen">
        <%-- 채팅 로그 영역 --%>
        <div id="chat-window" class="flex-1 overflow-y-auto p-4 bg-gray-50 dark:bg-gray-900 flex flex-col gap-4 scroll-smooth">
            <div class="flex justify-start">
                <div class="flex items-start gap-3 max-w-[85%]">
                    <span class="w-8 h-8 bg-blue-600 text-white rounded-full flex items-center justify-center text-[10px] font-bold flex-shrink-0 shadow-sm">AI</span>
                    <div class="p-3 bg-white dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-2xl rounded-tl-none shadow-sm">
                        <p class="text-sm text-gray-800 dark:text-gray-200 leading-relaxed">안녕하세요! 무엇을 도와드릴까요?</p>
                    </div>
                </div>
            </div>
        </div>
        
        <%-- 하단 입력 영역 --%>
        <div class="p-4 bg-white dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700">
            <div class="flex items-center gap-2">
                <input type="text" id="user-input" 
                       class="flex-1 bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-white text-sm rounded-lg focus:ring-2 focus:ring-blue-500 outline-none p-2.5 transition-all" 
                       placeholder="메시지를 입력하세요..." 
                       onkeypress="if(event.keyCode==13) sendMessage()">
                
                <button type="button" onclick="sendMessage()" 
                        class="bg-gray-900 dark:bg-blue-600 text-white font-bold rounded-lg text-xs px-4 py-2.5 hover:bg-black dark:hover:bg-blue-500 transition-all active:scale-95 flex-shrink-0">
                    전송
                </button>
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
            .then(res => res.json())
            .then(data => appendMessage('bot', data.answer))
            .catch(() => appendMessage('bot', '서버 통신 중 에러가 발생했습니다.'));
        }

        function appendMessage(sender, text) {
            const win = document.getElementById('chat-window');
            const wrapper = document.createElement('div');
            if (sender === 'user') {
                wrapper.className = "flex justify-end mb-2";
                wrapper.innerHTML = `<div class="max-w-[85%] p-3 bg-slate-800 dark:bg-blue-600 rounded-2xl rounded-tr-none shadow-sm border border-slate-700 dark:border-blue-500"><p class="text-sm font-medium text-white leading-relaxed break-words">\${text}</p></div>`;
            } else {
                wrapper.className = "flex justify-start mb-2";
                wrapper.innerHTML = `<div class="flex items-start gap-3 max-w-[85%]"><span class="w-8 h-8 bg-blue-600 text-white rounded-full flex items-center justify-center text-[10px] font-bold flex-shrink-0 shadow-sm">AI</span><div class="p-3 bg-white dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-2xl rounded-tl-none shadow-sm text-gray-800 dark:text-gray-200"><p class="text-sm leading-relaxed break-words">\${text}</p></div></div>`;
            }
            win.appendChild(wrapper);
            win.scrollTo({ top: win.scrollHeight, behavior: 'smooth' });
        }
    </script>
</body>
</html>