<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="customAlert" 
     style="position: fixed !important; 
            top: 50px !important; 
            left: 50% !important; 
            transform: translate(-50%, -20px) !important; 
            z-index: 2147483647 !important; 
            opacity: 0; 
            pointer-events: none; 
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            display: flex !important; 
            visibility: hidden;">
    
    <div class="glass-card" style="padding: 1.25rem 2rem; border-radius: 2.5rem; border: 1px solid rgba(255,255,255,0.2); box-shadow: 0 25px 50px -12px rgba(0,0,0,0.5); display: flex; align-items: center; gap: 1.25rem; background-color: rgba(15, 23, 42, 0.98); backdrop-filter: blur(20px); min-width: 320px;">
        <div id="alertIconArea" style="padding: 0.75rem; border-radius: 1rem; flex-shrink: 0;">
            <i id="alertIcon" data-lucide="info" style="width: 1.75rem; height: 1.75rem;"></i>
        </div>
        <div style="flex: 1;">
            <p id="alertMessage" style="color: white; font-weight: bold; font-size: 1.125rem; margin: 0;"></p>
        </div>
    </div>
</div>

<script>
    // 페이지 로드 직후 미리 body로 옮겨두기 (첫 번째 클릭 지연 방지)
    document.addEventListener('DOMContentLoaded', function() {
        var alertEl = document.getElementById('customAlert');
        if (alertEl && alertEl.parentElement !== document.body) {
            document.body.appendChild(alertEl);
        }
    });

    window.showAlert = function(message, type) {
        var alertEl = document.getElementById('customAlert');
        var msgEl = document.getElementById('alertMessage');
        var iconArea = document.getElementById('alertIconArea');
        var icon = document.getElementById('alertIcon');

        if (!alertEl || !msgEl) return;

        // 1. 메시지 먼저 채우기
        type = type || 'info';
        msgEl.innerText = message;

        // 2. 즉시 노출 스타일 적용 (가장 먼저 실행)
        alertEl.style.visibility = "visible";
        alertEl.style.opacity = "1";
        alertEl.style.pointerEvents = "auto";
        alertEl.style.transform = "translate(-50%, 0)";

        // 3. 색상 및 아이콘 설정 (노출 후에 처리해도 됨)
        if (type === 'error') {
            iconArea.style.backgroundColor = "rgba(239, 68, 68, 0.2)";
            if(icon) icon.style.color = "#ef4444";
        } else if (type === 'success') {
            iconArea.style.backgroundColor = "rgba(34, 197, 94, 0.2)";
            if(icon) icon.style.color = "#22c55e";
        } else {
            iconArea.style.backgroundColor = "rgba(59, 130, 246, 0.2)";
            if(icon) icon.style.color = "#60a5fa";
        }

        // 아이콘 렌더링 시도 (에러가 나도 알림창은 뜨도록 try-catch)
        try {
            if (window.lucide) window.lucide.createIcons();
        } catch(e) { 
            console.warn("Lucide icons not ready yet"); 
        }

        // 4. 자동 숨김 타이머
        if (window.alertTimeout) clearTimeout(window.alertTimeout);
        window.alertTimeout = setTimeout(function() {
            alertEl.style.opacity = "0";
            alertEl.style.transform = "translate(-50%, -20px)";
            setTimeout(function() {
                alertEl.style.visibility = "hidden";
            }, 400);
        }, 3000);
    };
</script>