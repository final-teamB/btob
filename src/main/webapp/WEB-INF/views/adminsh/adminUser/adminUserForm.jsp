<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- jQuery 로드 --%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<div class="mx-4 my-6 space-y-6">
    
    <%-- [1. 타이틀 영역] 다크모드 대응 --%>
    <div class="px-5 py-4 text-center">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">신규 관리자 등록</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">시스템 관리를 위한 신규 운영자 계정 정보를 입력해 주세요.</p>
    </div>

    <%-- [2. 입력 폼 영역] FAQ 페이지 스타일로 max-w-4xl 및 다크모드 적용 --%>
    <section class="max-w-4xl mx-auto p-8 bg-white rounded-xl shadow-sm border border-gray-100 dark:bg-gray-800 dark:border-gray-700">
        <form id="adminRegForm" class="space-y-6" autocomplete="off">
            <%-- 보안 토큰 --%>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="hidden" name="userType" value="ADMIN">

            <%-- 아이디 영역 --%>
            <div class="grid grid-cols-1 md:grid-cols-4 items-center gap-4">
                <label class="text-sm font-bold text-gray-700 dark:text-gray-300">관리자 아이디 <span class="text-red-500">*</span></label>
                <div class="md:col-span-3 flex gap-2">
                    <input type="text" id="userIdInput" name="userId" required
                           placeholder="아이디를 입력하세요."
                           class="flex-1 px-4 py-2 text-sm border border-gray-300 rounded-lg outline-none focus:ring-1 focus:ring-gray-900 dark:bg-gray-700 dark:text-white dark:border-gray-600 transition-all">
                    <button type="button" onclick="checkDuplicateId()" 
                            class="px-4 py-2 bg-gray-800 text-white text-sm rounded-lg hover:bg-black dark:bg-gray-600 dark:hover:bg-gray-500 transition-all">
                        중복확인
                    </button>
                </div>
            </div>

            <%-- 비밀번호 영역 --%>
            <div class="grid grid-cols-1 md:grid-cols-4 items-center gap-4 border-t border-gray-50 pt-6 dark:border-gray-700">
                <label class="text-sm font-bold text-gray-700 dark:text-gray-300">비밀번호 <span class="text-red-500">*</span></label>
                <div class="md:col-span-3">
                    <input type="password" name="password" required autocomplete="new-password"
                           placeholder="비밀번호를 입력하세요."
                           class="w-full px-4 py-2 text-sm border border-gray-300 rounded-lg outline-none focus:ring-1 focus:ring-gray-900 dark:bg-gray-700 dark:text-white dark:border-gray-600 transition-all">
                </div>
            </div>

            <%-- 이름 영역 --%>
            <div class="grid grid-cols-1 md:grid-cols-4 items-center gap-4 border-t border-gray-50 pt-6 dark:border-gray-700">
                <label class="text-sm font-bold text-gray-700 dark:text-gray-300">이름 (성함) <span class="text-red-500">*</span></label>
                <div class="md:col-span-3">
                    <input type="text" name="userName" required autocomplete="off"
                           placeholder="성함을 입력하세요."
                           class="w-full px-4 py-2 text-sm border border-gray-300 rounded-lg outline-none focus:ring-1 focus:ring-gray-900 dark:bg-gray-700 dark:text-white dark:border-gray-600 transition-all">
                </div>
            </div>

            <%-- 연락처 영역 --%>
            <div class="grid grid-cols-1 md:grid-cols-4 items-center gap-4 border-t border-gray-50 pt-6 dark:border-gray-700">
                <label class="text-sm font-bold text-gray-700 dark:text-gray-300">연락처</label>
                <div class="md:col-span-3">
                    <input type="text" name="phone" placeholder="010-0000-0000"
                           class="w-full px-4 py-2 text-sm border border-gray-300 rounded-lg outline-none focus:ring-1 focus:ring-gray-900 dark:bg-gray-700 dark:text-white dark:border-gray-600 transition-all">
                </div>
            </div>

            <%-- [3. 하단 액션 버튼] --%>
            <div class="flex justify-end space-x-3 pt-8 border-t border-gray-100 dark:border-gray-700">
                <%-- 취소 시 리스트로 이동 --%>
                <button type="button" onclick="location.href='${pageContext.request.contextPath}/admin/user/list?viewType=ADMIN'" 
                        class="px-6 py-2.5 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 dark:bg-gray-700 dark:text-gray-300 dark:hover:bg-gray-600 transition-all">
                    취소
                </button>
                <%-- 등록하기 버튼 (잔소리 로직 포함) --%>
                <button type="button" onclick="submitForm()" 
                        class="px-8 py-2.5 text-sm font-bold text-white bg-gray-900 rounded-lg hover:bg-gray-800 shadow-md dark:bg-blue-600 dark:hover:bg-blue-500 transition-all active:scale-95">
                    등록하기
                </button>
            </div>
        </form>
    </section>
</div>

<script>
let isIdChecked = false;

// 중복 확인
function checkDuplicateId() {
    const userId = $('#userIdInput').val().trim();
    if(!userId) { alert("아이디를 먼저 입력해주세요."); return; }

    $.ajax({
        url: "${pageContext.request.contextPath}/admin/user/checkDuplicateId",
        type: "GET",
        data: { userId: userId },
        success: function(isDuplicate) {
            if(isDuplicate) {
                alert("이미 사용 중인 아이디입니다.");
                isIdChecked = false;
            } else {
                alert("사용 가능한 아이디입니다.");
                isIdChecked = true;
            }
        },
        error: function() { alert("중복 체크 중 서버 에러 발생"); }
    });
}

// 아이디 입력 시 중복체크 상태 초기화
$('#userIdInput').on('input', function() {
    isIdChecked = false;
});

// 등록 실행
function submitForm() {
    const $form = $('#adminRegForm');
    const userId = $('#userIdInput').val().trim();
    const password = $form.find('[name="password"]').val().trim();
    const userName = $form.find('[name="userName"]').val().trim();

    // 1. 필수값 체크
    if(!userId) { alert("아이디를 입력하세요."); return; }
    if(!password) { alert("비밀번호를 입력하세요."); return; }
    if(!userName) { alert("이름을 입력하세요."); return; }

    // 2. 중복확인 체크
    if(!isIdChecked) {
        alert("아이디 중복확인을 진행해 주세요.");
        return;
    }

    if(!confirm("신규 관리자를 등록하시겠습니까?")) return;

    $.ajax({
        url: "${pageContext.request.contextPath}/admin/user/registerAdminUser",
        type: "POST",
        data: $form.serialize(),
        success: function(res) {
            if(res.trim() === "OK") {
                alert("성공적으로 등록되었습니다.");
                // 3. 등록 후 리스트로 이동
                location.href = "${pageContext.request.contextPath}/admin/user/list?viewType=ADMIN"; 
            } else {
                alert("등록 실패: " + res);
            }
        },
        error: function(xhr) { alert("서버 에러: " + xhr.status); }
    });
}
</script>