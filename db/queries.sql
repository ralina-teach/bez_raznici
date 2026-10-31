-- Запросы для приложения. Пара 11.
-- Выполняются после create_v1.sql и data.sql, в схеме bez_raznici.
-- ? - позиционные параметры будущих команд C#. Передаются отдельно от SQL.
-- В Workbench запросы с ? проверяются через PREPARE / EXECUTE ... USING.
USE bez_raznici;

-- Вход: пункты 2.5, 2.6, 3.17. Параметры: логин, пароль.
SELECT u.id, u.full_name, r.name AS role
FROM users u
JOIN roles r ON r.id = u.role_id
WHERE u.login = ? AND u.password = ?;

-- Каталог для всех ролей: пункты 2.7-2.11. Без дополнительных условий.
SELECT p.id, p.article, p.name, p.unit, p.price, p.discount, p.stock_qty,
       p.description, p.photo,
       c.name AS category, m.name AS manufacturer, s.name AS supplier
FROM products p
JOIN categories c ON c.id = p.category_id
JOIN manufacturers m ON m.id = p.manufacturer_id
JOIN suppliers s ON s.id = p.supplier_id;

-- Поиск, поставщик, сортировка по остатку: пункты 3.1-3.6.
-- Доступно менеджеру и администратору.
-- Параметры: строка поиска, ID поставщика (NULL - все), направление (asc / desc).
-- Пустая строка поиска оставляет все товары. Все три условия работают вместе.
SELECT p.id, p.article, p.name, p.unit, p.price, p.discount, p.stock_qty,
       p.description, p.photo,
       c.name AS category, m.name AS manufacturer, s.name AS supplier
FROM products p
JOIN categories c ON c.id = p.category_id
JOIN manufacturers m ON m.id = p.manufacturer_id
JOIN suppliers s ON s.id = p.supplier_id
WHERE CONCAT_WS(' ', p.article, p.name, p.unit, p.description,
                c.name, m.name, s.name) LIKE CONCAT('%', ?, '%')
  AND (? IS NULL OR p.supplier_id = ?)
ORDER BY CASE WHEN ? = 'asc' THEN p.stock_qty END ASC,
         CASE WHEN ? = 'desc' THEN p.stock_qty END DESC,
         p.id;
-- Для позиционных параметров передать 5 значений:
-- поиск, поставщик, поставщик, направление, направление.
-- Направление выбирается из двух вариантов в интерфейсе; в SQL оно не вставляется строковой склейкой.

-- Справочники формы товара: пункты 3.7, 3.10.
SELECT id, name FROM categories ORDER BY name;
SELECT id, name FROM manufacturers ORDER BY name;
SELECT id, name FROM suppliers ORDER BY name;

-- Добавление товара, только администратор: пункты 3.7, 3.12, 3.19.
-- Цена и остаток неотрицательны, скидка от 0 до 100; это проверяется в форме.
INSERT INTO products
  (article, name, unit, price, discount, stock_qty, description, photo,
   category_id, manufacturer_id, supplier_id)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);

-- Открыть товар для редактирования: пункт 3.10. Параметр: ID товара.
SELECT id, article, name, unit, price, discount, stock_qty, description, photo,
       category_id, manufacturer_id, supplier_id
FROM products WHERE id = ?;

-- Сохранение и путь к фото: пункты 3.8-3.12, 3.19.
-- Порядок параметров совпадает с полями; ID товара передаётся последним.
UPDATE products
SET article = ?, name = ?, unit = ?, price = ?, discount = ?, stock_qty = ?,
    description = ?, photo = ?, category_id = ?, manufacturer_id = ?, supplier_id = ?
WHERE id = ?;

-- Проверка перед удалением: пункт 3.16. Параметр: ID товара.
SELECT COUNT(*) AS used_in_orders FROM prodorders WHERE product_id = ?;

-- Удаление, только администратор: пункты 3.14-3.16.
-- Выполняется после проверки и подтверждения пользователя.
-- Внешний ключ prodorders.product_id дополнительно запрещает удаление купленного товара.
DELETE FROM products WHERE id = ?;
