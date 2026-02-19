package io.github.teamb.btob.dto.mgmtAdm.compy;

import io.github.teamb.btob.dto.attachfile.AtchFileDto;
import lombok.Data;

import java.util.List;

@Data
public class CompyRegisterRequestDTO {

    // 1. 회사 정보
    private InsertCompyDTO compyBase;

    // 2. 회사 첨부 이미지
    private List<AtchFileDto> companyLogo;

    /**
     * 추가: 임시 저장 폴더(D:\temp\img)에 저장된 파일명
     * JS의 previewImage 성공 시 반환받은 파일명을 여기에 담아 보냅니다.
     */
    // 회사 이미지로고
    private String companyLogoTempName;
}
