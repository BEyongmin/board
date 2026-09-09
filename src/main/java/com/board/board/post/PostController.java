package com.board.board.post;

import com.board.board.auth.CustomUserDetails;
import com.board.board.category.CategoryRepository;
import com.board.board.comment.CommentService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
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
    private final CommentService commentService;

    @GetMapping
    public String list(@RequestParam(required = false) String type,
                        @RequestParam(required = false) String keyword,
                        @RequestParam(defaultValue = "LATEST") String sort,
                        @PageableDefault(size = 20) Pageable pageable,
                        Model model) {

        Sort.Direction direction = "OLDEST".equals(sort) ? Sort.Direction.ASC : Sort.Direction.DESC;
        Pageable sortedPageable = PageRequest.of(pageable.getPageNumber(), pageable.getPageSize(), Sort.by(direction, "id"));

        Page<Post> postPage;
        boolean hasKeyword = keyword != null && !keyword.isBlank();

        if (hasKeyword) {
            String searchType = (type == null || type.isBlank()) ? "TITLE" : type;
            postPage = postService.search(searchType, keyword, sortedPageable);
            model.addAttribute("type", searchType);
        } else {
            postPage = postService.getList(sortedPageable);
            model.addAttribute("type", "TITLE");
        }

        model.addAttribute("postPage", postPage);
        model.addAttribute("keyword", keyword);
        model.addAttribute("sort", sort);
        return "post/list";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Long id,
                        @AuthenticationPrincipal CustomUserDetails userDetails,
                        HttpServletRequest request,
                        Model model) {

        Long userId = (userDetails != null) ? userDetails.getUser().getId() : null;
        String sessionId = (userId == null) ? request.getSession().getId() : null;

        model.addAttribute("post", postService.getDetail(id, userId, sessionId));
        model.addAttribute("comments", commentService.getComments(id));
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
        postForm.setUseAsThumbnail(post.isThumbnail());

        model.addAttribute("postForm", postForm);
        model.addAttribute("categories", categoryRepository.findAll());
        model.addAttribute("postId", id);
        model.addAttribute("currentImagePath", post.getImagePath());
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