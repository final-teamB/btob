<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>엑셀 관리 테스트</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .animate-fade-in { animation: fadeIn 0.3s ease-in; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="bg-gray-50 p-10">

<div class="max-w-screen-2xl mx-auto">
    <div class="bg-white p-8 rounded-xl shadow-lg border border-gray-100">
        <h2 class="text-2xl font-bold mb-6 text-gray-800">엑셀 통합 관리 및 데이터 조회</h2>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-8 mb-10">
            <div class="p-6 bg-gray-50 rounded-xl border border-gray-200">
                <h3 class="text-lg font-semibold mb-3 text-gray-700">1. 업로드 양식 다운로드</h3>
                <p class="text-sm text-gray-500 mb-4">표준 가이드 양식을 내려받습니다.</p>
                <button onclick="downloadTemplate()" class="bg-gray-600 text-white px-3 py-1.5 text-sm rounded hover:bg-gray-700 transition font-medium shadow-sm">
                    양식 다운로드 (.xlsx)
                </button>
            </div>

            <div class="p-6 bg-gray-50 rounded-xl border border-gray-200">
                <h3 class="text-lg font-semibold mb-3 text-gray-700">2. 엑셀 데이터 업로드</h3>
                <p class="text-sm text-gray-500 mb-4">파일을 선택하여 DB에 일괄 저장합니다.</p>
                <div class="flex items-center gap-2">
                    <input type="file" id="excelFile" accept=".xlsx, .xls" class="block w-full text-sm text-gray-500 file:mr-4 file:py-1.5 file:px-4 file:rounded-full file:border-0 file:text-xs file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100 cursor-pointer border border-gray-200 rounded-lg bg-white p-1">
                    <button id="uploadBtn" onclick="uploadExcel()" class="bg-blue-600 text-white px-3 py-1.5 text-sm rounded hover:bg-blue-700 transition font-medium shadow-sm shrink-0">
                        파일 업로드
                    </button>
                </div>
            </div>
        </div>

        <hr class="my-8 border-gray-100">

        <div class="mb-10">
            <div class="flex justify-between items-end mb-4">
                <div>
                    <h3 class="text-lg font-semibold text-gray-700">3. 파일 목록 조회 및 추출</h3>
                    <p class="text-sm text-gray-500">참조 유형과 ID를 입력하여 데이터를 조회하고 엑셀로 추출합니다.</p>
                </div>
                <button onclick="downloadUserList()" class="bg-green-600 text-white px-3 py-1.5 text-sm rounded hover:bg-green-700 transition font-medium shadow-sm flex items-center">
                    <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="C4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path></svg>
                    조회결과 엑셀 다운로드
                </button>
            </div>

            <div class="bg-white p-4 border border-gray-200 rounded-t-xl flex gap-4 items-end">
                <div>
                    <label class="block text-xs font-bold text-gray-600 mb-1">참조 유형 (refTypeCd)</label>
                    <input type="text" id="refTypeCd" value="TEST_BATCH" class="border border-gray-300 rounded px-3 py-1.5 text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-600 mb-1">참조 ID (refId)</label>
                    <input type="number" id="refId" value="12345" class="border border-gray-300 rounded px-3 py-1.5 text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                </div>
                <button onclick="searchData()" class="bg-indigo-600 text-white px-4 py-1.5 text-sm rounded hover:bg-indigo-700 transition font-medium shadow-sm">
                    데이터 조회
                </button>
            </div>

            <div class="overflow-x-auto border-x border-b border-gray-200 rounded-b-xl">
                <table class="w-full text-sm text-left text-gray-600">
                    <thead class="text-xs text-gray-700 uppercase bg-gray-100 border-b">
                        <tr>
                            <th class="px-4 py-3">유형</th>
                            <th class="px-4 py-3">참조ID</th>
                            <th class="px-4 py-3">파일명</th>
                            <th class="px-4 py-3">확장자</th>
                            <th class="px-4 py-3 text-right">용량(Byte)</th>
                        </tr>
                    </thead>
                    <tbody id="dataTableBody">
                        <tr>
                            <td colspan="5" class="px-4 py-10 text-center text-gray-400">조회된 데이터가 없습니다.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="resultArea" class="hidden animate-fade-in mt-6">
            <h3 class="text-lg font-semibold mb-3 text-gray-700">실행 결과</h3>
            <div id="resultContent" class="p-4 border rounded-lg text-sm font-mono whitespace-pre-wrap min-h-[50px]"></div>
        </div>

        <div class="mt-12 flex justify-start border-t pt-6">
            <a href="/jjjtest/hometest" class="text-blue-600 text-sm hover:underline flex items-center">
                <span class="mr-1">←</span> 메인 테스트 페이지로 돌아가기
            </a>
        </div>
    </div>
</div>

<script>
    // 1. 양식 다운로드
    function downloadTemplate() {
        window.location.href = '/jjjtest/download/template';
    }

    // 2. 데이터 업로드
    async function uploadExcel() {
        const fileInput = document.getElementById('excelFile');
        const uploadBtn = document.getElementById('uploadBtn');
        const resultArea = document.getElementById('resultArea');
        const resultContent = document.getElementById('resultContent');

        if (!fileInput.files[0]) {
            alert('업로드할 엑셀 파일을 선택해 주세요.');
            return;
        }

        uploadBtn.disabled = true;
        uploadBtn.innerText = "처리 중...";
        
        const formData = new FormData();
        formData.append('excelFile', fileInput.files[0]);

        try {
            const response = await fetch('/jjjtest/upload', { method: 'POST', body: formData });
            const result = await response.json();
            
            resultArea.classList.remove('hidden');
            if (response.ok && result.status === 'success') {
                resultContent.className = "p-4 border rounded-lg text-sm font-mono bg-blue-50 border-blue-200 text-blue-700";
                resultContent.innerText = "✅ " + result.message;
                searchData(); // 업로드 성공 후 목록 자동 갱신
            } else {
                resultContent.className = "p-4 border rounded-lg text-sm font-mono bg-red-50 border-red-200 text-red-700";
                resultContent.innerText = "❌ 실패: " + result.message;
            }
        } catch (error) {
            alert('통신 오류 발생');
        } finally {
            uploadBtn.disabled = false;
            uploadBtn.innerText = "파일 업로드";
        }
    }

    // 3. 데이터 조회 (AJAX)
    // 이 기능을 위해 컨트롤러에 목록 반환 메서드가 필요합니다 (아래 설명 참조)
    async function searchData() {
        const refTypeCd = document.getElementById('refTypeCd').value;
        const refId = document.getElementById('refId').value;
        const tbody = document.getElementById('dataTableBody');

        try {
            // 주소는 임의로 설정 (컨트롤러에 추가 필요)
            const response = await fetch(`/jjjtest/list?refTypeCd=${refTypeCd}&refId=${refId}`);
            const list = await response.json();
            
            tbody.innerHTML = '';
            if (list.length === 0) {
                tbody.innerHTML = '<tr><td colspan="5" class="px-4 py-10 text-center text-gray-400">데이터가 존재하지 않습니다.</td></tr>';
                return;
            }

            list.forEach(item => {
                const row = `
                    <tr class="border-b hover:bg-gray-50 transition">
                        <td class="px-4 py-3">${item.refTypeCd}</td>
                        <td class="px-4 py-3">${item.refId}</td>
                        <td class="px-4 py-3 font-medium text-gray-900">${item.orgFileNm}</td>
                        <td class="px-4 py-3"><span class="px-2 py-1 bg-gray-200 rounded text-xs">${item.fileExt}</span></td>
                        <td class="px-4 py-3 text-right">${item.fileSize.toLocaleString()} B</td>
                    </tr>`;
                tbody.innerHTML += row;
            });
        } catch (error) {
            console.error('조회 오류:', error);
        }
    }

    // 4. 조회된 데이터 엑셀 다운로드
    function downloadUserList() {
        const refTypeCd = document.getElementById('refTypeCd').value;
        const refId = document.getElementById('refId').value;
        
        // 쿼리 스트링으로 필터 조건을 넘깁니다.
        window.location.href = `/jjjtest/download/excellist?refTypeCd=${refTypeCd}&refId=${refId}`;
    }
</script>

</body>
</html>