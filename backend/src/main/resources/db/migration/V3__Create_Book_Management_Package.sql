-- 1. CREATE PACKAGE SPECIFICATION
CREATE OR REPLACE PACKAGE pkg_book_management AS
    PROCEDURE add_book_with_details(
        p_title IN VARCHAR2,
        p_author_name IN VARCHAR2,
        p_publisher_name IN VARCHAR2
    );
    
    PROCEDURE process_books_xml(p_xml_clob IN CLOB);
    PROCEDURE process_books_json(p_json_clob IN CLOB);
END pkg_book_management;
/

-- 2. CREATE PACKAGE BODY
CREATE OR REPLACE PACKAGE BODY pkg_book_management AS

    PROCEDURE add_book_with_details(
        p_title IN VARCHAR2,
        p_author_name IN VARCHAR2,
        p_publisher_name IN VARCHAR2
    ) IS
        v_author_id NUMBER;
        v_publisher_id NUMBER;
    BEGIN
        BEGIN
            SELECT id INTO v_author_id FROM AUTHORS WHERE name = p_author_name;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                INSERT INTO AUTHORS (name) VALUES (p_author_name) 
                RETURNING id INTO v_author_id;
        END;

        BEGIN
            SELECT id INTO v_publisher_id FROM PUBLISHERS WHERE name = p_publisher_name;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                INSERT INTO PUBLISHERS (name) VALUES (p_publisher_name) 
                RETURNING id INTO v_publisher_id;
        END;

        INSERT INTO BOOKS (title, author_id, publisher_id)
        VALUES (p_title, v_author_id, v_publisher_id);
    END add_book_with_details;

    PROCEDURE process_books_xml(p_xml_clob IN CLOB) IS
    BEGIN
        FOR r IN (
            SELECT xt.title, xt.author, xt.publisher
            FROM XMLTABLE('/books/book'
                PASSING XMLTYPE(p_xml_clob)
                COLUMNS
                    title     VARCHAR2(150) PATH 'title',
                    author    VARCHAR2(100) PATH 'author',
                    publisher VARCHAR2(100) PATH 'publisher'
            ) xt
        ) LOOP
            add_book_with_details(r.title, r.author, r.publisher);
        END LOOP;
    END process_books_xml;

    PROCEDURE process_books_json(p_json_clob IN CLOB) IS
    BEGIN
        FOR r IN (
            SELECT jt.title, jt.author, jt.publisher
            FROM JSON_TABLE(p_json_clob, '$.books[*]'
                COLUMNS
                    title     VARCHAR2(150) PATH '$.title',
                    author    VARCHAR2(100) PATH '$.author',
                    publisher VARCHAR2(100) PATH '$.publisher'
                ) jt
        ) LOOP
            add_book_with_details(r.title, r.author, r.publisher);
        END LOOP;
    END process_books_json;

END pkg_book_management;
/