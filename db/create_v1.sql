-- Магазин обуви. Структура базы данных, пара 10.

CREATE DATABASE IF NOT EXISTS bez_raznici CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE bez_raznici;


CREATE TABLE `categories` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;


CREATE TABLE `manufacturers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;


CREATE TABLE `suppliers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;


CREATE TABLE `roles` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;


CREATE TABLE `users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `full_name` VARCHAR(60) NOT NULL,
  `login` VARCHAR(50) NOT NULL,
  `password` VARCHAR(30) NOT NULL,
  `role_id` INT NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;


CREATE TABLE `pvz` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `postcode` CHAR(6) NOT NULL,
  `city` VARCHAR(30) NOT NULL,
  `street` VARCHAR(30) NOT NULL,
  `house` VARCHAR(5) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;


CREATE TABLE `orderstatus` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;


CREATE TABLE `products` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `article` VARCHAR(10) NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `unit` VARCHAR(10) NOT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  `discount` INT NOT NULL,
  `stock_qty` INT NOT NULL,
  `description` VARCHAR(255) NULL,
  `photo` VARCHAR(50) NULL,
  `category_id` INT NOT NULL,
  `manufacturer_id` INT NOT NULL,
  `supplier_id` INT NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;


CREATE TABLE `orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `order_date` DATETIME NOT NULL,
  `delivery_date` DATETIME NULL,
  `pvz_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `receive_code` VARCHAR(10) NOT NULL,
  `status_id` INT NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;


CREATE TABLE `prodorders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `qty` INT NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

ALTER TABLE `users` ADD CONSTRAINT `fk_users_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `products` ADD CONSTRAINT `fk_products_category_id` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `products` ADD CONSTRAINT `fk_products_manufacturer_id` FOREIGN KEY (`manufacturer_id`) REFERENCES `manufacturers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `products` ADD CONSTRAINT `fk_products_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `orders` ADD CONSTRAINT `fk_orders_pvz_id` FOREIGN KEY (`pvz_id`) REFERENCES `pvz` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `orders` ADD CONSTRAINT `fk_orders_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `orders` ADD CONSTRAINT `fk_orders_status_id` FOREIGN KEY (`status_id`) REFERENCES `orderstatus` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `prodorders` ADD CONSTRAINT `fk_prodorders_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE `prodorders` ADD CONSTRAINT `fk_prodorders_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
