package com.board.board.post;

import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface PostRepository extends JpaRepository<Post, Long> {

    @Query(
        value = "select p from Post p join fetch p.user join fetch p.category",
        countQuery = "select count(p) from Post p"
    )
    Page<Post> findAllWithUserAndCategory(Pageable pageable);

    @Query("select p from Post p join fetch p.user join fetch p.category where p.id = :id")
    Optional<Post> findByIdWithUserAndCategory(@Param("id") Long id);
}