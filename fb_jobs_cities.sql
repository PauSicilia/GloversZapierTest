SELECT name, code, country_code, p.delivery_postal_code FROM geography
LEFT JOIN (
SELECT
postal_codes.city_code,
postal_codes.delivery_postal_code
FROM
    (SELECT orders.city_code,
    orders.delivery_postal_code,
    ROW_NUMBER() OVER (PARTITION BY orders.city_code ORDER BY orders.city_code, orders.delivery_postal_code) as rank
    FROM orders
    WHERE orders.delivery_postal_code NOTNULL
    GROUP BY 1,2) postal_codes
WHERE rank=1
) p
ON geography.code = p.city_code
WHERE ENABLED IS TRUE
AND hidden IS FALSE
AND p.delivery_postal_code IS NOT NULL
ORDER BY 3, 1;