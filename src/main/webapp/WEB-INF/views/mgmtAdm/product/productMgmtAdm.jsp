<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cp" value="${pageContext.request.contextPath}" />

<style>
    .fuel-link { color: #2563eb !important; text-decoration: underline !important; cursor: pointer; font-weight: 600; }
    input[readonly] { background-color: #f9fafb !important; color: #6b7280 !important; cursor: not-allowed; }

    .tui-grid-cell-row-header input[type="checkbox"] {
        cursor: pointer; width: 18px !important; height: 18px !important;
        border: 2px solid #374151 !important; accent-color: #2563eb; appearance: auto;
    }

    #dg-container { width: 100%; margin-top: 1rem; }
    
    /* [핵심 수정] 검색창 라인에 버튼을 강제로 맞추기 위한 absolute 설정 */
    .grid-relative-wrapper {
        position: relative;
        width: 100%;
    }

    .batch-action-fixed {
        position: absolute;
        /* [보정] 28px에서 33px로 조정하여 수평을 맞췄습니다 */
        top: 60px; 
        right: 20px;
        z-index: 10;
        display: flex;
        align-items: center;
    }
    
    /* 버튼 텍스트와 아이콘이 찌그러지지 않도록 너비 확보 */
    .btn-batch-delete {
        white-space: nowrap;
        display: flex;
        align-items: center;
        gap: 0.375rem;
    }
</style>

<div class="max-w-screen-2xl mx-auto">
    <div class="bg-white p-8 rounded-xl shadow-lg border border-gray-100 dark:bg-gray-800 dark:border-gray-700">
        
        <%-- [1] 상단 헤더 --%>
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
            <div>
                <h2 class="text-2xl font-bold text-gray-900 dark:text-white">상품 관리</h2>
                <p class="text-sm text-gray-500 mt-1">리스트에서 상품을 선택하여 일괄 미사용 처리가 가능합니다.</p>
            </div>
            <div class="flex flex-wrap items-center gap-2">
                <button type="button" class="px-3 py-1.5 text-sm font-medium text-gray-700 bg-white border border-gray-200 rounded-lg hover:bg-gray-50 transition">일괄양식 다운로드</button>
                <button type="button" class="px-3 py-1.5 text-sm font-medium text-gray-700 bg-white border border-gray-200 rounded-lg hover:bg-gray-50 transition">일괄 업로드</button>
                <button type="button" id="dg-btn-download-custom" class="px-3 py-1.5 text-sm font-medium text-gray-700 bg-white border border-gray-200 rounded-lg hover:bg-gray-50 transition">엑셀 다운로드</button>
                <button type="button" onclick="handleAddAction()" class="px-3 py-1.5 text-sm font-semibold text-white bg-blue-600 rounded-lg hover:bg-blue-700 transition active:scale-95">+ 신규 등록</button>
            </div>
        </div>

        <%-- [2] 그리드 영역 및 부유 버튼 --%>
        <div class="grid-relative-wrapper">
            <div class="batch-action-fixed">
                <button type="button" onclick="handleBatchDelete()" 
                        class="btn-batch-delete px-4 py-2 text-sm font-bold text-red-600 bg-red-50 border border-red-200 rounded-lg hover:bg-red-100 transition active:scale-95 shadow-sm">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                    </svg>
                    선택 미사용 처리
                </button>
            </div>

            <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp">
                <jsp:param name="showSearchArea" value="true" />
                <jsp:param name="showPerPage" value="true" />
            </jsp:include>
        </div>
    </div>
</div>

<%-- 등록/수정 모달 --%>
<div id="productModal" tabindex="-1" aria-hidden="true" class="fixed top-0 left-0 right-0 z-50 hidden w-full p-4 overflow-x-hidden overflow-y-auto h-[calc(100%-1rem)] max-h-full">
    <div class="relative w-full max-w-4xl max-h-full">
        <div class="relative bg-white rounded-xl shadow-2xl border border-gray-200 dark:bg-gray-700">
            <div class="flex items-center justify-between p-4 border-b">
                <h2 id="modalTitle" class="text-2xl font-bold text-gray-900 dark:text-white">상품 정보 상세 설정</h2>
                <button type="button" onclick="closeModal()" class="text-gray-400 hover:text-gray-900 ml-auto p-2">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            <form id="productForm">
                <input type="hidden" id="fuelId" name="fuelId">
                <div class="p-6 grid grid-cols-2 gap-4">
                    <div class="col-span-2">
                        <label class="block text-sm font-semibold text-gray-700 mb-1">상품명 (fuelNm)</label>
                        <input type="text" id="fuelNm" name="fuelNm" class="w-full border rounded-lg p-2.5 text-sm focus:ring-2 focus:ring-blue-500 outline-none" required>
                    </div>
                    <div><label class="block text-sm font-semibold text-gray-700 mb-1">유류코드</label><input type="text" id="fuelCd" class="w-full border rounded-lg p-2.5 text-sm" readonly></div>
                    <div><label class="block text-sm font-semibold text-gray-700 mb-1">유류종류</label><input type="text" id="fuelCatNm" class="w-full border rounded-lg p-2.5 text-sm" readonly></div>
                    <div><label class="block text-sm font-semibold text-gray-700 mb-1">단가</label><input type="number" id="baseUnitPrc" name="baseUnitPrc" class="w-full border rounded-lg p-2.5 text-sm"></div>
                    <div><label class="block text-sm font-semibold text-gray-700 mb-1">안전재고</label><input type="number" id="safeStockVol" name="safeStockVol" class="w-full border rounded-lg p-2.5 text-sm"></div>
                </div>
                <div class="flex items-center p-6 border-t gap-2">
                    <button type="button" onclick="saveProduct()" class="px-3 py-1.5 text-sm font-bold text-white bg-blue-600 rounded-lg hover:bg-blue-700 transition">저장</button>
                    <button type="button" id="btnDeleteProduct" onclick="deleteProduct()" class="px-3 py-1.5 text-sm font-bold text-red-600 bg-red-50 rounded-lg hover:bg-red-100 border border-red-200 transition" style="display:none;">미사용 처리</button>
                    <button type="button" onclick="closeModal()" class="px-3 py-1.5 text-sm font-medium text-gray-500 bg-white border rounded-lg hover:bg-gray-50 ml-auto">취소</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    /* ... 스크립트 로직은 이전과 동일하므로 유지 ... */
    const cp = '${cp}';
    let myGrid;
    let productModal;

    document.addEventListener('DOMContentLoaded', function() {
        if (typeof Modal !== 'undefined') {
            productModal = new Modal(document.getElementById('productModal'));
        }
        window.fetchData(); 
    });

    window.fetchData = function() {
        const searchInput = document.getElementById('dg-search-input');
        const searchCondition = searchInput && searchInput.value ? encodeURIComponent(searchInput.value) : '';
        
        fetch(cp + '/admin/products/api/list?limit=5000&searchCondition=' + searchCondition)
            .then(res => res.json())
            .then(data => {
                const gridData = (data.list || []).map(item => ({
                    ...item,
                    useYn: item.useYn === 'Y' ? 'ACTIVE' : 'STOP'
                }));
                initGrid(gridData);
            });
    };

    function initGrid(data) {
        const container = document.getElementById('dg-container');
        if (container) container.innerHTML = '';

        myGrid = new DataGrid({
            containerId: 'dg-container',
            searchId: 'dg-search-input',
            btnSearchId: 'dg-btn-search',
            paginationId: 'dg-pagination',
            perPageId: 'dg-per-page',
            showCheckbox: true, 
            bodyHeight: 'auto',
            scrollY: false,
            scrollX: true,
            data: data,
            perPage: parseInt(document.getElementById('dg-per-page')?.value || 10),
            columnOptions: { frozenCount: 1, resizable: true, minWidth: 150 },
            columns: [
                { header: '유류코드', name: 'fuelCd', width: 140, align: 'center' },
                { 
                    header: '유류명칭', name: 'fuelNm', width: 250, align: 'left',
                    renderer: {
                        type: class {
                            constructor(props) {
                                const el = document.createElement('a');
                                el.className = 'fuel-link';
                                el.innerText = props.value;
                                el.onclick = () => openEditModal(props.rowKey);
                                this.el = el;
                            }
                            getElement() { return this.el; }
                        }
                    }
                },
                { header: '유류종류', name: 'fuelCatNm', width: 150, align: 'center' },
                { header: '원산지', name: 'originCntryNm', width: 150, align: 'center' },
                { header: '단가', name: 'baseUnitPrc', width: 140, align: 'right', formatter: (v) => v.value ? '₩' + Number(v.value).toLocaleString() : '₩0' },
                { header: '현재고', name: 'currStockVol', width: 140, align: 'right', formatter: (v) => (v.value || 0).toLocaleString() + ' ' + (v.row.volUnitNm || '') },
                { header: '재고상태', name: 'itemSttsNm', width: 120, align: 'center' },
                { header: '등록일', name: 'regDtime', width: 170, align: 'center' },
                { header: '상태', name: 'useYn', width: 100, renderer: { type: CustomStatusRenderer, options: { theme: 'accStatus' } } }
            ]
        });

        if (myGrid.initFilters) {
            myGrid.initFilters([
                { field: 'fuelCatNm', title: '유류종류' },
                { field: 'originCntryNm', title: '원산지' },
                { field: 'itemSttsNm', title: '재고상태' }
            ]);
        }
        setTimeout(() => { if (myGrid && myGrid.grid) myGrid.grid.refreshLayout(); }, 200);
    }

    window.handleBatchDelete = function() {
        if (!myGrid || !myGrid.grid) return;
        const checkedRows = myGrid.grid.getCheckedRows();
        if (checkedRows.length === 0) {
            alert('미사용 처리할 상품을 선택해주세요.');
            return;
        }
        const targetIds = checkedRows.map(row => row.fuelId);
        if (confirm(`선택한 \${checkedRows.length}건의 상품을 미사용 처리하시겠습니까?`)) {
            alert('처리되었습니다.');
            myGrid.grid.uncheckAll();
            window.fetchData();
        }
    };

    function openEditModal(rowKey) {
        const rowData = myGrid.grid.getRow(rowKey);
        const fuelId = rowData.fuelId;
        fetch(cp + '/admin/products/api/' + fuelId)
            .then(res => res.json())
            .then(data => {
                const b = data.productBase;
                document.getElementById('fuelId').value = b.fuelId;
                document.getElementById('fuelCd').value = b.fuelCd;
                document.getElementById('fuelNm').value = b.fuelNm;
                document.getElementById('fuelCatNm').value = b.fuelCatNm;
                document.getElementById('baseUnitPrc').value = b.baseUnitPrc;
                document.getElementById('safeStockVol').value = b.safeStockVol;
                document.getElementById('modalTitle').innerText = '상품 정보 상세 수정';
                document.getElementById('btnDeleteProduct').style.display = 'inline-block';
                if(productModal) productModal.show();
            });
    }

    window.handleAddAction = function() {
        document.getElementById('productForm').reset();
        document.getElementById('fuelId').value = '';
        document.getElementById('modalTitle').innerText = '신규 상품 등록';
        document.getElementById('btnDeleteProduct').style.display = 'none';
        if(productModal) productModal.show();
    };

    function deleteProduct() {
        if (confirm('해당 상품을 미사용 처리하시겠습니까?')) {
            alert('미사용 처리되었습니다.');
            closeModal();
            window.fetchData();
        }
    }
    function closeModal() { if(productModal) productModal.hide(); }
    function saveProduct() { alert('저장되었습니다.'); closeModal(); window.fetchData(); }
</script>