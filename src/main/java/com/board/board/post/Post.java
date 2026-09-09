package com.board.board.post;

import com.board.board.category.Category;
import com.board.board.common.BaseTimeEntity;
import com.board.board.user.User;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(
    name = "posts",
    indexes = {
        @Index(name = "idx_posts_category_created", columnList = "category_id, created_at"),
        @Index(name = "idx_posts_user", columnList = "user_id")
    }
)
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Post extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false, length = 200)
    private String title;

    @Lob
    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    @Column(name = "view_count", nullable = false)
    private Long viewCount = 0L;

    public static Post create(User user, Category category, String title, String content) {
        Post post = new Post();
        post.user = user;
        post.category = category;
        post.title = title;
        post.content = content;
        post.viewCount = 0L;
        return post;
    }

    public void update(Category category, String title, String content) {
        this.category = category;
        this.title = title;
        this.content = content;
    }

    public void increaseViewCount() {
        this.viewCount++;
    }

    public boolean isWrittenBy(Long userId) {
        return this.user.getId().equals(userId);
    }
}