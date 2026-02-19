<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id="histModal" class="hidden fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
    <div class="bg-white rounded-xl shadow-2xl w-full max-w-6xl max-h-[90vh] overflow-hidden flex flex-col">
        <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-gray-50">
            <div>
                <h3 class="text-xl font-bold text-gray-900">단계별 상세 이력</h3>
                <p class="text-xs text-gray-500 mt-1">해당 건의 승인/반려 및 상태 변경 이력을 확인합니다.</p>
            </div>
            <button type="button" onclick="closeHistModal()" class="text-gray-400 hover:text-gray-600 transition-colors p-2">
                <i class="fas fa-times text-xl"></i>
            </button>
        </div>

        <div class="p-6 overflow-y-auto flex-1 bg-gray-50/30">
            <div id="hist-grid-container" class="bg-white rounded-lg shadow-sm border border-gray-200 min-h-[450px]">
            </div>
        </div>

        <div class="px-6 py-4 border-t border-gray-100 flex justify-end bg-gray-50">
            <button type="button" onclick="closeHistModal()" class="px-6 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 font-semibold transition-colors border border-gray-300">닫기</button>
        </div>
    </div>
</div>

<script>
    let histGrid = null;
    let histModalObj = null;

    function closeHistModal() {
        // 1. 라이브러리 인스턴스로 닫기
        if (histModalObj) {
            histModalObj.hide();
        }
        
        // 2. 클래스로 숨기기
        const modalEl = document.getElementById('histModal');
        if (modalEl) modalEl.classList.add('hidden');

        // 3. [핵심 수정] 모든 backdrop을 지우는 대신, 현재 모달과 관련된 상태만 해제
        // 메인 페이지의 페이징이 사라지는 것을 방지하기 위해 body 스타일을 조심스럽게 복구
        if (!$('#approvModal').is(':visible')) { // 승인 모달이 떠있지 않을 때만 스크롤 복구
            document.body.classList.remove('overflow-hidden');
            document.body.style.overflow = '';
        }
        
        // 특정 라이브러리(Flowbite 등)가 생성한 배경막만 타겟팅하여 제거
        // 만약 $('.modal-backdrop')이 메인 페이징 레이아웃을 덮고 있다면 제거가 필요하지만, 
        // 너무 공격적으로 모든 요소를 remove() 하면 안 됩니다.
        $('.modal-backdrop').last().remove(); 

        // 4. 이력 그리드 컨테이너만 정밀 타격해서 비우기
        const container = document.getElementById('hist-grid-container');
        if (container) {
            container.innerHTML = ''; 
        }
        histGrid = null;

        // 5. 메인 그리드 강제 리프레시 (페이징 복구 유도)
        if (window.etpGrid && window.etpGrid.grid) {
            setTimeout(() => {
                window.etpGrid.grid.refreshLayout();
            }, 50);
        }
    }

    window.viewHistory = function(orderId) {
        if (!orderId) return;

        // 모달 객체 생성 (싱글톤 유지)
        if (!histModalObj && typeof Modal !== 'undefined') {
            histModalObj = new Modal(document.getElementById('histModal'), { 
                backdrop: 'static',
                onHide: () => {
                    // 외부 라이브러리에 의해 닫힐 때도 처리
                }
            });
        }

        histModalObj.show();

        const url = cp + '/admin/etp/api/' + orderId;
        fetch(url)
            .then(res => res.json())
            .then(data => {
                const list = (data && data.list) ? data.list : [];
                renderHistGrid(list);
            })
            .catch(err => console.error("이력 조회 실패:", err));
    };

    function renderHistGrid(data) {
        const container = document.getElementById('hist-grid-container');
        if(!container) return;
        container.innerHTML = ''; 

        histGrid = new DataGrid({
            containerId: 'hist-grid-container',
            data: data,
            perPage: 10,
            paginationId: 'hist-pagination-none', 
            perPageId: null,    
            searchId: null,     
            columns: [
                { header: '주문번호', name: 'orderNo', width: 150, align: 'center' },
                { 
                    header: '진행상태', name: 'etpSttsNm', width: 130, align: 'center',
                    renderer: {
                        type: class {
                            constructor(props) {
                                this.el = document.createElement('span');
                                this.render(props);
                            }
                            getElement() { return this.el; }
                            render(props) {
                                const row = props.grid.getRow(props.rowKey);
                                
                                // [수정] 쿼리에서 추가한 etp_stts_cd 값을 참조합니다.
                                // 환경에 따라 etpSttsCd 또는 etp_stts_cd로 들어올 수 있으니 둘 다 체크합니다.
                                const rawCode = row.etpSttsCd || row.etp_stts_cd || '';
                                const statusVal = String(rawCode).toLowerCase().trim();
                                const text = props.value || '-';
                                
                                let colorClass = 'stts-default';

                                // 상태 코드별 색상 클래스 배정
                                if (statusVal.includes('999')) {
                                    colorClass = 'stts-reject';
                                } else if (statusVal.startsWith('et')) {
                                    colorClass = 'stts-et';
                                } else if (statusVal.startsWith('od')) {
                                    colorClass = 'stts-od';
                                } else if (statusVal.startsWith('pr')) {
                                    colorClass = 'stts-pr';
                                } else if (statusVal.startsWith('pm')) {
                                    colorClass = 'stts-pm';
                                } else if (statusVal.startsWith('dv')) {
                                    colorClass = 'stts-dv';
                                }

                                // CSS 클래스 부여
                                this.el.className = 'stts-badge ' + colorClass;
                                this.el.innerText = text;

                                // 디버깅용: 만약 여전히 회색이라면 콘솔에서 코드를 확인하세요.
                                if (colorClass === 'stts-default' && statusVal !== '') {
                                    console.log("이력 상태코드 매칭 실패:", statusVal);
                                }
                            }
                        }
                    }
                },
                { header: '요청자', name: 'requestUserNm', width: 120, align: 'center', formatter: (v) => v.value || '-' },
                { header: '승인자', name: 'apprUserNm', width: 120, align: 'center', formatter: (v) => v.value || '-' },
                { 
                    header: '반려사유', name: 'rejtRsn', width: 300, align: 'center',
                    renderer: {
                        type: class {
                            constructor(props) {
                                const el = document.createElement('div');
                                el.className = 'px-2 break-words whitespace-normal text-red-600 font-bold text-center';
                                el.innerHTML = props.value ? '<span>' + props.value + '</span>' : '<span class="text-gray-400 font-normal">-</span>';
                                this.el = el;
                            }
                            getElement() { return this.el; }
                        }
                    }
                },
                { 
                    header: '처리일시', name: 'regDtime', width: 170, align: 'center',
                    formatter: (v) => v.value ? v.value.replace('T', ' ').split('.')[0] : '-' 
                }
            ]
        });
    }
</script>