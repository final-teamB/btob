<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- [1] 공통 그리드 레이아웃 설정 유지 --%>
<c:set var="showSearchArea" value="false" scope="request" />
<c:set var="showAddBtn" value="false" scope="request" />

<div class="mx-4 my-6 space-y-6">
    <%-- [2] 상단 타이틀 및 액션 버튼 --%>
    <div class="px-5 py-4 pb-0 flex justify-between items-center">
        <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">마이페이지</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
                <c:choose>
                    <c:when test="${user.userType == 'MASTER'}">대표자 정보 및 사업장 주소를 관리합니다.</c:when>
                    <c:otherwise>개인 정보 및 거주지 주소를 관리합니다.</c:otherwise>
                </c:choose>
            </p>
        </div>
        <div id="action-buttons">
            <button type="button" id="btn-edit-start" onclick="enableEditMode()"
                    class="px-4 py-2 bg-indigo-600 text-white rounded-lg font-bold hover:bg-indigo-700 transition shadow-sm">
                <i class="bi bi-pencil-square mr-2"></i>수정하기
            </button>
        </div>
    </div>

    <%-- [3] 수정 폼 --%>
    <form action="/mypage/update" method="post" id="mypageForm">
        <input type="hidden" name="email" value="${user.email}">
        
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 px-5">
            
            <%-- [섹션 1] 기본 인적 정보 --%>
            <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm overflow-hidden">
                <div class="px-6 py-4 border-b border-gray-100 dark:border-gray-700 bg-gray-50/50 dark:bg-gray-700/30">
                    <h3 class="text-lg font-bold text-gray-800 dark:text-white flex items-center">
                        <i class="bi bi-person-circle mr-2 text-indigo-500"></i>기본 정보
                    </h3>
                </div>
                <div class="p-6 space-y-4">
                    <div class="grid grid-cols-4 items-center">
                        <label class="text-sm font-semibold text-gray-600 dark:text-gray-400">성함</label>
                        <input type="text" name="userName" value="${user.userName}" disabled 
                               class="editable col-span-3 px-4 py-2 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-lg">
                    </div>
                    <div class="grid grid-cols-4 items-center">
                        <label class="text-sm font-semibold text-gray-600 dark:text-gray-400">연락처</label>
                        <input type="tel" name="phone" value="${user.phone}" disabled 
                               class="editable col-span-3 px-4 py-2 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-lg">
                    </div>
                    <div class="grid grid-cols-4 items-center">
                        <label class="text-sm font-semibold text-gray-600 dark:text-gray-400">직위</label>
                        <input type="text" name="position" value="${user.position}" disabled 
                               class="editable col-span-3 px-4 py-2 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-lg">
                    </div>
                </div>
            </div>

            <%-- [섹션 2] 주소 정보 (대표는 회사주소, 일반은 거주지주소) --%>
            <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm overflow-hidden">
                <div class="px-6 py-4 border-b border-gray-100 dark:border-gray-700 bg-gray-50/50 dark:bg-gray-700/30">
                    <h3 class="text-lg font-bold text-gray-800 dark:text-white flex items-center">
                        <i class="bi bi-geo-alt-fill mr-2 text-indigo-500"></i>
                        <c:out value="${user.userType == 'MASTER' ? '사업장 주소' : '거주지 정보'}" />
                    </h3>
                </div>
                <div class="p-6 space-y-4">
                    <div class="grid grid-cols-4 gap-2">
                        <label class="text-sm font-semibold text-gray-600 dark:text-gray-400 self-center">우편번호</label>
                        <input type="text" id="postcode" name="postcode" value="${user.postcode}" readonly 
                               class="col-span-2 px-4 py-2 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-lg text-gray-500">
                        <button type="button" id="searchAddrBtn" onclick="execPostcode()" 
                                class="hidden px-2 py-2 bg-gray-800 text-white rounded-lg text-xs font-bold hover:bg-black transition">검색</button>
                    </div>
                    <input type="text" id="address" name="address" value="${user.address}" readonly 
                           class="w-full px-4 py-2 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-lg text-gray-500" placeholder="기본 주소">
                    <input type="text" name="detailAddress" value="${user.detailAddress}" disabled 
                           class="editable w-full px-4 py-2 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-lg" placeholder="상세 주소">
                </div>
            </div>

            <%-- [섹션 3] 대표자 전용 사업자 정보 --%>
            <c:if test="${user.userType == 'MASTER'}">
            <div class="lg:col-span-2 bg-indigo-50/30 dark:bg-indigo-900/10 rounded-xl border border-indigo-100 dark:border-indigo-900 shadow-sm overflow-hidden">
                <div class="px-6 py-4 border-b border-indigo-100 dark:border-indigo-900 bg-indigo-50/50 dark:bg-indigo-900/20">
                    <h3 class="text-lg font-bold text-indigo-800 dark:text-indigo-300 flex items-center">
                        <i class="bi bi-building mr-2"></i>회사 기본 정보
                    </h3>
                </div>
                <div class="p-6 grid grid-cols-1 md:grid-cols-2 gap-8">
                    <div class="grid grid-cols-4 items-center">
                        <label class="text-sm font-semibold text-gray-600 dark:text-gray-400">회사명</label>
                        <input type="text" name="companyName" value="${user.companyName}" disabled 
                               class="editable col-span-3 px-4 py-2 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-lg">
                    </div>
                    <div class="grid grid-cols-4 items-center">
                        <label class="text-sm font-semibold text-gray-600 dark:text-gray-400">사업자번호</label>
                        <input type="text" name="businessNumber" value="${user.businessNumber}" disabled 
                               class="editable col-span-3 px-4 py-2 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-lg">
                    </div>
                </div>
            </div>
            </c:if>
        </div>

        <%-- 저장 및 취소 버튼 --%>
        <div id="edit-mode-footer" class="hidden mt-8 px-5 pb-10 flex justify-center gap-4">
            <button type="button" onclick="location.reload()" 
                    class="px-8 py-3 bg-white border border-gray-300 text-gray-700 rounded-xl font-bold hover:bg-gray-50 transition">취소</button>
            <button type="submit" 
                    class="px-12 py-3 bg-indigo-600 text-white rounded-xl font-bold hover:bg-indigo-700 transition shadow-lg shadow-indigo-200">수정 사항 저장</button>
        </div>
    </form>
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    /**
     * 편집 모드 활성화 함수
     */
    function enableEditMode() {
        // 모든 editable 클래스 요소 활성화 및 배경색 변경
        document.querySelectorAll('.editable').forEach(input => {
            input.disabled = false;
            input.classList.remove('bg-gray-50');
            input.classList.add('bg-white', 'border-indigo-300');
        });
        
        // 버튼 및 푸터 제어
        document.getElementById('btn-edit-start').classList.add('hidden');
        document.getElementById('edit-mode-footer').classList.remove('hidden');
        document.getElementById('searchAddrBtn').classList.remove('hidden');
        
        // 포커스 이동
        document.getElementsByName('userName')[0].focus();
    }

    /**
     * 주소 API 연동
     */
    function execPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                let addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
                document.getElementById("postcode").value = data.zonecode;
                document.getElementById("address").value = addr;
                document.getElementsByName('detailAddress')[0].focus();
            }
        }).open();
    }
</script>