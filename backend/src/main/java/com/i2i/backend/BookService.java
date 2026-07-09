package com.i2i.backend;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BookService {

    @PersistenceContext
    private EntityManager entityManager;

    @Transactional
    public void processXml(String xmlData) {
        entityManager.createNativeQuery("BEGIN pkg_book_management.process_books_xml(:xml); END;")
                .setParameter("xml", xmlData)
                .executeUpdate();
    }

    @Transactional
    public void processJson(String jsonData) {
        entityManager.createNativeQuery("BEGIN pkg_book_management.process_books_json(:json); END;")
                .setParameter("json", jsonData)
                .executeUpdate();
    }
}
