<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>챗봇 상담 시스템</title>
    <style>
        /* deliveryList.jsp의 기본 스타일 상속 */
        body { font-family: sans-serif; padding: 20px; }
        h2 { color: #333; margin-bottom: 20px; }
        
        .chat-container { width: 100%; max-width: 800px; border: 1px solid #ccc; }
        
        #chat-window { 
            height: 450px; 
            overflow-y: auto; 
            padding: 15px; 
            background-color: #fff;
            display: flex;
            flex-direction: column;
        }

        .message { margin-bottom: 15px; padding: 10px; border-radius: 5px; font-size: 14px; line-height: 1.4; max-width: 70%; }
        
        .user { align-self: flex-end; background-color: #4CAF50; color: white; text-align: right; }
        
        .bot { align-self: flex-start; background-color: #f4f4f4; color: #333; border: 1px solid #ddd; }

        .input-group { display: flex; border-top: 1px solid #ccc; padding: 10px; background: #f9f9f9; }
        .input-group input { flex: 1; padding: 10px; border: 1px solid #ccc; border-radius: 3px; }
        
        .btn-send { 
            margin-left: 10px;
            padding: 10px 20px; 
            background-color: #4CAF50; 
            color: white; 
            border: none; 
            border-radius: 3px; 
            cursor: pointer; 
            font-weight: bold;
        }
        .btn-send:hover { background-color: #45a049; }
    </style>
</head>
<body>
    <h2>문의 관리 (Chatbot)</h2>
    
    <div class="chat-container">
        <div id="chat-window">
            <div class="message bot">안녕하세요! 배송 상태나 기타 궁금하신 점을 말씀해 주세요.</div>
        </div>
        
        <div class="input-group">
            <input type="text" id="user-input" placeholder="메시지를 입력하세요..." onkeypress="if(event.keyCode==13) sendMessage()">
            <button class="btn-send" onclick="sendMessage()">전송</button>
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
                appendMessage('bot', '에러가 발생했습니다.');
            });
        }

        function appendMessage(sender, text) {
            const window = document.getElementById('chat-window');
            const msgDiv = document.createElement('div');
            msgDiv.className = 'message ' + sender;
            msgDiv.innerText = text;
            window.appendChild(msgDiv);
            window.scrollTop = window.scrollHeight;
        }
    </script>
</body>
</html>