<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- [1] 레이아웃 설정: 검색창은 쓰되, 신규 등록 버튼(showAddBtn)은 false로 끔 --%>
<c:set var="showSearchArea" value="true" scope="request" />
<c:set var="showAddBtn" value="false" scope="request" />

<div class="mx-4 my-6 space-y-6">
    <%-- [2] 타이틀 영역: '관리' 글자 빼고 깔끔하게 --%>
    <div class="px-5 py-4 pb-0">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">공지사항</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">시스템의 최신 소식을 확인하세요.</p>
    </div>

    <%-- [3] 데이터 그리드 인클루드 --%>
    <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp"/>
</div>

<%-- [4] 모달 영역은 사용자에게 필요 없으니 아예 삭제 --%>

<script>
    const rawData = [
        <c:forEach var="item" items="${noticeList}" varStatus="status">
        {
            noticeId: "${item.noticeId}",
            title: `<c:out value="${item.title}"/>`,
            displayRegId: "관리자", <%-- 사용자용에선 작성자 ID 대신 그냥 '관리자'로 퉁쳐도 됩니다 --%>
            regDtime: "${item.formattedRegDate}",
            viewCount: "${item.viewCount}"
        }${!status.last ? ',' : ''}
        </c:forEach>
    ];

    document.addEventListener('DOMContentLoaded', function() {
        // [5] 그리드 초기화
        const noticeGrid = new DataGrid({
            containerId: 'dg-container',
            searchId: 'dg-search-input',
            btnSearchId: 'dg-btn-search',
            perPageId: 'dg-per-page',
            columns: [
            	{ header: '번호', name: 'noticeId', width: 80, align: 'center', sortable: true },
                { header: '제목', name: 'title', align: 'left', sortable: true },
                { header: '등록일', name: 'regDtime', width: 150, align: 'center', sortable: true },
                { header: '조회수', name: 'viewCount', width: 100, align: 'center', sortable: true }
            ],
            data: rawData
        });

        // [6] 검색 로직
        document.getElementById('dg-btn-search').addEventListener('click', function() {
            const keyword = document.getElementById('dg-search-input').value.toLowerCase();
            const filtered = rawData.filter(item => 
                item.title.toLowerCase().includes(keyword)
            );
            noticeGrid.grid.resetData(filtered);
        });

        // [7] 행 클릭 시 상세 페이지(조회용)로 이동
        noticeGrid.grid.on('click', (ev) => {
            const rowData = noticeGrid.grid.getRow(ev.rowKey);
            if (rowData) {
                // 관리자용 /edit/ 대신 사용자용 /user/detail/ 경로 사용!
                location.href = '/notice/user/detail/' + rowData.noticeId;
            }
        });
    });
</script>

<style>
    .tui-grid-cell { cursor: pointer !important; }
</style>