<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .preview-container { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 8px; min-height: 50px; }
    .preview-item { position: relative; width: 100px; height: 100px; border: 1px solid #ddd; border-radius: 8px; overflow: hidden; background: #f3f4f6; }
    .preview-item img { width: 100%; height: 100%; object-fit: cover; cursor: pointer; }
    .preview-remove { position: absolute; top: 2px; right: 2px; background: rgba(239, 68, 68, 0.9); color: white; border-radius: 50%; width: 20px; height: 20px; font-size: 12px; cursor: pointer; display: flex; align-items: center; justify-content: center; font-weight: bold; z-index: 10; }
    #editor-container { height: 300px; border-bottom-left-radius: 0.5rem; border-bottom-right-radius: 0.5rem; }
</style>

<div id="productModal" tabindex="-1" aria-hidden="true" class="fixed top-0 left-0 right-0 z-50 hidden w-full p-4 overflow-x-hidden overflow-y-auto h-[calc(100%-1rem)] max-h-full bg-black/50">
    <div class="relative w-full max-w-5xl max-h-full mx-auto">
        <div class="relative bg-white rounded-xl shadow-2xl border border-gray-200">
            <div class="flex items-center justify-between p-4 border-b">
                <h2 id="modalTitle" class="text-xl font-bold text-gray-900">상품 정보 상세 설정</h2>
                <button type="button" onclick="closeModal()" class="text-gray-400 hover:text-gray-900 ml-auto p-2">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>
            
            <form id="productForm" enctype="multipart/form-data">
                <input type="hidden" id="fuelId" name="fuelId">
                <div class="p-6 grid grid-cols-12 gap-6">
                    <div class="col-span-12 md:col-span-6 space-y-4 border-r pr-6">
                        <h3 class="font-bold text-blue-600 border-b pb-1 text-sm uppercase">기본 정보</h3>
                        <div>
                            <label class="block text-sm font-semibold text-gray-700 mb-1">상품명</label>
                            <input type="text" id="fuelNm" class="w-full border rounded-lg p-2 text-sm focus:ring-2 focus:ring-blue-500 outline-none" required>
                        </div>
                        <div class="grid grid-cols-2 gap-3">
                            <div>
                                <label class="block text-sm font-semibold text-gray-700 mb-1">유류코드</label>
                                <input type="text" id="fuelCd" class="w-full border rounded-lg p-2 text-sm input-edit" placeholder="유류코드 입력">
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-gray-700 mb-1">유류종류</label>
                                <select id="fuelCatCd" class="w-full border rounded-lg p-2 text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                                    <c:forEach var="item" items="${selectBoxes.fuelCatList}">
                                        <option value="${item.value}">${item.text}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="grid grid-cols-2 gap-3">
                            <div>
                                <label class="block text-sm font-semibold text-gray-700 mb-1">단가 (₩)</label>
                                <input type="number" id="baseUnitPrc" class="w-full border rounded-lg p-2 text-sm">
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-gray-700 mb-1">원산지 국가</label>
                                <select id="originCntryCd" class="w-full border rounded-lg p-2 text-sm">
                                    <c:forEach var="item" items="${selectBoxes.countryList}">
                                        <option value="${item.value}">${item.text}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="grid grid-cols-2 gap-3">
                            <div>
                                <label class="block text-sm font-semibold text-gray-700 mb-1">현재 재고량</label>
                                <input type="number" id="currStockVol" class="w-full border rounded-lg p-2 text-sm">
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-gray-700 mb-1">안전 재고량</label>
                                <input type="number" id="safeStockVol" class="w-full border rounded-lg p-2 text-sm">
                            </div>
                        </div>
                        <div class="grid grid-cols-2 gap-3">
                            <div>
                                <label class="block text-sm font-semibold text-gray-700 mb-1">용량 단위</label>
                                <select id="volUnitCd" class="w-full border rounded-lg p-2 text-sm">
                                    <c:forEach var="item" items="${selectBoxes.volUnitList}">
                                        <option value="${item.value}">${item.text}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-gray-700 mb-1">재고 상태</label>
                                <select id="itemSttsCd" class="w-full border rounded-lg p-2 text-sm">
                                    <c:forEach var="item" items="${selectBoxes.itemSttsList}">
                                        <option value="${item.value}">${item.text}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="grid grid-cols-2 gap-4 mt-2">
                            <div>
                                <label class="block text-sm font-semibold text-gray-700 mb-1">메인 이미지</label>
                                <input type="file" id="mainFile" class="hidden" accept="image/*" onchange="previewImage(this, 'mainPreview')">
                                <button type="button" onclick="document.getElementById('mainFile').click()" class="w-full py-2 bg-gray-100 border rounded text-xs hover:bg-gray-200">이미지 선택</button>
                                <div id="mainPreview" class="preview-container"></div>
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-gray-700 mb-1">서브 이미지</label>
                                <input type="file" id="subFile" class="hidden" accept="image/*" onchange="previewImage(this, 'subPreview')">
                                <button type="button" onclick="document.getElementById('subFile').click()" class="w-full py-2 bg-gray-100 border rounded text-xs hover:bg-gray-200">이미지 선택</button>
                                <div id="subPreview" class="preview-container"></div>
                            </div>
                        </div>
                    </div>

                    <div class="col-span-12 md:col-span-6 space-y-4">
                        <h3 class="font-bold text-blue-600 border-b pb-1 text-sm uppercase">상세 정보 및 설명</h3>
                        <div class="grid grid-cols-3 gap-2">
                            <div><label class="text-[11px] font-bold">API GRV</label><input type="text" id="apiGrv" class="w-full border rounded p-1 text-sm"></div>
                            <div><label class="text-[11px] font-bold">Sulfur(%)</label><input type="text" id="sulfurPCnt" class="w-full border rounded p-1 text-sm"></div>
                            <div><label class="text-[11px] font-bold">Flash Pt</label><input type="text" id="flashPnt" class="w-full border rounded p-1 text-sm"></div>
                            <div><label class="text-[11px] font-bold">Viscosity</label><input type="text" id="viscosity" class="w-full border rounded p-1 text-sm"></div>
                            <div><label class="text-[11px] font-bold">Density 15C</label><input type="text" id="density15c" class="w-full border rounded p-1 text-sm"></div>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-gray-700 mb-1">상세 설명</label>
                            <div id="editor-container"></div>
                        </div>
                    </div>
                </div>
                <div class="flex items-center p-6 border-t gap-2">
                    <button type="button" onclick="saveProduct()" class="px-6 py-2 text-sm font-bold text-white bg-blue-600 rounded-lg hover:bg-blue-700 transition">저장</button>
                    <button type="button" id="btnDeleteProduct" onclick="deleteProduct()" class="px-6 py-2 text-sm font-bold text-red-600 bg-red-50 rounded-lg hover:bg-red-100 border border-red-200 transition" style="display:none;">미사용 처리</button>
                    <button type="button" onclick="closeModal()" class="px-4 py-2 text-sm font-medium text-gray-500 bg-white border rounded-lg ml-auto">취소</button>
                </div>
            </form>
        </div>
    </div>
</div>