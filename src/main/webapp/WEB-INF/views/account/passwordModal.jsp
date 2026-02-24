<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="passwordModal" class="hidden fixed inset-0 z-50 overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
    <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" onclick="closePasswordModal()"></div>
        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

        <div class="inline-block align-bottom bg-white rounded-2xl text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-md sm:w-full">
            <div class="bg-white px-6 pt-5 pb-4 sm:p-6 sm:pb-4">
                <div class="flex items-center mb-4">
                    <div class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-indigo-100 sm:mx-0 sm:h-10 sm:w-10">
                        <i class="bi bi-shield-lock text-indigo-600"></i>
                    </div>
                    <h3 class="ml-3 text-lg leading-6 font-bold text-gray-900">비밀번호 변경</h3>
                </div>
                
                <form id="passwordForm" class="space-y-4" onsubmit="event.preventDefault(); submitPasswordChange();">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">현재 비밀번호</label>
                        <input type="password" name="previousPassword" id="previousPassword" required
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 outline-none transition">
                    </div>
                    <hr class="border-gray-100">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">새 비밀번호</label>
                        <input type="password" id="newPassword" name="newPassword" required
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 outline-none transition"
                               placeholder="8자 이상 입력">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">새 비밀번호 확인</label>
                        <input type="password" id="confirmPassword" required
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 outline-none transition">
                        <p id="pwdMatchMsg" class="mt-1 text-xs hidden"></p>
                    </div>
                    <button type="submit" class="hidden"></button>
                </form>
            </div>
            
            <div class="bg-gray-50 px-6 py-4 sm:flex sm:flex-row-reverse gap-2">
                <button type="button" onclick="submitPasswordChange()"
                        class="w-full inline-flex justify-center rounded-xl border border-transparent shadow-sm px-6 py-2 bg-indigo-600 text-base font-bold text-white hover:bg-indigo-700 sm:w-auto sm:text-sm transition">
                    변경하기
                </button>
                <button type="button" onclick="closePasswordModal()"
                        class="mt-3 w-full inline-flex justify-center rounded-xl border border-gray-300 shadow-sm px-6 py-2 bg-white text-base font-bold text-gray-700 hover:bg-gray-50 sm:mt-0 sm:w-auto sm:text-sm transition">
                    취소
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const newPwdInput = document.getElementById('newPassword');
        const confirmInput = document.getElementById('confirmPassword');

        const checkPasswordMatch = () => {
            const newPwd = newPwdInput.value;
            const confirmPwd = confirmInput.value;
            const msg = document.getElementById('pwdMatchMsg');
            
            if (!confirmPwd) {
                msg.classList.add('hidden');
                return;
            }

            msg.classList.remove('hidden');
            if (newPwd === confirmPwd) {
                msg.textContent = "비밀번호가 일치합니다.";
                msg.className = "mt-1 text-xs text-green-600";
            } else {
                msg.textContent = "비밀번호가 일치하지 않습니다.";
                msg.className = "mt-1 text-xs text-red-600";
            }
        };

        if (newPwdInput && confirmInput) {
            newPwdInput.addEventListener('input', checkPasswordMatch);
            confirmInput.addEventListener('input', checkPasswordMatch);
        }
    });

    function openPasswordModal() {
        const modal = document.getElementById('passwordModal');
        if (modal) {
            modal.classList.remove('hidden');
            document.body.style.overflow = 'hidden';
            setTimeout(() => document.getElementById('previousPassword').focus(), 100);
        }
    }

    function closePasswordModal() {
        document.getElementById('passwordModal').classList.add('hidden');
        document.body.style.overflow = 'auto';
        document.getElementById('passwordForm').reset();
        document.getElementById('pwdMatchMsg').classList.add('hidden');
    }

    function submitPasswordChange() {
        const form = document.getElementById('passwordForm');
        const formData = new FormData(form);
        const newPwd = document.getElementById('newPassword').value;
        const confirmPwd = document.getElementById('confirmPassword').value;

        if (!formData.get('previousPassword')) {
            alert("현재 비밀번호를 입력해주세요.");
            return;
        }
        if (newPwd.length < 8) {
            alert("새 비밀번호는 8자 이상이어야 합니다.");
            return;
        }
        if (newPwd !== confirmPwd) {
            alert("새 비밀번호 확인이 일치하지 않습니다.");
            return;
        }

        const data = {
            userId: "${userInfo.userId}",
            userNo: "${userInfo.userNo}",
            previousPassword: formData.get('previousPassword'),
            newPassword: newPwd
        };

        fetch('/account/api/updatePassword', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        })
        .then(res => {
            if (!res.ok) throw new Error('NETWORK_ERROR');
            return res.json();
        })
        .then(res => {
            if (res.success) {
            	// 1. 서버에서 보낸 메시지를 우선 보여줍니다.
                alert(res.message);
                
                // 2. 알림창 확인을 누른 후 로그아웃 페이지로 이동
                location.replace("/logout"); // history를 남기지 않으려면 replace가 더 깔끔합니다.
            } else {
                let userMsg = res.message;
                if (userMsg.includes("static resource") || userMsg.includes("not found")) {
                    userMsg = "서버 경로를 찾을 수 없습니다. 관리자에게 문의하세요.";
                }
                alert("변경 실패\n" + userMsg);
            }
        })
        .catch(err => {
            console.error('Error:', err);
            alert(err.message === 'NETWORK_ERROR' 
                ? "서버와 통신이 원활하지 않습니다. 잠시 후 다시 시도해주세요." 
                : "알 수 없는 오류가 발생했습니다.");
        });
    }
</script>