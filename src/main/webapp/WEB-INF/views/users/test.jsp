<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/modal.css">
    
    <%-- 1. 화면 제목 --%>
    <div class="px-4 py-6 space-y-6">
        <div>
            <div
            class="text-2xl font-bold text-gray-800 dark:text-white">${pageTitle}
            </div>
        </div>
    </div>    

    <c:set var="showAddBtn" value="true" scope="request" />
    <c:set var="showDownloadBtn" value="true" scope="request" />

    <%-- 2. 공통 컴포넌트 포함 --%>
    <jsp:include page="/WEB-INF/views/common/message.jsp"/>
    <jsp:include page="/WEB-INF/views/users/userModal.jsp"/>
    <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp"/>
    
    <%-- 숨겨진 엑셀 업로드 폼 --%>
    <form id="excelUploadForm" action="${pageContext.request.contextPath}/users/upload" method="post" enctype="multipart/form-data" style="display:none;">
        <input type="file" id="excelFileInput" name="file" accept=".xls,.xlsx" onchange="submitExcelForm()"/>
    </form>

<script>
    /**
     * [Step 1] 서버에서 넘어온 데이터 JSON 변환
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

     document.addEventListener('DOMContentLoaded', function() {
          
        const userGrid = new DataGrid({
             containerId: 'dg-container',
             searchId: 'dg-search-input',
             perPageId: 'dg-per-page',
             btnSearchId: 'dg-btn-search',
             columns: [
                 { header: 'ID', name: 'userId'},	
                 { header: '이름', name: 'userName'},
                 { header: '전화번호', name: 'phone'},
                 {
                     header: '계정상태',
                     name: 'accStatus',
                     align: 'center',
                     renderer: { type: CustomStatusRenderer, options: { theme: 'accStatus' } }
                 },
                 { header: '등록일', name: 'regDtime', align: 'center'},
                 { header: '관리', name: 'manage', align: 'center', renderer: { type: CustomActionRenderer } }
             ],
             data: rawData
         });
        userGrid.initFilters([
             { field: 'userName', title: '이름' },
             { field: 'accStatus', title: '상태' } // 필드값 options 로 설정가능
         ]);
     });

     // 조회 함수
     window.fetchData = function() {
         const keyword = document.getElementById('dg-search-input')?.value || '';
         const userName = document.getElementById('filter-userName')?.value || '';
         const accStatus = document.getElementById('filter-accStatus')?.value || '';

         let url = window.location.pathname + "?keyword=" + encodeURIComponent(keyword);
         if (userName) url += "&userName=" + encodeURIComponent(userName);
         if (accStatus) url += "&accStatus=" + encodeURIComponent(accStatus);
         
         location.href = url;
     };
    /**
     * [Step 4] 모달 및 기타 액션
     */
    window.handleGridAction = function(rowData) {
        const fields = {
            "mUserNo": rowData.userNo,
            "mUserId": rowData.userId,
            "mUserName": rowData.userName,
            "mAccStatus": rowData.accStatus
        };
        for (const [id, value] of Object.entries(fields)) {
            const el = document.getElementById(id);
            if (el) el.value = value || ''; 
        }
        document.getElementById("userModal").style.display = "flex";
    };

    window.saveUser = function() {
        const status = document.getElementById("mAccStatus").value;
        if (status === 'STOP' && !confirm("퇴사 처리하시겠습니까?")) return;

        fetch("${pageContext.request.contextPath}/users/modifyStatus", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: new URLSearchParams(new FormData(document.getElementById("userForm")))
        })
        .then(res => {
            if (!res.ok) throw new Error("오류");
            alert("수정되었습니다.");
            location.reload(); 
        })
        .catch(err => alert("오류 발생"));
    };

    window.closeModal = function() {
        document.getElementById("userModal").style.display = "none";
    };

    function handleAddAction() {
        if(confirm("사원을 대량 등록하시겠습니까?")) {
            document.getElementById("excelFileInput").click();
        }
    }

    function submitExcelForm() {
        if (document.getElementById("excelFileInput").files.length > 0) {
            document.getElementById("excelUploadForm").submit();
        }
    }
</script>