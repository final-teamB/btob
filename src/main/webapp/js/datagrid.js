/**
 * datagrid.js
 * 클래스 기반으로 개편 (한 페이지 내 여러 그리드 사용 가능)
 */

// [1] 버튼 렌더러
class CustomActionRenderer {
    constructor(props) {
        const { grid, rowKey, columnInfo } = props;
        const rowData = grid.getRow(rowKey);
        
        // options.buttons 배열을 가져옴 (기본값 설정)
        const buttonConfigs = columnInfo.renderer.options?.buttons || [
            { text: '수정', action: 'edit' }
        ];
        
        const container = document.createElement('div');
        container.className = 'flex justify-center gap-2'; // 중앙 정렬 및 간격

        buttonConfigs.forEach(btnCfg => {
            const btn = document.createElement('button');
            btn.className = 'dg-btn-manage'; 
            btn.innerText = btnCfg.text;
            
            btn.onclick = () => {
                // handleGridAction 하나로 통합하되, 어떤 버튼인지 'action' 값을 같이 넘김
                if (typeof window.handleGridAction === 'function') {
                    window.handleGridAction(rowData, btnCfg.action);
                }
            };
            container.appendChild(btn);
        });

        this.el = container;
    }
    getElement() { return this.el; }
}

// [2] 메인 데이터그리드 클래스
class DataGrid {
    constructor(config) {
        // 인스턴스별 독립 변수 설정
        this.grid = null;
        this.allData = config.data || [];
        this.filteredData = [];
        this.perPage = config.perPage || 10;
        this.currentPage = 1;
        this.config = config;
        this.filterConfig = { 
            field: config.filterField || '', 
            selectId: config.filterSelectId || '' 
        };

        this.init();
    }

    init() {
        const config = this.config;

        // 컬럼 설정 가공
        const processedColumns = (config.columns || []).map(col => ({
            ...col,
            align: col.align || 'left',
            sortable: col.sortable !== undefined ? col.sortable : true,
            ellipsis: true
        }));

        // 데이터 전처리
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
            columns: processedColumns,
            rowHeight: 55,
            width: 'auto',
            bodyHeight: 'auto',
            scrollX: false,
            scrollY: false,
            rowHeaders: config.showCheckbox 
                ? [{type: 'rowNum', width: 100}, {type: 'checkbox', width: 50}] 
                : [{type: 'rowNum', width: 100}],
            usageStatistics: false,
            selectionUnit: 'cell',
            columnOptions: { minWidth: 150 }
        });

        // 초기 레이아웃 보정
        setTimeout(() => this.grid.refreshLayout(), 200);

        // 반응형 대응 (ResizeObserver)
        const container = document.getElementById(config.containerId || 'dg-container');
        if (container && container.parentElement) {
            const ro = new ResizeObserver(() => {
                if (this.grid) this.grid.refreshLayout();
            });
            ro.observe(container.parentElement);
        }
		
		container.addEventListener('mousedown', function(e) {
		    // 그리드의 행 선택 로직이 마우스 이벤트를 가로채지 못하게 원천 봉쇄
		    e.stopPropagation();
		}, true); // true(캡처링)가 핵심입니다.

        this.bindEvents();
        this.renderPagination();
    }

    bindEvents() {
        const c = this.config;
        const searchInput = document.getElementById(c.searchId);
		if (searchInput) {
		    // HTML이 있을 때만 검색 이벤트 연결
		    searchInput.addEventListener('keyup', (e) => {
		        if (e.key === 'Enter') this.search();
		    });
		}
        const filterSelect = document.getElementById(this.filterConfig.selectId);
        const perPageSelect = document.getElementById(c.perPageId);

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
        
        const btnSearch = document.getElementById(c.btnSearchId);
        if (btnSearch && typeof window.fetchData === 'function') {
            btnSearch.addEventListener('click', window.fetchData);
        }
    }

    updateGrid() {
        const start = (this.currentPage - 1) * this.perPage;
        const end = start + this.perPage;
        this.grid.resetData(this.filteredData.slice(start, end));
        this.renderPagination();
    }

    renderPagination() {
        // config에서 paginationId를 받아 여러 페이징 영역 대응
        const paginationId = this.config.paginationId || 'dg-pagination';
        const pagination = document.getElementById(paginationId);
        if (!pagination) return;
        pagination.innerHTML = '';

        const totalPages = Math.ceil(this.filteredData.length / this.perPage);
        if (totalPages <= 1) return;

        const pageGroup = Math.ceil(this.currentPage / 10);
        const last = pageGroup * 10;
        const first = last - 9;
        const groupLast = Math.min(last, totalPages);

        const navContainer = document.createElement('div');
        navContainer.className = 'flex items-center -space-x-px';

        if (pageGroup > 1) navContainer.appendChild(this.createPageBtn('◀', first - 1));
        for (let i = first; i <= groupLast; i++) {
            navContainer.appendChild(this.createPageBtn(i, i, i === this.currentPage));
        }
        if (groupLast < totalPages) navContainer.appendChild(this.createPageBtn('▶', groupLast + 1));

        pagination.appendChild(navContainer);
    }

    createPageBtn(label, page, isActive) {
        const btn = document.createElement('button');
        btn.textContent = label;
        btn.className = isActive ? 'active' : ''; 
        btn.onclick = () => {
            this.currentPage = page;
            this.updateGrid();
        };
        return btn;
    }
}