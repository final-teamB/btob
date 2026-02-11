/**
 * datagrid.js
 * 클래스 기반 데이터그리드 (Toast UI Grid 기반)
 */

// [1] 배지 테마 설정
/**
 * datagrid.js
 */

const GRID_STATUS_THEMES = {
    'deliveryStatus' : { bgColor: 'bg-indigo-100', textColor: 'text-indigo-700', label: '-'},
	
	'orderStatusNm': {
	    '1차결제완료': { bgColor: 'bg-blue-200', textColor: 'text-blue-800', label: '1차 결제완료' },
		'2차결제요청': { bgColor: 'bg-yellow-200', textColor: 'text-yellow-900', label: '2차 결제요청' },
	    '2차결제완료': { bgColor: 'bg-green-200', textColor: 'text-green-800', label: '2차 결제완료'}
	},
	
	'docType': {
	        'ESTIMATE': { bgColor: 'bg-blue-200', textColor: 'text-blue-700', label: '견적서' },
	        'PURCHASE ORDER': { bgColor: 'bg-emerald-200', textColor: 'text-emerald-700', label: '발주서' }
    },
	
    'accStatus': {
        'ACTIVE': { bgColor: 'bg-green-200', textColor: 'text-green-900', label: 'Active' },
        'STOP': { bgColor: 'bg-red-200', textColor: 'text-red-900', label: 'Stop' },
        'SLEEP': { bgColor: 'bg-yellow-200', textColor: 'text-yellow-900', label: 'Sleep' }
    },
	'appStatus': {
	        'APPROVED': { bgColor: 'bg-green-200', textColor: 'text-green-900', label: 'APPROVED' },
	        'REJECTED': { bgColor: 'bg-red-200', textColor: 'text-red-900', label: 'REJECTED' },
	        'PENDING': { bgColor: 'bg-yellow-200', textColor: 'text-yellow-900', label: 'PENDING' }
	    }
};

// [1] 상태값 렌더러 - render 메서드를 추가하여 데이터 변경 시 강제 갱신
class CustomStatusRenderer {
    constructor(props) {
        this.el = document.createElement('div');
        this.el.className = 'flex justify-center items-center h-full w-full';
        this.render(props); // 초기 생성 시 렌더링
    }

    getElement() {
        return this.el;
    }

    // [핵심] 데이터가 바뀌면 Grid가 이 render 메서드를 호출합니다.
    render(props) {
        const realValue = props.value;
        const options = props.columnInfo.renderer.options || {};
        const theme = GRID_STATUS_THEMES[options.theme] || {};
        const statusKey = realValue ? String(realValue).trim().toUpperCase() : '';
        const config = theme[statusKey] || { 
            bgColor: 'bg-gray-200', textColor: 'text-gray-900', label: realValue 
        };

        this.el.innerHTML = `
            <span class="relative inline-block px-3 py-1 font-bold leading-tight ${config.textColor} text-xs">
                <span class="absolute inset-0 ${config.bgColor} rounded-full opacity-50"></span>
                <span class="relative">${config.label || realValue}</span>
            </span>
        `;
    }
}

// [2] 액션 버튼 렌더러
class CustomActionRenderer {
	
	
    constructor(props) {
        this.el = document.createElement('div');
        this.el.className = 'flex justify-center gap-3'; // 버튼 사이 간격(gap) 추가
        this.render(props);
    }
    getElement() { return this.el; }
    
    render(props) {
        const { grid, rowKey, columnInfo } = props;
		const rowData = grid.getRow(rowKey);
        this.el.innerHTML = ''; // 기존 버튼 초기화

        const options = columnInfo.renderer.options || {};
        
        // [수정 핵심] 버튼 설정이 배열로 들어오면 루프를 돌고, 아니면 기본 버튼 생성
        const buttonConfigs = options.buttons || [{ text: options.btnText || '수정', action: 'edit' }];

        buttonConfigs.forEach(btnCfg => {
			if (btnCfg.visibleIf) {
			            const { field, value } = btnCfg.visibleIf;
			            // 해당 필드의 값이 설정한 값과 다르면 버튼을 생성하지 않음
			            if (rowData[field] !== value) {
			                return; 
			            }
			        }
			
        const btn = document.createElement('button');
		btn.type = 'button';
         const textColor = btnCfg.color || 'text-gray-600 hover:text-gray-900';
                     
            btn.className = `text-sm font-bold underline underline-offset-4 transition ${textColor}`;
            btn.innerText = btnCfg.text;
            
            btn.onclick = (e) => {
				e.preventDefault();
                e.stopPropagation(); // 행 선택 이벤트 전파 방지
                const actualData = grid.getRow(rowKey);
                if (typeof window.handleGridAction === 'function') {
                    // 클릭한 버튼의 action 값을 두 번째 인자로 전달
                    window.handleGridAction(actualData, btnCfg.action);
                }
            };
            this.el.appendChild(btn);
        });
    }
}

// [3] 메인 클래스
class DataGrid {
    constructor(config) {
        this.grid = null;
        this.config = config;
        this.perPage = config.perPage || 10;
        this.currentPage = 1;
        
        // 원본 데이터 복사 및 날짜 처리
        this.allData = (config.data || []).map(item => {
            const newItem = { ...item };
            if (newItem.regDtime && typeof newItem.regDtime === 'string') {
                newItem.regDtime = newItem.regDtime.replace('T', ' ').split('.')[0];
            }
            return newItem;
        });
        
        this.filteredData = [];
        this.init();
    }
	
    init() {
        // 초기 필터링 적용
        this.executeFiltering(false);

		this.grid = new tui.Grid({
		    el: document.getElementById(this.config.containerId || 'dg-container'),
		    data: this.filteredData.slice(0, this.perPage),
		    columns: this.config.columns.map(col => ({
                ...col,
                align: col.align || 'center',
                sortable: col.sortable !== undefined ? col.sortable : true,
                ellipsis: true
            })),
		    showDummyRows: false,
			
			/*20260205 가로 횡스크롤때문에 추가*/
			/*scrollX: false,
			scrollY: false,*/
			scrollX: this.config.scrollX !== undefined ? this.config.scrollX : true,
			scrollY: this.config.scrollY !== undefined ? this.config.scrollY : true,
		    rowHeight: 55,
			width: 'auto',
			/*20260205 가로 횡스크롤때문에 추가*/
		    bodyHeight: 'auto',
			//bodyHeight: this.config.bodyHeight || 500, // auto가 아닌 고정 높이가 있어야 스크롤이 명확해짐
		    rowHeaders: this.config.showCheckbox ? ['rowNum', 'checkbox'] : ['rowNum'],
			selectionUnit: 'cell',
		    usageStatistics: false,
			/*20260205 가로 횡스크롤때문에 추가*/
			/*columnOptions: { minWidth: 150 }*/
			columnOptions: { 
			            minWidth: 150,           // 최소 너비 유지
			            resizable: true          // 리사이징 허용
			        }
		});
            
        this.bindEvents();
        this.renderPagination();
        setTimeout(() => this.grid.refreshLayout(), 50);
    }

    executeFiltering(shouldUpdate = true) {
        const searchInput = document.getElementById(this.config.searchId);
        const keyword = searchInput ? searchInput.value.toLowerCase() : '';
        const activeFilters = {};
        
        document.querySelectorAll('.dg-filter').forEach(select => {
            if (select.value) {
                const fieldName = select.id.replace('filter-', '');
                activeFilters[fieldName] = select.value;
            }
        });

        this.filteredData = this.allData.filter(row => {
            const matchesSearch = Object.values(row).some(v => v && v.toString().toLowerCase().includes(keyword));
            const matchesFilters = Object.entries(activeFilters).every(([f, v]) => String(row[f] || '') === String(v));
            return matchesSearch && matchesFilters;
        });

        if (shouldUpdate) {
            this.currentPage = 1;
            this.updateGrid();
        }
    }
	initFilters(filterConfigs) {
	    const wrapper = document.getElementById('dg-common-filter-wrapper');
	    const container = wrapper?.querySelector('.flex');
	    if (!wrapper || !container) return;

	    filterConfigs.forEach((config, index) => {
	        let select;
	        if (index === 0) {
	            select = document.getElementById('dg-common-filter');
	        } else {
	            select = document.createElement('select');
	            container.appendChild(select);
	        }

	        select.id = `filter-${config.field}`;
	        select.className = 'dg-filter rounded-lg border border-gray-300 bg-white py-2 px-4 text-sm outline-none min-w-[120px]';
	        select.innerHTML = `<option value="">${config.title} 전체</option>`;

	        // [수정 포인트] config에 options가 정의되어 있다면 해당 매핑 정보를 사용
	        if (config.options && config.options.length > 0) {
	            config.options.forEach(opt => {
	                select.add(new Option(opt.text, opt.value));
	            });
	        } else {
	            // 기존 방식: 데이터에서 유니크한 값을 뽑아서 생성
	            const options = [...new Set(this.allData.map(i => i[config.field]))]
	                .filter(Boolean)
	                .sort();
	            options.forEach(opt => select.add(new Option(opt, opt)));
	        }

	        select.addEventListener('change', () => {
	            this.executeFiltering(true);
	        });
	    });

	    wrapper.classList.remove('hidden');
	    wrapper.classList.add('flex');
	}
   
   bindEvents() {
       const c = this.config;
       const searchInput = document.getElementById(c.searchId);
       const perPageSelect = document.getElementById(c.perPageId);
       const btnSearch = document.getElementById(c.btnSearchId);

	    // [핵심 수정] 모든 필터(.dg-filter)를 찾아서 이벤트를 연결합니다.
	    const allFilters = document.querySelectorAll('.dg-filter');

	    // 실시간 필터링 함수 (이미 작성하신 executeFiltering을 호출)
	    const runLocalFilter = () => {
	        this.executeFiltering(true);
	    };

	    // 1. 검색창 이벤트
	    if (searchInput) {
	        searchInput.addEventListener('input', runLocalFilter);
	        searchInput.addEventListener('keyup', (e) => {
	            if (e.key === 'Enter') {
	                if (typeof window.fetchData === 'function') window.fetchData();
	                else runLocalFilter();
	            }
	        });
	    }

	    // 2. 모든 필터 셀렉트박스에 이벤트 연결 (필터가 2개든 10개든 작동)
	    allFilters.forEach(filter => {
	        filter.addEventListener('change', runLocalFilter);
	    });

	    // 3. 페이지당 개수 변경
	    if (perPageSelect) {
	        perPageSelect.addEventListener('change', (e) => {
	            this.perPage = parseInt(e.target.value);
	            this.currentPage = 1;
	            this.updateGrid();
	        });
	    }

	    // 4. 조회 버튼 (서버 조회 우선)
	    if (btnSearch) {
	        btnSearch.addEventListener('click', () => {
	            if (typeof window.fetchData === 'function') window.fetchData();
	            else runLocalFilter();
	        });
	    }
	}
	
    updateGrid() {
        const start = (this.currentPage - 1) * this.perPage;
        // [중요] resetData는 행을 아예 새로 만들기 때문에 렌더링 섞임 방지에 최적입니다.
        this.grid.resetData(this.filteredData.slice(start, start + this.perPage));
        this.renderPagination();
    }
	
    // --- 요청하신 기존 페이징 로직 그대로 유지 ---
	renderPagination() {
	    const paginationId = this.config.paginationId || 'dg-pagination';
	    const pagination = document.getElementById(paginationId);
	    if (!pagination) return;
	    pagination.innerHTML = '';
		
		const totalPages = Math.ceil(this.filteredData.length / this.perPage) || 0;

		    // [핵심 추가] 데이터가 아예 없거나, 1페이지뿐이라면 페이징을 그리지 않고 종료
		    if (totalPages <= 1) {
		        return; 
		    }
	    const pageGroup = Math.ceil(this.currentPage / 10);
	    const lastPageOfGroup = pageGroup * 10;
	    const firstPageOfGroup = lastPageOfGroup - 9;
	    const groupLast = Math.min(lastPageOfGroup, totalPages);

	    const navContainer = document.createElement('div');
	    navContainer.className = 'inline-flex items-center -space-x-px shadow-sm';

	    const hasPrev = this.currentPage > 1;
	    const prevGroupTarget = pageGroup > 1 ? firstPageOfGroup - 10 : 1;
	    navContainer.appendChild(this.createNavBtn('prevGroup', hasPrev, prevGroupTarget));
	    navContainer.appendChild(this.createNavBtn('prev', hasPrev, this.currentPage - 1));

	    for (let i = firstPageOfGroup; i <= groupLast; i++) {
	        navContainer.appendChild(this.createPageBtn(i, i === this.currentPage));
	    }

	    const hasNext = this.currentPage < totalPages;
	    const nextGroupTarget = groupLast < totalPages ? groupLast + 1 : totalPages;
	    navContainer.appendChild(this.createNavBtn('next', hasNext, this.currentPage + 1));
	    navContainer.appendChild(this.createNavBtn('nextGroup', hasNext, nextGroupTarget));

	    pagination.appendChild(navContainer);
	}

    createPageBtn(page, isActive) {
        const btn = document.createElement('button');
        btn.type = 'button';
        btn.textContent = page;
        const baseClass = 'px-4 py-2 text-base border border-gray-300 transition min-w-[44px] min-h-[44px] flex items-center justify-center';
        btn.className = isActive 
            ? `${baseClass} text-gray-900 bg-gray-100 font-bold` 
            : `${baseClass} text-gray-600 bg-white hover:bg-gray-100`;
        btn.onclick = () => { this.currentPage = page; this.updateGrid(); };
        return btn;
    }

    createNavBtn(type, isEnabled, targetPage) {
        const btn = document.createElement('button');
        btn.type = 'button';
        const rounded = type === 'prevGroup' ? 'rounded-l-xl' : (type === 'nextGroup' ? 'rounded-r-xl' : '');
        btn.className = `w-[44px] h-[44px] text-gray-600 bg-white border border-gray-300 ${rounded} hover:bg-gray-100 transition flex items-center justify-center`;
        if (!isEnabled) btn.classList.add('opacity-20', 'cursor-not-allowed');

        const pPrev = "M1427 301l-531 531 531 531q19 19 19 45t-19 45l-166 166q-19 19-45 19t-45-19l-742-742q-19-19-19-45t19-45l742-742q19-19 45-19t45 19l166 166q19 19 19 45t-19 45z";
        const pNext = "M1363 877l-742 742q-19 19-45 19t-45-19l-166-166q-19-19-19-45t19-45l531-531-531-531q-19-19-19-45t19-45l166-166q19-19 45-19t45 19l742 742q19 19 19 45t-19 45z";

        let svgContent = (type.includes('prev')) ? `<path d="${pPrev}"></path>` : `<path d="${pNext}"></path>`;
        if (type.includes('Group')) {
            const trans = type.includes('prev') ? 'translate(-700, 0)' : 'translate(700, 0)';
            svgContent += (type.includes('prev')) ? `<path d="${pPrev}" transform="${trans}"></path>` : `<path d="${pNext}" transform="${trans}"></path>`;
        }
        btn.innerHTML = `<svg width="18" height="18" fill="currentColor" viewBox="-800 0 3500 1792">${svgContent}</svg>`;
        btn.onclick = () => { if (isEnabled) { this.currentPage = targetPage; this.updateGrid(); } };
        return btn;
    }
}

// 테마 적용
tui.Grid.applyTheme('clean', {
    outline: { 
        border: '#f3f4f6',      // JSP의 border-gray-100/200 느낌
        showVerticalBorder: false 
    },
    area: { 
        header: { 
            background: '#f9fafb', // JSP의 bg-gray-50
            border: '#f3f4f6' 
        },
        body: { 
            background: '#ffffff' 
        }
    },
    cell: { 
        normal: { 
            background: '#ffffff',
            border: '#f3f4f6',      // JSP의 divide-gray-100
            showVerticalBorder: false,
            showHorizontalBorder: true 
        }, 
        header: { 
            background: '#f9fafb',
            border: '#f3f4f6', 
            showVerticalBorder: false,
            showHorizontalBorder: true 
        },
        // [추가] 선택된 셀이나 포커스된 셀의 효과를 제거하여 미니멀함 유지
        selectedHeader: { background: '#f9fafb' },
        focused: { border: 'transparent' },
        focusedInactive: { border: 'transparent' }
    }
});