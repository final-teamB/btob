<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div style="margin-bottom: 20px;">
    <form action="/admin/chat/faqList" method="get">
        <select name="category">
            <option value="">전체 카테고리</option>
            <option value="DELIVERY" ${param.category == 'DELIVERY' ? 'selected' : ''}>배송</option>
            <option value="PAYMENT" ${param.category == 'PAYMENT' ? 'selected' : ''}>결제</option>
            <option value="PRODUCT" ${param.category == 'PRODUCT' ? 'selected' : ''}>상품</option>
            <option value="ETC" ${param.category == 'ETC' ? 'selected' : ''}>기타</option>
        </select>

        <input type="text" name="searchKeyword" value="${param.searchKeyword}" placeholder="질문 또는 답변 검색">
        
        <button type="submit">검색</button>
        <button type="button" onclick="location.href='/admin/chat/faqList'">초기화</button>
    </form>
</div>

<button onclick="location.href='/admin/chat/registerFaq'">등록</button>
<table border="1" style="width:100%; border-collapse:collapse;">
    <tr><th>카테고리</th><th>질문</th><th>관리</th></tr>
    <c:forEach var="f" items="${faqList}">
        <tr>
            <td>
                <c:choose>
                    <c:when test="${f.category == 'DELIVERY'}">배송</c:when>
                    <c:when test="${f.category == 'PAYMENT'}">결제</c:when>
                    <c:when test="${f.category == 'PRODUCT'}">상품</c:when>
                    <c:otherwise>기타</c:otherwise>
                </c:choose>
            </td>
            <td><a href="/admin/chat/modifyFaq/${f.faqId}">${f.question}</a></td>
            <td><button onclick="del(${f.faqId})">삭제</button></td>
        </tr>
    </c:forEach>
</table>
<script>
    // 등록 수정 성공 알림
    const msg = "${msg}";
    if(msg) alert(msg);

    // 삭제
    fetch('/admin/chat/removeFaq', {
	    method: 'POST',
	    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
	    body: 'faqId=' + id
	})
	.then(res => res.json())
	.then(result => {
	    if(result) {
	        alert("삭제되었습니다.");
	        location.reload();
	    } else {
	        alert("삭제 실패하였습니다.");
	    }
	});
</script>