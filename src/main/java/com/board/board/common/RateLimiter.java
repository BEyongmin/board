package com.board.board.common;

import java.util.ArrayDeque;
import java.util.Deque;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import org.springframework.stereotype.Component;

@Component
public class RateLimiter {

    private final Map<String, Deque<Long>> requestLog = new ConcurrentHashMap<>();

    /**
     * @param key         제한 기준이 되는 키 (예: "post:3", "comment:3" — 액션종류:사용자id)
     * @param maxRequests windowMillis 동안 허용할 최대 요청 수
     * @param windowMillis 기준 시간(밀리초)
     * @return true면 허용, false면 제한 초과
     */
    public synchronized boolean isAllowed(String key, int maxRequests, long windowMillis) {
        long now = System.currentTimeMillis();
        Deque<Long> timestamps = requestLog.computeIfAbsent(key, k -> new ArrayDeque<>());

        // 1분(windowMillis) 지난 오래된 기록은 버림
        while (!timestamps.isEmpty() && now - timestamps.peekFirst() > windowMillis) {
            timestamps.pollFirst();
        }

        if (timestamps.size() >= maxRequests) {
            return false;
        }

        timestamps.addLast(now);
        return true;
    }
}