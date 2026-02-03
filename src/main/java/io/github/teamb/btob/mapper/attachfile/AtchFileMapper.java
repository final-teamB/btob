package io.github.teamb.btob.mapper.attachfile;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.attachfile.AtchFileDto;


/**
 * 
 * 첨부파일 매퍼
 * @author GD
 * @since 2026. 1. 26.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 26.  GD       최초 생성
 */
@Mapper
public interface AtchFileMapper {
		
	/**
	 * 
	 * 파일 정보 단건 저장
	 * @author GD
	 * @since 2026. 1. 26.
	 * @param atchFileDto
	 * @return 추가된 행 수
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 1. 26.  GD       최초 생성
	 */
    int insertFile(AtchFileDto atchFileDto);
    
    /**
     * 
     * 파일 단건 상세 조회 (다운로드용)
     * @author GD
     * @since 2026. 1. 26.
     * @param fileId
     * @return 파일 상세 정보
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    AtchFileDto selectFileById(int fileId);
    
    /**
     * 
     * 참조 대상별 파일 목록 조회 (공지사항 상세 등)
     * @author GD
     * @since 2026. 1. 26.
     * @param param refTypeCd 및 refId를 담은 Map
     * @return 파일 목록 리스트
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    List<AtchFileDto> selectFileListByRef(Map<String, Object> param);

    /**
     * 
     * 파일 정보 삭제 (미사용으로 미표출 처리)
     * @author GD
     * @since 2026. 1. 26.
     * @param fileId
     * @return 미사용 처리된 행 수
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    int deleteFileById(int fileId);
}
