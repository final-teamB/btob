<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .preview-container { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 8px; min-height: 50px; }
    .preview-item { position: relative; width: 120px; height: 120px; border: 1px solid #ddd; border-radius: 8px; overflow: hidden; background: #f3f4f6; }
    .preview-item img { width: 100%; height: 100%; object-fit: cover; cursor: pointer; }
    .preview-remove { position: absolute; top: 2px; right: 2px; background: rgba(239, 68, 68, 0.9); color: white; border-radius: 50%; width: 22px; height: 22px; font-size: 12px; cursor: pointer; display: flex; align-items: center; justify-content: center; font-weight: bold; z-index: 10; }
    /* 에디터 높이도 모달 크기에 맞춰 소폭 상향 조정 */
    #editor-container { height: 350px; border-bottom-left-radius: 0.5rem; border-bottom-right-radius: 0.5rem; }
    
    /* 인풋 필드 포커스 시 시각적 효과 강화 */
    .input-edit:focus { border-color: #2563eb; ring: 2px; ring-color: #bfdbfe; }
</style>

<div id="productModal" tabindex="-1" aria-hidden="true" data-modal-backdrop="static" class="fixed top-0 left-0 right-0 z-50 hidden w-full p-4 overflow-x-hidden overflow-y-auto h-full max-h-full bg-black/60 backdrop-blur-sm">
    
    <div class="relative w-full max-w-7xl max-h-full mx-auto my-4">
        <div class="relative bg-white rounded-2xl shadow-2xl border border-gray-200 overflow-hidden">
            
            <div class="flex items-center justify-between p-5 border-b bg-gray-50">
                <div class="flex items-center gap-2">
                    <div class="w-2 h-6 bg-blue-600 rounded-full"></div>
                    <h2 id="modalTitle" class="text-2xl font-bold text-gray-900">상품 정보 상세 설정</h2>
                </div>
                <button type="button" onclick="closeModal()" class="text-gray-400 hover:text-gray-900 hover:bg-gray-200 rounded-lg p-2 transition-colors">
                    <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>
            
            <form id="productForm" enctype="multipart/form-data">
                <input type="hidden" id="fuelId" name="fuelId">
                
                <div class="p-8 grid grid-cols-12 gap-10">
                    
                    <div class="col-span-12 lg:col-span-5 space-y-6 lg:border-r lg:pr-10">
                        <div class="flex items-center gap-2 mb-2">
                            <i class="fas fa-info-circle text-blue-600"></i>
                            <h3 class="font-bold text-gray-800 text-lg uppercase tracking-tight">기본 정보</h3>
                        </div>
                        
                        <div class="space-y-4">
                            <div>
                                <label class="block text-sm font-bold text-gray-700 mb-1.5">상품명</label>
                                <input type="text" id="fuelNm" class="w-full border-gray-300 rounded-lg p-3 text-base focus:ring-2 focus:ring-blue-500 outline-none border transition-all" placeholder="상품 명칭을 입력하세요" required>
                            </div>

                            <div class="grid grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-sm font-bold text-gray-700 mb-1.5">유류코드</label>
                                    <input type="text" id="fuelCd" class="w-full border-gray-300 rounded-lg p-3 text-base bg-gray-50" readonly>
                                </div>
                                <div>
                                    <label class="block text-sm font-bold text-gray-700 mb-1.5">유류종류</label>
                                    <select id="fuelCatCd" class="w-full border-gray-300 rounded-lg p-3 text-base focus:ring-2 focus:ring-blue-500 outline-none border transition-all">
                                        <c:forEach var="item" items="${selectBoxes.fuelCatList}">
                                            <option value="${item.value}">${item.text}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="grid grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-sm font-bold text-gray-700 mb-1.5">단가 (₩)</label>
                                    <input type="number" id="baseUnitPrc" class="w-full border-gray-300 rounded-lg p-3 text-base border">
                                </div>
                                <div>
                                    <label class="block text-sm font-bold text-gray-700 mb-1.5">원산지 국가</label>
                                    <select id="originCntryCd" class="w-full border-gray-300 rounded-lg p-3 text-base border">
                                        <c:forEach var="item" items="${selectBoxes.countryList}">
                                            <option value="${item.value}">${item.text}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="grid grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-sm font-bold text-gray-700 mb-1.5">현재 재고량</label>
                                    <input type="number" id="currStockVol" class="w-full border-gray-300 rounded-lg p-3 text-base border">
                                </div>
                                <div>
                                    <label class="block text-sm font-bold text-gray-700 mb-1.5">안전 재고량</label>
                                    <input type="number" id="safeStockVol" class="w-full border-gray-300 rounded-lg p-3 text-base border">
                                </div>
                            </div>

                            <div class="grid grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-sm font-bold text-gray-700 mb-1.5">용량 단위</label>
                                    <select id="volUnitCd" class="w-full border-gray-300 rounded-lg p-3 text-base border">
                                        <c:forEach var="item" items="${selectBoxes.volUnitList}">
                                            <option value="${item.value}">${item.text}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label class="block text-sm font-bold text-gray-700 mb-1.5">재고 상태</label>
                                    <select id="itemSttsCd" class="w-full border-gray-300 rounded-lg p-3 text-base border">
                                        <c:forEach var="item" items="${selectBoxes.itemSttsList}">
                                            <option value="${item.value}">${item.text}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="grid grid-cols-1 gap-4 pt-2">
                                <div class="p-4 bg-blue-50/50 rounded-xl border border-blue-100">
                                    <div class="flex justify-between items-center mb-3">
                                        <label class="text-sm font-bold text-blue-800">메인 이미지</label>
                                        <button type="button" onclick="document.getElementById('mainFile').click()" class="px-3 py-1 bg-white border border-blue-300 text-blue-600 rounded-md text-xs font-bold hover:bg-blue-50">파일 선택</button>
                                    </div>
                                    <input type="file" id="mainFile" class="hidden" accept="image/*" onchange="previewImage(this, 'mainPreview')">
                                    <div id="mainPreview" class="preview-container justify-center"></div>
                                </div>
                                
                                <div class="p-4 bg-gray-50 rounded-xl border border-gray-200">
                                    <div class="flex justify-between items-center mb-3">
                                        <label class="text-sm font-bold text-gray-700">서브 이미지</label>
                                        <button type="button" onclick="document.getElementById('subFile').click()" class="px-3 py-1 bg-white border border-gray-300 text-gray-600 rounded-md text-xs font-bold hover:bg-gray-100">파일 선택</button>
                                    </div>
                                    <input type="file" id="subFile" class="hidden" accept="image/*" onchange="previewImage(this, 'subPreview')">
                                    <div id="subPreview" class="preview-container justify-center"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-span-12 lg:col-span-7 space-y-6">
                        <div class="flex items-center gap-2 mb-2">
                            <i class="fas fa-list-alt text-blue-600"></i>
                            <h3 class="font-bold text-gray-800 text-lg uppercase tracking-tight">상세 스펙 및 설명</h3>
                        </div>

                        <div class="grid grid-cols-5 gap-3 bg-gray-50 p-5 rounded-xl border border-gray-200">
                            <div class="col-span-1">
                                <label class="block text-[11px] font-extrabold text-gray-500 mb-1 uppercase">API GRV</label>
                                <input type="number" id="apiGrv" class="w-full border-gray-300 rounded p-2 text-sm focus:ring-1 focus:ring-blue-500 outline-none">
                            </div>
                            <div class="col-span-1">
                                <label class="block text-[11px] font-extrabold text-gray-500 mb-1 uppercase">Sulfur(%)</label>
                                <input type="number" id="sulfurPCnt" class="w-full border-gray-300 rounded p-2 text-sm focus:ring-1 focus:ring-blue-500 outline-none">
                            </div>
                            <div class="col-span-1">
                                <label class="block text-[11px] font-extrabold text-gray-500 mb-1 uppercase">Flash Pt</label>
                                <input type="number" id="flashPnt" class="w-full border-gray-300 rounded p-2 text-sm focus:ring-1 focus:ring-blue-500 outline-none">
                            </div>
                            <div class="col-span-1">
                                <label class="block text-[11px] font-extrabold text-gray-500 mb-1 uppercase">Viscosity</label>
                                <input type="number" id="viscosity" class="w-full border-gray-300 rounded p-2 text-sm focus:ring-1 focus:ring-blue-500 outline-none">
                            </div>
                            <div class="col-span-1">
                                <label class="block text-[11px] font-extrabold text-gray-500 mb-1 uppercase">Density</label>
                                <input type="number" id="density15c" class="w-full border-gray-300 rounded p-2 text-sm focus:ring-1 focus:ring-blue-500 outline-none">
                            </div>
                        </div>

                        <div class="flex flex-col h-full">
                            <label class="block text-sm font-bold text-gray-700 mb-2">상세 상품 설명 (HTML 에디터)</label>
                            <div class="flex-grow shadow-sm">
                                <div id="editor-container"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="flex items-center p-6 border-t bg-gray-50 gap-3">
                    <button type="button" onclick="saveProduct()" class="px-10 py-3 text-base font-bold text-white bg-blue-600 rounded-xl hover:bg-blue-700 shadow-lg shadow-blue-200 transition-all transform hover:-translate-y-0.5 active:scale-95">상품 저장하기</button>
                    
                    <button type="button" id="btnDeleteProduct" onclick="deleteProduct()" class="px-6 py-3 text-base font-bold text-red-600 bg-white border border-red-200 rounded-xl hover:bg-red-50 transition-all" style="display:none;">상품 미사용 처리</button>
                    
                    <button type="button" onclick="closeModal()" class="px-8 py-3 text-base font-medium text-gray-600 bg-white border border-gray-300 rounded-xl hover:bg-gray-100 ml-auto transition-all">닫기</button>
                </div>
            </form>
        </div>
    </div>
</div>