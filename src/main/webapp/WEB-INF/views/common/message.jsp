<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${not empty insertedCount}">
    <div class="alert alert-success">
        ✔ 사원 ${insertedCount}명 등록이 완료되었습니다.
    </div>
</c:if>

<c:if test="${not empty error}">
    <div class="alert alert-error">
        ✖ ${error}
    </div>
</c:if>

<c:if test="${not empty failList}">
    <div class="upload-fail-box">
        <details open>
            <summary>엑셀 검증 오류 내역 (${fn:length(failList)}건)</summary>
            <table class="fail-table">
                <thead>
                    <tr>
                        <th>행 번호</th>
                        <th>사원 ID</th>
                        <th>오류 사유</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="fail" items="${failList}">
                        <tr>
                            <td>${fail.rowNum}</td>
                            <td>${fail.userId}</td>
                            <td>${fail.reason}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </details>
    </div>
</c:if>
