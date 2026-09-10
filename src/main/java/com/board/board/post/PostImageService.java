package com.board.board.post;

import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class PostImageService {

    private final PostImageRepository postImageRepository;

    @Transactional(readOnly = true)
    public List<PostImage> getImages(Long postId) {
        return postImageRepository.findAllByPostIdOrderByIdAsc(postId);
    }

    @Transactional(readOnly = true)
    public Map<Long, PostImage> getThumbnailMap(List<Long> postIds) {
        return postImageRepository.findAllByPostIdInAndThumbnailTrue(postIds).stream()
                .collect(Collectors.toMap(img -> img.getPost().getId(), Function.identity()));
    }
}