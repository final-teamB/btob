<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<div class="p-2 space-y-2">
    <div class="px-2 pb-1 border-b">
        <h3 class="font-bold text-blue-600 text-sm uppercase">계정 기본 정보</h3>
        <p class="text-[12px] text-gray-400 mt-1">* 모든 항목은 필수 입력 사항입니다.</p>
    </div>

    <section class="bg-white">
        <form id="adminRegForm" class="space-y-3" autocomplete="off">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="hidden" name="userType" value="ADMIN">

            <div class="grid grid-cols-1 gap-y-2 px-2">
                <%-- 아이디 --%>
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1">
                        관리자 아이디 <span class="text-red-500">*</span>
                    </label>
                    <div class="flex gap-2">
                        <input type="text" id="userIdInput" name="userId" required
                               placeholder="아이디를 입력하세요"
                               class="flex-1 px-3 py-2.5 text-sm border border-gray-300 rounded-lg outline-none focus:ring-1 focus:ring-blue-500 transition-all">
                        <button type="button" onclick="checkDuplicateId()"
                                class="px-4 py-2 bg-gray-100 border border-gray-300 text-gray-700 text-xs font-bold rounded-lg hover:bg-gray-200 transition-all">
                            중복확인
                        </button>
                    </div>
                    <p id="idCheckMsg" class="text-[11px] mt-1 hidden"></p>
                </div>

                <%-- 비밀번호 --%>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">
                            비밀번호 <span class="text-red-500">*</span>
                        </label>
                        <input type="password" id="password" name="password" required autocomplete="new-password"
                               placeholder="비밀번호를 입력하세요"
                               class="w-full px-3 py-2.5 text-sm border border-gray-300 rounded-lg outline-none focus:ring-1 focus:ring-blue-500 transition-all">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">
                            비밀번호 확인 <span class="text-red-500">*</span>
                        </label>
                        <input type="password" id="passwordConfirm" required autocomplete="new-password"
                               placeholder="한번 더 입력하세요"
                               class="w-full px-3 py-2.5 text-sm border border-gray-300 rounded-lg outline-none focus:ring-1 focus:ring-blue-500 transition-all">
                        <p id="passwordMatchMsg" class="text-[11px] mt-1 hidden"></p>
                    </div>
                </div>

                <%-- 이름 및 연락처 --%>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">
                            관리자 이름 <span class="text-red-500">*</span>
                        </label>
                        <input type="text" name="userName" id="userNameInput" required
                               placeholder="성함을 입력하세요"
                               class="w-full px-3 py-2.5 text-sm border border-gray-300 rounded-lg outline-none focus:ring-1 focus:ring-blue-500 transition-all">
                        <p id="nameCheckMsg" class="text-[11px] mt-1 hidden text-red-500">이름을 입력해주세요.</p>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">연락처</label>
                        <input type="text" name="phone"
                               placeholder="010-0000-0000"
                               class="w-full px-3 py-2.5 text-sm border border-gray-300 rounded-lg outline-none focus:ring-1 focus:ring-blue-500 transition-all">
                    </div>
                </div>
            </div>

            <%-- 하단 액션바 --%>
            <div class="flex items-center justify-between p-4 border-t mt-3">
                <button type="button" onclick="submitForm()"
                        class="px-10 py-2.5 text-sm font-bold text-white bg-blue-600 rounded-lg hover:bg-blue-700 shadow-md transition-all active:scale-95">
                    관리자 등록
                </button>
                <button type="button" onclick="closeAdminRegModal()"
                        class="px-6 py-2.5 text-sm font-medium text-gray-500 bg-white border border-gray-200 rounded-lg hover:bg-gray-50 transition-all shadow-sm">
                    취소
                </button>
            </div>
        </form>
    </section>
</div>

<script>
let isIdChecked = false;
let isPasswordMatched = false;

function displayMsg($el, msg, type) {
    $el.text(msg).removeClass('hidden text-red-500 text-blue-600');
    if (type === 'error') $el.addClass('text-red-500');
    else if (type === 'success') $el.addClass('text-blue-600');
}

function checkDuplicateId() {
    const userId = $('#userIdInput').val().trim();
    const $msg = $('#idCheckMsg');
    if (!userId) { displayMsg($msg, "아이디를 먼저 입력해주세요.", "error"); return; }
    $.ajax({
        url: "${pageContext.request.contextPath}/admin/user/checkDuplicateId",
        type: "GET",
        data: { userId },
        success: function(isDuplicate) {
            if (isDuplicate) { displayMsg($msg, "이미 사용 중인 아이디입니다.", "error"); isIdChecked = false; }
            else { displayMsg($msg, "사용 가능한 아이디입니다.", "success"); isIdChecked = true; }
        },
        error: function() { displayMsg($msg, "서버 에러가 발생했습니다.", "error"); }
    });
}

$('#userIdInput').on('input', function() { isIdChecked = false; $('#idCheckMsg').addClass('hidden'); });

function checkPasswordMatch() {
    const p1 = $('#password').val(), p2 = $('#passwordConfirm').val();
    const $msg = $('#passwordMatchMsg');
    if (!p1 || !p2) { $msg.addClass('hidden'); isPasswordMatched = false; return; }
    if (p1 === p2) { displayMsg($msg, "비밀번호가 일치합니다.", "success"); isPasswordMatched = true; }
    else { displayMsg($msg, "비밀번호가 일치하지 않습니다.", "error"); isPasswordMatched = false; }
}

$('#password, #passwordConfirm').on('keyup input', checkPasswordMatch);
$('#userNameInput').on('input', function() { $('#nameCheckMsg').addClass('hidden'); });

function submitForm() {
    const userId = $('#userIdInput').val().trim();
    const password = $('#password').val().trim();
    const userName = $('#userNameInput').val().trim();
    let hasError = false;

    if (!userId) { displayMsg($('#idCheckMsg'), "아이디를 입력하세요.", "error"); hasError = true; }
    else if (!isIdChecked) { displayMsg($('#idCheckMsg'), "중복확인을 진행해 주세요.", "error"); hasError = true; }

    if (!password) { displayMsg($('#passwordMatchMsg'), "비밀번호를 입력하세요.", "error"); hasError = true; }
    else if (!isPasswordMatched) { displayMsg($('#passwordMatchMsg'), "비밀번호 확인이 일치하지 않습니다.", "error"); hasError = true; }

    if (!userName) { $('#nameCheckMsg').removeClass('hidden'); hasError = true; }
    if (hasError) return;
    if (!confirm("신규 관리자를 등록하시겠습니까?")) return;

    $.ajax({
        url: "${pageContext.request.contextPath}/admin/user/registerAdminUser",
        type: "POST",
        data: $('#adminRegForm').serialize(),
        success: function(res) {
            if (res.trim() === "OK") { alert("성공적으로 등록되었습니다."); closeAdminRegModal(); location.reload(); }
            else { displayMsg($('#idCheckMsg'), "등록 실패: " + res, "error"); }
        },
        error: function(xhr) { alert("서버 에러: " + xhr.status); }
    });
}
</script>