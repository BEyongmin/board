package com.board.board.category;

import java.util.List;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component 
@RequiredArgsConstructor 
public class CategoryInitializer implements CommandLineRunner {

    private final CategoryRepository categoryRepository;

    private static final List<String> DEFAULT_CATEGORIES =
            List.of("공지사항", "자유게시판", "질문게시판", "정보게시판", "자료게시판", "기타");

    @Override
    public void run(String... args) {
        for (String name : DEFAULT_CATEGORIES) {
            if (!categoryRepository.existsByName(name)) {
                categoryRepository.save(Category.create(name));
            }
        }
    }
}