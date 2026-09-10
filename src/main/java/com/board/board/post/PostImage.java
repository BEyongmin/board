package com.board.board.post;

import com.board.board.common.BaseTimeEntity;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(
    name = "post_images",
    indexes = {
        @Index(name = "idx_post_images_post", columnList = "post_id")
    }
)
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class PostImage extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "post_id", nullable = false)
    private Post post;

    @Column(name = "original_name", nullable = false, length = 255)
    private String originalName;

    @Column(name = "stored_name", nullable = false, unique = true, length = 255)
    private String storedName;

    @Column(name = "file_path", nullable = false, length = 500)
    private String filePath;

    @Column(name = "thumbnail", nullable = false)
    private boolean thumbnail;

    public static PostImage create(Post post, String originalName, String storedName, boolean thumbnail) {
        PostImage image = new PostImage();
        image.post = post;
        image.originalName = originalName;
        image.storedName = storedName;
        image.filePath = "/uploads/" + storedName;
        image.thumbnail = thumbnail;
        return image;
    }

    public void markAsThumbnail() {
        this.thumbnail = true;
    }

    public void unmarkThumbnail() {
        this.thumbnail = false;
    }
}