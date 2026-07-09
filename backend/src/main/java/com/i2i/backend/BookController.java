
package com.i2i.backend;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/books")
public class BookController {

    private final BookService bookService;

    public BookController(BookService bookService) {
        this.bookService = bookService;
    }

    @PostMapping(value = "/xml", consumes = "application/xml")
    public String uploadXml(@RequestBody String xmlData) {
        bookService.processXml(xmlData);
        return "XML data processed and books inserted successfully!";
    }

    @PostMapping(value = "/json", consumes = "application/json")
    public String uploadJson(@RequestBody String jsonData) {
        bookService.processJson(jsonData);
        return "JSON data processed and books inserted successfully!";
    }
}