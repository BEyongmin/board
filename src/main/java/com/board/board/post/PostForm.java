package com.board.board.post;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.util.ArrayList;
import java.util.List;
import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

@Getter
@Setter
public class PostForm {

    @NotNull(message = "카테고리를 선택해주세요.")
    private Long categoryId;

    @NotBlank(message = "제목을 입력해주세요.")
    @Size(max = 200, message = "제목은 200자 이하로 입력해주세요.")
    private String title;

    @NotBlank(message = "내용을 입력해주세요.")
    private String content;

    /** 새로 첨부하는 이미지 파일들 (0장 이상) */
    private List<MultipartFile> images = new ArrayList<>();

    /** 기존 이미지 중 삭제할 것들의 id 목록 */
    private List<Long> removeImageIds = new ArrayList<>();

    /** 기존 이미지 중 대표로 지정할 id (없으면 null) */
    private Long thumbnailImageId;

    /** 새로 올리는 이미지 중 몇 번째(0부터)를 대표로 지정할지 (없으면 null) */
    private Integer newThumbnailIndex;
}