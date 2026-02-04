<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

<div class="px-4 py-6 space-y-6">

    <div>
        <div>
            <h1 class="text-2xl font-bold text-gray-800 dark:text-white">${pageTitle}</h1>
        </div>
    </div>
    </div>    
    
	<c:set var="showSearchArea" value="false" scope="request" />
	<c:set var="showPerPage" value="false" scope="request" />
	
	<jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp"/>
<script>
	
	const rawData = [
		<c:forEach var="p" items="${pendingList}" varStatus="status">
		{
			userNo: "${p.userNo}",
			userId: "${p.userId}",
			userName: "${p.userName}",
			phone: "${p.phone}",
			appStatus: "${p.appStatus}",
			regDtime: "${p.regDtime}"
		}${!status.last ? ',' : ''}
		</c:forEach>
	];
	
	 document.addEventListener('DOMContentLoaded', function() {
	 
		const pendingGrid = new DataGrid({
			containerId: 'dg-container',
            
			columns: [
				{ header: '사원 ID', name: 'userId'},
				{ header: '이름', name: 'userName'},
				{ header: '전화번호', name: 'phone'},
				{ 
					header: '인증 상태',
					name: 'appStatus',
					align: 'center',
					renderer: { type: CustomStatusRenderer, options: { theme: 'appStatus' } }
				},
				{ header: '등록일', name: 'regDtime', align: 'center'},
				{ 
					header: '처리',
			    	name: 'pending',
			    	sortable: false,
			    	renderer: {
			    		type: CustomActionRenderer,
			    		options: {
			    			buttons: [
		                        { text: '승인', action: 'APPROVED', color: 'text-blue-500' },
		                        { text: '거부', action: 'REJECTED', color: 'text-red-500' }
		                    ]
			    		}
			    	}
				}
			],
			data: rawData
			});
		});
	 
	 window.handleGridAction = function(rowData, action) {
	        const userNo = rowData.userNo;
	        const userName = rowData.userName;

	        if (action === 'APPROVED') {
	            processUser(userNo, 'APPROVED', userName);
	        } else if (action === 'REJECTED') {
	            processUser(userNo, 'REJECTED', userName);
	        }
	    };

	    function processUser(userNo, appStatus, userName) {
	        const msg = appStatus === 'APPROVED' ? "승인" : "거부";
	        if (!confirm(userName + " 님을 " + msg + "하시겠습니까?")) return;
	    
	        fetch("${pageContext.request.contextPath}/users/pendingAction", {
	            method: "POST",
	            headers: { "Content-Type": "application/x-www-form-urlencoded" },
	            body: new URLSearchParams({
	                userNo: userNo,
	                appStatus: appStatus
	            })
	        })
	        .then(res => {
	            if (!res.ok) throw new Error();
	            alert(msg + " 처리되었습니다.");
	            location.reload();
	        })
	        .catch(() => alert(msg + " 처리 실패"));
	    }
</script>

