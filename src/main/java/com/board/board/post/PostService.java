package com.board.board.post;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
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

    private final PostRepository postRepository;
    private final CategoryRepository categoryRepository;
    private final UserRepository userRepository;
    private final FileStorageService fileStorageService;
    private final CommentRepository commentRepository;
    private final PostViewService postViewService;

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
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalStateException("사용자를 찾을 수 없습니다."));
        Category category = categoryRepository.findById(form.getCategoryId())
                .orElseThrow(() -> new IllegalStateException("카테고리를 찾을 수 없습니다."));

        Post post = Post.create(user, category, form.getTitle(), form.getContent());

        if (form.getImage() != null && !form.getImage().isEmpty()) {
            String storedName = fileStorageService.store(form.getImage());
            post.attachImage(storedName, form.getImage().getOriginalFilename(), form.isUseAsThumbnail());
        }

        postRepository.save(post);
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
                .orElseThrow(() -> new IllegalStateException("카테고리를 찾을 수 없습니다."));
        post.update(category, form.getTitle(), form.getContent());

        if (form.isRemoveImage()) {
            // 1: 이미지 체크 시 무조건 삭제
            post.removeImage();
        } else if (form.getImage() != null && !form.getImage().isEmpty()) {
            // 2: 새 파일이 올라왔으면 교체
            String storedName = fileStorageService.store(form.getImage());
            post.attachImage(storedName, form.getImage().getOriginalFilename(), form.isUseAsThumbnail());
        } else if (post.hasImage()) {
            // 3: 새 파일도 없고 삭제도 아니면, 대표 여부만 갱신
            post.updateThumbnail(form.isUseAsThumbnail());
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
            postRepository.delete(post);
        }
}