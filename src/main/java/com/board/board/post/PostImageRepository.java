package com.board.board.post;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface PostImageRepository extends JpaRepository<PostImage, Long> {

    List<PostImage> findAllByPostIdOrderByIdAsc(Long postId);

    List<PostImage> findAllByPostIdInOrderByIdAsc(List<Long> postIds);
    List<PostImage> findAllByPostIdInAndThumbnailTrue(List<Long> postIds);

    @Modifying
    @Query("delete from PostImage i where i.post.id = :postId")
    void deleteAllByPostId(@Param("postId") Long postId);

    @Modifying
    @Query("update PostImage i set i.thumbnail = false where i.post.id = :postId")
    void clearThumbnailByPostId(@Param("postId") Long postId);
}