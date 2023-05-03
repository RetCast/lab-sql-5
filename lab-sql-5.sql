USE sakila;

# 1. Drop column picture from staff.
SELECT * FROM staff;

ALTER TABLE staff
DROP COLUMN picture;
SELECT * FROM staff;

/* 2. A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. 
Update the database accordingly.*/
SHOW CREATE TABLE staff;
/*CREATE TABLE `staff` (
   `staff_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
   `first_name` varchar(45) NOT NULL,
   `last_name` varchar(45) NOT NULL,
   `address_id` smallint unsigned NOT NULL,
   `email` varchar(50) DEFAULT NULL,
   `store_id` tinyint unsigned NOT NULL,
   `active` tinyint(1) NOT NULL DEFAULT '1',
   `username` varchar(16) NOT NULL,
   `password` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
   `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`staff_id`),
   KEY `idx_fk_store_id` (`store_id`),
   KEY `idx_fk_address_id` (`address_id`),
   CONSTRAINT `fk_staff_address` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
   CONSTRAINT `fk_staff_store` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`) ON DELETE RESTRICT ON UPDATE CASCADE
 ) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci*/

SELECT * FROM address;
SELECT *FROM store;
INSERT INTO staff (first_name, last_name, address_id, email, store_id, active, username, password)
VALUES ('Tamy', 'Sanders', 1, 'tammy.sanders@sakilastaff.com', 1, 1, 'tammys', 'password');
SELECT * FROM staff;

/* 3. Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. 
You can use current date for the rental_date column in the rental table. 
Hint: Check the columns in the table rental and see what information you would need to add there. 
You can query those pieces of information. For eg., you would notice that you need customer_id information 
as well.*/
SELECT * FROM rental;
SELECT customer_id 
FROM customer 
WHERE first_name = 'Charlotte' AND last_name = 'Hunter'; #customer_id = 130

SELECT * FROM inventory;
SELECT inventory_id 
FROM inventory 
WHERE film_id = (
	SELECT film_id 
    FROM film 
    WHERE title = 'Academy Dinosaur') AND store_id = 1;
#Existen 4 películas con diferente inventory_id, del film_id = 1 y que tienen un store_id = 1.

SELECT * FROM staff;
SELECT staff_id
FROM staff
WHERE first_name = 'Mike' AND last_name = 'Hillyer'; #staff_id = 1

SHOW CREATE TABLE rental;
SELECT * FROM rental;
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
VALUES (CURDATE(), 1, 130, NULL, 1, NOW());

SELECT *
FROM rental
WHERE inventory_id = 1;

/*4. Delete non-active users, but first, create a backup table deleted_users to store customer_id, 
email, and the date for the users that would be deleted. Follow these steps:
	Check if there are any non-active users
	Create a table backup table as suggested
	Insert the non active users in the table backup table
	Delete the non active users from the table customer*/
SELECT * FROM customer;
SELECT * 
FROM customer
WHERE `active` = 0;

SHOW CREATE TABLE customer;

DROP TABLE IF EXISTS deleted_users;
CREATE TABLE deleted_users (
	`customer_id` smallint unsigned NOT NULL,
    `store_id` tinyint unsigned NOT NULL,
    `first_name` varchar(45) NOT NULL,
    `last_name` varchar(45) NOT NULL,
    `email` varchar(50) DEFAULT NULL,
    `address_id` smallint unsigned NOT NULL,
    `active` tinyint(1) NOT NULL,
    `create_date` varchar(50) NOT NULL,
    `last_update` varchar(50) NOT NULL,
    PRIMARY KEY (`customer_id`),
    KEY `idx_fk_store_id` (`store_id`),
    KEY `idx_fk_address_id` (`address_id`),
    KEY `idx_last_name` (`last_name`),
    CONSTRAINT `fk_delated_customer_address` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `fk_delated_customer_store` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`) ON DELETE RESTRICT ON UPDATE CASCADE
 ) ENGINE=InnoDB AUTO_INCREMENT=600 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO deleted_users (customer_id, store_id, first_name, last_name, email, address_id, `active`, 
create_date, last_update)
SELECT customer_id, store_id, first_name, last_name, email, address_id, `active`,
create_date, last_update
FROM customer
WHERE `active` = 0;

SELECT * FROM deleted_users;

# NOTAS:
/* SMALLINT: tipo de dato en SQL que permite almacenar valores enteros con un tamaño de 2 bytes, 
es decir, valores en un rango de 0 a 65,535.

UNSIGNED: se utiliza para indicar que los valores almacenados en la columna no pueden ser negativos, 
lo que significa que se utiliza el rango completo de 0 a 65,535 para almacenar los valores. 
Si no se especifica UNSIGNED, se pueden almacenar valores enteros en el rango de -32,768 a 32,767.

TINYINT UNSIGNED: tipo de dato numérico en SQL que puede almacenar valores enteros pequeños sin signo, 
es decir, sólo número positivos. Puede almacenar números enteros que van desde 0 hasta 255. 
El tamaño de almacenamiento de este tipo de datos es de 1 byte. 
Si no se usa la palabra clave UNSIGNED, se puede almacenar números enteros con signo en la columna, 
y el rango sería de -128 a 127.

