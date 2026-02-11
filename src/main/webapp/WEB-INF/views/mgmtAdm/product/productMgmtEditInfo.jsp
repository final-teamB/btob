<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<body>
<div id="editModal" tabindex="-1" class="fixed top-0 left-0 right-0 z-50 hidden w-full p-4 overflow-x-hidden overflow-y-auto h-full bg-black/50">
    <div class="relative w-full max-w-5xl mx-auto mt-5">
        <form id="editForm" onsubmit="return false;" class="relative bg-white rounded-xl shadow-lg border">
            <div class="flex items-center justify-between p-4 border-b">
                <h2 class="text-xl font-bold">상품 정보 수정</h2>
                <button type="button" onclick="closeEditModal()" class="text-gray-400 hover:text-gray-900">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>

            <input type="hidden" id="editFuelId" name="fuelId">

            <div class="p-6 grid grid-cols-12 gap-6">
                <div class="col-span-12 md:col-span-6 space-y-4 border-r pr-6">
                    <h3 class="font-bold text-blue-600 border-b pb-1 text-sm uppercase">기본 정보 수정</h3>
                    
                    <div>
                        <label class="block text-[11px] font-bold text-gray-500 mb-1">상품명</label>
                        <input type="text" id="editFuelNm" class="w-full border rounded-lg p-2 text-sm font-semibold focus:ring-2 focus:ring-blue-500 outline-none">
                    </div>

                    <div class="grid grid-cols-2 gap-3">
                        <div>
                            <label class="block text-[11px] font-bold text-gray-500 mb-1">유류코드 (수정불가)</label>
                            <input type="text" id="editFuelCd" class="w-full bg-gray-100 border rounded-lg p-2 text-sm text-gray-500" readonly>
                        </div>
                        <div>
                            <label class="block text-[11px] font-bold text-gray-500 mb-1">유류종류</label>
                            <select id="editFuelCatCd" class="w-full border rounded-lg p-2 text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                                <c:forEach var="item" items="${selectBoxes.fuelCatList}">
                                    <option value="${item.value}">${item.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="grid grid-cols-2 gap-3">
                        <div>
                            <label class="block text-[11px] font-bold text-gray-500 mb-1">단가 (₩)</label>
                            <input type="number" id="editBaseUnitPrc" class="w-full border rounded-lg p-2 text-sm font-bold text-blue-700">
                        </div>
                        <div>
                            <label class="block text-[11px] font-bold text-gray-500 mb-1">원산지 국가</label>
                            <select id="editOriginCntryCd" class="w-full border rounded-lg p-2 text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                                <c:forEach var="item" items="${selectBoxes.countryList}">
                                    <option value="${item.value}">${item.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="grid grid-cols-2 gap-3">
                        <div>
                            <label class="block text-[11px] font-bold text-gray-500 mb-1">현재 재고량</label>
                            <input type="number" id="editCurrStockVol" class="w-full border rounded-lg p-2 text-sm">
                        </div>
                        <div>
                            <label class="block text-[11px] font-bold text-gray-500 mb-1">안전 재고량</label>
                            <input type="number" id="editSafeStockVol" class="w-full border rounded-lg p-2 text-sm">
                        </div>
                    </div>

                    <div class="grid grid-cols-2 gap-3">
                        <div>
                            <label class="block text-[11px] font-bold text-gray-500 mb-1">용량 단위</label>
                            <select id="editVolUnitCd" class="w-full border rounded-lg p-2 text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                                <c:forEach var="item" items="${selectBoxes.volUnitList}">
                                    <option value="${item.value}">${item.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div>
                            <label class="block text-[11px] font-bold text-gray-500 mb-1">재고 상태</label>
                            <select id="editItemSttsCd" class="w-full border rounded-lg p-2 text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                                <c:forEach var="item" items="${selectBoxes.itemSttsList}">
                                    <option value="${item.value}">${item.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div>
                        <label class="block text-[11px] font-bold text-gray-500 mb-1">사용 여부</label>
                        <select id="editUseYn" class="w-full border rounded-lg p-2 text-sm bg-blue-50 font-bold">
                            <option value="Y">사용함 (ACTIVE)</option>
                            <option value="N">사용안함 (STOPPED)</option>
                        </select>
                    </div>

                    <div class="grid grid-cols-2 gap-4 pt-2 border-t">
                        <div>
						    <label class="block text-[11px] font-bold text-gray-500 mb-1">메인 이미지</label>
						    <div id="editMainImgContainer" class="w-full h-32 bg-gray-50 rounded-lg border border-dashed flex items-center justify-center overflow-hidden mb-2"></div>
						    <input type="file" id="mainFile" accept="image/*" class="text-[10px] w-full" 
						           onchange="handleImageChange(this, 'editMainImgContainer', 'editMainRemainName')">
						    <input type="hidden" id="editMainRemainName">
						</div>
						
						<div>
						    <label class="block text-[11px] font-bold text-gray-500 mb-1">서브 이미지</label>
						    <div id="editSubImgContainer" class="w-full h-32 bg-gray-50 rounded-lg border border-dashed flex items-center justify-center overflow-hidden mb-2"></div>
						    <input type="file" id="subFile" accept="image/*" class="text-[10px] w-full" 
						           onchange="handleImageChange(this, 'editSubImgContainer', 'editSubRemainName')">
						    <input type="hidden" id="editSubRemainName">
						</div>
                    </div>
                </div>

                <div class="col-span-12 md:col-span-6 space-y-4">
                    <h3 class="font-bold text-blue-600 border-b pb-1 text-sm uppercase">기술 제원 수정</h3>
                    <div class="grid grid-cols-2 gap-3 bg-gray-50 p-4 rounded-xl border border-gray-100">
                        <div>
                            <label class="block text-[11px] font-bold text-gray-600 mb-1 uppercase">API GRV</label>
                            <input type="number" step="0.01" id="editApiGrv" class="w-full border rounded p-2 text-sm">
                        </div>
                        <div>
                            <label class="block text-[11px] font-bold text-gray-600 mb-1 uppercase">Sulfur (%)</label>
                            <input type="number" step="0.01" id="editSulfurPCnt" class="w-full border rounded p-2 text-sm">
                        </div>
                        <div>
                            <label class="block text-[11px] font-bold text-gray-600 mb-1 uppercase">Flash Pt</label>
                            <input type="number" step="0.1" id="editFlashPnt" class="w-full border rounded p-2 text-sm">
                        </div>
                        <div>
                            <label class="block text-[11px] font-bold text-gray-600 mb-1 uppercase">Viscosity</label>
                            <input type="number" step="0.1" id="editViscosity" class="w-full border rounded p-2 text-sm">
                        </div>
                        <div class="col-span-2">
                            <label class="block text-[11px] font-bold text-gray-600 mb-1 uppercase">Density 15C</label>
                            <input type="number" step="0.0001" id="editDensity15c" class="w-full border rounded p-2 text-sm">
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-2 uppercase">상품 상세 설명 (Editor)</label>
                        <div id="editQuillEditor" class="bg-white border rounded-lg" style="height: 220px;"></div>
                    </div>
                </div>
            </div>

            <div class="flex items-center p-4 border-t gap-2 justify-end bg-gray-50 rounded-b-xl">
                <button type="button" onclick="closeEditModal()" class="px-4 py-2 text-sm font-medium text-gray-500 border bg-white rounded-lg hover:bg-gray-100">취소</button>
                <button type="button" onclick="saveProductEdit()" class="px-6 py-2 text-sm font-bold text-white bg-blue-600 rounded-lg hover:bg-blue-700 shadow-md">정보 수정 완료</button>
            </div>
        </form>
    </div>
</div>

<script>
    let editModal = null;
    let editQuill = null;

    document.addEventListener('DOMContentLoaded', function() {
        // 1. 모달 및 에디터 초기화
        const modalEl = document.getElementById('editModal');
        if (modalEl && typeof Modal !== 'undefined') {
            editModal = new Modal(modalEl, { backdrop: 'static', closable: false });
        }
        if (document.getElementById('editQuillEditor')) {
            editQuill = new Quill('#editQuillEditor', {
                theme: 'snow',
                modules: { 
                    toolbar: [
                        ['bold', 'italic', 'underline'], 
                        [{ 'list': 'ordered'}, { 'list': 'bullet' }], 
                        ['image', 'clean']
                    ] 
                }
            });
        }

        // 2. 이미지 변경 이벤트 통합 등록
        const mainFileInp = document.getElementById('mainFile');
        if(mainFileInp) {
            mainFileInp.addEventListener('change', function() {
                handleImageChange(this, 'editMainImgContainer', 'editMainRemainName');
            });
        }
        const subFileInp = document.getElementById('subFile');
        if(subFileInp) {
            subFileInp.addEventListener('change', function() {
                handleImageChange(this, 'editSubImgContainer', 'editSubRemainName');
            });
        }
    });

    /**
     * 이미지 선택 시 즉시 서버 임시 업로드 수행 및 미리보기 갱신
     */
     function handleImageChange(input, containerId, hiddenInputId) {
    		
    		// 1. 함수가 실행되는지 확인하기 위한 로그
    	    console.log("handleImageChange 함수 시작됨! 대상:", containerId);

    	    if (!input.files || !input.files[0]) {
    	        console.log("선택된 파일이 없습니다.");
    	        return;
    	    }
    	
    	    if (!input.files || !input.files[0]) return;

    	    const formData = new FormData();
    	    formData.append("file", input.files[0]);

    	    fetch(cp + '/api/file/temp-img-upload', {
    	        method: 'POST',
    	        body: formData
    	    })
    	    .then(res => res.json())
    	    .then(data => {
    	        // [수정] data.url이 이미 /api/...로 시작한다면 cp와 중복되지 않게 처리
    	        console.log("dataurl확인" + data.url);
    	        if (data.url) {
    	            const displayUrl = data.url.startsWith('http') ? data.url : (cp + data.url);
    	            const imgHtml = '<img src="' + displayUrl + '" class="w-full h-full object-contain">';
    	            document.getElementById(containerId).innerHTML = imgHtml;
    	            
    	            // [중요] 서버의 registerInternalImgFile은 '임시파일명'을 orgFileNm으로 받아서 찾습니다.
    	            // data.fileName이 서버가 생성한 UUID라면 이 값을 반드시 hidden에 넣어야 합니다.
    	            document.getElementById(hiddenInputId).value = data.fileName;
    	            console.log("임시 파일명 저장:", data.fileName);
    	        }
    	    })
    	    .catch(err => {
    	        console.error("업로드 에러:", err);
    	        alert("이미지 업로드에 실패했습니다.");
    	    });
    	}

    /**
     * 최종 정보 수정 완료 (Save)
     */
    function saveProductEdit() {
        const fuelId = document.getElementById('editFuelId').value;
        const formData = new FormData();

        // 1. 텍스트 데이터 구성
        const productData = {
            productBase: {
                fuelId: fuelId,
                fuelNm: document.getElementById('editFuelNm').value,
                fuelCatCd: document.getElementById('editFuelCatCd').value,
                originCntryCd: document.getElementById('editOriginCntryCd').value,
                baseUnitPrc: document.getElementById('editBaseUnitPrc').value,
                currStockVol: document.getElementById('editCurrStockVol').value,
                safeStockVol: document.getElementById('editSafeStockVol').value,
                volUnitCd: document.getElementById('editVolUnitCd').value,
                itemSttsCd: document.getElementById('editItemSttsCd').value,
                useYn: document.getElementById('editUseYn').value
            },
            productDetail: {
                fuelId: fuelId,
                apiGrv: document.getElementById('editApiGrv').value,
                sulfurPCnt: document.getElementById('editSulfurPCnt').value,
                flashPnt: document.getElementById('editFlashPnt').value,
                viscosity: document.getElementById('editViscosity').value,
                density15c: document.getElementById('editDensity15c').value,
                fuelMemo: editQuill.root.innerHTML,
                useYn: document.getElementById('editUseYn').value
            }
        };

        formData.append("productData", new Blob([JSON.stringify(productData)], { type: "application/json" }));

        // 2. 파일명 리스트 추가 (서버 Service 로직의 List<String> mainRemainNames 파라미터 대응)
        const mainName = document.getElementById('editMainRemainName').value;
        const subName = document.getElementById('editSubRemainName').value;

        if (mainName) formData.append("mainRemainNames", mainName);
        if (subName) formData.append("subRemainNames", subName);

        // ※ 주의: handleImageChange에서 이미 업로드했으므로 mainFiles 파라미터(파일 원본)는 보내지 않아도 됩니다.
        // 서버의 registerInternalImgFile이 mainRemainNames를 읽어서 Temp 폴더 파일을 이동시킵니다.

        fetch(cp + '/admin/products/api/modify/' + fuelId, {
            method: 'POST',
            body: formData
        }).then(res => {
            if(res.ok) {
                alert("상품 정보가 성공적으로 업데이트되었습니다.");
                
             	// [수정 포인트] 
                // 1. 그리드 데이터를 갱신 (목록 업데이트)
                if (window.fetchData) window.fetchData(); 
                
                // 2. 현재 수정창을 닫고 상세 정보창을 띄우거나, 현재 창 데이터를 갱신
                // 만약 상세 조회 전용 함수(예: openDetailView)가 있다면 그것을 호출하세요.
                if (typeof openDetailView === 'function') {
                    closeEditModal();
                    openDetailView(fuelId); 
                } else {
                    // 상세조회 함수가 따로 없다면 현재 수정 모달을 최신 정보로 갱신
                    openEditModalByFuelId(fuelId);
                }
                
            } else {
                alert("수정 실패: 서버 오류가 발생했습니다.");
            }
        }).catch(err => {
            console.error("저장 에러:", err);
            alert("서버와 통신 중 에러가 발생했습니다.");
        });
    }

    function openEditModalByFuelId(fuelId) {
        if(!fuelId) return;
        const url = cp + '/admin/products/api/' + fuelId;

        fetch(url)
            .then(res => res.json())
            .then(data => {
                // MST 및 DETAIL 데이터 바인딩 (기존 로직 유지)
                document.getElementById('editFuelId').value = data.fuelId;
                document.getElementById('editFuelNm').value = data.fuelNm || '';
                document.getElementById('editFuelCd').value = data.fuelCd || '';
                document.getElementById('editFuelCatCd').value = data.fuelCatCd || '';
                document.getElementById('editOriginCntryCd').value = data.originCntryCd || '';
                document.getElementById('editVolUnitCd').value = data.volUnitCd || '';
                document.getElementById('editItemSttsCd').value = data.itemSttsCd || '';
                document.getElementById('editBaseUnitPrc').value = data.baseUnitPrc || 0;
                document.getElementById('editCurrStockVol').value = data.currStockVol || 0;
                document.getElementById('editSafeStockVol').value = data.safeStockVol || 0;
                document.getElementById('editUseYn').value = (data.useYn === 'ACTIVE' || data.useYn === 'Y') ? 'Y' : 'N';
                document.getElementById('editApiGrv').value = data.apiGrv || '';
                document.getElementById('editSulfurPCnt').value = data.sulfurPCnt || '';
                document.getElementById('editFlashPnt').value = data.flashPnt || '';
                document.getElementById('editViscosity').value = data.viscosity || '';
                document.getElementById('editDensity15c').value = data.density15c || '';
                if (editQuill) editQuill.root.innerHTML = data.fuelMemo || '';

                // 이미지 초기화 및 바인딩
                const mainCont = document.getElementById('editMainImgContainer');
                const subCont = document.getElementById('editSubImgContainer');
                mainCont.innerHTML = '<span class="text-gray-400 text-[10px]">이미지 없음</span>'; 
                subCont.innerHTML = '<span class="text-gray-400 text-[10px]">이미지 없음</span>';
                document.getElementById('editMainRemainName').value = '';
                document.getElementById('editSubRemainName').value = '';

                if (data.fileList && data.fileList.length > 0) {
                    data.fileList.forEach(file => {
                        const imgHtml = '<img src="' + cp + file.fileUrl + '" class="w-full h-full object-contain">';
                        if (file.systemId === 'PRODUCT_M') {
                            mainCont.innerHTML = imgHtml;
                            document.getElementById('editMainRemainName').value = file.strFileNm;
                        } else if (file.systemId === 'PRODUCT_S') {
                            subCont.innerHTML = imgHtml;
                            document.getElementById('editSubRemainName').value = file.strFileNm;
                        }
                    });
                }
                if(editModal) editModal.show();
            });
    }

    function closeEditModal() { if(editModal) editModal.hide(); }
</script>
</body>
</html>