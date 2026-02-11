<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="excelUploadModal" tabindex="-1" aria-hidden="true" class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full">
    <div class="relative p-4 w-full max-w-2xl max-h-full">
        <div class="relative bg-white rounded-xl shadow-lg dark:bg-gray-800 border border-gray-200">
            <div class="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600">
                <h3 class="text-xl font-semibold text-gray-900 dark:text-white">상품 일괄 업로드</h3>
                <button type="button" onclick="ProductExcelHandler.closeModal()" class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center">
                    <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/></svg>
                </button>
            </div>

            <div class="p-4 md:p-5 space-y-4">
                <div id="upload-input-area" class="space-y-4">
                    <div class="bg-blue-50 p-4 rounded-lg border border-blue-100">
                        <h4 class="text-blue-800 font-bold mb-2 flex items-center">
                            <svg class="w-4 h-4 mr-2" fill="currentColor" viewBox="0 0 20 20"><path d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z"></path></svg>
                            업로드 가이드 및 주의사항
                        </h4>
                        <ul class="text-sm text-blue-700 space-y-1 list-disc ml-5">
                            <li>제공된 <strong>최신 양식 파일</strong>만 사용 가능합니다.</li>
                            <li>한 번에 최대 <strong>1,000건</strong>까지 업로드 가능합니다.</li>
                            <li>오류 발생 시, 해당 행을 제외한 나머지 데이터만 저장됩니다.</li>
                        </ul>
                    </div>

                    <div class="flex items-center justify-center w-full">
                        <label for="excel-file-input" class="flex flex-col items-center justify-center w-full h-32 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100">
                            <div class="flex flex-col items-center justify-center pt-5 pb-6">
                                <svg class="w-8 h-8 mb-4 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"/></svg>
                                <p class="mb-2 text-sm text-gray-500 font-semibold" id="file-name-display">클릭하여 엑셀 파일 선택</p>
                                <p class="text-xs text-gray-400">XLSX, XLS (Max. 10MB)</p>
                            </div>
                            <input id="excel-file-input" type="file" class="hidden" accept=".xlsx, .xls" onchange="ProductExcelHandler.handleFileSelect(this)" />
                        </label>
                    </div>
                </div>

                <div id="upload-result-area" class="hidden space-y-4">
				    <div class="p-4 rounded-lg bg-gray-50 border border-gray-200">
				        <h4 class="text-lg font-bold text-gray-800 mb-3 text-center">업로드 처리 결과</h4>
				        <div class="grid grid-cols-3 gap-4 text-center">
				            <div class="bg-white p-3 rounded-md shadow-sm border border-gray-100">
				                <p class="text-xs text-gray-500 uppercase font-medium">전체</p>
				                <p class="text-xl font-bold text-gray-800" id="res-total-cnt">0</p>
				            </div>
				            <div class="bg-white p-3 rounded-md shadow-sm border border-green-100">
				                <p class="text-xs text-green-600 uppercase font-medium">성공</p>
				                <p class="text-xl font-bold text-green-600" id="res-success-cnt">0</p>
				            </div>
				            <div class="bg-white p-3 rounded-md shadow-sm border border-red-100">
				                <p class="text-xs text-red-600 uppercase font-medium">실패</p>
				                <p class="text-xl font-bold text-red-600" id="res-fail-cnt">0</p>
				            </div>
				        </div>
				    </div>
				
				    <div id="fail-table-area" class="hidden border-t pt-4">
				        <p class="text-sm font-bold text-red-600 mb-2">실패 내역 상세</p>
				        <div class="overflow-x-auto max-h-48 overflow-y-auto border rounded-lg">
				            <table class="w-full text-sm text-left text-gray-500">
				                <thead class="text-xs text-gray-700 uppercase bg-gray-100 sticky top-0">
				                    <tr>
				                        <th class="px-4 py-2 text-center w-16">행</th>
				                        <th class="px-4 py-2">실패 사유</th>
				                    </tr>
				                </thead>
				                <tbody id="fail-list-body">
				                    </tbody>
				            </table>
				        </div>
				        
				        <button type="button" onclick="ProductExcelHandler.downloadFailExcel()" 
				                class="mt-3 w-full py-2.5 text-sm font-medium text-red-600 bg-white border border-red-200 rounded-lg hover:bg-red-50 shadow-sm transition-colors">
				            실패 내역 엑셀 다운로드 (.xlsx)
				        </button>
				    </div>
				</div>
                
            </div>

            <div class="flex items-center p-4 md:p-5 border-t border-gray-200 rounded-b">
                <div id="footer-buttons-before" class="flex w-full">
                    <button type="button" onclick="ProductExcelHandler.uploadExecute()" class="text-white bg-blue-600 hover:bg-blue-700 font-medium rounded-lg text-sm px-5 py-2.5">업로드 시작</button>
                    <button type="button" onclick="ProductExcelHandler.downloadBatchTemplate()" class="ms-3 text-gray-500 bg-white hover:bg-gray-100 border border-gray-200 font-medium rounded-lg text-sm px-5 py-2.5">양식 다운로드</button>
                    <button type="button" onclick="ProductExcelHandler.closeModal()" class="ms-auto text-gray-700 bg-white hover:bg-gray-100 border border-gray-200 font-medium rounded-lg text-sm px-5 py-2.5 transition-colors shadow-sm">닫기</button>
                </div>
                <div id="footer-buttons-after" class="hidden w-full">
                    <button type="button" onclick="ProductExcelHandler.resetModal()" class="w-full text-white bg-gray-800 hover:bg-gray-900 font-medium rounded-lg text-sm px-5 py-2.5">확인 및 돌아가기</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    let excelModal = null;

    const ProductExcelHandler = {
        init: function() {
            if (typeof Modal !== 'undefined') {
            	
            	// 옵션 설정 추가
                const options = {
                    backdrop: 'static', // 배경 클릭 시 닫히지 않음
                    closable: false,    // ESC 키 등으로 닫히는 기능 제어 (필요 시)
                    onHide: () => {
                        console.log('modal is hidden');
                    }
                };
            	
                excelModal = new Modal(document.getElementById('excelUploadModal'), options);
            }
        },

        openUploadModal: function() {
            if(!excelModal) this.init();
            this.resetModal(); // 모달을 열 때 항상 초기 상태로 세팅
            excelModal.show();
        },

        closeModal: function() {
            if(excelModal) {
                excelModal.hide();
                // 닫을 때 데이터가 성공적으로 들어갔을 수 있으므로 그리드 갱신
                if(window.fetchData) window.fetchData(); 
            }
        },

        downloadBatchTemplate: function() {
            window.location.href = cp + '/admin/products/download/template';
        },
        
     	// [추가] 조회 결과 엑셀 다운로드
        downloadProductExcel: function() {
            // 1. 현재 데이터그리드에 입력된 검색어 가져오기
            const searchInput = document.getElementById('dg-search-input');
            const searchCondition = searchInput ? searchInput.value : '';

            // 2. 검색 조건을 쿼리 스트링으로 변환
            const params = new URLSearchParams();
            if (searchCondition) {
                params.append('searchCondition', searchCondition);
            }
            
         	// 3. datagrid.js가 생성한 필터 ID 규칙(filter-필드명)으로 값 수집
            // 소스 코드의 `select.id = "filter-${config.field}";` 부분을 반영합니다.
            const fuelCatNm = document.getElementById('filter-fuelCatNm')?.value;
            const originCntryNm = document.getElementById('filter-originCntryNm')?.value;
            const itemSttsNm = document.getElementById('filter-itemSttsNm')?.value;

            if (fuelCatNm) params.append('fuelCatNm', fuelCatNm);
            if (originCntryNm) params.append('originCntryNm', originCntryNm);
            if (itemSttsNm) params.append('itemSttsNm', itemSttsNm);

            // 4. 엑셀 전용 플래그 추가 (MyBatis에서 LIMIT 제외용)
            params.append('isExcel', 'Y');

            // 5. 다운로드 URL 생성 (컨트롤러 @GetMapping 주소)
            const downloadUrl = cp + '/admin/products/download/excel?' + params.toString();

            // 6. 실행 전 확인 및 진행
            if (confirm("현재 검색 결과대로 엑셀을 다운로드하시겠습니까?")) {
                window.location.href = downloadUrl;
            }
        },

        handleFileSelect: function(input) {
            const fileName = input.files[0]?.name || '클릭하여 엑셀 파일 선택';
            document.getElementById('file-name-display').innerText = fileName;
        },

        // 모달 초기 상태로 되돌리기 (UI 스위칭)
        resetModal: function() {
            document.getElementById('upload-input-area').classList.remove('hidden');
            document.getElementById('upload-result-area').classList.add('hidden');
            document.getElementById('footer-buttons-before').classList.remove('hidden');
            document.getElementById('footer-buttons-after').classList.add('hidden');
            
            document.getElementById('excel-file-input').value = '';
            document.getElementById('file-name-display').innerText = '클릭하여 엑셀 파일 선택';
            
            const failBody = document.getElementById('fail-list-body');
            if(failBody) failBody.innerHTML = '';
            window.currentFailList = null;
        },

        uploadExecute: function() {
            const fileInput = document.getElementById('excel-file-input');
            const file = fileInput.files[0];

            if (!file) {
                alert("업로드할 파일을 선택해주세요.");
                return;
            }

            const formData = new FormData();
            formData.append("file", file);

            document.getElementById('file-name-display').innerText = "데이터 분석 및 저장 중... 잠시만 기다려주세요.";

            fetch(cp + '/admin/products/api/upload/excel', {
                method: 'POST',
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                // 1. UI 영역 전환 (먼저 영역을 보여줘야 내부 요소 렌더링이 정확함)
                document.getElementById('upload-input-area').classList.add('hidden');
                document.getElementById('upload-result-area').classList.remove('hidden');
                document.getElementById('footer-buttons-before').classList.add('hidden');
                document.getElementById('footer-buttons-after').classList.remove('hidden');

                // 2. 숫자 결과 바인딩
                document.getElementById('res-total-cnt').innerText = data.totalCount ?? 0;
                document.getElementById('res-success-cnt').innerText = data.successCount ?? 0;
                document.getElementById('res-fail-cnt').innerText = data.failCount ?? 0;

                // 3. 실패 리스트 상세 처리
                const failTableArea = document.getElementById('fail-table-area');
                const failBody = document.getElementById('fail-list-body');
                
                // 기존 내용 초기화
                failBody.innerHTML = ''; 
                window.currentFailList = null;

                const failCount = parseInt(data.failCount || 0);

                if (failCount > 0 && data.failList && data.failList.length > 0) {
                    // 테이블 영역 보이기
                    failTableArea.classList.remove('hidden');
                    
                    // 전역 변수 저장 (다운로드용)
                    window.currentFailList = data.failList;

                    // [수정 포인트] 문자열 합치기 대신 명확하게 행 추가
                    data.failList.forEach(item => {
                        const tr = document.createElement('tr');
                        tr.className = "bg-white border-b hover:bg-gray-50 text-xs";
                        
                        // 행 번호 컬럼
                        const tdNum = document.createElement('td');
                        tdNum.className = "px-4 py-3 text-center font-bold text-gray-700 border-r";
                        tdNum.innerText = item.rowNum ?? '-';
                        
                        // 에러 사유 컬럼
                        const tdMsg = document.createElement('td');
                        tdMsg.className = "px-4 py-3 text-red-600 font-medium";
                        tdMsg.innerText = item.errorMsg ?? '상세 사유 없음';
                        
                        tr.appendChild(tdNum);
                        tr.appendChild(tdMsg);
                        failBody.appendChild(tr);
                    });
                } else {
                    failTableArea.classList.add('hidden');
                }
            })
            .catch(err => {
                console.error("Upload Error:", err);
                alert("업로드 중 통신 오류가 발생했습니다.");
                this.resetModal();
            });
        },

        downloadFailExcel: function() {
            if (!window.currentFailList || window.currentFailList.length === 0) {
                alert("다운로드할 실패 내역이 없습니다.");
                return;
            }

            // 동적으로 폼 생성하여 POST 전송 (파일 다운로드는 이 방식이 가장 확실함)
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = cp + '/admin/products/api/download/fail-report';

            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'failListJson';
            input.value = JSON.stringify(window.currentFailList);

            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
            document.body.removeChild(form);
        }
    };

    document.addEventListener('DOMContentLoaded', () => ProductExcelHandler.init());
</script>