<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cp" value="${pageContext.request.contextPath}" />

<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>

<style>
    .fuel-link { color: #2563eb !important; text-decoration: underline !important; cursor: pointer; font-weight: 600; }
    .input-edit { background-color: #ffffff !important; color: #111827 !important; cursor: text !important; }
    #dg-container { width: 100%; margin-top: 1rem; }
    .grid-relative-wrapper { position: relative; width: 100%; }
</style>

<div class="max-w-screen-2xl mx-auto">
    <div class="bg-white p-8 rounded-xl shadow-lg border border-gray-100 dark:bg-gray-800 dark:border-gray-700">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
            <div>
                <h2 class="text-2xl font-bold text-gray-900 dark:text-white">상품 관리</h2>
                <p class="text-sm text-gray-500 mt-1">등록된 유류 상품의 상세 정보를 조회하고 관리할 수 있습니다.</p>
            </div>
            <div class="flex flex-wrap items-center gap-2">
                <button type="button" class="px-3 py-1.5 text-sm font-medium text-gray-700 bg-white border border-gray-200 rounded-lg hover:bg-gray-50 transition">일괄양식 다운로드</button>
                <button type="button" class="px-3 py-1.5 text-sm font-medium text-gray-700 bg-white border border-gray-200 rounded-lg hover:bg-gray-50 transition">일괄 업로드</button>
                <button type="button" id="dg-btn-download-custom" class="px-3 py-1.5 text-sm font-medium text-gray-700 bg-white border border-gray-200 rounded-lg hover:bg-gray-50 transition">엑셀 다운로드</button>
                <button type="button" onclick="handleAddAction()" class="px-3 py-1.5 text-sm font-semibold text-white bg-blue-600 rounded-lg hover:bg-blue-700 transition active:scale-95">+ 신규 등록</button>
            </div>
        </div>

        <div class="grid-relative-wrapper">
            <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp">
                <jsp:param name="showSearchArea" value="true" />
                <jsp:param name="showPerPage" value="true" />
            </jsp:include>
        </div>
    </div>
</div>

<jsp:include page="productMgmtInsertAdm.jsp" />

<script>
    const cp = '${cp}';
    let myGrid, productModal, quill;

    // 이미지 임시 파일명을 보관할 변수 (등록 시 사용)
    let mainTempName = null;
    let subTempName = null;

    document.addEventListener('DOMContentLoaded', function() {
        if (typeof Modal !== 'undefined') {
            productModal = new Modal(document.getElementById('productModal'));
        }

        quill = new Quill('#editor-container', {
            theme: 'snow',
            placeholder: '상품의 상세 설명 및 주의사항을 입력하세요...',
            modules: { 
                toolbar: [
                    ['bold', 'italic', 'underline'], 
                    [{ 'list': 'ordered'}, { 'list': 'bullet' }], 
                    ['image', 'clean'] 
                ] 
            }
        });

        const toolbar = quill.getModule('toolbar');
        toolbar.addHandler('image', () => {
            const input = document.createElement('input');
            input.setAttribute('type', 'file');
            input.setAttribute('accept', 'image/*');
            input.click();

            input.onchange = function() {
                const file = input.files[0];
                if (!file) return;

                const formData = new FormData();
                formData.append('file', file);

                fetch(cp + '/api/file/temp-img-upload', {
                    method: 'POST',
                    body: formData
                })
                .then(res => res.json())
                .then(data => {
                    const range = quill.getSelection();
                    quill.insertEmbed(range ? range.index : 0, 'image', data.url);
                    quill.setSelection((range ? range.index : 0) + 1);
                })
                .catch(e => console.error("에디터 업로드 실패:", e));
            };
        });

        window.fetchData(); 
    });

    // --- 미리보기 함수 (비동기 처리 최적화 및 문구 제거) ---
    function previewImage(input, containerId) {
        var container = document.getElementById(containerId);
        
        if (input.files && input.files[0]) {
            var file = input.files[0];
            var formData = new FormData();
            formData.append("file", file);

            fetch(cp + '/api/file/temp-img-upload', {
                method: 'POST',
                body: formData
            })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.url) {
                    // 서버에서 생성된 실제 임시 파일명 저장 (UUID.확장자 형태라고 가정)
                    // URL에서 파일명만 추출하거나 서버 응답에 fileName 필드가 있다면 그것을 사용
                    const tempFileName = data.url.substring(data.url.lastIndexOf('/') + 1);
                    
                    if (containerId === 'mainPreview') mainTempName = tempFileName;
                    if (containerId === 'subPreview') subTempName = tempFileName;

                    var imgHtml = 
                        '<div class="preview-item">' +
                            '<img src="' + data.url + '" onclick="insertImageToEditor(\'' + data.url + '\')">' +
                            '<div class="preview-remove" onclick="removeSingleFile(\'' + input.id + '\', \'' + containerId + '\')">×</div>' +
                        '</div>';
                    
                    container.innerHTML = imgHtml;
                }
            })
            .catch(function(error) {
                console.error("미리보기 업로드 에러:", error);
            });
        } else {
            container.innerHTML = '';
        }
    }

    function insertImageToEditor(url) {
        const range = quill.getSelection();
        quill.insertEmbed(range ? range.index : 0, 'image', url);
    }

    function removeSingleFile(inputId, containerId) {
        document.getElementById(inputId).value = '';
        document.getElementById(containerId).innerHTML = '';
        if (containerId === 'mainPreview') mainTempName = null;
        if (containerId === 'subPreview') subTempName = null;
    }

    // --- 데이터 그리드 및 조회 기능 ---
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
        if (!container) return;
        if (myGrid && myGrid.grid) {
            myGrid.grid.resetData(data);
            return;
        }
        container.innerHTML = '';
        myGrid = new DataGrid({
            containerId: 'dg-container',
            searchId: 'dg-search-input',
            btnSearchId: 'dg-btn-search',
            paginationId: 'dg-pagination',
            perPageId: 'dg-per-page',
            showCheckbox: false, 
            bodyHeight: 'auto',
            data: data,
            perPage: parseInt(document.getElementById('dg-per-page')?.value || 10),
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
                            render(props) { this.el.innerText = props.value; }
                        }
                    }
                },
                { header: '유류종류', name: 'fuelCatNm', width: 150, align: 'center' },
                { header: '원산지', name: 'originCntryNm', width: 150, align: 'center' },
                { header: '단가', name: 'baseUnitPrc', width: 140, align: 'right', formatter: (v) => v.value ? '₩' + Number(v.value).toLocaleString() : '₩0' },
                { header: '현재고', name: 'currStockVol', width: 140, align: 'right', formatter: (v) => (v.value || 0).toLocaleString() + ' ' + (v.row.volUnitNm || '') },
                { header: '재고상태', name: 'itemSttsNm', width: 120, align: 'center' },
                { header: '등록일', name: 'regDtime', width: 170, align: 'center' },
                { header: '상태', name: 'useYn', width: 100, align: 'center', renderer: { type: CustomStatusRenderer, options: { theme: 'accStatus' } } }
            ]
        });
    }

    window.handleAddAction = function() {
        document.getElementById('productForm').reset();
        document.getElementById('fuelId').value = '';
        document.getElementById('fuelCd').value = '';
        quill.setContents([]);
        document.getElementById('mainPreview').innerHTML = '';
        document.getElementById('subPreview').innerHTML = '';
        mainTempName = null;
        subTempName = null;
        document.getElementById('modalTitle').innerText = '신규 상품 등록';
        document.getElementById('btnDeleteProduct').style.display = 'none';
        if(productModal) productModal.show();
    };

    function openEditModal(rowKey) {
        const rowData = myGrid.grid.getRow(rowKey);
        fetch(cp + '/admin/products/api/' + rowData.fuelId)
            .then(res => res.json())
            .then(data => {
                const b = data.productBase;
                const d = data.productDetail || {};
                const files = data.fileList || []; 
                
                document.getElementById('fuelId').value = b.fuelId;
                document.getElementById('fuelCd').value = b.fuelCd;
                document.getElementById('fuelNm').value = b.fuelNm;
                document.getElementById('fuelCatCd').value = b.fuelCatCd;
                document.getElementById('originCntryCd').value = b.originCntryCd;
                document.getElementById('baseUnitPrc').value = b.baseUnitPrc;
                document.getElementById('currStockVol').value = b.currStockVol;
                document.getElementById('safeStockVol').value = b.safeStockVol;
                document.getElementById('volUnitCd').value = b.volUnitCd;
                document.getElementById('itemSttsCd').value = b.itemSttsCd;
                
                document.getElementById('apiGrv').value = d.apiGrv || '';
                document.getElementById('sulfurPCnt').value = d.sulfurPCnt || '';
                document.getElementById('flashPnt').value = d.flashPnt || '';
                document.getElementById('viscosity').value = d.viscosity || '';
                document.getElementById('density15c').value = d.density15c || '';
                quill.root.innerHTML = d.fuelMemo || '';
                
                document.getElementById('mainPreview').innerHTML = '';
                document.getElementById('subPreview').innerHTML = '';
                
                files.forEach(file => {
                    const imgUrl = cp + '/api/file/display/' + file.systemId + '?fileName=' + file.strFileNm;
                    const imgHtml = `
                        <div class="preview-item">
                            <img src="${imgUrl}" onclick="insertImageToEditor('${imgUrl}')">
                            <div class="preview-remove" onclick="this.parentElement.remove()">×</div>
                            <input type="hidden" name="${file.systemId}_remain" value="${file.strFileNm}">
                        </div>`;

                    if (file.systemId === 'PRODUCT_M') {
                        document.getElementById('mainPreview').innerHTML = imgHtml;
                    } else if (file.systemId === 'PRODUCT_S') {
                        document.getElementById('subPreview').innerHTML = imgHtml;
                    }
                });
                
                document.getElementById('modalTitle').innerText = '상품 정보 상세 수정';
                document.getElementById('btnDeleteProduct').style.display = (b.useYn === 'Y') ? 'inline-block' : 'none';
                if(productModal) productModal.show();
            });
    }

    // --- 상품 저장 (JSON 기반 임시 파일명 전송 방식) ---
    async function saveProduct() {
        const fuelId = document.getElementById('fuelId').value;
        const isEdit = fuelId !== '';
        
        const productData = {
            productBase: {
                fuelId: fuelId || null,
                fuelCd: document.getElementById('fuelCd').value,
                fuelNm: document.getElementById('fuelNm').value,
                fuelCatCd: document.getElementById('fuelCatCd').value,
                originCntryCd: document.getElementById('originCntryCd').value,
                baseUnitPrc: document.getElementById('baseUnitPrc').value,
                currStockVol: document.getElementById('currStockVol').value,
                safeStockVol: document.getElementById('safeStockVol').value,
                volUnitCd: document.getElementById('volUnitCd').value,
                itemSttsCd: document.getElementById('itemSttsCd').value,
                useYn: 'Y'
            },
            productDetail: {
                apiGrv: document.getElementById('apiGrv').value,
                sulfurPCnt: document.getElementById('sulfurPCnt').value,
                flashPnt: document.getElementById('flashPnt').value,
                viscosity: document.getElementById('viscosity').value,
                density15c: document.getElementById('density15c').value,
                fuelMemo: quill.root.innerHTML,
                useYn: 'Y'
            },
            // [중요] 임시 폴더에 저장된 파일명을 DTO 필드에 맞춰 전달
            mainTempNames: mainTempName ? [mainTempName] : [],
            subTempNames: subTempName ? [subTempName] : []
        };

        const url = isEdit ? cp + '/admin/products/api/modify/' + fuelId : cp + '/admin/products/api/register';

        try {
            // [변경] FormData가 아닌 JSON 전송 방식으로 변경
            const response = await fetch(url, { 
                method: 'POST', 
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(productData) 
            });

            if (response.ok) {
                alert(isEdit ? "수정되었습니다." : "등록되었습니다.");
                closeModal();
                window.fetchData();
            } else { 
                alert("저장 실패"); 
            }
        } catch (error) { 
            console.error("저장 오류:", error);
            alert("오류 발생"); 
        }
    }

    function deleteProduct() {
        const fuelId = document.getElementById('fuelId').value;
        if (!fuelId || !confirm('해당 상품을 미사용 처리하시겠습니까?')) return;
        fetch(cp + '/admin/products/api/unuse', {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ fuelId: fuelId, useYn: 'N', userNo: 1 })
        }).then(res => {
            if(res.ok) { alert('미사용 처리되었습니다.'); closeModal(); window.fetchData(); }
        });
    }

    function closeModal() { if(productModal) productModal.hide(); }
</script>