package com.board.board.user;

import com.board.board.common.BaseTimeEntity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity 
@Table (
    name = "users",
    uniqueConstraints = @UniqueConstraint(name = "uk_users_email", columnNames = "email")
)
@Getter 
@NoArgsConstructor (access = AccessLevel.PROTECTED)
public class User extends BaseTimeEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 255)
    private String email;

    @Column(nullable = false, length = 255)
    private String password;

    @Column(nullable = false, length = 50)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private UserRole role;

    public static User create(String email, String encodedPassword, String name) {
        User user = new User();
        user.email = email;
        user.password = encodedPassword;
        user.name = name;
        user.role = UserRole.USER;
        return user;
    }
}
