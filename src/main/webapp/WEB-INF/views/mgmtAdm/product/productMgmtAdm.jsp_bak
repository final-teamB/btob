<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cp" value="${pageContext.request.contextPath}" />

<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>

<style>
    /* 유류명칭 링크 스타일 고도화 */
	.fuel-link { 
	    color: #1e293b; /* 깊은 네이비 색상 */
	    font-weight: 600; 
	    cursor: pointer; 
	    transition: all 0.2s ease; /* 부드러운 전환 효과 */
	    padding: 4px 8px;
	    border-radius: 4px;
	    display: inline-block;
	}
	
	.fuel-link:hover { 
	    color: #2563eb; /* 호버 시 밝은 블루 */
	    background-color: #eff6ff; /* 호버 시 아주 연한 배경색 */
	    text-decoration: none !important; /* 밑줄 대신 배경색으로 강조 */
	}
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
<jsp:include page="productMgmtDetailInfo.jsp" />
<jsp:include page="productMgmtEditInfo.jsp" />

<script>
    //const cp = '${cp}';
    const cp = window.location.origin + ( '${pageContext.request.contextPath}' === '/' ? '' : '${pageContext.request.contextPath}' );
    let myGrid, productModal, quill;

    // 이미지 임시 파일명을 보관할 변수
    let mainTempName = null;
    let subTempName = null;

    document.addEventListener('DOMContentLoaded', function() {
        if (typeof Modal !== 'undefined') {
        	
        	// [수정 포인트] 옵션 객체를 추가하여 바깥 클릭 및 ESC 키로 닫히는 것을 방지합니다.
            const modalOptions = {
                backdrop: 'static',   // 바깥 배경 클릭 시 닫히지 않음
                closable: false,      // ESC 키 등으로 닫히는 것 방지 (라이브러리에 따라 다를 수 있음)
                onHide: () => {
                    console.log('modal is hidden');
                },
                onShow: () => {
                    console.log('modal is shown');
                },
                onToggle: () => {
                    console.log('modal has been toggled');
                },
            };
        	
         	// 인스턴스 생성 시 옵션 전달
            productModal = new Modal(document.getElementById('productModal'), modalOptions);
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

    // --- 미리보기 함수 (유지) ---
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
            .then(function(response) { return response.json(); })
            .then(function(data) {
            	if (data.url) {
                    // [수정 핵심] URL에서 파라미터(fileName=) 뒤의 순수 파일명만 추출
                    let tempFileName = "";
                    if (data.url.indexOf('fileName=') > -1) {
                        tempFileName = data.url.split('fileName=')[1];
                    } else {
                        tempFileName = data.url.substring(data.url.lastIndexOf('/') + 1);
                    }

                    if (containerId === 'mainPreview') mainTempName = tempFileName;
                    if (containerId === 'subPreview') subTempName = tempFileName;

                    var imgHtml =
                        '<div class="preview-item">' +
                            '<img src="' + data.url + '" onclick="insertImageToEditor(\'' + data.url + '\')">' +
                            '<div class="preview-remove" onclick="removeSingleFile(\'' + input.id + '\', \'' + containerId + '\')">×</div>' +
                        '</div>';
                    container.innerHTML = imgHtml;
                }
            });
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

    // --- 데이터 그리드 조회 ---
    window.fetchData = function() {
        const searchInput = document.getElementById('dg-search-input');
        const searchCondition = searchInput && searchInput.value ? encodeURIComponent(searchInput.value) : '';

        // [수정] 현재 사용자가 선택한 페이지당 건수를 미리 확보
        const perPageEl = document.getElementById('dg-per-page');
        const currentPerPage = perPageEl ? parseInt(perPageEl.value) : 10;

        fetch(cp + '/admin/products/api/list?limit=5000&searchCondition=' + searchCondition)
            .then(res => res.json())
            .then(data => {
                const gridData = (data.list || []).map(item => ({
                    ...item,
                    useYn: item.useYn === 'Y' ? 'ACTIVE' : 'STOP'
                }));
                initGrid(gridData, currentPerPage);
            });
    };

    function initGrid(data, perPage) {
        const container = document.getElementById('dg-container');
        if (!container) return;

        // [수정 포인트] 기존 그리드가 있을 때: 필터 카테고리는 건드리지 않고 데이터와 페이징만 동기화
        if (myGrid && myGrid.grid) {
            // 1. datagrid.js 내부의 데이터 저장소(allData) 업데이트 (기존 방식 유지)
            myGrid.allData = data.map(item => {
                const newItem = { ...item };
                if (newItem.regDtime && typeof newItem.regDtime === 'string') {
                    newItem.regDtime = newItem.regDtime.replace('T', ' ').split('.')[0];
                }
                return newItem;
            });

            // 2. 현재 설정값 동기화
            myGrid.perPage = perPage;
            myGrid.currentPage = 1;

            // 3. 필터 카테고리를 '새로 생성'하지 않고, 현재 데이터 기준으로 필터링만 실행
            // initFilters를 다시 호출하면 셀렉트 박스가 중복 생성될 수 있으므로 executeFiltering만 실행합니다.
            myGrid.executeFiltering(true);

            // 4. 레이아웃 리프레시
            setTimeout(() => myGrid.grid.refreshLayout(), 50);
            return;
        }

        // --- 최초 생성 시 (여기서 정의한 필터 카테고리가 유지됩니다) ---
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
            perPage: perPage || 10,
            columns: [
                { header: '유류코드', name: 'fuelCd', width: 140, align: 'center' },
                {
                    header: '유류명칭', name: 'fuelNm', width: 250, align: 'center',
                    renderer: {
                        type: class {
                            constructor(props) {
                                const el = document.createElement('a');
                                el.className = 'fuel-link';
                                el.innerText = props.value;
                             	// 수정 후 (상세조회 모달부터 띄우기)
                                // [수정 핵심] props.rowData 대신 아래 방식으로 데이터를 가져옵니다.
				                el.onclick = () => {
				                    const rowData = props.grid.getRow(props.rowKey);
				                    if (rowData && rowData.fuelId) {
				                        openDetailView(rowData.fuelId);
				                    }
				                };
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

        // 최초 생성 시에만 필터 카테고리를 설정합니다.
        if (myGrid.initFilters) {
            myGrid.initFilters([
                { field: 'fuelCatNm', title: '유류종류' },
                { field: 'originCntryNm', title: '원산지' },
                { field: 'itemSttsNm', title: '재고상태' }
            ]);
        }
    }

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
            mainTempNames: mainTempName ? [mainTempName] : [],
            subTempNames: subTempName ? [subTempName] : []
        };

        const url = isEdit ? cp + '/admin/products/api/modify/' + fuelId : cp + '/admin/products/api/register';

        try {
            const response = await fetch(url, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(productData)
            });
            if (response.ok) {
                alert(isEdit ? "수정되었습니다." : "등록되었습니다.");
                closeModal();
                window.fetchData();
            } else { alert("저장 실패"); }
        } catch (error) { alert("오류 발생"); }
    }

    function openEditModal(keyOrId) {
    	let fuelId;

        // 2. 전달받은 값이 숫자인지, 그리드의 rowKey(문자열 혹은 객체)인지 판별
        if (typeof keyOrId === 'number' || !isNaN(keyOrId)) {
            // ID가 직접 들어온 경우 (예: 상세조회 모달에서 호출)
            fuelId = keyOrId;
        } else {
            // rowKey가 들어온 경우 (예: 그리드에서 직접 호출)
            const rowData = myGrid.grid.getRow(keyOrId);
            if (rowData) {
                fuelId = rowData.fuelId;
            }
        }

        if (!fuelId) {
            console.error("상품 ID를 찾을 수 없습니다.");
            return;
        }
        
        fetch(cp + '/admin/products/api/' + fuelId)
            .then(res => res.json())
            .then(data => {
            	// [주의] 백엔드에서 넘겨주는 데이터 구조에 맞춰 바인딩
                // 서비스 코드상 SearchDetailInfoProductDTO는 productBase 필드가 따로 없을 수 있습니다.
                // 만약 data.productBase가 undefined라면 data.fuelId 식으로 바로 접근하세요.
                const b = data.productBase || data; 
                const d = data.productDetail || data;
                const files = data.fileList || [];

                // 데이터 바인딩
                document.getElementById('fuelId').value = b.fuelId;
                
                // [수정] 유류코드는 수정 모드에서도 읽기 전용으로 유지
                const fuelCdInput = document.getElementById('fuelCd');
                fuelCdInput.value = b.fuelCd;
                fuelCdInput.readOnly = true;
                fuelCdInput.placeholder = "";

                document.getElementById('fuelNm').value = b.fuelNm;
                document.getElementById('fuelCatCd').value = b.fuelCatCd;
                document.getElementById('originCntryCd').value = b.originCntryCd;
                document.getElementById('baseUnitPrc').value = b.baseUnitPrc;
                document.getElementById('currStockVol').value = b.currStockVol;
                document.getElementById('safeStockVol').value = b.safeStockVol;
                document.getElementById('volUnitCd').value = b.volUnitCd;
                document.getElementById('itemSttsCd').value = b.itemSttsCd;

                // 상세 및 이미지 로직 (기존 유지)
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
                    if (file.systemId === 'PRODUCT_M') document.getElementById('mainPreview').innerHTML = imgHtml;
                    else if (file.systemId === 'PRODUCT_S') document.getElementById('subPreview').innerHTML = imgHtml;
                });

                document.getElementById('modalTitle').innerText = '상품 정보 상세 수정';
                document.getElementById('btnDeleteProduct').style.display = (b.useYn === 'Y') ? 'inline-block' : 'none';
                if(productModal) productModal.show();
            });
    }

    window.handleAddAction = function() {
        document.getElementById('productForm').reset();
        document.getElementById('fuelId').value = '';
        
        // 1. 유류코드 자동 생성을 위한 UI 처리
        const fuelCdInput = document.getElementById('fuelCd');
        if (fuelCdInput) {
            fuelCdInput.value = '';
            fuelCdInput.placeholder = "등록 시 자동 생성됩니다.";
            fuelCdInput.readOnly = true;
            fuelCdInput.style.backgroundColor = "#f9fafb"; // 연한 회색 배경
            fuelCdInput.style.cursor = "not-allowed";
        }

        quill.setContents([]);
        document.getElementById('mainPreview').innerHTML = '';
        document.getElementById('subPreview').innerHTML = '';
        mainTempName = null;
        subTempName = null;
        document.getElementById('modalTitle').innerText = '신규 상품 등록';
        document.getElementById('btnDeleteProduct').style.display = 'none';
        if(productModal) productModal.show();
    };

    // 2. [추가 권장] type="number"에서 소수점 입력을 더 부드럽게 지원하기 위한 스크립트
    document.addEventListener('DOMContentLoaded', function() {
        const numericIds = [
            'currStockVol', 'safeStockVol', 'apiGrv', 
            'sulfurPCnt', 'flashPnt', 'viscosity', 'density15c', 'baseUnitPrc'
        ];

        numericIds.forEach(id => {
            const el = document.getElementById(id);
            if (el) {
                // 소수점 입력을 허용하기 위해 step 속성을 "any"로 설정 (스크립트에서 제어)
                el.setAttribute('step', 'any');
                
                // 'e', 'E', '+', '-' 입력을 방지하고 싶다면 아래 주석 해제
                el.addEventListener('keydown', function(e) {
                    if (['e', 'E', '+', '-'].includes(e.key)) {
                        e.preventDefault();
                    }
                });
            }
        });
    });

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