package com.board.board.comment;

import com.board.board.auth.CustomUserDetails;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
public class CommentController {

    private final CommentService commentService;

    @PostMapping("/posts/{postId}/comments")
    public String create(@PathVariable Long postId,
                          @Valid @ModelAttribute CommentForm commentForm,
                          BindingResult bindingResult,
                          @AuthenticationPrincipal CustomUserDetails userDetails) {

        if (!bindingResult.hasErrors()) {
            commentService.create(postId, userDetails.getUser().getId(), commentForm);
        }
        return "redirect:/posts/" + postId;
    }

    @PostMapping("/comments/{commentId}/delete")
    public String delete(@PathVariable Long commentId,
                          @RequestParam Long postId,
                          @AuthenticationPrincipal CustomUserDetails userDetails) {
        commentService.delete(commentId, userDetails.getUser().getId());
        return "redirect:/posts/" + postId;
    }
}