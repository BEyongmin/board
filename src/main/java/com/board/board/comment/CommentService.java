package com.board.board.comment;

import com.board.board.common.ForbiddenException;
import com.board.board.post.Post;
import com.board.board.post.PostRepository;
import com.board.board.user.User;
import com.board.board.user.UserRepository;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class CommentService {

    private final CommentRepository commentRepository;
    private final PostRepository postRepository;
    private final UserRepository userRepository;
    private final com.board.board.common.RateLimiter rateLimiter;

    @Transactional(readOnly = true)
    public List<Comment> getComments(Long postId) {
        return commentRepository.findAllByPostIdWithUser(postId);
    }

    @Transactional
    public void create(Long postId, Long userId, CommentForm form) {

        if (!rateLimiter.isAllowed("comment:" + userId, 5, 60_000)) {
            throw new com.board.board.common.TooManyRequestsException("잠시 후 다시 시도해주세요. (1분에 최대 5개까지 작성 가능)");
        }
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalStateException("게시글을 찾을 수 없습니다."));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalStateException("사용자를 찾을 수 없습니다."));

        Comment comment = Comment.create(post, user, form.getContent());
        commentRepository.save(comment);
    }

    @Transactional
    public void delete(Long commentId, Long userId) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new IllegalStateException("댓글을 찾을 수 없습니다."));

        if (!comment.isWrittenBy(userId)) {
            throw new ForbiddenException("삭제 권한이 없습니다.");
        }

        commentRepository.delete(comment);
    }
}