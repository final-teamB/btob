<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<style>
/* 모달 배경: 화면 전체를 어둡게 덮음 */
.modal {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5); /* 반투명 검정 */
    display: none; /* 기본은 숨김 */
    align-items: center; /* 수직 중앙 정렬 */
    justify-content: center; /* 수평 중앙 정렬 */
    z-index: 9999; /* 그리드보다 위에 뜨도록 함 */
}

/* 모달 박스: 실제 흰색 대화창 */
.modal-box {
    background-color: #fff;
    padding: 20px;
    border-radius: 8px;
    width: 90%;
    max-width: 500px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

/* 다크모드 대응 (선택사항) */
.dark .modal-box {
    background-color: #1f2937;
    color: white;
}
</style>

<div class="px-4 py-6 space-y-6">

    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b pb-4 dark:border-gray-700">
        <div>
            <h1 class="text-2xl font-bold text-gray-800 dark:text-white">${pageTitle}</h1>
        </div>
    </div>
    </div>    
    
		
	<jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp"/>

	<!-- 메모 모달 -->
	<div id="memoModal" class="modal" style="display:none;">
    <div class="modal-box">
        <h3 class="text-lg font-bold mb-4">특이사항 메모</h3>
        <form id="memoForm">
            <input type="hidden" id="mDocId" name="docId">
            <textarea id="mMemo" name="memo" rows="5" class="w-full border rounded-lg p-2 dark:bg-gray-700 dark:text-white"></textarea>
            <div class="flex justify-end gap-2 mt-4">
                <button type="button" onclick="saveMemo()" class="bg-blue-600 text-white px-4 py-2 rounded">저장</button>
                <button type="button" onclick="closeMemoModal()" class="bg-gray-500 text-white px-4 py-2 rounded">취소</button>
            </div>
        </form>
    </div>
</div>
	
<script>
class MemoCellRenderer {
    constructor(props) {
        const el = document.createElement('div');
        // 중앙 정렬 및 가독성을 위한 스타일 적용
        el.className = 'w-full flex items-center justify-center py-1';
        
        const val = props.value ? String(props.value).trim() : "";
        
        if (val !== "" && val !== "null") {
            // 글자가 길어질 경우를 대비해 최소한의 스타일만 적용
            el.innerHTML = `
                <span class="cursor-pointer text-blue-600 hover:underline font-medium px-2" 
                      style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 180px;">
                    \${val}
                </span>`;
        } else {
            el.innerHTML = `<button type="button" class="px-3 py-1 text-xs font-bold text-white bg-green-500 rounded hover:bg-green-600">등록</button>`;
        }
        
        el.onclick = () => window.handleGridAction(props.grid.getRow(props.rowKey), 'MEMO');
        this.el = el;
    }
    getElement() { return this.el; }
}

	const rawData = [
		<c:forEach var="d" items="${documentList}" varStatus="status">
		{
			docId: "${d.docId}",
			docNo: "${d.docNo}",
			userName: "${d.userName}",
			docType: "${d.docType}",
			regDtime: "${d.regDtime}",
			memo: "${d.memo}"
		}${!status.last ? ',' : ''}
		</c:forEach>
	];
	
	document.addEventListener('DOMContentLoaded', function() {
	const filterSelect = document.getElementById('dg-common-filter');
        
        // 첫 번째 옵션이 레이블 역할을 대신함
        const options = [
            { value: "", text: "전체" }, 
            { value: "QUOTE", text: "견적서" },
            { value: "TRANSATION", text: "거래내역서" },
            { value: "CONTRACT", text: "계약서" },
        ];

        options.forEach(opt => {
            filterSelect.add(new Option(opt.text, opt.value));
        });

        // 필터 값이 있으면 노출
        document.getElementById('dg-common-filter-wrapper').classList.remove('hidden'); 
		
		const docGrid = new DataGrid({
			containerId: 'dg-container',
			searchId: 'dg-search-input',
            perPageId: 'dg-per-page',
            btnSearchId: 'dg-btn-search',
            filterField: 'docType',
            filterSelectId: 'dg-common-filter',
            
			columns: [
				{ header: '담당자', name: 'userName'},
				{ header: '문서번호', name: 'docNo'},
				{ header: '문서유형', name: 'docType'},
				{ header: '등록일', name: 'regDtime', align: 'center'},
				{ 
			        header: '특이사항', 
			        name: 'memo', 
			        width: 200,
			        sortable: false,
			        renderer: { type: MemoCellRenderer } 
			    },
				{ 
			    	header: 'PDF',
			        name: 'pdfAction',
			        width: 150,
			        align: 'center',
			        sortable: false,
			        renderer: {
			            type: CustomActionRenderer,
			            options: {
			                buttons: [{ text: 'PDF', action: 'PDF', className: 'bg-red-500' }
		                    ]
			    		}
			    	}
				}
			],
			data: rawData
			});
		});
	
	window.handleGridAction = function(rowData, action) {
	    if (action === 'MEMO') {
	        // 셀 내부에서 전달받은 rowData를 바로 활용
	        openMemoModal(rowData.docId, rowData.memo);
	    } else if (action === 'PDF') {
	        previewPDF(rowData.docId);
	    }
	};
	
	/* =========================
	   메모 모달 제어
	========================= */
	function openMemoModal(docId, memo) {
	    document.getElementById("mDocId").value = docId;
	    document.getElementById("mMemo").value = memo || "";
	    
	    const modal = document.getElementById("memoModal");
	    modal.style.display = "flex"; // flex로 띄워야 화면 중앙 정렬이 쉽습니다.
	}

	function closeMemoModal() {
	    document.getElementById("memoModal").style.display = "none";
	}

	function saveMemo() {
	    const memoField = document.getElementById("mMemo");
	    
	    // 줄바꿈을 공백으로 치환하고 앞뒤 공백 제거
	    const cleanValue = memoField.value.replace(/(\r\n|\n|\r)/gm, " ").trim();
	    memoField.value = cleanValue; // 변환된 값을 다시 필드에 세팅

	    const form = document.getElementById("memoForm");
	    const formData = new URLSearchParams(new FormData(form));

	    fetch("${pageContext.request.contextPath}/document/modifyMemo", {
	        method: "POST",
	        headers: { "Content-Type": "application/x-www-form-urlencoded" },
	        body: formData
	    })
	    .then(res => {
	        if (!res.ok) throw new Error();
	        alert("메모가 저장되었습니다.");
	        location.reload(); 
	    })
	    .catch(() => alert("메모 저장 중 오류가 발생했습니다."));
	}

	/* =========================
	   PDF 미리보기
	========================= */
	function previewPDF(docId) {
	    if(!docId) return;
	    window.open("${pageContext.request.contextPath}/document/previewPDF?docId=" + docId, "_blank");
	}
</script>