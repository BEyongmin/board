package com.board.board.post;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;

import org.springframework.dao.DataIntegrityViolationException;

import com.board.board.category.Category;
import com.board.board.category.CategoryRepository;
import com.board.board.comment.CommentRepository;
import com.board.board.common.FileStorageService;
import com.board.board.common.ForbiddenException;
import com.board.board.user.User;
import com.board.board.user.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PostService {

    private final PostImageRepository postImageRepository;
    private final PostRepository postRepository;
    private final CategoryRepository categoryRepository;
    private final UserRepository userRepository;
    private final FileStorageService fileStorageService;
    private final CommentRepository commentRepository;
    private final PostViewService postViewService;
    private final com.board.board.common.RateLimiter rateLimiter;
    private final PostViewRepository postViewRepository;


    @Transactional(readOnly = true)
    public Page<Post> getList(Pageable pageable) {
        return postRepository.findAllWithUserAndCategory(pageable);
    }

    @Transactional(readOnly = true)
    public Page<Post> search(String type, String keyword, Pageable pageable) {
        return postRepository.search(type, keyword, pageable);
    }

    // 수정 폼 등에서 조회수 증가 없이 단순 조회할 때 사용
    @Transactional(readOnly = true)
    public Post getById(Long postId) {
        return postRepository.findById(postId)
                .orElseThrow(() -> new PostNotFoundException("게시글을 찾을 수 없습니다."));
    }

    @Transactional
    public Post getDetail(Long postId, Long userId, String sessionId) {
        Post post = postRepository.findByIdWithUserAndCategory(postId)
                .orElseThrow(() -> new PostNotFoundException("게시글을 찾을 수 없습니다."));

        boolean firstView = true;
        try {
            postViewService.recordView(postId, userId, sessionId);
        } catch (DataIntegrityViolationException e) {
            firstView = false;
        }

        if (firstView) {
            post.increaseViewCount();
        }

        return post;
    }

    @Transactional
    public Long create(Long userId, PostForm form) {

        if (!rateLimiter.isAllowed("post:" + userId, 3, 60_000)) {
            throw new com.board.board.common.TooManyRequestsException("잠시 후 다시 시도해주세요. (1분에 최대 3개까지 작성 가능)");
        }   
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalStateException("사용자를 찾을 수 없습니다."));
        Category category = categoryRepository.findById(form.getCategoryId())
                .orElseThrow(() -> new InvalidCategoryException("존재하지 않는 카테고리입니다."));

        Post post = Post.create(user, category, form.getTitle(), form.getContent());
        postRepository.save(post);

        List<MultipartFile> images = form.getImages();
        List<MultipartFile> validImages = images.stream()
                .filter(f -> f != null && !f.isEmpty())
                .toList();

        if (!validImages.isEmpty()) {
            fileStorageService.validateCount(0, validImages.size());

            for (int i = 0; i < validImages.size(); i++) {
                MultipartFile file = validImages.get(i);
                String storedName = fileStorageService.store(file);
                boolean isThumbnail = form.getNewThumbnailIndex() != null
                        && form.getNewThumbnailIndex() == i;

                PostImage postImage = PostImage.create(
                        post, file.getOriginalFilename(), storedName, isThumbnail
                );
                postImageRepository.save(postImage);
            }
        }

        return post.getId();
    }

    @Transactional
    public void update(Long postId, Long userId, PostForm form) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new PostNotFoundException("게시글을 찾을 수 없습니다."));

        if (!post.isWrittenBy(userId)) {
            throw new ForbiddenException("수정 권한이 없습니다.");
        }

        Category category = categoryRepository.findById(form.getCategoryId())
                .orElseThrow(() -> new InvalidCategoryException("존재하지 않는 카테고리입니다."));
        post.update(category, form.getTitle(), form.getContent());

        // 1) 삭제 요청된 기존 이미지 제거 (DB 행만, 실제 파일은 오늘 범위에서 생략)
        List<Long> removeIds = form.getRemoveImageIds();
        if (removeIds != null && !removeIds.isEmpty()) {
            postImageRepository.deleteAllById(removeIds);
        }

        // 2) 새로 올리는 파일 개수 검증 (남은 기존 개수 + 새로 올리는 개수)
        List<MultipartFile> validImages = form.getImages().stream()
                .filter(f -> f != null && !f.isEmpty())
                .toList();

        int remainingExisting = postImageRepository.findAllByPostIdOrderByIdAsc(postId).size();
        if (!validImages.isEmpty()) {
            fileStorageService.validateCount(remainingExisting, validImages.size());
        }

        // 3) 새 이미지 저장
        List<PostImage> newImages = new ArrayList<>();
        for (MultipartFile file : validImages) {
            String storedName = fileStorageService.store(file);
            PostImage postImage = PostImage.create(post, file.getOriginalFilename(), storedName, false);
            newImages.add(postImageRepository.save(postImage));
        }

        // 4) 대표 이미지 재지정 (요청이 있을 때만)
        if (form.getThumbnailImageId() != null || form.getNewThumbnailIndex() != null) {
            postImageRepository.clearThumbnailByPostId(postId);

            if (form.getThumbnailImageId() != null) {
                postImageRepository.findById(form.getThumbnailImageId())
                        .ifPresent(PostImage::markAsThumbnail);
            } else {
                int idx = form.getNewThumbnailIndex();
                if (idx >= 0 && idx < newImages.size()) {
                    newImages.get(idx).markAsThumbnail();
                }
            }
        }
    }

    @Transactional
    public void delete(Long postId, Long userId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new PostNotFoundException("게시글을 찾을 수 없습니다."));

        if (!post.isWrittenBy(userId)) {
            throw new ForbiddenException("삭제 권한이 없습니다.");
        }

        commentRepository.deleteAllByPostId(postId);
        postViewRepository.deleteAllByPostId(postId);  
        postImageRepository.deleteAllByPostId(postId);
        postRepository.delete(post);
    }

    @Transactional(readOnly = true)
    public Page<Post> getListByCategory(Long categoryId, Pageable pageable) {
        return postRepository.findAllByCategoryId(categoryId, pageable);
    }
}