<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>거래 문서 목록</title>
</head>
<body>
	<h2>거래 문서 목록</h2>

	<table>
		<thead>
			<tr>
				<th>담당자</th>
				<th>문서번호</th>
				<th>문서유형</th>
				<th>등록일</th>
				<th>특이사항</th>
				<th>PDF</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="doc" items="${documentList}">
				<tr>
					<td>${doc.userName}</td>
					<td>${doc.docNo}</td>
					<td>${doc.docType}</td>
					<td>${doc.regDtime}</td>
					<td>
	                    <c:choose>
	                        <c:when test="${fn:length(doc.memo) > 5}">
	                            ${fn:substring(doc.memo, 0, 5)}..
	                        </c:when>
	                        <c:otherwise>
	                            ${doc.memo}
	                        </c:otherwise>
	                    </c:choose>
	                    <button 
						    data-doc-id="${doc.docId}"
						    data-memo="${doc.memo}"
						    onclick="openMemoModalFromBtn(this)">보기/수정
					    </button>
	                </td>
					<td>
					    <button onclick="previewPDF(${doc.docId})">PDF</button>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>

	<!-- 메모 모달 -->
	<div id="memoModal" class="modal">
		<div class="modal-box">
			<h3>특이사항 메모</h3>
			<form id="memoForm">
				<input type="hidden" id="mDocId" name="docId">
				<textarea id="mMemo" name="memo" rows="5" style="width: 100%;"></textarea>
				<div style="text-align: right; margin-top: 10px;">
					<button type="button" onclick="saveMemo()">저장</button>
					<button type="button" onclick="closeMemoModal()">취소</button>
				</div>
			</form>
		</div>
	</div>
	
<script>
	/* =========================
	   메모 모달
	========================= */
	function openMemoModalFromBtn(btn) {
	    const docId = btn.dataset.docId;
	    const memo = btn.dataset.memo;
	
	    document.getElementById("mDocId").value = docId;
	    document.getElementById("mMemo").value = memo || "";
	    document.getElementById("memoModal").style.display = "block";
	}
	
	function closeMemoModal() {
	    document.getElementById("memoModal").style.display = "none";
	}
	
	function saveMemo() {
	    const form = document.getElementById("memoForm");
	
	    fetch("${pageContext.request.contextPath}/documents/saveMemo", {
	        method: "POST",
	        headers: {
	            "Content-Type": "application/x-www-form-urlencoded"
	        },
	        body: new URLSearchParams(new FormData(form))
	    })
	    .then(res => {
	        if (!res.ok) throw new Error();
	        alert("메모가 저장되었습니다.");
	        location.reload(); // 리스트 갱신
	    })
	    .catch(() => alert("메모 저장 실패"));
	}
	
	/* =========================
	   PDF 미리보기 
	========================= */
	function previewPDF(docId) {
	    window.open(
	        "${pageContext.request.contextPath}/document/previewPDF?docId=" + docId,
	        "_blank"
	    );
	}
</script>
</body>
</html>