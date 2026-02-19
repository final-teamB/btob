<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    /* [상향] 텍스트 가독성을 위해 컬러값 조정 */
    #detailMemo {
        line-height: 1.8;
        color: #1f2937;
    }

    #detailMemo img {
        max-width: 100% !important;
        height: auto !important;
        display: block;
        margin: 24px auto;
        border-radius: 16px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.12);
    }
    
    #detailMemo p {
        margin-bottom: 1.2rem;
    }

    /* 커스텀 스크롤바 */
    .modal-content-scroll::-webkit-scrollbar {
        width: 8px;
    }
    .modal-content-scroll::-webkit-scrollbar-track {
        background: #f1f1f1;
    }
    .modal-content-scroll::-webkit-scrollbar-thumb {
        background: #9ca3af;
        border-radius: 10px;
    }
</style>

<div id="productDetailModal" class="fixed inset-0 z-[100] hidden overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
    <div class="flex items-center justify-center min-h-screen p-4 text-center sm:p-0">
        <div class="fixed inset-0 bg-gray-900/80 backdrop-blur-sm transition-opacity" aria-hidden="true"></div>

        <div class="inline-block align-middle bg-white dark:bg-gray-800 rounded-[2rem] text-left overflow-hidden shadow-2xl transform transition-all sm:my-8 sm:max-w-6xl sm:w-full">
            
            <div class="absolute top-6 right-6 z-20">
                <button onclick="closeProductDetail()" class="w-10 h-10 flex items-center justify-center bg-gray-200 hover:bg-gray-300 dark:bg-gray-700 dark:hover:bg-gray-600 rounded-full transition-all group">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-600 group-hover:text-black dark:text-gray-300 dark:group-hover:text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </button>
            </div>

            <div class="flex flex-col lg:flex-row max-h-[90vh]">
                <div class="lg:w-5/12 bg-gray-100 dark:bg-gray-900 flex items-center justify-center p-6 border-r border-gray-200 dark:border-gray-700">
                    <div class="relative w-full aspect-square rounded-[1.5rem] overflow-hidden bg-white shadow-md border border-gray-200">
                        <img id="mainDetailImg" src="" alt="상품 이미지" class="w-full h-full object-contain p-4">
                    </div>
                </div>

                <div class="lg:w-7/12 flex flex-col modal-content-scroll overflow-y-auto bg-white dark:bg-gray-800">
                    <div class="p-8 lg:p-10">
                        <div class="mb-8">
                            <span id="detailFuelCat" class="px-3 py-1 bg-blue-100 text-blue-800 text-[12px] font-bold rounded-lg uppercase tracking-widest border border-blue-200"></span>
                            <h2 id="detailFuelNm" class="text-3xl font-black text-gray-900 dark:text-white mt-4 tracking-tight"></h2>
                        </div>

                        <div class="grid grid-cols-2 gap-4 p-6 bg-gray-50 dark:bg-gray-700/50 rounded-[1.5rem] mb-10 border border-gray-200 dark:border-gray-600">
                            <div class="border-r border-gray-300 dark:border-gray-500">
                                <p class="text-[12px] text-gray-500 dark:text-gray-400 font-bold uppercase mb-1">단가 (Unit Price)</p>
                                <div class="flex items-baseline">
                                    <span class="text-2xl font-black text-blue-700 dark:text-blue-400" id="detailPrice"></span>
                                    <span class="text-sm text-gray-600 dark:text-gray-300 ml-1 font-bold" id="detailVolUnit"></span>
                                </div>
                            </div>
                            <div class="pl-4">
                                <p class="text-[12px] text-gray-500 dark:text-gray-400 font-bold uppercase mb-1">판매 상태</p>
                                <div id="detailStts" class="mt-1"></div>
                            </div>
                        </div>

                        <div class="mb-10">
                            <h3 class="flex items-center text-sm font-black text-gray-600 dark:text-gray-400 uppercase tracking-widest mb-5">
                                <span class="w-8 h-[2px] bg-gray-400 mr-3"></span>
                                Technical Specs
                                <span class="flex-grow h-[2px] bg-gray-400 ml-3"></span>
                            </h3>
                            <div class="grid grid-cols-2 gap-3">
                                <div class="p-4 bg-white dark:bg-gray-700 rounded-2xl border border-gray-300 dark:border-gray-600 shadow-sm">
                                    <p class="text-[12px] text-gray-500 font-black mb-1">API Gravity</p>
                                    <p id="detailApiGrv" class="font-bold text-gray-900 dark:text-gray-100 text-lg"></p>
                                </div>
                                <div class="p-4 bg-white dark:bg-gray-700 rounded-2xl border border-gray-300 dark:border-gray-600 shadow-sm">
                                    <p class="text-[12px] text-gray-500 font-black mb-1">Sulfur (%)</p>
                                    <p id="detailSulfur" class="font-bold text-gray-900 dark:text-gray-100 text-lg"></p>
                                </div>
                                <div class="p-4 bg-white dark:bg-gray-700 rounded-2xl border border-gray-300 dark:border-gray-600 shadow-sm">
                                    <p class="text-[12px] text-gray-500 font-black mb-1">Flash Point</p>
                                    <p id="detailFlashPnt" class="font-bold text-gray-900 dark:text-gray-100 text-lg"></p>
                                </div>
                                <div class="p-4 bg-white dark:bg-gray-700 rounded-2xl border border-gray-300 dark:border-gray-600 shadow-sm">
                                    <p class="text-[12px] text-gray-500 font-black mb-1">Density @15°C</p>
                                    <p id="detailDensity" class="font-bold text-gray-900 dark:text-gray-100 text-lg"></p>
                                </div>
                            </div>
                        </div>

                        <div class="space-y-4 mb-10 pb-10 border-b-2 border-gray-200 dark:border-gray-700">
                            <div class="flex items-center justify-between text-base">
                                <div class="flex items-center text-gray-700 dark:text-gray-300 font-bold">원산지 (Origin)</div>
                                <span id="detailOrigin" class="font-black text-gray-900 dark:text-white"></span>
                            </div>
                            <div class="flex items-center justify-between text-base">
                                <div class="flex items-center text-gray-700 dark:text-gray-300 font-bold">현재 재고량 (Stock)</div>
                                <span id="detailStock" class="font-black text-gray-900 dark:text-white"></span>
                            </div>
                        </div>

                        <div class="mb-10">
                            <h3 class="text-sm font-black text-gray-600 dark:text-gray-400 uppercase tracking-widest mb-4 italic">Product Detail Memo</h3>
                            <div id="detailMemo" class="bg-gray-50 dark:bg-gray-900 p-6 rounded-2xl border-2 border-dashed border-gray-300 dark:border-gray-600"></div>
                        </div>
                        
                        <div id="actionArea" class="pt-8 border-t-2 border-gray-300 dark:border-gray-600">
						    <div id="btnGroup" class="flex flex-col sm:flex-row gap-3">
						        <button onclick="addToCart()" 
						                class="flex-1 flex items-center justify-center gap-2 px-4 py-4 bg-white dark:bg-gray-700 text-gray-800 dark:text-white font-bold rounded-2xl border-2 border-gray-200 dark:border-gray-600 hover:bg-gray-50 transition-all shadow-sm group whitespace-nowrap">
						            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400 group-hover:text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
						            </svg>
						            장바구니
						        </button>
						
						        <button onclick="requestQuote()" 
						                class="flex-1 flex items-center justify-center gap-2 px-4 py-4 bg-slate-50 dark:bg-slate-800 text-slate-600 dark:text-slate-300 font-bold rounded-2xl border-2 border-gray-200 dark:border-gray-600 hover:border-slate-300 transition-all shadow-sm whitespace-nowrap">
						            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2-2z" />
						            </svg>
						            견적 요청
						        </button>
						
						        <button onclick="directOrder()" 
						                class="flex-[1.2] flex items-center justify-center gap-2 px-4 py-4 bg-blue-500 hover:bg-blue-600 dark:bg-blue-600 dark:hover:bg-blue-700 text-white font-black rounded-2xl transition-all shadow-md shadow-blue-100 dark:shadow-none transform active:scale-95 whitespace-nowrap">
						            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z" />
						            </svg>
						            주문하기
						        </button>
						    </div>
						
						    <div id="statusNotice" class="hidden">
						        <div class="bg-gray-50 dark:bg-gray-900 border-2 border-gray-100 dark:border-gray-700 rounded-[1.5rem] p-6 text-center">
						            <p id="noticeMsg" class="text-lg font-black text-gray-700 dark:text-gray-200 mb-1"></p>
						            <p class="text-gray-400 dark:text-gray-500 text-sm font-medium">기타 문의사항은 챗봇으로 문의 부탁드립니다.</p>
						        </div>
						    </div>
						</div>
                        
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function openProductDetail(fuelId) {
    if(!fuelId) return;

    fetch('/usr/productView/api/' + fuelId)
        .then(response => response.json())
        .then(data => {
            // 1. 기본 텍스트 정보
            document.getElementById('detailFuelNm').innerText = data.fuelNm;
            document.getElementById('detailFuelCat').innerText = data.fuelCatNm;
            document.getElementById('detailOrigin').innerText = data.originCntryNm;
            
            // 2. 숫자 포맷팅
            const price = data.baseUnitPrc || 0;
            document.getElementById('detailPrice').innerText = '₩' + new Intl.NumberFormat().format(price);
            document.getElementById('detailVolUnit').innerText = ' / ' + (data.volUnitNm || '');
            
            const stock = data.currStockVol || 0;
            document.getElementById('detailStock').innerText = new Intl.NumberFormat().format(stock) + ' ' + (data.volUnitNm || '');

            // 3. 메모 HTML 바인딩
            document.getElementById('detailMemo').innerHTML = data.fuelMemo || '<p class="text-gray-400 text-center py-4">등록된 상세 설명이 없습니다.</p>';
            
            // 4. 기술 사양
            document.getElementById('detailApiGrv').innerText = data.apiGrv || '-';
            document.getElementById('detailSulfur').innerText = data.sulfurPCnt ? data.sulfurPCnt + '%' : '-';
            document.getElementById('detailFlashPnt').innerText = data.flashPnt ? data.flashPnt + '°C' : '-';
            document.getElementById('detailDensity').innerText = data.density15c || '-';

            // 5. [수정] 판매 상태 스타일링 및 버튼 제어 로직
            const sttsEl = document.getElementById('detailStts');
            const btnGroup = document.getElementById('btnGroup');
            const statusNotice = document.getElementById('statusNotice');
            const noticeMsg = document.getElementById('noticeMsg');
            
            const sCode = data.itemSttsCd; // 상태 코드
            const sttsText = data.itemSttsNm; // 상태 명칭
            let sttsClass = 'bg-gray-100 text-gray-600';

            // 초기 상태 리셋
            btnGroup.classList.remove('hidden');
            statusNotice.classList.add('hidden');

            if (sCode === 'SA001') {
                // 판매 중
                sttsClass = 'bg-green-100 text-green-700 border border-green-200';
            } else {
                // [핵심] 판매 불가 상태 처리 (SO002:품절, EX003:판매만료, DC004:단종 등)
                btnGroup.classList.add('hidden'); // 버튼 숨김
                statusNotice.classList.remove('hidden'); // 안내창 표시
                noticeMsg.innerText = `\${sttsText} 상태로 현재 주문이 불가합니다.`; // 문구 동적 세팅

                if (sCode === 'SO002') sttsClass = 'bg-red-100 text-red-700 border border-red-200';
                else if (sCode === 'EX003') sttsClass = 'bg-gray-100 text-gray-600 border border-gray-200';
                else if (sCode === 'DC004') sttsClass = 'bg-orange-100 text-orange-700 border border-orange-200';
            }

            sttsEl.innerHTML = `<span class="px-3 py-1.5 rounded-lg font-bold text-xs \${sttsClass}">\${sttsText}</span>`;

            // 6. 이미지 처리
            let mainImgUrl = contextPath + '/images/no-image.png';
            if (data.fileList && data.fileList.length > 0) {
                const mainFile = data.fileList.find(f => f.systemId === 'PRODUCT_M') || data.fileList[0];
                mainImgUrl = mainFile.fileUrl;
            }
            document.getElementById('mainDetailImg').src = mainImgUrl;

            // 모달 표시 및 스크롤 차단
            document.getElementById('productDetailModal').classList.remove('hidden');
            document.body.style.overflow = 'hidden'; 
        })
        .catch(error => {
            console.error('Error:', error);
            alert('상세 정보를 불러오는 중 오류가 발생했습니다.');
        });
}

function closeProductDetail() {
    document.getElementById('productDetailModal').classList.add('hidden');
    document.body.style.overflow = 'auto'; 
}

/**
 * 액션 함수 정의
 */
function addToCart() {
    const fuelNm = document.getElementById('detailFuelNm').innerText;
    alert(fuelNm + ' 상품을 장바구니에 담았습니다.');
}

function requestQuote() {
    const fuelNm = document.getElementById('detailFuelNm').innerText;
    if(confirm(fuelNm + ' 상품에 대한 견적서를 요청하시겠습니까?')) {
        // 실제 로직 연동 시 fuelId 등을 파라미터로 넘겨야 합니다.
    }
}

function directOrder() {
    const fuelNm = document.getElementById('detailFuelNm').innerText;
    alert(fuelNm + ' 주문 페이지로 이동합니다.');
}

/**
 * [추가] ESC 키를 누르면 모달 닫기
 * 전역 이벤트 리스너로 등록하여 사용자가 언제든 ESC를 누르면 반응합니다.
 */
window.addEventListener('keydown', function(e) {
    // 누른 키가 'Escape'인지 확인
    if (e.key === 'Escape' || e.keyCode === 27) {
        const modal = document.getElementById('productDetailModal');
        
        // 모달이 현재 열려있는 상태(hidden 클래스가 없는 상태)일 때만 닫기 함수 실행
        if (modal && !modal.classList.contains('hidden')) {
            closeProductDetail();
        }
    }
});

</script>