package com.board.board.post;

import com.board.board.category.Category;
import com.board.board.category.CategoryRepository;
import com.board.board.common.ForbiddenException;
import com.board.board.user.User;
import com.board.board.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class PostService {

    private final PostRepository postRepository;
    private final CategoryRepository categoryRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public Page<Post> getList(Pageable pageable) {
        return postRepository.findAllWithUserAndCategory(pageable);
    }

    // 수정 폼 등에서 조회수 증가 없이 단순 조회할 때 사용
    @Transactional(readOnly = true)
    public Post getById(Long postId) {
        return postRepository.findById(postId)
                .orElseThrow(() -> new PostNotFoundException("게시글을 찾을 수 없습니다."));
    }

    // 상세 화면 조회 시 사용 (조회수 증가 포함)
    @Transactional
    public Post getDetail(Long postId) {
        Post post = postRepository.findByIdWithUserAndCategory(postId)
                .orElseThrow(() -> new PostNotFoundException("게시글을 찾을 수 없습니다."));
        post.increaseViewCount();
        return post;
    }

    @Transactional
    public Long create(Long userId, PostForm form) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalStateException("사용자를 찾을 수 없습니다."));
        Category category = categoryRepository.findById(form.getCategoryId())
                .orElseThrow(() -> new IllegalStateException("카테고리를 찾을 수 없습니다."));

        Post post = Post.create(user, category, form.getTitle(), form.getContent());
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
    }

    @Transactional
    public void delete(Long postId, Long userId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new PostNotFoundException("게시글을 찾을 수 없습니다."));

        if (!post.isWrittenBy(userId)) {
            throw new ForbiddenException("삭제 권한이 없습니다.");
        }

        postRepository.delete(post);
    }
}