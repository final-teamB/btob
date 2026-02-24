<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="authModal" class="fixed inset-0 z-[100] hidden flex items-center justify-center px-4">
    <div class="absolute inset-0 bg-slate-950/60 backdrop-blur-sm shadow-2xl transition-opacity" onclick="closeAuthModal()"></div>
    
    <div class="relative w-full max-w-4xl glass-card rounded-[3rem] overflow-hidden shadow-2xl border border-white/20 animate-up">
        
        <button onclick="closeAuthModal()" class="absolute top-8 right-8 text-white/50 hover:text-white transition-colors z-10">
            <i data-lucide="x" class="w-8 h-8"></i>
        </button>

        <div class="flex border-b border-white/10 relative z-0">
            <button onclick="switchTab('login')" id="loginTab" class="flex-1 py-6 text-lg font-bold text-blue-400 border-b-4 border-blue-400 transition-all">로그인</button>
            <button onclick="switchTab('register')" id="registerTab" class="flex-1 py-6 text-lg font-bold text-white/40 hover:text-white/60 transition-all border-b-4 border-transparent">회원가입</button>
        </div>

        <div class="p-10 md:p-14">
            <div id="loginForm" class="space-y-8">
                <div class="text-left mb-8">
                    <h2 class="text-3xl font-black text-white mb-3">반가워요! 👋</h2>
                    <p class="text-gray-400 text-lg">글로벌 무역 파트너, TradeHuB에 접속하세요.</p>
                </div>
                <div class="space-y-5">
                    <div class="relative">
                        <i data-lucide="user" class="absolute left-5 top-4.5 w-6 h-6 text-gray-500"></i>
                        <input type="text" id="loginId" name="userId" placeholder="아이디 (@gmail.com)" class="w-full bg-white/5 border border-white/10 rounded-2xl py-4.5 pl-14 pr-5 text-white text-lg focus:outline-none focus:border-blue-500 transition-all">
                    </div>
                    <div class="relative">
                        <i data-lucide="lock" class="absolute left-5 top-4.5 w-6 h-6 text-gray-500"></i>
                        <input type="password" id="loginPw" name="password" placeholder="비밀번호" class="w-full bg-white/5 border border-white/10 rounded-2xl py-4.5 pl-14 pr-5 text-white text-lg focus:outline-none focus:border-blue-500 transition-all">
                    </div>
                </div>
                <div class="flex items-center justify-between text-sm font-medium">
                    <label class="flex items-center gap-2 text-gray-400 cursor-pointer">
                        <input type="checkbox" id="saveId" class="w-5 h-5 rounded border-white/10 bg-white/5"> 아이디 저장
                    </label>
                    <button onclick="switchTab('find')" class="text-blue-400 hover:underline">정보를 잊으셨나요?</button>
                </div>
                <button onclick="handleLogin()" class="w-full py-5 bg-blue-600 hover:bg-blue-700 text-white font-black text-xl rounded-2xl shadow-lg shadow-blue-900/20 transition-all transform active:scale-[0.98]">
                    로그인
                </button>
            </div>

            <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

            <div id="registerForm" class="hidden space-y-8">
                <div class="text-left mb-6">
                    <h2 class="text-3xl font-black text-white mb-3">파트너 가입</h2>
                    <div id="regStepIndicator" class="flex gap-3 mb-6">
                        <span class="step-dot h-1.5 w-12 bg-blue-600 rounded-full"></span>
                        <span class="step-dot h-1.5 w-12 bg-white/20 rounded-full"></span>
                        <span class="step-dot h-1.5 w-12 bg-white/20 rounded-full"></span>
                    </div>
                </div>

                <div id="regStep1" class="space-y-6">
                    <div class="bg-white/5 border border-white/10 rounded-2xl p-6 h-48 overflow-y-auto text-sm text-gray-400 leading-relaxed">
                        <p class="font-bold text-white mb-2">[이용약관 및 개인정보 처리방침]</p>
                        TradeHuB 서비스 이용을 위해 본 약관에 동의가 필요합니다... (내용 중략)
                    </div>
                    <label class="flex items-center gap-4 text-white text-lg cursor-pointer p-3 bg-white/5 rounded-2xl border border-white/5 hover:border-white/20 transition-all">
                        <input type="checkbox" id="agreeTerms" class="w-6 h-6 rounded border-white/10 bg-white/5">
                        <span>위 약관에 동의합니다. <span class="text-blue-400 font-bold">(필수)</span></span>
                    </label>
                    <button onclick="nextStep(2)" class="w-full py-5 bg-blue-600 text-white font-black text-xl rounded-2xl">다음 단계</button>
                </div>

                <div id="regStep2" class="hidden grid grid-cols-2 gap-6">
                    <button onclick="selectUserType('USER')" class="p-10 border-2 border-white/10 rounded-[2rem] hover:border-blue-500 transition-all text-center group bg-white/5">
                        <i data-lucide="user" class="w-16 h-16 mx-auto mb-5 text-gray-500 group-hover:text-blue-500"></i>
                        <span class="text-xl text-white font-bold block">일반 사용자</span>
                        <p class="text-gray-500 mt-2 text-sm">회사 소속 직원 가입</p>
                    </button>
                    <button onclick="selectUserType('MASTER')" class="p-10 border-2 border-white/10 rounded-[2rem] hover:border-blue-500 transition-all text-center group bg-white/5">
                        <i data-lucide="briefcase" class="w-16 h-16 mx-auto mb-5 text-gray-500 group-hover:text-blue-500"></i>
                        <span class="text-xl text-white font-bold block">회사 대표</span>
                        <p class="text-gray-500 mt-2 text-sm">신규 업체 등록 및 가입</p>
                    </button>
                </div>

                <div id="regStep3" class="hidden space-y-6 max-h-[550px] overflow-y-auto pr-4 custom-scroll">
                    <div class="grid grid-cols-2 gap-6">
                        <div class="col-span-2">
                            <label class="text-blue-400 text-xs font-bold ml-1 mb-1 block">아이디 (Gmail 주소 형식)</label>
                            <input type="text" id="regId" placeholder="example@gmail.com" class="w-full bg-white/5 border border-white/10 rounded-2xl py-4 px-6 text-white text-lg">
                        </div>
                        <div>
                            <label class="text-blue-400 text-xs font-bold ml-1 mb-1 block">비밀번호 (8~20자, 대/소문자, 숫자, 특수문자 포함)</label>
                            <input type="password" id="regPw" placeholder="비밀번호" class="w-full bg-white/5 border border-white/10 rounded-2xl py-4 px-6 text-white text-lg">
                        </div>
                        <div>
                            <label class="text-blue-400 text-xs font-bold ml-1 mb-1 block">비밀번호 확인</label>
                            <input type="password" id="regPwConfirm" placeholder="비밀번호 확인" class="w-full bg-white/5 border border-white/10 rounded-2xl py-4 px-6 text-white text-lg">
                        </div>

                        <div class="col-span-1">
                             <label class="text-blue-400 text-xs font-bold ml-1 mb-1 block">담당자 이름</label>
                             <input type="text" id="regName" placeholder="성함" class="w-full bg-white/5 border border-white/10 rounded-2xl py-4 px-6 text-white text-lg">
                        </div>
                        <div class="col-span-1">
						     <label class="text-blue-400 text-xs font-bold ml-1 mb-1 block">직급</label>
						     <input type="text" id="regPosition" placeholder="예: 대리, 대표" class="w-full bg-white/5 border border-white/10 rounded-2xl py-4 px-6 text-white text-lg focus:outline-none focus:border-blue-500">
						</div>
                        <div class="col-span-1">
                             <label class="text-blue-400 text-xs font-bold ml-1 mb-1 block">휴대폰 번호</label>
                             <input type="text" id="regPhone" oninput="autoHyphen(this)" maxlength="13" placeholder="010-0000-0000" class="w-full bg-white/5 border border-white/10 rounded-2xl py-4 px-6 text-white text-lg">
                        </div>
                        
                        <div class="col-span-2">
                            <label class="text-blue-400 text-xs font-bold ml-1 mb-1 block">이메일 주소 (Gmail)</label>
                            <input type="email" id="regEmail" placeholder="partner@gmail.com" class="w-full bg-white/5 border border-white/10 rounded-2xl py-4 px-6 text-white text-lg">
                        </div>

                        <div class="col-span-2 space-y-4">
                            <hr class="border-white/10 my-4">
                            
                            <div id="userCompanyArea" class="space-y-4">
                                <p class="text-blue-400 text-sm font-black ml-1">소속 회사 선택</p>
							    <select id="companySelect" class="w-full bg-slate-900 border border-white/10 rounded-2xl py-4 px-6 text-white text-lg focus:outline-none focus:border-blue-500">
							        <option value="">소속 회사를 선택하세요</option>
							    </select>
                                <input type="text" id="etcCompanyName" placeholder="회사명을 직접 입력하세요" class="hidden w-full bg-white/5 border border-white/10 rounded-2xl py-4 px-6 text-white text-lg">
                            </div>

                            <div id="ownerFields" class="hidden space-y-4">
                                <p class="text-blue-400 text-sm font-black ml-1">신규 회사 및 사업자 정보 등록</p>
                                <div class="grid grid-cols-2 gap-4">
							        <input type="text" id="ownerCompanyName" placeholder="등록할 회사명" class="w-full bg-white/5 border border-white/10 rounded-2xl py-4 px-6 text-white text-lg">
							        <input type="text" id="ownerCompanyPhone" oninput="autoHyphen(this)" maxlength="13" placeholder="회사 연락처 (02-000-0000)" class="w-full bg-white/5 border border-white/10 rounded-2xl py-4 px-6 text-white text-lg">
							    </div>
                                
                                <div class="flex gap-3">
                                    <input type="text" id="zipNo" placeholder="우편번호" class="flex-1 bg-white/5 border border-white/10 rounded-2xl py-4 px-6 text-white text-lg" readonly>
                                    <button type="button" onclick="execDaumPostcode()" class="px-8 bg-gray-700 text-white rounded-2xl font-bold hover:bg-gray-600 transition-all">주소찾기</button>
                                </div>
                                <input type="text" id="addrRoad" placeholder="한글 도로명 주소" class="w-full bg-white/5 border border-white/10 rounded-2xl py-4 px-6 text-white text-lg" readonly>
                                <input type="text" id="addrEng" placeholder="영문 주소" class="w-full bg-white/5 border border-white/10 rounded-2xl py-4 px-6 text-white text-lg" readonly>
                                <div class="grid grid-cols-2 gap-4">
                                    <input type="text" id="bizNo" placeholder="사업자 등록번호" class="w-full bg-white/5 border border-white/10 rounded-2xl py-4 px-6 text-white text-lg">
                                    <input type="text" id="customsNo" placeholder="통관번호" class="w-full bg-white/5 border border-white/10 rounded-2xl py-4 px-6 text-white text-lg">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="sticky bottom-0 pt-4 bg-slate-950/20 backdrop-blur-md">
                        <button onclick="handleRegister()" class="w-full py-5 bg-white text-slate-900 font-black text-xl rounded-2xl shadow-2xl hover:bg-gray-100 transition-all">파트너 가입 신청</button>
                    </div>
                </div>
            </div>
           
           <div id="findForm" class="hidden">
			    <jsp:include page="/WEB-INF/views/home/findAccount.jsp" />
			</div>
        </div>
    </div>
</div>

<script>
    /* -----------------------------------------------------------
     * [변수 관리]
     * ----------------------------------------------------------- */
    var currentRegStep = 1;
    var selectedUserType = 'USER';

    /* 모달 제어 */
    function openAuthModal() {
        document.getElementById('authModal').classList.remove('hidden');
        document.body.style.overflow = 'hidden';
        if(window.lucide) lucide.createIcons();
    }

    function closeAuthModal() {
        document.getElementById('authModal').classList.add('hidden');
        document.body.style.overflow = 'auto';
        resetRegisterStep();
        
     	// [추가] 정보 찾기 중이었을 경우 타이머 중지 및 폼 초기화
        if(typeof timerInterval !== 'undefined') clearInterval(timerInterval);
    }

    /* 탭 전환 */
	function switchTab(type) {
	    var forms = ['loginForm', 'registerForm', 'findForm'];
	    forms.forEach(function(f) { 
	        document.getElementById(f).classList.add('hidden'); 
	    });
	    
	    document.getElementById(type + 'Form').classList.remove('hidden');
	
	    var loginTab = document.getElementById('loginTab');
	    var registerTab = document.getElementById('registerTab');
	
	    // 스타일 제어
	    if (type === 'login' || type === 'find') {
	        loginTab.className = "flex-1 py-6 text-lg font-bold text-blue-400 border-b-4 border-blue-400 transition-all";
	        registerTab.className = "flex-1 py-6 text-lg font-bold text-white/40 hover:text-white/60 transition-all border-b-4 border-transparent";
	    } else {
	        registerTab.className = "flex-1 py-6 text-lg font-bold text-blue-400 border-b-4 border-blue-400 transition-all";
	        loginTab.className = "flex-1 py-6 text-lg font-bold text-white/40 hover:text-white/60 transition-all border-b-4 border-transparent";
	        resetRegisterStep();
	    }
	
	    // [추가] 정보 찾기 탭 클릭 시 include 된 파일 내부의 아이콘/상태 초기화
	    if(type === 'find') {
	        if(window.lucide) lucide.createIcons();
	        if(typeof switchFindMode === 'function') switchFindMode('ID'); // 기본 모드를 ID찾기로 설정
	    }
	}

    /* -----------------------------------------------------------
     * [유틸리티: 휴대폰 번호 자동 하이픈]
     * ----------------------------------------------------------- */
    function autoHyphen(target) {
        target.value = target.value
            .replace(/[^0-9]/g, '')
            .replace(/^(\d{0,3})(\d{0,4})(\d{0,4})$/g, "$1-$2-$3")
            .replace(/(\-{1,2})$/g, "");
    }

    /* -----------------------------------------------------------
     * [회원가입 로직: 단계 및 데이터 제어]
     * ----------------------------------------------------------- */
    function resetRegisterStep() {
        currentRegStep = 1;
        nextStep(1);
    }

    function nextStep(step) {
        if(step === 2 && !document.getElementById('agreeTerms').checked) {
            alert('이용약관 및 개인정보 처리방침에 동의해주세요.');
            return;
        }
        
        document.getElementById('regStep1').classList.add('hidden');
        document.getElementById('regStep2').classList.add('hidden');
        document.getElementById('regStep3').classList.add('hidden');
        document.getElementById('regStep' + step).classList.remove('hidden');
        currentRegStep = step;

        var dots = document.querySelectorAll('.step-dot');
        dots.forEach(function(dot, idx) {
            if (idx < step) dot.classList.replace('bg-white/20', 'bg-blue-600');
            else dot.classList.replace('bg-blue-600', 'bg-white/20');
        });
    }

    function loadCompanyList() {
        fetch('/account/api/select-boxes')
            .then(function(response) { return response.json(); })
            .then(function(data) {
                var select = document.getElementById('companySelect');
                select.innerHTML = '<option value="">소속 회사를 선택하세요</option>';
                
                var hasEtc = false;
                if (data.companyList) {
                    data.companyList.forEach(function(item) {
                        var opt = document.createElement('option');
                        opt.value = item.value; 
                        opt.text = item.text;   
                        select.appendChild(opt);
                        if(item.value === 'ETC') hasEtc = true;
                    });
                }
                
                // 리스트에 ETC가 없을 경우에만 수동으로 추가 (중복 방지)
                if(!hasEtc) {
                    var etcOpt = document.createElement('option');
                    etcOpt.value = 'ETC';
                    etcOpt.text = '기타 (소속 회사 없음)';
                    select.appendChild(etcOpt);
                }
            })
            .catch(function(err) { console.error('회사 목록 로딩 실패:', err); });
    }

    function selectUserType(type) {
        selectedUserType = type;
        var ownerFields = document.getElementById('ownerFields');
        var userCompanyArea = document.getElementById('userCompanyArea');
        
        if(type === 'MASTER') {
            ownerFields.classList.remove('hidden');
            userCompanyArea.classList.add('hidden');
        } else {
            ownerFields.classList.add('hidden');
            userCompanyArea.classList.remove('hidden');
            loadCompanyList(); 
        }
        nextStep(3);
    }

    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                document.getElementById('zipNo').value = data.zonecode;
                document.getElementById('addrRoad').value = data.roadAddress;
                document.getElementById('addrEng').value = data.addressEnglish;
            }
        }).open();
    }

    /* -----------------------------------------------------------
     * [데이터 전송: 로그인 및 회원가입]
     * ----------------------------------------------------------- */
    function handleLogin() {
        var userId = document.getElementById('loginId').value;
        var password = document.getElementById('loginPw').value;

        if(!userId || !password) { alert('아이디와 비밀번호를 입력해주세요.'); return; }

        var params = new URLSearchParams();
        params.append('userId', userId);
        params.append('password', password);

        fetch('/loginProc', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        })
        .then(function(res) { return res.json(); })
        .then(function(result) {
            if(result.success) location.href = result.redirectUrl;
            else alert(result.message);
        })
        .catch(function() { alert('로그인 중 오류가 발생했습니다.'); });
    }

    function handleRegister() {
        var userId = document.getElementById('regId').value;
        var password = document.getElementById('regPw').value;
        var pwConfirm = document.getElementById('regPwConfirm').value;
        var userName = document.getElementById('regName').value;
        var position = document.getElementById('regPosition').value;
        var phone = document.getElementById('regPhone').value;
        var email = document.getElementById('regEmail').value;

        // 유효성 검사
        var gmailRegex = /^[a-zA-Z0-9._%+-]+@gmail\.com$/;
        var pwRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()])[A-Za-z\d!@#$%^&*()]{8,20}$/;
        var phoneRegex = /^010-\d{3,4}-\d{4}$/;

        if (!gmailRegex.test(userId)) { alert("아이디는 @gmail.com 형식이어야 합니다."); return; }
        if (!pwRegex.test(password)) { 
            alert("비밀번호는 8~20자 이내이며, 영어 대문자, 소문자, 숫자, 특수문자를 모두 포함해야 합니다."); 
            document.getElementById('regPw').focus();
            return; 
        }
        if (password !== pwConfirm) { alert("비밀번호가 일치하지 않습니다."); return; }
        if (!userName) { alert("담당자 이름을 입력해주세요."); return; }
        if (!position) { alert("직급을 입력해주세요."); return; }
        if (!phoneRegex.test(phone)) { alert("휴대폰 번호 형식을 확인해주세요."); return; }

        // 회사 정보 설정
        var finalCompanyName = "";
        var finalCompanyCd = "";
        var finalCompanyPhone = "";

        if(selectedUserType === 'MASTER') {
            finalCompanyName = document.getElementById('ownerCompanyName').value;
            finalCompanyPhone = document.getElementById('ownerCompanyPhone').value; // [추가]
            
            if(!finalCompanyName) { alert("등록할 회사명을 입력해주세요."); return; }
            if(!finalCompanyPhone) { alert("회사 연락처를 입력해주세요."); return; } // [추가] 유효성 검사
        } else {
            var select = document.getElementById('companySelect');
            if(!select.value) { alert("소속 회사를 선택해주세요."); return; }
            
            // DB 데이터 연동: 선택된 텍스트와 값을 그대로 사용
            finalCompanyName = select.options[select.selectedIndex].text;
            finalCompanyCd = select.value;
            finalCompanyPhone = "";
        }

        var data = {
            insertUserInfo: {
                userId: userId,
                password: password,
                userName: userName,
                position: position,
                phone: phone,
                email: email,
                userType: selectedUserType,
                companyCd: finalCompanyCd
            },
            insertCompanyInfo: {
                companyName: finalCompanyName,
                companyCd: finalCompanyCd,
                companyPhone: finalCompanyPhone,
                zipCode: document.getElementById('zipNo').value || "",
                addrKor: document.getElementById('addrRoad').value || "",
                addrEng: document.getElementById('addrEng').value || "",
                bizNumber: (finalCompanyCd === 'ETC') ? "999-99-99999" : (document.getElementById('bizNo').value || ""),
                customsNum: (finalCompanyCd === 'ETC') ? "99999" : (document.getElementById('customsNo').value || "")
            }
        };

        fetch('/account/api/register', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        })
        .then(function(res) { return res.json(); })
        .then(function(result) {
            if(result.success) {
                alert('회원가입 신청이 완료되었습니다.\n관리자 승인 후 로그인이 가능합니다.');
                switchTab('login');
            } else {
                alert(result.message || '가입 처리 중 오류가 발생했습니다.');
            }
        })
        .catch(function(err) {
            console.error(err);
            alert('서버와 통신 중 오류가 발생했습니다.');
        });
    }
</script>