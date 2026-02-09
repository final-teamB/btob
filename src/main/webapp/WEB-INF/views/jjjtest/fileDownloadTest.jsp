<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>파일 다운로드 및 삭제 테스트</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 p-10">

<div class="max-w-screen-2xl mx-auto">
    <div class="bg-white p-8 rounded-xl shadow-lg border border-gray-100">
        <h2 class="text-2xl font-bold mb-6 text-gray-800">첨부파일 목록 관리 (Soft Delete 적용)</h2>
        
        <div class="flex gap-4 mb-8 p-4 bg-blue-50 rounded-lg items-end border border-blue-100">
            <div>
                <label class="block text-xs font-bold mb-1 text-gray-600">참조 유형 코드 (refTypeCd)</label>
                <input type="text" id="searchType" value="TEST_BATCH" class="border p-2 rounded text-sm w-40 outline-none focus:ring-2 focus:ring-blue-400">
            </div>
            <div>
                <label class="block text-xs font-bold mb-1 text-gray-600">참조 ID (refId)</label>
                <input type="number" id="searchId" value="12345" class="border p-2 rounded text-sm w-40 outline-none focus:ring-2 focus:ring-blue-400">
            </div>
            <button onclick="fetchFileList()" class="bg-blue-600 text-white px-4 py-2 text-sm rounded hover:bg-blue-700 transition font-medium shadow-sm">
                조회 및 새로고침
            </button>
        </div>

        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="border-b-2 border-gray-100 text-sm text-gray-500 uppercase">
                        <th class="py-3 px-2">파일 ID</th>
                        <th class="py-3 px-2">파일명</th>
                        <th class="py-3 px-2">크기</th>
                        <th class="py-3 px-2 text-center">관리</th>
                    </tr>
                </thead>
                <tbody id="dbFileList" class="text-sm">
                    <tr>
                        <td colspan="4" class="py-10 text-center text-gray-400 italic">데이터를 조회해주세요.</td>
                    </tr>
                </tbody>
            </table>
        </div>
        
        <div class="mt-8 flex justify-start">
            <a href="/jjjtest/hometest" class="text-blue-600 text-sm hover:underline flex items-center">
                <span class="mr-1">←</span> 메인 테스트 페이지로 이동
            </a>
        </div>
    </div>
</div>

<script>
    async function fetchFileList() {
        const type = document.getElementById('searchType').value;
        const id = document.getElementById('searchId').value;
        const tbody = document.getElementById('dbFileList');

        try {
            // [수정 포인트] refType -> refTypeCd 로 변경
            const response = await fetch('/jjjtest/filelist?refTypeCd=' + type + '&refId=' + id);
            
            if (!response.ok) {
                console.error('Response Error:', response.status);
                alert('목록을 가져오지 못했습니다. (Error: ' + response.status + ')');
                return;
            }

            const files = await response.json();
            tbody.innerHTML = '';

            if (!files || files.length === 0) {
                tbody.innerHTML = '<tr><td colspan="4" class="py-10 text-center text-gray-400 italic">조회된 파일이 없습니다 (USE_YN="Y" 기준).</td></tr>';
                return;
            }

            files.forEach(file => {
                const tr = document.createElement('tr');
                tr.className = "border-b border-gray-50 hover:bg-gray-50 transition-colors";
                
                // 템플릿 리터럴 `${}` 대신 문자열 결합 사용하여 JSP 엔진 간섭 방지
                let html = '';
                html += '<td class="py-4 px-2 text-gray-400 font-mono">' + file.fileId + '</td>';
                html += '<td class="py-4 px-2 font-medium text-gray-700">' + file.orgFileNm + '</td>';
                html += '<td class="py-4 px-2 text-gray-500">' + (file.fileSize / 1024).toFixed(1) + ' KB</td>';
                html += '<td class="py-4 px-2 text-center space-x-1">';
                html += '    <button onclick="downloadFile(' + file.fileId + ')" class="bg-green-500 text-white px-3 py-1.5 text-xs rounded hover:bg-green-600">다운로드</button>';
                html += '    <button onclick="deleteFile(' + file.fileId + ')" class="bg-red-50 text-red-500 px-3 py-1.5 text-xs rounded hover:bg-red-100">삭제</button>';
                html += '</td>';
                
                tr.innerHTML = html;
                tbody.appendChild(tr);
            });
        } catch (error) {
            console.error('Fetch Error:', error);
            alert('서버와 통신 중 오류가 발생했습니다.');
        }
    }

    function downloadFile(fileId) {
        window.location.href = '/jjjtest/filedownload/' + fileId;
    }

    async function deleteFile(fileId) {
        if(!confirm('해당 파일을 목록에서 삭제(비활성화) 하시겠습니까?')) return;
        
        try {
            const response = await fetch('/jjjtest/file/' + fileId, { method: 'DELETE' });
            if(response.ok) {
                alert('정상적으로 삭제되었습니다.');
                fetchFileList();
            } else {
                alert('삭제 처리에 실패했습니다.');
            }
        } catch(e) {
            alert('통신 오류 발생');
        }
    }
</script>
</body>
</html>