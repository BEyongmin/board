package com.board.board.post;

import com.board.board.auth.CustomUserDetails;
import com.board.board.category.CategoryRepository;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/posts")
@RequiredArgsConstructor
public class PostController {

    private final PostService postService;
    private final CategoryRepository categoryRepository;

    @GetMapping
    public String list(@PageableDefault(size = 20, sort = "id", direction = Sort.Direction.DESC) Pageable pageable,
                        Model model) {
        model.addAttribute("postPage", postService.getList(pageable));
        return "post/list";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Long id, Model model) {
        model.addAttribute("post", postService.getDetail(id));
        return "post/detail";
    }

    @GetMapping("/new")
    public String createForm(Model model) {
        model.addAttribute("postForm", new PostForm());
        model.addAttribute("categories", categoryRepository.findAll());
        return "post/form";
    }

    @PostMapping
    public String create(@Valid @ModelAttribute PostForm postForm,
                          BindingResult bindingResult,
                          @AuthenticationPrincipal CustomUserDetails userDetails,
                          Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("categories", categoryRepository.findAll());
            return "post/form";
        }
        Long postId = postService.create(userDetails.getUser().getId(), postForm);
        return "redirect:/posts/" + postId;
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id,
                            @AuthenticationPrincipal CustomUserDetails userDetails,
                            Model model) {
        Post post = postService.getById(id);
        if (!post.isWrittenBy(userDetails.getUser().getId())) {
            throw new com.board.board.common.ForbiddenException("수정 권한이 없습니다.");
        }

        PostForm postForm = new PostForm();
        postForm.setCategoryId(post.getCategory().getId());
        postForm.setTitle(post.getTitle());
        postForm.setContent(post.getContent());

        model.addAttribute("postForm", postForm);
        model.addAttribute("categories", categoryRepository.findAll());
        model.addAttribute("postId", id);
        return "post/form";
    }

    @PostMapping("/{id}/edit")
    public String edit(@PathVariable Long id,
                        @Valid @ModelAttribute PostForm postForm,
                        BindingResult bindingResult,
                        @AuthenticationPrincipal CustomUserDetails userDetails,
                        Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("categories", categoryRepository.findAll());
            model.addAttribute("postId", id);
            return "post/form";
        }
        postService.update(id, userDetails.getUser().getId(), postForm);
        return "redirect:/posts/" + id;
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id,
                          @AuthenticationPrincipal CustomUserDetails userDetails) {
        postService.delete(id, userDetails.getUser().getId());
        return "redirect:/posts";
    }
}