<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <link rel="stylesheet"  href="${pageContext.request.contextPath}/css/modal.css">
	
	<%-- 1. 화면 제목 (H1) --%>
	<div class="px-4 py-6 space-y-6">

    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b pb-4 dark:border-gray-700">
        <div>
            <h1 class="text-2xl font-bold text-gray-800 dark:text-white">${pageTitle}</h1>
        </div>
    </div>
    </div>    

	<c:set var="showAddBtn" value="true" scope="request" />

    <%-- 1. 공통 메시지 및 모달 포함 --%>
    <jsp:include page="/WEB-INF/views/common/message.jsp"/>
    <jsp:include page="/WEB-INF/views/users/userModal.jsp"/>
	<jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp"/>
	
	
    <%-- 숨겨진 엑셀 업로드 폼 (기존 로직 유지) --%>
    <form id="excelUploadForm" action="${pageContext.request.contextPath}/users/upload" method="post" enctype="multipart/form-data" style="display:none;">
        <input type="file" id="excelFileInput" name="file" accept=".xls,.xlsx" onchange="submitExcelForm()"/>
    </form>
<script>
    /**
     * [Step 1] 서버에서 넘어온 데이터를 JSON으로 변환
     */
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

    /**
     * [Step 2] 그리드 초기화
     */
    document.addEventListener('DOMContentLoaded', function() {
    	const filterSelect = document.getElementById('dg-common-filter');
        
        // 첫 번째 옵션이 레이블 역할을 대신함
        const options = [
            { value: "", text: "전체" }, 
            { value: "ACTIVE", text: "ACTIVE" },
            { value: "SLEEP", text: "SLEEP" },
        ];

        options.forEach(opt => {
            filterSelect.add(new Option(opt.text, opt.value));
        });

        // 필터 값이 있으면 노출
        document.getElementById('dg-common-filter-wrapper').classList.remove('hidden');
    	
        const userGrid = new DataGrid({
            containerId: 'dg-container',
            searchId: 'dg-search-input',
            perPageId: 'dg-per-page',
            btnSearchId: 'dg-btn-search',
            
       		  // [수정 포인트] 위에서 정의한 셀렉트 박스 ID와 똑같이 맞춰야 합니다!
            filterField: 'accStatus',
            filterSelectId: 'dg-common-filter',
            
            columns: [
                { header: 'ID', name: 'userId'},
                { header: '이름', name: 'userName'},
                { header: '전화번호', name: 'phone'},
                { header: '계정 상태', name: 'accStatus', align: 'center'},
                { header: '등록일', name: 'regDtime', align: 'center'},
                { 
                    header: '관리', 
                    name: 'manage', 
                    align: 'center',
                    sortable: false,
                    renderer: { 
                    	type: CustomActionRenderer,
                    	options: {
                            btnText: '수정' // 여기서 텍스트 변경
                        }
                    }
                }
            ],
            data: rawData
        });
    });
    
 	// 조회 버튼 클릭 시 실행될 함수
    window.fetchData = function() {
        const keyword = document.getElementById('dg-search-input').value;
        // 실제로는 여기서 DB 조회를 위한 페이지 리로드나 Ajax 호출이 들어가야 합니다.
        // 예: location.href = "/users/list?searchKeyword=" + keyword;
        location.href = "${pageContext.request.contextPath}/users/test?keyword=" + encodeURIComponent(keyword);
    };

    /**
     * [Step 3] 공통 버튼 동작 구현 (datagrid.jsp의 버튼과 매칭)
     */
    
  // 1. 등록 버튼
     function handleAddAction() {
         if(confirm("엑셀 파일로 사원을 대량 등록하시겠습니까?")) {
             document.getElementById("excelFileInput").click();
         }
     }

     // 2. 수정 모달 열기 (Renderer에서 직접 호출)
     window.handleGridAction = function(rowData) {
         console.log("모달로 전달된 데이터:", rowData);

         const fields = {
             "mUserNo": rowData.userNo,
             "mUserId": rowData.userId,
             "mUserName": rowData.userName,
             "mAccStatus": rowData.accStatus
         };

         for (const [id, value] of Object.entries(fields)) {
             const el = document.getElementById(id);
             if (el) {
                 el.value = value || ''; 
             } else {
                 console.warn("ID가 '" + id + "'인 엘리먼트를 찾을 수 없습니다.");
             }
         }

         const modal = document.getElementById("userModal");
         if (modal) {
             modal.style.display = "flex";
         }
     };

    /**
     * 사원 상태 수정 저장 (전역 함수 등록)
     */
    window.saveUser = function() {
        const status = document.getElementById("mAccStatus").value;

        // 퇴사(STOP) 시 한 번 더 확인
        if (status === 'STOP' && !confirm("퇴사 처리하시겠습니까?\n(다시 사용하려면 관리자 문의)")) {
            return;
        }

        // 서버로 데이터 전송
        fetch("${pageContext.request.contextPath}/users/modifyStatus", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: new URLSearchParams(new FormData(document.getElementById("userForm")))
        })
        .then(res => {
            if (!res.ok) throw new Error("서버 응답 오류");
            alert("수정되었습니다.");
            location.reload(); // 성공 시 화면 새로고침하여 반영된 데이터 확인
        })
        .catch((err) => {
            console.error(err);
            alert("수정 중 오류가 발생했습니다.");
        });
    };

    /**
     * 모달 닫기 (전역 함수 등록)
     */
    window.closeModal = function() {
        document.getElementById("userModal").style.display = "none";
    };

    // 엑셀 업로드 제출 로직 (기존 유지)
    function submitExcelForm() {
        const fileInput = document.getElementById("excelFileInput");
        if (fileInput.files.length > 0) {
            document.getElementById("excelUploadForm").submit();
        }
    }
  
</script>