/**
 * datagrid.js
 * 렌더러 + 범용 필터링 + 기본 정렬/정렬옵션 통합본
 */

// [1] 버튼 렌더러
class CustomActionRenderer {
    constructor(props) {
        const { grid, rowKey } = props;
        const rowData = grid.getRow(rowKey);
        
        const el = document.createElement('button');
        el.className = 'dg-btn-manage'; 
        el.innerText = '수정';
        
        el.onclick = () => {
            if (typeof window.openEditModal === 'function') {
                window.openEditModal(rowData);
            }
        };
        this.el = el;
    }
    getElement() { return this.el; }
}

// [2] 메인 관리 객체
const DataGridManager = {
    grid: null,
    allData: [],
    filteredData: [],
    perPage: 10,
    currentPage: 1,
    filterConfig: { field: '', selectId: '' },

    init: function(config) {
        this.allData = config.data || [];
        this.perPage = config.perPage || 10;
        this.filterConfig.field = config.filterField || ''; 
        this.filterConfig.selectId = config.filterSelectId || '';

        // [수정] 컬럼 옵션 통합 처리 (기본 정렬: Left, 정렬: True)
        const processedColumns = (config.columns || []).map(col => ({
            ...col,
            align: col.align || 'left',
            sortable: col.sortable !== undefined ? col.sortable : true,
			resizable: col.resizable !== undefined ? col.resizable : true,
			ellipsis: true // 텍스트가 길 때 자동으로 ... 처리 + 호버 시 툴팁 제공
        }));

        // [수정] 데이터 전처리 (안전한 옵셔널 체이닝 적용)
        this.filteredData = this.allData.map(item => {
            if (item.regDtime && typeof item.regDtime === 'string') {
                item.regDtime = item.regDtime.replace('T', ' ').split('.')[0];
            }
            return item;
        });

        // 그리드 초기화
        this.grid = new tui.Grid({
            el: document.getElementById(config.containerId || 'dg-container'),
            data: this.filteredData.slice(0, this.perPage),
            columns: processedColumns, // 가공된 컬럼 사용
            rowHeight: 55,
            width: 'auto',
            bodyHeight: 'auto',
            scrollX: false,
            scrollY: false,
			rowHeaders: config.showCheckbox 
			        ? [{type: 'rowNum', width: 100}, {type: 'checkbox', width: 50}] 
			        : [{type: 'rowNum', width: 100}],
            usageStatistics: false,
			selectionUnit: 'cell', // 'row' 대신 'cell'로 설정하면 개별 셀 선택이 쉬워짐
            columnOptions: { minWidth: 150 }
        }); 
		
        this.grid.refreshLayout();
		
		setTimeout(() => {
		    // 1. 그리드가 존재할 때만 실행
		    if (this.grid) {
		        // 2. 현재 부모의 실제 너비에 맞춰 그리드 재정렬
		        this.grid.refreshLayout(); 
		    }
		}, 200); // 브라우저가 레이아웃 연산을 끝낼 충분한 시간(0.2초) 부여

        // 반응형 대응
		const layoutWrapper = document.getElementById('dg-container').parentElement;
		if (layoutWrapper) {
		    const ro = new ResizeObserver(() => {
		        if (this.grid) this.grid.refreshLayout();
		    });
		    ro.observe(layoutWrapper);
		}
		
		// 그리드 초기화 코드 아래에 추가
		const container = document.getElementById('dg-container');

		container.addEventListener('mousedown', function(e) {
		    // 텍스트 노드나 입력창을 클릭했을 때 그리드의 기본 동작을 막음
		    e.stopPropagation();
		}, true); // 'true'를 주어 캡처링 단계에서 이벤트를 먼저 가로챕니다.
		
        this.bindEvents(config.searchId, config.perPageId, config.btnSearchId);
        this.renderPagination();
    },

    bindEvents: function(searchId, perPageId, btnSearchId) {
        const searchInput = document.getElementById(searchId);
        const filterSelect = document.getElementById(this.filterConfig.selectId);
        const perPageSelect = document.getElementById(perPageId);

        const executeFiltering = () => {
            const keyword = searchInput ? searchInput.value.toLowerCase() : '';
            const filterValue = filterSelect ? filterSelect.value : '';
            const filterField = this.filterConfig.field;

            this.filteredData = this.allData.filter(row => {
                const matchesSearch = Object.values(row).some(val => 
                    val && val.toString().toLowerCase().includes(keyword)
                );
                const matchesSelect = !filterField || filterValue === '' || row[filterField] === filterValue;
                return matchesSearch && matchesSelect;
            });

            this.currentPage = 1;
            this.updateGrid();
        };

        if (searchInput) searchInput.addEventListener('input', executeFiltering);
        if (filterSelect) filterSelect.addEventListener('change', executeFiltering);
        if (perPageSelect) {
            perPageSelect.addEventListener('change', (e) => {
                this.perPage = parseInt(e.target.value);
                this.currentPage = 1;
                this.updateGrid();
            });
        }
        
        const btnSearch = document.getElementById(btnSearchId);
        if (btnSearch && typeof window.fetchData === 'function') {
            btnSearch.addEventListener('click', window.fetchData);
        }
    },

    updateGrid: function() {
        const start = (this.currentPage - 1) * this.perPage;
        const end = start + this.perPage;
        this.grid.resetData(this.filteredData.slice(start, end));
        this.renderPagination();
    },

    renderPagination: function() {
        const pagination = document.getElementById('dg-pagination');
        if (!pagination) return;
        pagination.innerHTML = '';

        const totalPages = Math.ceil(this.filteredData.length / this.perPage);
        if (totalPages <= 1) return;

        const pageGroup = Math.ceil(this.currentPage / 10);
        const last = pageGroup * 10;
        const first = last - 9;
        const groupLast = Math.min(last, totalPages);

        const navContainer = document.createElement('div');
        navContainer.className = 'flex items-center -space-x-px'; // 버튼 간격 조절

        if (pageGroup > 1) navContainer.appendChild(this.createPageBtn('◀', first - 1));
        for (let i = first; i <= groupLast; i++) {
            navContainer.appendChild(this.createPageBtn(i, i, i === this.currentPage));
        }
        if (groupLast < totalPages) navContainer.appendChild(this.createPageBtn('▶', groupLast + 1));

        pagination.appendChild(navContainer);
    },

    createPageBtn: function(label, page, isActive) {
        const btn = document.createElement('button');
        btn.textContent = label;
        // [수정] 활성화 상태일 때 명확한 클래스 부여
        btn.className = isActive ? 'active' : ''; 
        btn.onclick = () => {
            this.currentPage = page;
            this.updateGrid();
        };
        return btn;
    }
};