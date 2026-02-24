<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="showSearchArea" value="false" scope="request" />
<c:set var="showAddBtn" value="false" scope="request" />

<div class="mx-4 my-6 space-y-6">
    <%-- 상단 타이틀 및 액션 버튼 --%>
    <div class="px-5 py-4 pb-0 flex justify-between items-center">
        <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">마이페이지</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
                <c:choose>
                    <c:when test="${userInfo.userType eq 'MASTER'}">대표자 정보 및 사업장 정보를 관리합니다.</c:when>
                    <c:when test="${userInfo.userType eq 'ADMIN'}">관리자 시스템 설정 및 개인 정보를 관리합니다.</c:when>
                    <c:otherwise>개인 정보 및 소속 정보를 확인합니다.</c:otherwise>
                </c:choose>
            </p>
        </div>
        <div class="flex gap-2">
            <button type="button" onclick="openPasswordModal()"
                    class="px-4 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg font-bold hover:bg-gray-50 transition shadow-sm">
                <i class="bi bi-key mr-2"></i>비밀번호 변경
            </button>
            <button type="button" id="btn-edit-start" onclick="enableEditMode()"
                    class="px-4 py-2 bg-indigo-600 text-white rounded-lg font-bold hover:bg-indigo-700 transition shadow-sm">
                <i class="bi bi-pencil-square mr-2"></i>정보 수정
            </button>
        </div>
    </div>

    <form id="mypageForm">
        <input type="hidden" name="userId" value="${userInfo.userId}">
        <input type="hidden" name="userNo" value="${userInfo.userNo}">
        
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 px-5">
            
            <%-- [섹션 1] 기본 개인 정보 --%>
            <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm overflow-hidden">
                <div class="px-6 py-4 border-b border-gray-100 dark:border-gray-700 bg-gray-50/50 dark:bg-gray-700/30">
                    <h3 class="text-lg font-bold text-gray-800 dark:text-white flex items-center">
                        <i class="bi bi-person-circle mr-2 text-indigo-500"></i>기본 개인 정보
                    </h3>
                </div>
                <div class="p-6 space-y-4">
                    <div class="grid grid-cols-4 items-center">
                        <label class="text-sm font-semibold text-gray-600">사용자ID</label>
                        <input type="text" value="${userInfo.userId}" disabled class="col-span-3 px-4 py-2 bg-gray-100 rounded-lg text-gray-500 font-medium">
                    </div>
                    <div class="grid grid-cols-4 items-center">
                        <label class="text-sm font-semibold text-gray-600">성함</label>
                        <input type="text" name="userName" value="${userInfo.userName}" disabled 
                               class="editable col-span-3 px-4 py-2 bg-gray-50 border border-gray-200 rounded-lg">
                    </div>
                    <div class="grid grid-cols-4 items-center">
                        <label class="text-sm font-semibold text-gray-600">이메일</label>
                        <input type="email" name="email" value="${userInfo.email}" disabled 
                               class="editable col-span-3 px-4 py-2 bg-gray-50 border border-gray-200 rounded-lg">
                    </div>
                    <div class="grid grid-cols-4 items-center">
                        <label class="text-sm font-semibold text-gray-600">연락처</label>
                        <input type="tel" name="phone" value="${userInfo.phone}" disabled 
                               class="editable col-span-3 px-4 py-2 bg-gray-50 border border-gray-200 rounded-lg">
                    </div>
                    <div class="grid grid-cols-4 items-center">
                        <label class="text-sm font-semibold text-gray-600">직위</label>
                        <input type="text" name="position" value="${userInfo.position}" disabled 
                               class="editable col-span-3 px-4 py-2 bg-gray-50 border border-gray-200 rounded-lg">
                    </div>
                </div>
            </div>

            <%-- [섹션 2] 계정 권한 및 상태 --%>
            <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm overflow-hidden">
                <div class="px-6 py-4 border-b border-gray-100 dark:border-gray-700 bg-gray-50/50 dark:bg-gray-700/30">
                    <h3 class="text-lg font-bold text-gray-800 dark:text-white flex items-center">
                        <i class="bi bi-shield-check mr-2 text-indigo-500"></i>계정 권한 및 상태
                    </h3>
                </div>
                <div class="p-6 space-y-6">
                    <div class="flex justify-between items-center p-4 bg-gray-50 rounded-lg border border-gray-100">
                        <div>
                            <p class="text-xs text-gray-500 uppercase font-bold mb-1">승인 상태</p>
                            <p class="text-lg font-bold ${userInfo.appStatus eq 'REJECTED' ? 'text-red-600' : 'text-gray-800'}">
                                ${userInfo.appSttsNm}
                            </p>
                        </div>
                        <c:if test="${userInfo.appStatus eq 'REJECTED'}">
                            <button type="button" onclick="reApplyAuth()" 
                                    class="px-4 py-2 bg-red-100 text-red-700 rounded-lg text-sm font-bold hover:bg-red-200 transition">
                                권한 재신청
                            </button>
                        </c:if>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div class="p-4 border border-gray-100 rounded-lg bg-gray-50/30">
                            <p class="text-xs text-gray-500 font-bold mb-1">계정 상태</p>
                            <p class="font-semibold text-indigo-600">${userInfo.accSttsNm}</p>
                        </div>
                        <div class="p-4 border border-gray-100 rounded-lg bg-gray-50/30">
						    <p class="text-xs text-gray-500 font-bold mb-1">사용자 유형</p>
						    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-bold 
						        ${userInfo.userType eq 'ADMIN' ? 'bg-purple-100 text-purple-700' : 
						          userInfo.userType eq 'MASTER' ? 'bg-blue-100 text-blue-700' : 'bg-gray-100 text-gray-700'}">
						        <i class="bi bi-person-badge mr-1"></i>
						        ${userInfo.userTypeNm}
						    </span>
						</div>
                    </div>
                </div>
            </div>

            <%-- [섹션 3] 회사/사업장 정보 (companyCd가 'ETC'가 아닐 때만 노출) --%>
            <c:if test="${userInfo.companyCd ne 'ETC'}">
            <div class="lg:col-span-2 bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm overflow-hidden">
                <div class="px-6 py-4 border-b border-gray-100 dark:border-gray-700 bg-gray-50/50 dark:bg-gray-700/30">
                    <h3 class="text-lg font-bold text-gray-800 dark:text-white flex items-center">
                        <i class="bi bi-building mr-2 text-indigo-500"></i>회사 정보 관리
                    </h3>
                </div>
                <div class="p-6 grid grid-cols-1 md:grid-cols-2 gap-x-12 gap-y-6">
                    <%-- 왼쪽 컬럼: 기본 정보 --%>
                    <div class="space-y-4">
                        <div class="grid grid-cols-4 items-center">
                            <label class="text-sm font-semibold text-gray-600">회사명</label>
                            <input type="text" name="companyName" value="${userInfo.companyName}" 
                                   ${(userInfo.userType eq 'MASTER' || userInfo.userType eq 'ADMIN') ? '' : 'disabled'} 
                                   class="${(userInfo.userType eq 'MASTER' || userInfo.userType eq 'ADMIN') ? 'editable' : ''} col-span-3 px-4 py-2 bg-gray-50 border border-gray-200 rounded-lg">
                        </div>
                        <div class="grid grid-cols-4 items-center">
                            <label class="text-sm font-semibold text-gray-600">사업자번호</label>
                            <input type="text" name="bizNumber" value="${userInfo.bizNumber}" 
                                   ${(userInfo.userType eq 'MASTER' || userInfo.userType eq 'ADMIN') ? '' : 'disabled'} 
                                   class="${(userInfo.userType eq 'MASTER' || userInfo.userType eq 'ADMIN') ? 'editable' : ''} col-span-3 px-4 py-2 bg-gray-50 border border-gray-200 rounded-lg">
                        </div>
                        <div class="grid grid-cols-4 items-center">
                            <label class="text-sm font-semibold text-gray-600">대표자명</label>
                            <input type="text" value="${userInfo.masterNm}" disabled 
                                   class="col-span-3 px-4 py-2 bg-gray-100 border border-gray-200 rounded-lg text-gray-500">
                            <input type="hidden" name="masterId" value="${userInfo.masterId}">
                        </div>
                        <div class="grid grid-cols-4 items-center">
                            <label class="text-sm font-semibold text-gray-600">회사번호</label>
                            <input type="text" name="companyPhone" value="${userInfo.companyPhone}" 
                                   ${(userInfo.userType eq 'MASTER' || userInfo.userType eq 'ADMIN') ? '' : 'disabled'} 
                                   class="${(userInfo.userType eq 'MASTER' || userInfo.userType eq 'ADMIN') ? 'editable' : ''} col-span-3 px-4 py-2 bg-gray-50 border border-gray-200 rounded-lg">
                        </div>
                    </div>

                    <%-- 오른쪽 컬럼: 주소 정보 --%>
                    <div class="space-y-4">
                        <div class="grid grid-cols-4 items-center">
                            <label class="text-sm font-semibold text-gray-600">통관번호</label>
                            <input type="text" name="customsNum" value="${userInfo.customsNum}" 
                                   ${(userInfo.userType eq 'MASTER' || userInfo.userType eq 'ADMIN') ? '' : 'disabled'} 
                                   class="${(userInfo.userType eq 'MASTER' || userInfo.userType eq 'ADMIN') ? 'editable' : ''} col-span-3 px-4 py-2 bg-gray-50 border border-gray-200 rounded-lg">
                        </div>
                        <div class="grid grid-cols-4 gap-2 items-center">
                            <label class="text-sm font-semibold text-gray-600">우편번호</label>
                            <div class="col-span-3 flex gap-2">
                                <input type="text" id="zipCode" name="zipCode" value="${userInfo.zipCode}" readonly 
                                       class="w-32 px-4 py-2 bg-gray-100 border border-gray-200 rounded-lg text-gray-500">
                                <button type="button" id="searchAddrBtn" onclick="execPostcode()" 
                                        class="hidden px-4 py-2 bg-gray-800 text-white rounded-lg text-xs font-bold hover:bg-black transition">주소 검색</button>
                            </div>
                        </div>
                        <div class="grid grid-cols-4 items-center">
                            <label class="text-sm font-semibold text-gray-600">한글 주소</label>
                            <input type="text" id="addrKor" name="addrKor" value="${userInfo.addrKor}" readonly 
                                   class="col-span-3 px-4 py-2 bg-gray-100 border border-gray-200 rounded-lg text-gray-500">
                        </div>
                        <div class="grid grid-cols-4 items-center">
                            <label class="text-sm font-semibold text-gray-600">영문 주소</label>
                            <input type="text" id="addrEng" name="addrEng" value="${userInfo.addrEng}" 
                                   ${(userInfo.userType eq 'MASTER' || userInfo.userType eq 'ADMIN') ? '' : 'disabled'} 
                                   class="${(userInfo.userType eq 'MASTER' || userInfo.userType eq 'ADMIN') ? 'editable' : ''} col-span-3 px-4 py-2 bg-gray-50 border border-gray-200 rounded-lg" placeholder="English Address">
                        </div>
                    </div>
                </div>
            </div>
            </c:if>
        </div>

        <%-- 저장/취소 버튼 푸터 --%>
        <div id="edit-mode-footer" class="hidden mt-8 px-5 pb-10 flex justify-center gap-4">
            <button type="button" onclick="location.reload()" 
                    class="px-8 py-3 bg-white border border-gray-300 text-gray-700 rounded-xl font-bold hover:bg-gray-50 transition">취소</button>
            <button type="button" onclick="saveMyInfo()" 
                    class="px-12 py-3 bg-indigo-600 text-white rounded-xl font-bold hover:bg-indigo-700 transition shadow-lg shadow-indigo-200">수정 사항 저장</button>
        </div>
    </form>
</div>
<jsp:include page="/WEB-INF/views/account/passwordModal.jsp" />

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    function enableEditMode() {
        document.querySelectorAll('.editable').forEach(input => {
            input.disabled = false;
            input.classList.remove('bg-gray-50');
            input.classList.add('bg-white', 'border-indigo-300');
        });
        
        document.getElementById('btn-edit-start').classList.add('hidden');
        document.getElementById('edit-mode-footer').classList.remove('hidden');
        
        // 권한 체크 후 주소 검색 버튼 노출
        const userType = "${userInfo.userType}";
        if(userType === 'MASTER' || userType === 'ADMIN') {
            const searchBtn = document.getElementById('searchAddrBtn');
            if(searchBtn) searchBtn.classList.remove('hidden');
        }
    }

    function execPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                let addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
                // 영문 주소도 API에서 제공함
                let extraAddrEng = data.addressEnglish; 
                
                document.getElementById("zipCode").value = data.zonecode;
                document.getElementById("addrKor").value = addr;
                document.getElementById("addrEng").value = extraAddrEng;
            }
        }).open();
    }

    function saveMyInfo() {
        const form = document.getElementById('mypageForm');
        const formData = new FormData(form);
        
        const data = {
            updateUserInfo: {
                userId: formData.get('userId'),
                userNo: formData.get('userNo'),
                userName: formData.get('userName'),
                email: formData.get('email'),
                phone: formData.get('phone'),
                position: formData.get('position'),
                userType: "${userInfo.userType}"
            },
            updateCompanyInfo: {
                companyName: formData.get('companyName'),
                bizNumber: formData.get('bizNumber'),
                companyPhone: formData.get('companyPhone'),
                customsNum: formData.get('customsNum'),
                zipCode: formData.get('zipCode'),
                addrKor: formData.get('addrKor'),
                addrEng: formData.get('addrEng'),
                masterId: formData.get('masterId')
            }
        };

        fetch('/account/api/modify', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        })
        .then(res => res.json())
        .then(res => {
            if(res.success) {
                alert(res.message || "성공적으로 수정되었습니다.");
                location.reload();
            } else {
                alert("수정 실패: " + res.message);
            }
        })
        .catch(err => alert("서버 통신 중 오류가 발생했습니다."));
    }

    function reApplyAuth() {
        if(confirm("권한 재신청을 진행하시겠습니까? 현재 '반려' 상태에서 '승인 대기' 상태로 변경됩니다.")) {
            fetch('/account/api/re-apply', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' }
            })
            .then(res => res.json())
            .then(res => {
                if(res.success) {
                    alert(res.message);
                    location.reload(); // 상태 반영을 위해 새로고침
                } else {
                    alert("재신청 실패: " + res.message);
                }
            })
            .catch(err => {
                console.error(err);
                alert("서버와 통신 중 오류가 발생했습니다.");
            });
        }
    }
</script>