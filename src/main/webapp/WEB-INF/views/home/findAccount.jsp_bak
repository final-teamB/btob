<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="space-y-8">
    <div class="text-left">
        <h2 class="text-3xl font-black text-white mb-3">정보 찾기</h2>
        <p class="text-gray-400 text-lg mb-8">본인 인증을 위해 등록된 이메일로 인증번호를 발송합니다.</p>
        
        <div class="flex gap-6 mb-8 border-b border-white/10">
            <button onclick="switchFindMode('ID')" id="tabFindId" class="pb-4 text-xl font-bold text-blue-400 border-b-4 border-blue-400 transition-all">아이디 찾기</button>
            <button onclick="switchFindMode('PW')" id="tabFindPw" class="pb-4 text-xl font-bold text-white/40 hover:text-white transition-all border-b-4 border-transparent">비밀번호 재설정</button>
        </div>
    </div>

    <div id="inputFormArea" class="space-y-5">
        <div class="relative">
            <i data-lucide="user" class="absolute left-5 top-4.5 w-6 h-6 text-gray-500"></i>
            <input type="text" id="findUserName" placeholder="성함" 
                   class="w-full bg-white/5 border border-white/10 rounded-2xl py-4.5 pl-14 pr-5 text-white text-lg focus:outline-none focus:border-blue-500 transition-all">
        </div>
        
        <div id="findUserIdArea" class="relative hidden">
            <i data-lucide="mail" class="absolute left-5 top-4.5 w-6 h-6 text-gray-500"></i>
            <input type="text" id="findUserId" placeholder="아이디 (@gmail.com)" 
                   class="w-full bg-white/5 border border-white/10 rounded-2xl py-4.5 pl-14 pr-5 text-white text-lg focus:outline-none focus:border-blue-500 transition-all">
        </div>

        <div class="flex gap-3">
            <div class="relative flex-1">
                <i data-lucide="at-sign" class="absolute left-5 top-4.5 w-6 h-6 text-gray-500"></i>
                <input type="email" id="targetEmail" placeholder="가입 시 등록한 이메일" 
                       class="w-full bg-white/5 border border-white/10 rounded-2xl py-4.5 pl-14 pr-5 text-white text-lg focus:outline-none focus:border-blue-500 transition-all">
            </div>
            <button onclick="sendVerificationCode()" id="btnSendMail" 
                    class="px-8 bg-blue-600/20 text-blue-400 font-bold rounded-2xl border border-blue-500/30 hover:bg-blue-600/30 transition-all whitespace-nowrap">
                인증번호 발송
            </button>
        </div>

        <div id="authCodeArea" class="hidden space-y-5 animate-fade-in">
            <div class="relative">
                <i data-lucide="shield-check" class="absolute left-5 top-4.5 w-6 h-6 text-gray-500"></i>
                <input type="text" id="authCode" maxlength="6" 
			           inputmode="numeric" pattern="[0-9]*"
			           oninput="this.value = this.value.replace(/[^0-9]/g, '');"
			           placeholder="인증번호 6자리" 
			           class="w-full bg-white/10 border border-blue-500/50 rounded-2xl py-4.5 pl-14 pr-24 text-white text-lg focus:outline-none shadow-[0_0_15px_rgba(59,130,246,0.2)]">
                <span id="timer" class="absolute right-5 top-4.5 text-blue-400 font-mono text-lg">03:00</span>
            </div>
            <button onclick="verifyCode()" class="w-full py-4 bg-blue-600 text-white font-bold rounded-2xl hover:bg-blue-700 transition-all shadow-lg">
                인증 확인
            </button>
        </div>
        
        <div id="newPwArea" class="hidden space-y-5 pt-6 border-t border-white/10">
            <p class="text-blue-400 text-sm font-black ml-1 uppercase tracking-wider">New Password Setup</p>
            <input type="password" id="findNewPw" placeholder="새 비밀번호 (8~20자, 특수문자 포함)" 
                   class="w-full bg-white/5 border border-white/10 rounded-2xl py-4.5 px-6 text-white text-lg focus:outline-none focus:border-blue-500">
            <input type="password" id="findNewPwConfirm" placeholder="새 비밀번호 확인" 
                   class="w-full bg-white/5 border border-white/10 rounded-2xl py-4.5 px-6 text-white text-lg focus:outline-none focus:border-blue-500">
        </div>
    </div>

    <div id="findIdResultArea" class="hidden space-y-6 p-10 bg-blue-600/10 border border-blue-500/30 rounded-3xl text-center animate-fade-in">
        <div class="inline-flex items-center justify-center w-16 h-16 bg-blue-500/20 rounded-full mb-2">
            <i data-lucide="check-circle" class="w-8 h-8 text-blue-400"></i>
        </div>
        <div>
            <p class="text-gray-400 mb-3">요청하신 정보와 일치하는 아이디입니다.</p>
            <h3 id="foundIdText" class="text-xl font-bold text-white tracking-wide leading-relaxed"></h3>
        </div>
    </div>

    <button id="btnFinalAction" onclick="handleFindComplete()" 
            class="hidden w-full py-5 bg-white text-slate-900 font-black text-xl rounded-2xl shadow-2xl hover:bg-gray-100 transition-all transform active:scale-[0.98] mt-4">
        아이디 찾기
    </button>
    
    <button onclick="switchTab('login')" class="text-lg text-gray-500 hover:text-white transition-colors block mx-auto font-medium">
        로그인 화면으로 돌아가기
    </button>
</div>

<script>
    var findMode = 'ID'; 
    var isVerified = false;
    var timerInterval;

    function switchFindMode(mode) {
        findMode = mode;
        isVerified = false;
        if(timerInterval) clearInterval(timerInterval);
        
        document.getElementById('inputFormArea').classList.remove('hidden');
        document.getElementById('findIdResultArea').classList.add('hidden');
        document.getElementById('findUserIdArea').classList.toggle('hidden', mode === 'ID');
        document.getElementById('newPwArea').classList.add('hidden');
        document.getElementById('authCodeArea').classList.add('hidden');
        
        // 탭 전환 시 최종 실행 버튼은 항상 숨김 (인증 전)
        document.getElementById('btnFinalAction').classList.add('hidden');
        
        document.getElementById('findUserName').value = "";
        document.getElementById('findUserId').value = "";
        document.getElementById('targetEmail').value = "";
        document.getElementById('authCode').value = "";
        
        const btnSend = document.getElementById('btnSendMail');
        btnSend.innerText = "인증번호 발송";
        btnSend.disabled = false;
        
     	// [추가] 3. 탭 스타일 업데이트 (글자색 및 하단 보더)
        const tabId = document.getElementById('tabFindId');
        const tabPw = document.getElementById('tabFindPw');

        if (mode === 'ID') {
            // 아이디 찾기 활성화
            tabId.className = "pb-4 text-xl font-bold text-blue-400 border-b-4 border-blue-400 transition-all";
            tabPw.className = "pb-4 text-xl font-bold text-white/40 hover:text-white transition-all border-b-4 border-transparent";
        } else {
            // 비밀번호 재설정 활성화
            tabPw.className = "pb-4 text-xl font-bold text-blue-400 border-b-4 border-blue-400 transition-all";
            tabId.className = "pb-4 text-xl font-bold text-white/40 hover:text-white transition-all border-b-4 border-transparent";
        }
        
        document.getElementById('btnFinalAction').innerText = (mode === 'ID' ? '아이디 찾기' : '비밀번호 재설정 완료');
        if(window.lucide) lucide.createIcons();
    }

    function sendVerificationCode() {
        const userName = document.getElementById('findUserName').value.trim();
        const email = document.getElementById('targetEmail').value.trim();
        const userId = document.getElementById('findUserId').value.trim();

        if(!userName) { alert("성함을 입력해주세요."); return; }
        if(!email) { alert("이메일 주소를 입력해주세요."); return; }
        if(findMode === 'PW' && !userId) { alert("아이디를 입력해주세요."); return; }

        const btnMail = document.getElementById('btnSendMail');
        btnMail.disabled = true;
        btnMail.innerText = "발송 중...";

        fetch('/account/api/send-auth-num', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ userName: userName, email: email, userId: userId, type: findMode })
        })
        .then(res => res.json())
        .then(data => {
            if(data.success) {
                alert(data.message);
                document.getElementById('authCodeArea').classList.remove('hidden');
                document.getElementById('authCode').disabled = false;
                document.getElementById('authCode').focus();
                startTimer(180); 
                btnMail.innerText = "재발송";
                btnMail.disabled = false;
            } else {
                alert(data.message);
                btnMail.disabled = false;
                btnMail.innerText = "인증번호 발송";
            }
        })
        .catch(err => {
            alert("서버 통신 중 오류가 발생했습니다.");
            btnMail.disabled = false;
        });
    }

    function verifyCode() {
        const authCode = document.getElementById('authCode').value.trim();
        if(authCode.length < 6) { alert("인증번호 6자리를 입력해주세요."); return; }

        fetch('/account/api/verify-auth-num', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ authNum: authCode, type: findMode })
        })
        .then(res => res.json())
        .then(data => {
            if(data.success) {
                isVerified = true;
                clearInterval(timerInterval);
                
                document.getElementById('authCode').disabled = true;
                document.getElementById('timer').textContent = "인증완료";
                document.getElementById('btnSendMail').innerText = "인증 완료";
                document.getElementById('btnSendMail').disabled = true;

                if(findMode === 'ID') {
                    handleFindComplete(); // 아이디 찾기는 즉시 최종 단계 실행
                } else {
                    alert("인증되었습니다. 새 비밀번호를 설정해주세요.");
                    document.getElementById('newPwArea').classList.remove('hidden');
                    // 비밀번호 재설정 모드일 때만 '재설정 완료' 버튼 노출
                    document.getElementById('btnFinalAction').classList.remove('hidden');
                }
            } else {
                alert(data.message);
                isVerified = false;
            }
        })
        .catch(err => alert("인증 처리 중 오류가 발생했습니다."));
    }

    function handleFindComplete() {
        const userName = document.getElementById('findUserName').value.trim();
        const email = document.getElementById('targetEmail').value.trim();
        const userId = document.getElementById('findUserId').value.trim();

        // 서비스의 UserInfoDTO 구조에 맞게 payload 구성
        let payload = { 
            userName: userName, 
            email: email, 
            userId: userId, 
            type: findMode 
        };
        
        if(findMode === 'PW') {
            const newPw = document.getElementById('findNewPw').value;
            const newPwConfirm = document.getElementById('findNewPwConfirm').value;
            if(!newPw || newPw.length < 8) { alert("새 비밀번호를 8자 이상 입력해주세요."); return; }
            if(newPw !== newPwConfirm) { alert("비밀번호가 일치하지 않습니다."); return; }
            
            // [중요] 서비스 코드의 userInfoDTO.getNewPassword()와 매칭
            payload.newPassword = newPw; 
        }

        const apiUrl = (findMode === 'ID') ? '/account/api/find-id-complete' : '/account/api/reset-pw-complete';
        
        fetch(apiUrl, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        })
        .then(res => res.json())
        .then(data => {
            if(data.success) {
                if(findMode === 'ID') {
                    document.getElementById('inputFormArea').classList.add('hidden');
                    document.getElementById('findIdResultArea').classList.remove('hidden');
                    const formattedResult = data.result.replace('T', ' ');
                    document.getElementById('foundIdText').innerText = formattedResult;
                    if(window.lucide) lucide.createIcons();
                } else {
                    alert("비밀번호 변경이 완료되었습니다. 다시 로그인해주세요.");
                    
                	 // [수정] 강제 페이지 이동 대신, 기존 UI 내의 로그인 탭으로 전환
                    if(typeof switchTab === 'function') {
                        switchTab('login'); 
                    } else {
                        // switchTab을 못 찾을 경우를 대비한 안전장치 (메인으로 이동)
                        location.href = "/home/index";
                    }
                }
            } else {
                alert(data.message);
            }
        })
        .catch(err => alert("요청 처리 중 오류가 발생했습니다."));
    }

    function startTimer(duration) {
        if(timerInterval) clearInterval(timerInterval);
        let timer = duration;
        const display = document.getElementById('timer');
        timerInterval = setInterval(function () {
            let minutes = parseInt(timer / 60, 10);
            let seconds = parseInt(timer % 60, 10);
            display.textContent = (minutes < 10 ? "0" + minutes : minutes) + ":" + (seconds < 10 ? "0" + seconds : seconds);
            if (--timer < 0) {
                clearInterval(timerInterval);
                display.textContent = "만료";
                display.classList.replace('text-blue-400', 'text-red-500');
                document.getElementById('authCode').disabled = true;
                isVerified = false;
            }
        }, 1000);
    }
</script>