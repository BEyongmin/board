package com.board.board.post;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface PostViewRepository extends JpaRepository<PostView, Long> {

    @Modifying
    @Query("delete from PostView v where v.post.id = :postId")
    void deleteAllByPostId(@Param("postId") Long postId);
}