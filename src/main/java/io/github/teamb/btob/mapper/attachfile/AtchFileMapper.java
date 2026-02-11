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
    Integer insertFile(AtchFileDto atchFileDto);
    
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
    AtchFileDto selectFileById(Map<String, Integer> params);
    
    /**
     * 
     * 참조 대상별 파일 목록 조회 (공지사항 상세 등)
     * @author GD
     * @since 2026. 1. 26.
     * @param param systemId 및 refId를 담은 Map
     * @return 파일 목록 리스트
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    List<AtchFileDto> selectFileListByRef(Map<String, Object> param);

    /**
     * 
     * 첨부 파일 수정 시 삭제 처리 ( 미사용으로 변경 처리 )
     * @author GD
     * @since 2026. 1. 26.
     * @param fileId
     * @return 미사용 처리된 행 수
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    Integer updateUnusedFilesExceptRemaining(Map<String, Object> params);
    
    /**
     * 
     * 일반 미사용 처리 시
     * @author GD
     * @since 2026. 2. 4.
     * @param params
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 4.  GD       최초 생성
     */
    Integer unUseAtchFile(Map<String, Object> params);
    
    /**
     * 
     * 세부정보에서 수정 시 사용여부를 동적 처리하는게 필요함
     * @author GD
     * @since 2026. 2. 11.
     * @param params
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 11.  GD       최초 생성
     */
    Integer updateUseYnByDetailInfoChg(Map<String, Object> params);
    
    
    /**
     * 
     * 세부정보에서 수정 시 아이디랑 변환파일명따와야함
     * @author GD
     * @since 2026. 2. 11.
     * @param params
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 11.  GD       최초 생성
     */
    AtchFileDto selectFileIdStrFileNm(Map<String, Object> params);
}
