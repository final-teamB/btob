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
                <div class="bg-blue-50 p-4 rounded-lg border border-blue-100">
                    <h4 class="text-blue-800 font-bold mb-2 flex items-center">
                        <svg class="w-4 h-4 mr-2" fill="currentColor" viewBox="0 0 20 20"><path d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z"></path></svg>
                        업로드 가이드 및 주의사항
                    </h4>
                    <ul class="text-sm text-blue-700 space-y-1 list-disc ml-5">
                        <li>제공된 <strong>최신 양식 파일</strong>만 사용 가능합니다.</li>
                        <li>이미지 업로드 시, 파일명이 엑셀에 입력한 이름과 일치해야 하며 <strong>서버 임시 경로에 미리 업로드</strong>되어 있어야 합니다.</li>
                        <li>한 번에 최대 <strong>1,000건</strong>까지 업로드 가능합니다.</li>
                        <li>업로드 중 오류 발생 시, 해당 행을 제외한 나머지 데이터만 저장됩니다.</li>
                    </ul>
                </div>

                <div class="flex items-center justify-center w-full">
                    <label for="excel-file-input" class="flex flex-col items-center justify-center w-full h-32 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100">
                        <div class="flex flex-col items-center justify-center pt-5 pb-6">
                            <svg class="w-8 h-8 mb-4 text-gray-500" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 16"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2"/></svg>
                            <p class="mb-2 text-sm text-gray-500 font-semibold" id="file-name-display">클릭하여 엑셀 파일 선택</p>
                            <p class="text-xs text-gray-400">XLSX, XLS (Max. 10MB)</p>
                        </div>
                        <input id="excel-file-input" type="file" class="hidden" accept=".xlsx, .xls" onchange="ProductExcelHandler.handleFileSelect(this)" />
                    </label>
                </div>
            </div>
            <div class="flex items-center p-4 md:p-5 border-t border-gray-200 rounded-b">
                <button type="button" onclick="ProductExcelHandler.uploadExecute()" class="text-white bg-blue-600 hover:bg-blue-700 font-medium rounded-lg text-sm px-5 py-2.5 text-center">업로드 시작</button>
                <button type="button" onclick="ProductExcelHandler.downloadBatchTemplate()" class="ms-3 text-gray-500 bg-white hover:bg-gray-100 border border-gray-200 font-medium rounded-lg text-sm px-5 py-2.5">양식 다운로드</button>
                <button type="button" onclick="ProductExcelHandler.closeModal()" class="ms-auto text-gray-500 hover:underline">닫기</button>
            </div>
        </div>
    </div>
</div>

<script>
    let excelModal = null;

    const ProductExcelHandler = {
        init: function() {
            if (typeof Modal !== 'undefined') {
                excelModal = new Modal(document.getElementById('excelUploadModal'));
            }
        },

        openUploadModal: function() {
            if(!excelModal) this.init();
            document.getElementById('excel-file-input').value = '';
            document.getElementById('file-name-display').innerText = '클릭하여 엑셀 파일 선택';
            excelModal.show();
        },

        closeModal: function() {
            if(excelModal) excelModal.hide();
        },

        downloadBatchTemplate: function() {
            window.location.href = cp + '/admin/products/download/template';
        },

        handleFileSelect: function(input) {
            const fileName = input.files[0]?.name || '선택된 파일 없음';
            document.getElementById('file-name-display').innerText = fileName;
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

            // 처리 중 알림 (간이 로딩)
            document.getElementById('file-name-display').innerText = "업로드 중... 잠시만 기다려주세요.";

            fetch(cp + '/admin/products/api/upload/excel', {
                method: 'POST',
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    alert("업로드 결과\n- 총 건수: " + data.totalCount + "건\n- 성공: " + data.successCount + "건\n- 실패: " + data.failCount + "건");
                    this.closeModal();
                    if(window.fetchData) window.fetchData(); // 그리드 새로고침
                } else {
                    alert("오류: " + data.message);
                }
            })
            .catch(err => {
                console.error(err);
                alert("업로드 중 통신 오류가 발생했습니다.");
            });
        }
    };

    document.addEventListener('DOMContentLoaded', () => ProductExcelHandler.init());
</script>