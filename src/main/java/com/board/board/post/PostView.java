package com.board.board.post;

import com.board.board.common.BaseTimeEntity;
import com.board.board.user.User;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(
    name = "post_views",
    indexes = {
        @Index(name = "idx_post_views_post_user", columnList = "post_id, user_id"),
        @Index(name = "idx_post_views_post_session", columnList = "post_id, session_id")
    },
    uniqueConstraints = {
        @UniqueConstraint(name = "uk_post_views_post_user", columnNames = {"post_id", "user_id"}),
        @UniqueConstraint(name = "uk_post_views_post_session", columnNames = {"post_id", "session_id"})
    }
)
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class PostView extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "post_id", nullable = false)
    private Post post;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "session_id", length = 100)
    private String sessionId;

    public static PostView createForUser(Post post, User user) {
        PostView view = new PostView();
        view.post = post;
        view.user = user;
        view.sessionId = null;
        return view;
    }

    public static PostView createForSession(Post post, String sessionId) {
        PostView view = new PostView();
        view.post = post;
        view.user = null;
        view.sessionId = sessionId;
        return view;
    }
}