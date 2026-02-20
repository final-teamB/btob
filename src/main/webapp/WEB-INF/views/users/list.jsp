<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/modal.css">

<%-- 1. 화면 제목 --%>
<div class="px-4 py-6 space-y-6">
    <h1 class="text-2xl font-bold text-gray-800 dark:text-white">${pageTitle}</h1>
</div>

<c:set var="showAddBtn" value="true" scope="request" />

<%-- 공통 모달 포함 --%>
<jsp:include page="/WEB-INF/views/users/userModal.jsp"/>
<jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp"/>

<div id="excelActionModal" class="fixed inset-0 z-50 hidden items-center justify-center bg-black bg-opacity-50">
    <div class="bg-white rounded-lg p-6 w-[400px] shadow-2xl border dark:bg-gray-800">
        <div class="flex justify-between items-center mb-6">
            <h2 class="text-xl font-bold text-gray-800 dark:text-white border-b pb-2 flex-grow">사원 대량 관리</h2>
            <button type="button" onclick="closeExcelActionModal()" class="text-gray-400 hover:text-gray-600 text-2xl ml-2">&times;</button>
        </div>

        <div id="modalDefaultContent" class="space-y-4">
            <button type="button" onclick="downloadTemplate()" class="w-full py-4 border-2 border-blue-500 text-blue-500 rounded-xl font-bold hover:bg-blue-50 transition flex items-center justify-center gap-2">
                <span class="material-icons">file_download</span>사원 등록 양식 다운로드
            </button>
            <div id="drop-zone" class="w-full py-10 border-2 border-dashed border-gray-300 rounded-xl text-center cursor-pointer hover:border-green-500 hover:bg-green-50 transition group">
                <input type="file" id="excelDragInput" class="hidden" accept=".xlsx, .xls">
                <div class="text-gray-400 group-hover:text-green-500 mb-2">
                    <span class="material-icons text-5xl">upload_file</span>
                </div>
                <p class="text-gray-600 font-medium">여기에 엑셀 파일을 드래그 하세요</p>
                <p class="text-xs text-gray-400 mt-1">또는 클릭하여 파일 선택</p>
            </div>
        </div>

        <div id="modalLoadingContent" class="hidden flex-col items-center justify-center py-10 space-y-4">
            <div class="loader-blue"></div> <div class="text-center">
                <p class="text-gray-800 dark:text-white font-bold text-lg">데이터 처리 중</p>
                <p class="text-gray-500 text-sm">잠시만 기다려 주세요...</p>
            </div>
        </div>
    </div>
</div>

<div id="uploadResultModal" class="fixed inset-0 z-[60] hidden items-center justify-center bg-black bg-opacity-60">
    <div class="bg-white rounded-lg shadow-2xl w-full max-w-lg overflow-hidden flex flex-col max-h-[80vh]">
        <div class="px-6 py-4 border-b bg-gray-50 flex justify-between items-center">
            <h3 class="text-lg font-bold text-gray-800">업로드 처리 결과</h3>
            <button onclick="location.reload()" class="text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
        </div>
        <div class="p-6 overflow-y-auto">
            <div class="grid grid-cols-3 gap-3 mb-6">
                <div class="p-4 bg-gray-100 rounded-lg text-center">
                    <p class="text-xs text-gray-500">전체</p>
                    <p id="resTotal" class="text-xl font-bold text-gray-800">0</p>
                </div>
                <div class="p-4 bg-green-50 rounded-lg text-center border border-green-100">
                    <p class="text-xs text-green-600">성공</p>
                    <p id="resSuccess" class="text-xl font-bold text-green-600">0</p>
                </div>
                <div class="p-4 bg-red-50 rounded-lg text-center border border-red-100">
                    <p class="text-xs text-red-600">실패</p>
                    <p id="resFail" class="text-xl font-bold text-red-600">0</p>
                </div>
            </div>
            <div id="failSection" class="hidden">
                <h4 class="text-sm font-bold text-red-500 mb-2 flex items-center">
                    <span class="material-icons text-sm mr-1">warning</span> 실패 사유 리스트
                </h4>
                <div class="border rounded-lg bg-gray-50 overflow-hidden">
                    <div class="max-h-[250px] overflow-y-auto">
                        <table class="w-full text-xs text-left border-collapse">
                            <thead class="bg-gray-200 sticky top-0 shadow-sm">
                                <tr>
                                    <th class="px-3 py-2 w-16 text-center border-b">행</th>
                                    <th class="px-3 py-2 border-b">에러 사유</th>
                                </tr>
                            </thead>
                            <tbody id="failListBody" class="divide-y divide-gray-200"></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="px-6 py-4 border-t bg-gray-50 flex justify-end">
            <button onclick="location.reload()" class="px-6 py-2 bg-blue-600 text-white rounded font-bold hover:bg-blue-700 transition">확인 및 새로고침</button>
        </div>
    </div>
</div>

<script>
    const rawData = [
        <c:forEach var="user" items="${userList}" varStatus="status">
        {
            userNo: "${user.userNo}",
            userId: "${user.userId}",
            userName: "${user.userName}",
            phone: "${user.phone}",
            accStatus: "${user.accStatus}",
            regDtime: "${user.regDtime}"
        }${!status.last ? ',' : ''}
        </c:forEach>
    ];

    document.addEventListener('DOMContentLoaded', function() {
        if (typeof DataGrid !== 'undefined') {
            const userGrid = new DataGrid({
                containerId: 'dg-container',
                searchId: 'dg-search-input',
                perPageId: 'dg-per-page',
                btnSearchId: 'dg-btn-search',
                columns: [
                    { header: 'ID', name: 'userId'},
                    { header: '이름', name: 'userName'},
                    { header: '전화번호', name: 'phone'},
                    { header: '계정 상태', name: 'accStatus', align: 'center', renderer: { type: CustomStatusRenderer, options: { theme: 'accStatus' } } },
                    { header: '등록일', name: 'regDtime', align: 'center'},
                    { header: '관리', name: 'manage', align: 'center', sortable: false, renderer: { type: CustomActionRenderer, options: { btnText: '수정' } } }
                ],
                data: rawData
            });
            userGrid.initFilters([{ field: 'accStatus', title: '상태' }]);
        }
        initExcelDragAndDrop();
    });

    window.handleAddAction = function() {
        resetExcelModal();
        document.getElementById("excelActionModal").style.display = "flex";
    };

    window.closeExcelActionModal = function() {
        document.getElementById("excelActionModal").style.display = "none";
    };

    function resetExcelModal() {
        document.getElementById('modalDefaultContent').classList.remove('hidden');
        document.getElementById('modalLoadingContent').style.display = 'none';
    }

    function handleFileUpload(file) {
        if (!file) return;
        const ext = file.name.split('.').pop().toLowerCase();
        if (ext !== 'xls' && ext !== 'xlsx') {
            alert("엑셀 파일만 업로드 가능합니다.");
            return;
        }

        document.getElementById('modalDefaultContent').classList.add('hidden');
        document.getElementById('modalLoadingContent').style.display = 'flex';

        const formData = new FormData();
        formData.append("file", file);

        fetch("${pageContext.request.contextPath}/users/upload-ajax", {
            method: "POST",
            body: formData
        })
        .then(res => res.json())
        .then(data => {
            resetExcelModal(); 
            showUploadResult(data);
        })
        .catch(err => {
            resetExcelModal();
            alert("업로드 중 오류가 발생했습니다.");
        });
    }

    function showUploadResult(data) {
        document.getElementById('excelActionModal').style.display = 'none';
        document.getElementById('uploadResultModal').style.display = 'flex';
        
        document.getElementById('resTotal').innerText = data.totalCount || 0;
        document.getElementById('resSuccess').innerText = data.successCount || 0;
        document.getElementById('resFail').innerText = data.failCount || 0;

        const body = document.getElementById('failListBody');
        const section = document.getElementById('failSection');
        body.innerHTML = '';

        if (data.failCount > 0) {
            section.classList.remove('hidden');
            data.failList.forEach(function(fail) {
                const tr = '<tr>' +
                           '<td class="px-3 py-2 text-center font-bold text-red-500 border-r">' + fail.rowNum + '</td>' +
                           '<td class="px-3 py-2 text-gray-700">' + fail.reason + '</td>' +
                           '</tr>';
                body.insertAdjacentHTML('beforeend', tr);
            });
        } else {
            section.classList.add('hidden');    
        }
    }

    function downloadTemplate() {
        location.href = "${pageContext.request.contextPath}/users/downloadTemplate?fileName=user_template.xlsx";
    }

    function initExcelDragAndDrop() {
        const dropZone = document.getElementById('drop-zone');
        const fileInput = document.getElementById('excelDragInput');
        if(!dropZone) return;

        dropZone.addEventListener('click', () => fileInput.click());
        fileInput.addEventListener('change', (e) => {
            if (e.target.files.length > 0) handleFileUpload(e.target.files[0]);
        });

        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(name => {
            dropZone.addEventListener(name, (e) => { e.preventDefault(); e.stopPropagation(); }, false);
        });

        dropZone.addEventListener('drop', (e) => {
            const files = e.dataTransfer.files;
            if (files.length > 0) handleFileUpload(files[0]);
        });
    }

    window.handleGridAction = function(rowData) {
        const fields = { "mUserNo": rowData.userNo, "mUserId": rowData.userId, "mUserName": rowData.userName, "mAccStatus": rowData.accStatus };
        for (const [id, value] of Object.entries(fields)) {
            const el = document.getElementById(id);
            if (el) el.value = value || '';
        }
        document.getElementById("userModal").style.display = "flex";
    };

    window.saveUser = function() {
        if (document.getElementById("mAccStatus").value === 'STOP' && !confirm("퇴사 처리하시겠습니까?")) return;
        fetch("${pageContext.request.contextPath}/users/modifyStatus", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: new URLSearchParams(new FormData(document.getElementById("userForm")))
        })
        .then(res => { alert("수정되었습니다."); location.reload(); })
        .catch(err => alert("오류 발생"));
    };

    window.closeModal = function() { document.getElementById("userModal").style.display = "none"; };
    
    window.fetchData = function() {
        const keyword = document.getElementById('dg-search-input').value;
        const accStatus = document.getElementById('filter-accStatus')?.value || '';
        location.href = window.location.pathname + "?keyword=" + encodeURIComponent(keyword) + "&accStatus=" + accStatus;
    };
</script>