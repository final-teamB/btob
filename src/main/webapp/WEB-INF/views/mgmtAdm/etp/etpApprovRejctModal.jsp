<%@ page contentType="text/html; charset=UTF-8" %>
<div id="approvModal" tabindex="-1" aria-hidden="true" class="fixed top-0 left-0 right-0 z-50 hidden w-full p-4 overflow-x-hidden overflow-y-auto h-[calc(100%-1rem)] max-h-full">
    <div class="relative w-full max-w-md max-h-full">
        <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
            <div class="flex items-center justify-between p-4 border-b rounded-t">
                <h3 class="text-xl font-semibold text-gray-900 dark:text-white">결제/구매 의사결정</h3>
                <button type="button" onclick="closeModal()" class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ml-auto inline-flex justify-center items-center">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <div class="p-6 space-y-4">
                <input type="hidden" id="modalOrderId">
                <input type="hidden" id="modalSystemId">
                <input type="hidden" id="modalUserId">
                <input type="hidden" id="modalUserType">
                
                <div>
                    <label class="block mb-1 text-sm font-medium text-gray-500">요청자</label>
                    <p id="modalRequestUser" class="text-base font-semibold text-gray-900"></p>
                </div>
                <div>
                    <label class="block mb-1 text-sm font-medium text-gray-500">대상 건(계약명)</label>
                    <p id="modalCtrtNm" class="text-sm text-gray-700"></p>
                </div>

                <div class="flex gap-4 py-2">
                    <label class="inline-flex items-center">
                        <input type="radio" name="apprStatus" value="APPROVED" checked onchange="toggleRejtRsn(false)" class="w-4 h-4 text-blue-600 focus:ring-blue-500">
                        <span class="ml-2 text-sm font-medium text-gray-900">승인</span>
                    </label>
                    <label class="inline-flex items-center">
                        <input type="radio" name="apprStatus" value="REJECTED" onchange="toggleRejtRsn(true)" class="w-4 h-4 text-red-600 focus:ring-red-500">
                        <span class="ml-2 text-sm font-medium text-gray-900 text-red-600">반려</span>
                    </label>
                </div>

                <div id="rejtRsnArea" style="display:none;">
                    <label for="rejtRsn" class="block mb-2 text-sm font-medium text-gray-900">반려 사유 <span class="text-red-500">*</span></label>
                    <textarea id="rejtRsn" rows="3" class="block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500" placeholder="반려 사유를 입력하세요."></textarea>
                </div>
            </div>

            <div class="flex items-center p-6 space-x-2 border-t border-gray-200 rounded-b">
                <button type="button" onclick="submitApproval()" class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center">처리 확정</button>
                <button type="button" onclick="closeModal()" class="text-gray-500 bg-white hover:bg-gray-100 focus:ring-4 focus:outline-none focus:ring-blue-300 rounded-lg border border-gray-200 text-sm font-medium px-5 py-2.5 hover:text-gray-900">취소</button>
            </div>
        </div>
    </div>
</div>

<script>
	function submitApproval() {
    // 1. 값 수집 (jQuery 셀렉터 사용)
    var orderId = $('#modalOrderId').val();
    var estId = $('#modalEstId').val();
    var systemId = $('#modalSystemId').val();
    var userId = $('#modalUserId').val();
    var userType = $('#modalUserType').val();
    var approvalStatus = $('input[name="apprStatus"]:checked').val();
    var rejtRsn = $('#rejtRsn').val();

    // 2. 유효성 검사
    if (approvalStatus === 'REJECTED' && (!rejtRsn || !rejtRsn.trim())) {
        alert('반려 사유를 입력해 주세요.');
        return;
    }

    // 3. 데이터 구성
    var payload = {
        orderId: orderId ? parseInt(orderId) : null,
        estId: estId ? parseInt(estId) : null,
        systemId: systemId,
        userId: userId,
        userType: userType,
        approvalStatus: approvalStatus,
        rejtRsn: rejtRsn
    };

    // 4. AJAX 호출
    $.ajax({
        url: cp + '/admin/etp/api/approve-reject',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify(payload),
        dataType: 'json',
        success: function(data) {
            if (data.success) {
                alert(data.message || '처리가 완료되었습니다.');
                closeModal();
                // 조회 페이지의 데이터 갱신 함수 호출
                if (typeof window.fetchData === 'function') {
                    window.fetchData();
                }
            } else {
                alert('실패: ' + data.message);
            }
        },
        error: function(xhr, status, error) {
            console.error('AJAX Error:', status, error);
            // 서버에서 보낸 에러 메시지가 있다면 출력
            var errorMsg = (xhr.responseJSON && xhr.responseJSON.message) ? xhr.responseJSON.message : '처리 중 서버 오류가 발생했습니다.';
            alert(errorMsg);
        }
    });
}
</script>