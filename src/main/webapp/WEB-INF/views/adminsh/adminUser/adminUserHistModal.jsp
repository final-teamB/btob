<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id="userHistModal" class="hidden fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50" style="display:none !important;">
    <div class="bg-white rounded-xl shadow-2xl w-full max-w-5xl max-h-[85vh] overflow-hidden flex flex-col">
        <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-blue-50">
            <div>
                <h3 class="text-xl font-bold text-blue-900">사용자 상태 변경 이력</h3>
                <p class="text-xs text-blue-600 mt-1">해당 사용자의 계정 상태 및 승인/반려 기록을 확인합니다.</p>
            </div>
            <button type="button" onclick="closeUserHistModal()" class="text-gray-400 hover:text-gray-600 transition-colors p-2">
                <i class="fas fa-times text-xl"></i>
            </button>
        </div>

        <div class="p-6 overflow-y-auto flex-1 bg-gray-50/30">
            <div id="user-hist-grid-container" class="bg-white rounded-lg shadow-sm border border-gray-200 min-h-[400px]">
            </div>
        </div>

        <div class="px-6 py-4 border-t border-gray-100 flex justify-end bg-gray-50">
            <button type="button" onclick="closeUserHistModal()" class="px-6 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 font-semibold transition-colors border border-gray-300">닫기</button>
        </div>
    </div>
</div>

<script>
const cp = '${pageContext.request.contextPath}';

let userHistGrid = null;

//모달 닫기 함수
function closeUserHistModal() {
 const modalEl = document.getElementById('userHistModal');
 modalEl.style.display = 'none'; // 즉시 숨김
 modalEl.classList.add('hidden');
 document.body.style.overflow = '';
}

//이력 조회 메인 함수
window.viewUserHistory = function(userId) {
    if (!userId) return;

    const modalEl = document.getElementById('userHistModal');
    modalEl.style.cssText = 'display:flex !important;';

    const url = cp + '/admin/user/api/history/' + userId;

    fetch(url)
        .then(res => res.json())
        .then(data => {
            // status 체크 제거하고 list만 확인
            const list = (data && data.list) ? data.list : [];
            renderUserHistGrid(list);
            setTimeout(() => {
                if (userHistGrid) userHistGrid.refreshLayout();
            }, 50);
        })
        .catch(err => {
            console.error("이력 조회 실패:", err);
        });
};

function renderUserHistGrid(data) {
    const container = document.getElementById('user-hist-grid-container');
    if (!container) return;
    container.innerHTML = '';

    userHistGrid = new tui.Grid({
        el: container,
        data: data,
        scrollX: false,
        scrollY: true,
        bodyHeight: 400,
        columns: [
            {
                header: '상태명', name: 'statusNm', width: 120, align: 'center',
                renderer: {
                    type: class {
                        constructor(props) {
                            this.el = document.createElement('span');
                            this.render(props);
                        }
                        getElement() { return this.el; }
                        render(props) {
                            // props.row → props.grid.getRow(props.rowKey) 로 수정
                            const row = props.grid.getRow(props.rowKey);
                            const status = String(row ? row.currStatusCd : '').toUpperCase();
                            let cls = 'stts-default';
                            if (['ACTIVE', 'APPROVED'].includes(status)) cls = 'stts-active';
                            else if (['STOP', 'REJECTED'].includes(status)) cls = 'stts-reject';
                            else if (['SLEEP', 'PENDING'].includes(status)) cls = 'stts-wait';

                            this.el.className = 'stts-badge ' + cls;
                            this.el.innerText = props.value || '-';
                        }
                    }
                }
            },
            { header: '변경 사유/메모', name: 'reason', align: 'left' },
            { header: '처리자', name: 'regId', width: 120, align: 'center' },
            { header: '처리일시', name: 'regDtime', width: 180, align: 'center' }
        ]
    });
}
</script>

<style>
    /* 사용자 관리 전용 배지 스타일 */
    .stts-badge { padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: bold; }
    .stts-active { background-color: #e0f2fe; color: #0369a1; } /* 파란색: 승인/활성 */
    .stts-reject { background-color: #fee2e2; color: #dc2626; } /* 빨간색: 반려/정지 */
    .stts-wait { background-color: #fef3c7; color: #92400e; }   /* 노란색: 대기/휴면 */
    .stts-default { background-color: #f3f4f6; color: #374151; }
</style>