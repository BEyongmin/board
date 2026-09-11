package com.board.board.common;

import com.board.board.post.InvalidCategoryException;
import com.board.board.post.PostNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(PostNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String handleNotFound(PostNotFoundException e, Model model) {
        model.addAttribute("message", e.getMessage());
        return "error/404";
    }

    @ExceptionHandler(ForbiddenException.class)
    @ResponseStatus(HttpStatus.FORBIDDEN)
    public String handleForbidden(ForbiddenException e, Model model) {
        model.addAttribute("message", e.getMessage());
        return "error/403";
    }

    @ExceptionHandler(TooManyRequestsException.class)
    @ResponseStatus(HttpStatus.TOO_MANY_REQUESTS)
    public String handleTooManyRequests(TooManyRequestsException e, Model model) {
        model.addAttribute("message", e.getMessage());
        return "error/429";
    }
    @ExceptionHandler(InvalidCategoryException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public String handleInvalidCategory(InvalidCategoryException e, Model model) {
        model.addAttribute("message", e.getMessage());
        return "error/400";
    }
}