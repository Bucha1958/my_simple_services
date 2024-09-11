package com.example.MyFristDemoWithSpring;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.ResponseEntity;

@RestController
public class HelloWorld {
    @CrossOrigin(origins = "http://34.46.81.41:80") // Allow requests from your frontend's origin
    @GetMapping("/api/message")
    public ResponseEntity<MessageResponse> hello() {
        // Create a response object with the message
        MessageResponse response = new MessageResponse("Hello, Java World changes!");
        return ResponseEntity.ok(response);
    }

    // Inner class to represent the response structure
    public static class MessageResponse {
        private String message;

        public MessageResponse(String message) {
            this.message = message;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }
    }
}
