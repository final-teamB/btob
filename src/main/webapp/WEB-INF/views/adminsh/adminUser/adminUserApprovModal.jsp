<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id="userApprovModal" class="hidden fixed inset-0 z-[60] flex items-center justify-center bg-black bg-opacity-60 backdrop-blur-sm" style="display:none !important;">
    <div class="relative w-full max-w-2xl max-h-[90vh] overflow-hidden border border-gray-300 rounded-xl shadow-2xl bg-white flex flex-col">
        
        <div class="flex items-center justify-between p-5 border-b border-gray-300 bg-gray-100 rounded-t-xl">
            <h3 class="text-xl font-bold text-gray-900">사용자 가입 승인 처리</h3>
            <button type="button" onclick="closeUserModal()" class="text-gray-500 hover:text-gray-800 transition-colors">
                <i class="fas fa-times text-xl"></i>
            </button>
        </div>

        <div class="p-8 space-y-6">
            <input type="hidden" id="modalUserId">
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="bg-gray-50 p-4 rounded-lg border border-gray-300 shadow-sm">
                    <label class="block mb-1 text-xs font-bold text-gray-600 uppercase tracking-wider">대상자(이름)</label>
                    <p id="modalTargetNm" class="text-lg font-bold text-gray-900"></p>
                </div>
                <div class="bg-gray-50 p-4 rounded-lg border border-gray-300 shadow-sm">
                    <label class="block mb-1 text-xs font-bold text-gray-600 uppercase tracking-wider">소속 회사</label>
                    <p id="modalTargetCompany" class="text-base text-gray-800 font-semibold"></p>
                </div>
            </div>

            <div class="py-2">
                <label class="block mb-3 text-sm font-bold text-gray-800">승인 여부 선택 <span class="text-red-600">*</span></label>
                <div class="flex gap-6">
                    <label class="flex-1 inline-flex items-center justify-center p-4 bg-white border-2 border-gray-300 rounded-xl cursor-pointer hover:bg-blue-50 hover:border-blue-500 transition-all group">
                        <input type="radio" name="userApprStatus" value="APPROVED" checked onchange="toggleUserRejtRsn(false)" class="w-5 h-5 text-blue-600 focus:ring-blue-500 border-gray-400">
                        <span class="ml-3 text-base font-bold text-gray-900">가입 승인</span>
                    </label>
                    <label class="flex-1 inline-flex items-center justify-center p-4 bg-white border-2 border-gray-300 rounded-xl cursor-pointer hover:bg-red-50 hover:border-red-500 transition-all group">
                        <input type="radio" name="userApprStatus" value="REJECTED" onchange="toggleUserRejtRsn(true)" class="w-5 h-5 text-red-600 focus:ring-red-500 border-gray-400">
                        <span class="ml-3 text-base font-bold text-red-600">가입 반려</span>
                    </label>
                </div>
            </div>

            <div id="userRejtRsnArea" class="hidden animate-fade-in-down">
                <label for="userRejtRsn" class="block mb-2 text-sm font-bold text-gray-900">반려 사유 입력 <span class="text-red-600 font-normal">(필수)</span></label>
                <textarea id="userRejtRsn" rows="4" class="block p-4 w-full text-sm text-gray-900 bg-gray-50 rounded-xl border-2 border-gray-300 focus:ring-2 focus:ring-red-500 focus:border-red-500 transition-all placeholder-gray-400" placeholder="사용자에게 전달할 구체적인 반려 사유를 입력해 주세요."></textarea>
            </div>
        </div>

        <div class="flex items-center justify-end p-6 space-x-4 border-t border-gray-300 bg-gray-100 rounded-b-xl">
            <button type="button" onclick="closeUserModal()" class="px-6 py-2.5 text-sm font-bold text-gray-700 bg-white border border-gray-400 rounded-lg hover:bg-gray-200 transition-colors">취소</button>
            <button type="button" onclick="submitUserApproval()" class="px-8 py-2.5 text-sm font-black text-white bg-blue-700 rounded-lg hover:bg-blue-800 shadow-md transition-all">처리 확정</button>
        </div>
    </div>
</div>

<style>
    @keyframes fade-in-down {
        from { opacity: 0; transform: translateY(-10px); }
        to { opacity: 1; transform: translateY(0); }
    }
    .animate-fade-in-down { animation: fade-in-down 0.3s ease-out; }
    
    /* 선택된 카드 강조 스타일 */
    label:has(input[name="userApprStatus"]:checked) {
        border-color: #3b82f6; /* 기본 파란색 */
        background-color: #eff6ff;
    }
    label:has(input[value="REJECTED"]:checked) {
        border-color: #ef4444; /* 반려 시 빨간색 */
        background-color: #fef2f2;
    }
</style>

<script>
/* 반려 사유 영역 토글 */
function toggleUserRejtRsn(show) {
    const area = document.getElementById('userRejtRsnArea');
    const input = document.getElementById('userRejtRsn');
    if (show) {
        area.classList.remove('hidden');
        input.focus();
    } else {
        area.classList.add('hidden');
        input.value = '';
    }
}

/* 모달 열기 */
function openUserModal(row) {
    document.getElementById('modalUserId').value = row.userId;
    document.getElementById('modalTargetNm').textContent = row.userName;
    document.getElementById('modalTargetCompany').textContent = row.companyName;

    // 초기화
    document.querySelector('input[name="userApprStatus"][value="APPROVED"]').checked = true;
    toggleUserRejtRsn(false);

    const modal = document.getElementById('userApprovModal');
    modal.style.cssText = 'display:flex !important;';
    document.body.classList.add('overflow-hidden');
}

/* 모달 닫기 */
function closeUserModal() {
    const modal = document.getElementById('userApprovModal');
    modal.style.cssText = 'display:none !important;';
    document.body.classList.remove('overflow-hidden');
}

/* 승인/반려 제출 */
function submitUserApproval() {
    const userId = document.getElementById('modalUserId').value;
    const status = document.querySelector('input[name="userApprStatus"]:checked').value;
    const rejtRsn = document.getElementById('userRejtRsn').value.trim();

    if (status === 'REJECTED' && !rejtRsn) {
        alert('상세한 반려 사유를 입력해 주세요.');
        document.getElementById('userRejtRsn').focus();
        return;
    }

    const confirmMsg = status === 'APPROVED' ? '해당 사용자를 승인 처리하시겠습니까?' : '해당 사용자를 반려 처리하시겠습니까?';
    if (!confirm(confirmMsg)) return;

    const url = status === 'APPROVED' ? cp + '/admin/user/approveCompany' : cp + '/admin/user/rejectCompany';
    const body = new URLSearchParams();
    body.append('userId', userId);
    if (status === 'REJECTED') body.append('rejectReason', rejtRsn);

    fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: body
    })
    .then(res => res.text())
    .then(res => {
        if (res === 'OK') {
            alert(status === 'APPROVED' ? '정상적으로 승인되었습니다.' : '반려 처리가 완료되었습니다.');
            closeUserModal();
            location.reload();
        } else {
            alert('처리 중 오류가 발생했습니다.');
        }
    })
    .catch(err => {
        console.error(err);
        alert('서버와 통신 중 오류가 발생했습니다.');
    });
}
</script>