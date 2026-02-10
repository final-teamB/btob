<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>

    /* [추가] 상세 메모 내 이미지 레이아웃 최적화 */
    #detailMemo {
        line-height: 1.6;
        color: #4b5563; /* 가독성 좋은 회색 */
    }

    #detailMemo img {
        max-width: 100% !important; /* 모달 너비를 넘지 않게 */
        height: auto !important;    /* 비율 유지 */
        display: block;
        margin: 20px auto;          /* 위아래 간격 및 중앙 정렬 */
        border-radius: 12px;        /* 부드러운 모서리 */
        box-shadow: 0 4px 12px rgba(0,0,0,0.05); /* 살짝 그림자 추가 */
    }
    
    /* 혹시 모를 p 태그 간격 조정 */
    #detailMemo p {
        margin-bottom: 1rem;
    }
</style>

<div id="productDetailModal" class="fixed inset-0 z-[100] hidden overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
    <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <div class="fixed inset-0 bg-gray-900 bg-opacity-75 transition-opacity" aria-hidden="true" onclick="closeProductDetail()"></div>

        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
        <div class="inline-block align-bottom bg-white dark:bg-gray-800 rounded-3xl text-left overflow-hidden shadow-2xl transform transition-all sm:my-8 sm:align-middle sm:max-w-5xl sm:w-full">
            
            <div class="absolute top-5 right-5 z-10">
                <button onclick="closeProductDetail()" class="text-gray-400 hover:text-gray-600 dark:hover:text-white transition">
                    <i class="ri-close-line text-3xl"></i>
                </button>
            </div>

            <div class="flex flex-col lg:flex-row">
                <div class="lg:w-1/2 bg-gray-50 dark:bg-gray-900 flex items-center justify-center p-8 border-r border-gray-100 dark:border-gray-700">
                    <div id="detailImageContainer" class="relative w-full aspect-square rounded-2xl overflow-hidden shadow-inner bg-white">
                        <img id="mainDetailImg" src="" alt="상품 이미지" class="w-full h-full object-contain">
                    </div>
                </div>

                <div class="lg:w-1/2 p-10 flex flex-col">
                    <div class="mb-6">
                        <span id="detailFuelCat" class="px-3 py-1 bg-blue-100 text-blue-600 text-xs font-bold rounded-full uppercase tracking-wider"></span>
                        <h2 id="detailFuelNm" class="text-3xl font-black text-gray-900 dark:text-white mt-3 mb-2"></h2>
                        <p id="detailFuelCd" class="text-sm text-gray-400 font-mono"></p>
                    </div>

                    <div class="flex items-center justify-between p-5 bg-gray-50 dark:bg-gray-700/50 rounded-2xl mb-8">
                        <div>
                            <p class="text-xs text-gray-400 mb-1">단가 (Base Unit Price)</p>
                            <span class="text-2xl font-bold text-blue-600" id="detailPrice"></span>
                            <span class="text-gray-500 ml-1" id="detailVolUnit"></span>
                        </div>
                        <div class="text-right">
                            <p class="text-xs text-gray-400 mb-1">판매상태</p>
                            <span id="detailStts" class="inline-flex items-center px-3 py-1 rounded-md text-sm font-bold"></span>
                        </div>
                    </div>

                    <h3 class="text-lg font-bold text-gray-800 dark:text-white mb-4 flex items-center">
                        <i class="ri-flask-line mr-2 text-blue-500"></i> 기술 사양 (Specifications)
                    </h3>
                    <div class="grid grid-cols-2 gap-4 mb-8">
                        <div class="p-3 border border-gray-100 dark:border-gray-700 rounded-xl">
                            <p class="text-xs text-gray-400">API Gravity</p>
                            <p id="detailApiGrv" class="font-semibold dark:text-gray-200">-</p>
                        </div>
                        <div class="p-3 border border-gray-100 dark:border-gray-700 rounded-xl">
                            <p class="text-xs text-gray-400">Sulfur Content (%)</p>
                            <p id="detailSulfur" class="font-semibold dark:text-gray-200">-</p>
                        </div>
                        <div class="p-3 border border-gray-100 dark:border-gray-700 rounded-xl">
                            <p class="text-xs text-gray-400">Flash Point (°C)</p>
                            <p id="detailFlashPnt" class="font-semibold dark:text-gray-200">-</p>
                        </div>
                        <div class="p-3 border border-gray-100 dark:border-gray-700 rounded-xl">
                            <p class="text-xs text-gray-400">Density @15°C</p>
                            <p id="detailDensity" class="font-semibold dark:text-gray-200">-</p>
                        </div>
                    </div>

                    <div class="space-y-4">
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-400">원산지</span>
                            <span id="detailOrigin" class="font-medium dark:text-gray-200"></span>
                        </div>
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-400">현재 재고</span>
                            <span id="detailStock" class="font-medium dark:text-gray-200"></span>
                        </div>
                    </div>

                    <div class="mt-auto pt-8">
                        <p class="text-xs text-gray-400 mb-2 font-bold uppercase">Product Memo</p>
                        <p id="detailMemo" class="text-sm text-gray-600 dark:text-gray-400 leading-relaxed"></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
/**
 * 상품 상세 조회 및 모달 열기
 */
 function openProductDetail(fuelId) {
	    if(!fuelId) return;

	    fetch('/usr/productView/api/' + fuelId)
	        .then(response => response.json())
	        .then(data => {
	            // 1. 기본 텍스트 정보 바인딩
	            document.getElementById('detailFuelNm').innerText = data.fuelNm;
	            document.getElementById('detailFuelCd').innerText = '#' + data.fuelCd;
	            document.getElementById('detailFuelCat').innerText = data.fuelCatNm;
	            document.getElementById('detailOrigin').innerText = data.originCntryNm;
	            
	            // 2. 숫자 포맷팅 (가격 및 재고)
	            const price = data.baseUnitPrc || 0;
	            document.getElementById('detailPrice').innerText = new Intl.NumberFormat().format(price);
	            document.getElementById('detailVolUnit').innerText = ' / ' + (data.volUnitNm || '');
	            
	            const stock = data.currStockVol || 0;
	            document.getElementById('detailStock').innerText = new Intl.NumberFormat().format(stock) + ' ' + (data.volUnitNm || '');

	            // 3. [해결] HTML 태그 및 이미지 출력 (innerHTML 사용)
	            // 에디터로 작성된 <p>, <img> 태그를 실제 화면으로 렌더링합니다.
	            document.getElementById('detailMemo').innerHTML = data.fuelMemo || '<p class="text-gray-400">등록된 상세 설명이 없습니다.</p>';
	            
	            // 4. 기술 사양 바인딩
	            document.getElementById('detailApiGrv').innerText = data.apiGrv || '-';
	            document.getElementById('detailSulfur').innerText = data.sulfurPCnt ? data.sulfurPCnt + '%' : '-';
	            document.getElementById('detailFlashPnt').innerText = data.flashPnt ? data.flashPnt + '°C' : '-';
	            document.getElementById('detailDensity').innerText = data.density15c || '-';

	            // 5. [해결] 판매 상태 코드별 분기 처리 (SA001, SO002, EX003, DC004)
	            const sttsEl = document.getElementById('detailStts');
	            const sCode = data.itemSttsCd; // 서버에서 넘어온 코드값
	            
	            let sttsText = data.itemSttsNm; // 기본값
	            let sttsClass = 'bg-gray-100 text-gray-600'; // 기본 스타일 (판매만료 등)

	            if (sCode === 'SA001') {
	                sttsText = '판매중';
	                sttsClass = 'bg-green-100 text-green-700';
	            } else if (sCode === 'SO002') {
	                sttsText = '품절';
	                sttsClass = 'bg-red-100 text-red-700';
	            } else if (sCode === 'EX003') {
	                sttsText = '판매만료';
	                sttsClass = 'bg-gray-100 text-gray-600';
	            } else if (sCode === 'DC004') {
	                sttsText = '단종';
	                sttsClass = 'bg-orange-100 text-orange-700';
	            }

	            sttsEl.innerText = sttsText;
	            sttsEl.className = 'inline-flex items-center px-3 py-1 rounded-md text-sm font-bold ' + sttsClass;

	            // 6. 메인 이미지 처리 (PRODUCT_M 우선순위)
	            let mainImgUrl = contextPath + '/images/no-image.png';
	            if (data.fileList && data.fileList.length > 0) {
	                // 상세용 이미지(PRODUCT_M)를 먼저 찾고, 없으면 첫 번째 이미지를 사용
	                const mainFile = data.fileList.find(f => f.systemId === 'PRODUCT_M') || data.fileList[0];
	                mainImgUrl = mainFile.fileUrl;
	            }
	            document.getElementById('mainDetailImg').src = mainImgUrl;

	            // 모달 표시
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
    document.body.style.overflow = 'auto'; // 스크롤 복구
}
</script>