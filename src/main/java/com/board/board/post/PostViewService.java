package com.board.board.post;

import com.board.board.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class PostViewService {

    private final PostViewRepository postViewRepository;
    private final PostRepository postRepository;
    private final UserRepository userRepository;

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void recordView(Long postId, Long userId, String sessionId) {
        Post postRef = postRepository.getReferenceById(postId);

        PostView view = (userId != null)
                ? PostView.createForUser(postRef, userRepository.getReferenceById(userId))
                : PostView.createForSession(postRef, sessionId);

        postViewRepository.saveAndFlush(view);
    }
}