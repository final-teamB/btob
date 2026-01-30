<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
	<meta charset="UTF-8">
    <title>사원 목록</title>
    
</head>
<body>

	<jsp:include page="/WEB-INF/views/common/message.jsp"/>
	<jsp:include page="/WEB-INF/views/users/userModal.jsp"/>
	<jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp"/>
	
	<h2>사원 목록</h2>
	
	<form id="searchForm" method="get" action="${pageContext.request.contextPath}/users/list" class="search-box">
	    <!-- 엑셀 업로드 트리거 버튼 -->
	    <button type="button" onclick="triggerExcelUpload()">사원 등록 (엑셀)</button>
	
	    <select name="accStatus">
	        <option value="">전체</option>
	        <option value="ACTIVE" ${param.accStatus == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
	        <option value="SLEEP" ${param.accStatus == 'SLEEP' ? 'selected' : ''}>SLEEP</option>
	    </select>
	
	    <input type="text" name="keyword"
	           value="${param.keyword}"
	           placeholder="이름 또는 이메일">
	
	    <button type="submit">검색</button>
	</form>
	
	<form id="excelUploadForm"
      action="${pageContext.request.contextPath}/users/upload"
      method="post"
      enctype="multipart/form-data"
      style="display:none;">

    <input type="file"
           id="excelFileInput"
           name="file"
           accept=".xls,.xlsx"
           onchange="submitExcelForm()"/>
	</form>
	
	
	<table>
	    <thead>
	        <tr>
	            <th>ID</th>
	            <th>이름</th>
	            <th>전화번호</th>
	            <th>계정 상태</th>
	            <th>등록일</th>
	            <th>관리</th>
	        </tr>
	    </thead>
	    <tbody>
	        <c:forEach var="user" items="${userList}">
	            <tr>
	                <td>${user.userId}</td>
	                <td>${user.userName}</td>
	                <td>${user.phone}</td>
	                <td>${user.accStatus}</td>
	                <td>${user.regDtime}</td>
	                <td>
		                <button type="button"
						    data-no="${user.userNo}"
						    data-id="${user.userId}"
						    data-name="${user.userName}"
						    data-status="${user.accStatus}"
						    onclick="openUserModal(this)">
						    수정
						</button>
	                </td>
	              </tr>
	        </c:forEach>
	    </tbody>
	</table>
<script>
	// 엑셀 등록 모달
	function triggerExcelUpload() {
    document.getElementById("excelFileInput").click();
	}
	
	function submitExcelForm() {
	    const fileInput = document.getElementById("excelFileInput");
	
	    if (!fileInput.files || fileInput.files.length === 0) {
	        return;
	    }
	
	    if (!confirm("선택한 엑셀 파일로 사원을 등록하시겠습니까?")) {
	        fileInput.value = "";
	        return;
	    }
		
	    document.getElementById("excelUploadForm").submit();
	}
	
	// 수정 모달
	function openUserModal(btn) {
	    document.getElementById("mUserNo").value = btn.dataset.no;
	    document.getElementById("mUserId").value = btn.dataset.id;
	    document.getElementById("mUserName").value = btn.dataset.name;
	    document.getElementById("mAccStatus").value = btn.dataset.status;
	
	    document.getElementById("userModal").style.display = "flex";
	}
	
	// 취소
	function closeModal() {
	    document.getElementById("userModal").style.display = "none";
	}
	
	document.getElementById("userModal").addEventListener("click", e => {
	    if (e.target.classList.contains("modal")) {
	        closeModal();
	    }
	});
	
	document.addEventListener("keydown", e => {
	    if (e.key === "Escape") {
	        closeModal();
	    }
	});
	
	// 저장
	function saveUser() {
	    const status = document.getElementById("mAccStatus").value;
	
	    if (status === 'STOP' && !confirm("퇴사 처리하시겠습니까?\n(다시 사용하려면 관리자 문의)")) {
	        return;
	    }
	
	    fetch("${pageContext.request.contextPath}/users/modifyStatus", {
	        method: "POST",
	        headers: { "Content-Type": "application/x-www-form-urlencoded" },
	        body: new URLSearchParams(
	            new FormData(document.getElementById("userForm"))
	        )
	    })
	    .then(res => {
	        if (!res.ok) throw new Error();
	        alert("수정되었습니다.");
	        location.reload();
	    })
	    .catch(() => alert("수정 실패"));
	}
</script>

</body>
</html>