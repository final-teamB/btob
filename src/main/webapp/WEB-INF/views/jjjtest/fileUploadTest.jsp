<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- JSP 엔진이 이 페이지 내의 모든 ${ } 문법을 무시하도록 설정합니다 (가장 확실한 방법) --%>
<%@ page isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>파일 업로드 테스트</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 p-10">

<div class="max-w-screen-2xl mx-auto">
    <div class="bg-white p-8 rounded-xl shadow-lg border border-gray-100">
        <h2 class="text-2xl font-bold mb-6 text-gray-800">다중 경로 파일 누적 테스트</h2>
        
        <form id="uploadForm" onsubmit="return submitFiles(event)" enctype="multipart/form-data">
            <div class="grid grid-cols-2 gap-4 mb-6">
                <div>
                    <label class="block text-sm font-bold mb-2 text-gray-700">참조 유형</label>
                    <input type="text" id="refTypeCd" value="TEST_BATCH" readonly 
                           class="w-full border p-2 rounded bg-gray-100 text-gray-500 outline-none">
                </div>
                <div>
                    <label class="block text-sm font-bold mb-2 text-gray-700">참조 ID</label>
                    <input type="number" id="refId" value="12345" 
                           class="w-full border p-2 rounded focus:ring-2 focus:ring-blue-500 outline-none">
                </div>
            </div>

            <div class="mb-6">
                <label class="block text-sm font-bold mb-2 text-blue-600">파일 추가 (여러 폴더에서 반복 선택 가능)</label>
                <input type="file" id="fileInput" multiple 
                       class="w-full border-2 border-dashed border-gray-300 p-4 rounded-lg hover:border-blue-400 hover:bg-blue-50 cursor-pointer transition-all">
            </div>

            <div class="mb-6 bg-gray-50 p-4 rounded-lg border border-gray-200">
                <h3 class="text-lg font-bold mb-3 text-gray-700">업로드 예정 목록 (<span id="fileCount" class="text-blue-600">0</span>개)</h3>
                <div id="fileListWrapper" class="space-y-2">
                    <p class="text-gray-400 text-sm italic">추가된 파일이 없습니다.</p>
                </div>
            </div>

            <div class="flex justify-end">
                <button type="submit" class="bg-blue-600 text-white px-3 py-1.5 text-sm rounded hover:bg-blue-700 shadow-md transition-colors font-medium">
                    전체 파일 서버로 전송
                </button>
            </div>
        </form>
    </div>
    
    <div class="mt-8 flex justify-start">
            <a href="/jjjtest/hometest" class="text-blue-600 text-sm hover:underline flex items-center">
                <span class="mr-1">←</span> 메인 테스트 페이지로 이동
            </a>
    </div>
</div>

<script>
    var fileArray = [];

    document.getElementById('fileInput').addEventListener('change', function(e) {
        var selectedFiles = Array.from(e.target.files);
        
        selectedFiles.forEach(function(file) {
            var isDuplicate = fileArray.some(function(f) {
                return f.name === file.name && f.size === file.size;
            });
            
            if (!isDuplicate) {
                fileArray.push(file);
            }
        });

        renderFileList();
        this.value = ''; 
    });

    function renderFileList() {
        var wrapper = document.getElementById('fileListWrapper');
        var countDisplay = document.getElementById('fileCount');
        
        countDisplay.innerText = fileArray.length;
        wrapper.innerHTML = '';

        if (fileArray.length === 0) {
            wrapper.innerHTML = '<p class="text-gray-400 text-sm italic">추가된 파일이 없습니다.</p>';
            return;
        }

        fileArray.forEach(function(file, index) {
            var fileSize = (file.size / 1024).toFixed(1) + " KB";
            var fileItem = document.createElement('div');
            fileItem.className = "flex justify-between items-center bg-white p-3 border border-gray-200 rounded-md shadow-sm text-sm";
            
            var content = '';
            content += '<div class="flex flex-col">';
            content += '    <span class="font-medium text-gray-700">' + file.name + '</span>';
            content += '    <span class="text-xs text-gray-400">' + fileSize + '</span>';
            content += '</div>';
            content += '<button type="button" onclick="removeFile(' + index + ')" class="text-red-400 font-bold px-2 py-1 rounded border border-red-100">삭제</button>';
            
            fileItem.innerHTML = content;
            wrapper.appendChild(fileItem);
        });
    }

    function removeFile(index) {
        fileArray.splice(index, 1);
        renderFileList();
    }

    async function submitFiles(event) {
        event.preventDefault();

        if (fileArray.length === 0) {
            alert("파일을 선택해주세요.");
            return;
        }

        var formData = new FormData();
        fileArray.forEach(function(file) {
            formData.append("files", file);
        });
        
        formData.append("refTypeCd", document.getElementById('refTypeCd').value);
        formData.append("refId", document.getElementById('refId').value);

        try {
            var submitBtn = event.target.querySelector('button[type="submit"]');
            submitBtn.disabled = true;

            var response = await fetch('/jjjtest/fileupload', {
                method: 'POST',
                body: formData
            });

            if (response.ok) {
                alert("업로드 성공!");
                fileArray = []; 
                renderFileList();
            } else {
                alert("업로드 실패");
            }
        } catch (error) {
            alert("통신 오류");
        } finally {
            submitBtn.disabled = false;
        }
    }
</script>

</body>
</html>