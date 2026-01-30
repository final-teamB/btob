<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>승인 대기자 목록</title>
</head>
<body>

<h2>승인 대기자 목록</h2>

<table>
    <thead>
        <tr>
            <th>사원 ID</th>
            <th>이름</th>
            <th>전화번호</th>
            <th>인증 상태</th>
            <th>등록일</th>
            <th>처리</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="p" items="${pendingList}">
            <tr>
                <td>${p.userId}</td>
                <td>${p.userName}</td>
                <td>${p.phone}</td>
                <td>${p.appStatus}</td>
                <td>${p.regDtime}</td>
                <td>
                    <button onclick="processUser('${p.userNo}', 'APPROVED')">승인</button>
                    <button onclick="processUser('${p.userNo}', 'REJECTED')">거부</button>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<script>
function processUser(userNo, appStatus) {
    const msg = appStatus === 'APPROVED' ? "승인" : "거부";
    if (!confirm(msg + "하시겠습니까?")) return;

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

</body>
</html>
