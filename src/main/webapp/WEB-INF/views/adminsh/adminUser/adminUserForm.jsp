<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- jQuery 로드 --%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<div class="p-2 space-y-4">
    <div class="px-2 pb-2">
        <h3 class="font-bold text-blue-600 border-b pb-1 text-sm uppercase">계정 기본 정보</h3>
        <p class="text-[12px] text-gray-500 mt-1">* 모든 항목은 필수 입력 사항입니다.</p>
    </div>

    <section class="bg-white dark:bg-gray-800">
        <form id="adminRegForm" class="space-y-5" autocomplete="off">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="hidden" name="userType" value="ADMIN">

            <div class="grid grid-cols-1 gap-y-4 px-2">
		    <%-- 아이디 영역 --%>
		    <div>
		        <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1">
		            관리자 아이디 <span class="text-red-500 ml-0.5">*</span>
		        </label>
		        <div class="flex gap-2">
		            <input type="text" id="userIdInput" name="userId" required
		                   placeholder="아이디를 입력하세요"
		                   class="flex-1 px-3 py-2 text-sm border border-gray-300 rounded-lg outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:text-white transition-all">
		            <button type="button" onclick="checkDuplicateId()" 
		                    class="px-4 py-2 bg-gray-100 border border-gray-300 text-gray-700 text-xs font-bold rounded-lg hover:bg-gray-200 transition-all">
		                중복확인
		            </button>
		        </div>
		        <%-- 아이디 관련 메시지 --%>
		        <p id="idCheckMsg" class="text-[11px] mt-1 hidden"></p>
		    </div>
		
		    <%-- 비밀번호 영역 --%>
		    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
		        <div>
		            <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1">
		                비밀번호 <span class="text-red-500 ml-0.5">*</span>
		            </label>
		            <input type="password" id="password" name="password" required autocomplete="new-password"
		                   placeholder="비밀번호를 입력하세요"
		                   class="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:text-white transition-all">
		        </div>
		        <div>
		            <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1">
		                비밀번호 확인 <span class="text-red-500 ml-0.5">*</span>
		            </label>
		            <input type="password" id="passwordConfirm" required autocomplete="new-password"
		                   placeholder="비밀번호를 한번 더 입력하세요"
		                   class="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:text-white transition-all">
		            <%-- 비밀번호 일치 메시지 --%>
		            <p id="passwordMatchMsg" class="text-[11px] mt-1 hidden"></p>
		        </div>
		    </div>
		
		    <%-- 이름 및 연락처 --%>
		    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
		        <div>
		            <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1">
		                관리자 이름 <span class="text-red-500 ml-0.5">*</span>
		            </label>
		            <input type="text" name="userName" id="userNameInput" required
		                   placeholder="성함을 입력하세요"
		                   class="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:text-white transition-all">
		            <p id="nameCheckMsg" class="text-[11px] mt-1 hidden text-red-500">이름을 입력해주세요.</p>
		        </div>
		        <div>
		            <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1">연락처</label>
		            <input type="text" name="phone"
		                   placeholder="010-0000-0000"
		                   class="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:text-white transition-all">
		        </div>
		    </div>
		</div>

            <div class="flex items-center p-4 border-t gap-2 mt-6">
                <button type="button" onclick="submitForm()" 
                        class="px-8 py-2 text-sm font-bold text-white bg-blue-600 rounded-lg hover:bg-blue-700 shadow-md transition-all active:scale-95">
                    관리자 등록
                </button>
                <button type="button" onclick="closeAdminRegModal()"
                        class="px-4 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-lg ml-auto hover:bg-gray-50 transition-all">
                    취소
                </button>
            </div>
        </form>
    </section>
</div>

<script>
let isIdChecked = false;
let isPasswordMatched = false;

// 공통 메시지 출력 함수
function displayMsg($el, msg, type) {
    $el.text(msg).removeClass('hidden text-red-500 text-blue-600');
    if (type === 'error') $el.addClass('text-red-500');
    else if (type === 'success') $el.addClass('text-blue-600');
}

// 아이디 중복확인
function checkDuplicateId() {
    const userId = $('#userIdInput').val().trim();
    const $msg = $('#idCheckMsg');
    
    if(!userId) { 
        displayMsg($msg, "아이디를 먼저 입력해주세요.", "error");
        return; 
    }

    $.ajax({
        url: "${pageContext.request.contextPath}/admin/user/checkDuplicateId",
        type: "GET",
        data: { userId: userId },
        success: function(isDuplicate) {
            if(isDuplicate) {
                displayMsg($msg, "이미 사용 중인 아이디입니다.", "error");
                isIdChecked = false;
            } else {
                displayMsg($msg, "사용 가능한 아이디입니다.", "success");
                isIdChecked = true;
            }
        },
        error: function() { 
            displayMsg($msg, "서버 에러가 발생했습니다.", "error");
        }
    });
}

// 입력 시 상태 초기화
$('#userIdInput').on('input', function() {
    isIdChecked = false;
    $('#idCheckMsg').addClass('hidden');
});

// 비밀번호 실시간 체크
function checkPasswordMatch() {
    const p1 = $('#password').val();
    const p2 = $('#passwordConfirm').val();
    const $msg = $('#passwordMatchMsg');

    if (!p1 || !p2) {
        $msg.addClass('hidden');
        isPasswordMatched = false;
        return;
    }

    if (p1 === p2) {
        displayMsg($msg, "비밀번호가 일치합니다.", "success");
        isPasswordMatched = true;
    } else {
        displayMsg($msg, "비밀번호가 일치하지 않습니다.", "error");
        isPasswordMatched = false;
    }
}

$('#password, #passwordConfirm').on('keyup input', function() {
    checkPasswordMatch();
});

// 이름 입력 시 에러메시지 숨김
$('#userNameInput').on('input', function() {
    $('#nameCheckMsg').addClass('hidden');
});

function submitForm() {
    const $form = $('#adminRegForm');
    const userId = $('#userIdInput').val().trim();
    const password = $('#password').val().trim();
    const userName = $('#userNameInput').val().trim();

    let hasError = false;

    // 아이디 체크
    if(!userId) {
        displayMsg($('#idCheckMsg'), "아이디를 입력하세요.", "error");
        hasError = true;
    } else if(!isIdChecked) {
        displayMsg($('#idCheckMsg'), "중복확인을 진행해 주세요.", "error");
        hasError = true;
    }

    // 비밀번호 체크
    if(!password) {
        displayMsg($('#passwordMatchMsg'), "비밀번호를 입력하세요.", "error");
        hasError = true;
    } else if(!isPasswordMatched) {
        displayMsg($('#passwordMatchMsg'), "비밀번호 확인이 일치하지 않습니다.", "error");
        hasError = true;
    }

    // 이름 체크
    if(!userName) {
        $('#nameCheckMsg').removeClass('hidden');
        hasError = true;
    }

    if(hasError) return;

    if(!confirm("신규 관리자를 등록하시겠습니까?")) return;

    $.ajax({
        url: "${pageContext.request.contextPath}/admin/user/registerAdminUser",
        type: "POST",
        data: $form.serialize(),
        success: function(res) {
            if(res.trim() === "OK") {
                alert("성공적으로 등록되었습니다.");
                closeAdminRegModal();
                location.reload();
            } else {
                displayMsg($('#idCheckMsg'), "등록 실패: " + res, "error");
            }
        },
        error: function(xhr) { 
            alert("서버 에러: " + xhr.status); 
        }
    });
}
</script>