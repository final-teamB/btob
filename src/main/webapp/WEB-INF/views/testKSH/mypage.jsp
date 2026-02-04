<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- [1] 레이아웃 설정: 상단바 및 기본 버튼 설정 (datagrid.jsp의 스타일 가이드 적용) --%>
<c:set var="showSearchArea" value="false" scope="request" />
<c:set var="showAddBtn" value="false" scope="request" />

<div class="mx-4 my-6 space-y-6">
    <%-- [2] 타이틀 영역: adminFaqList.jsp와 동일한 간격 및 폰트 적용 [cite: 1] --%>
    <div class="px-5 py-4 pb-0 flex justify-between items-center">
        <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">내 정보 수정</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">회원님의 개인정보를 안전하게 확인하고 수정할 수 있습니다.</p>
        </div>
        <%-- 편집 모드로 전환하는 액션 버튼 --%>
        <div id="action-buttons">
            <button type="button" id="btn-edit-start"
                    class="px-4 py-2 bg-indigo-600 text-white rounded-lg font-bold hover:bg-indigo-700 transition shadow-sm" 
                    onclick="enableEdit()">
                정보 수정하기
            </button>
        </div>
    </div>

    <%-- [3] 정보 카드 영역: 데이터 그리드 컨테이너와 동일한 쉐도우 및 테두리 적용 --%>
    <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 overflow-hidden mx-5">
        <form action="/mypage/update" method="post" id="profileForm" class="p-8 space-y-8">
            
            <%-- 기본 인적사항 섹션 --%>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-x-12 gap-y-6">
                <div class="space-y-2">
                    <label class="block text-sm font-bold text-gray-700 dark:text-gray-300">이름</label>
                    <input type="text" class="editable w-full p-2.5 border border-gray-300 rounded-lg bg-gray-50 text-gray-500" 
                           name="userName" value="${user.userName}" disabled>
                </div>
                <div class="space-y-2">
                    <label class="block text-sm font-bold text-gray-700 dark:text-gray-300">이메일 (ID)</label>
                    <input type="email" class="w-full p-2.5 border border-gray-300 rounded-lg bg-gray-100 text-gray-400 cursor-not-allowed" 
                           value="${user.email}" readonly>
                    <input type="hidden" name="email" value="${user.email}">
                </div>
                <div class="space-y-2">
                    <label class="block text-sm font-bold text-gray-700 dark:text-gray-300">연락처</label>
                    <input type="tel" class="editable w-full p-2.5 border border-gray-300 rounded-lg bg-gray-50 text-gray-500" 
                           name="phone" value="${user.phone}" placeholder="010-0000-0000" disabled>
                </div>
                <div class="space-y-2">
                    <label class="block text-sm font-bold text-gray-700 dark:text-gray-300">직위</label>
                    <input type="text" class="editable w-full p-2.5 border border-gray-300 rounded-lg bg-gray-50 text-gray-500" 
                           name="position" value="${user.position}" disabled>
                </div>
            </div>

            <%-- 주소 정보 섹션 --%>
            <div class="space-y-4 pt-4 border-t border-gray-100 dark:border-gray-700">
                <label class="block text-sm font-bold text-gray-700 dark:text-gray-300">주소 정보</label>
                <div class="flex gap-3">
                    <input type="text" class="w-32 p-2.5 border border-gray-300 rounded-lg bg-gray-100 text-gray-500" 
                           id="postcode" name="postcode" value="${user.postcode}" readonly>
                    <button type="button" id="searchAddrBtn" 
                            class="hidden px-4 py-2 bg-white border border-gray-300 rounded-lg text-sm font-medium text-gray-700 hover:bg-gray-50 transition"
                            onclick="execPostcode()">
                        주소 검색
                    </button>
                </div>
                <input type="text" class="w-full p-2.5 border border-gray-300 rounded-lg bg-gray-100 text-gray-500" 
                       id="address" name="address" value="${user.address}" readonly>
                <input type="text" class="editable w-full p-2.5 border border-gray-300 rounded-lg bg-gray-50 text-gray-500" 
                       name="detailAddress" value="${user.detailAddress}" placeholder="상세주소를 입력하세요" disabled>
            </div>

            <%-- 사업자 정보 (마스터 권한 전용) --%>
            <c:if test="${user.userType == 'MASTER'}">
            <div class="p-5 bg-blue-50 dark:bg-blue-900/20 rounded-xl border border-blue-100 dark:border-blue-800">
                <label class="block text-sm font-bold text-blue-700 dark:text-blue-300 mb-2">사업자 등록번호</label>
                <input type="text" class="editable w-full p-2.5 border border-blue-200 rounded-lg bg-white text-gray-700" 
                       name="businessNumber" value="${user.businessNumber}" placeholder="000-00-00000" disabled>
                <input type="hidden" name="isRepresentative" value="Y">
            </div>
            </c:if>

            <%-- 하단 버튼: 편집 모드 시에만 동적으로 노출 --%>
            <div id="edit-mode-footer" class="hidden pt-6 border-t border-gray-100 dark:border-gray-700 flex gap-4">
                <button type="button" 
                        class="flex-1 py-3 px-4 bg-white border border-gray-300 text-gray-700 font-bold rounded-lg hover:bg-gray-50 transition"
                        onclick="location.reload()">
                    취소하기
                </button>
                <button type="submit" 
                        class="flex-1 py-3 px-4 bg-green-600 hover:bg-green-700 text-white font-bold rounded-lg transition shadow-md">
                    변경사항 저장
                </button>
            </div>
        </form>
    </div>

    <%-- 메인으로 가기 [cite: 1] --%>
    <div class="text-center mt-8">
        <a href="/main" class="text-sm text-gray-500 hover:text-gray-800 underline underline-offset-4 transition">
            메인 페이지로 돌아가기
        </a>
    </div>
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    /**
     * 편집 모드 활성화 (adminFaqList.jsp의 handleAddAction 방식 차용) 
     */
    function enableEdit() {
        // [1] 모든 입력창 활성화 및 스타일 변경
        document.querySelectorAll('.editable').forEach(input => {
            input.disabled = false;
            input.classList.remove('bg-gray-50', 'text-gray-500');
            input.classList.add('bg-white', 'text-gray-900', 'border-indigo-300');
        });
        
        // [2] 상단 수정 버튼 숨기기
        document.getElementById('btn-edit-start').classList.add('hidden');
        
        // [3] 주소 검색 및 하단 저장 버튼 표시
        document.getElementById('searchAddrBtn').classList.remove('hidden');
        document.getElementById('edit-mode-footer').classList.remove('hidden');
        
        // 첫 번째 입력창에 포커스
        document.getElementsByName('userName')[0].focus();
    }

    /**
     * 다음 주소 API 연동
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

<style>
    /* adminFaqList.jsp 커스텀 스타일 연동  */
    input:focus {
        outline: none;
        border-color: #4f46e5 !important;
        box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
    }
    .editable:not(:disabled) {
        border-color: #d1d5db;
    }
</style>