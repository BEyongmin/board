package com.board.board.comment;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface CommentRepository extends JpaRepository<Comment, Long> {

    @Query("select c from Comment c join fetch c.user where c.post.id = :postId order by c.createdAt asc")
    List<Comment> findAllByPostIdWithUser(@Param("postId") Long postId);
}