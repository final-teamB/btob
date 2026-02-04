package io.github.teamb.btob.dto.oil;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class OilMstDTO {

    private int fuelId;              // fuel_id
    private String fuelCd;           // fuel_cd
    private String fuelNm;           // fuel_nm
    private String fuelCatCd;        // fuel_cat_cd
    private String originCntryCd;    // origin_cntry_cd

    private Integer baseUnitPrc;     // base_unit_prc
    private Integer currStockVol;    // curr_stock_vol
    private Integer safeStockVol;    // safe_stock_vol

    private String volUnitCd;        // vol_unit_cd
    private String itemSttsCd;       // item_stts_cd

    private LocalDateTime regDtime;  // reg_dtime
    private String regId;            // reg_id
    private LocalDateTime updDtime;  // upd_dtime
    private String updId;            // upd_id

    private String useYn;            // use_yn (Y/N)
}