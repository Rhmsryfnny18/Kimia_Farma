-- Struktur Tabel Kantor Cabang
CREATE OR REPLACE TABLE `rakaminkfanalytics-459512.kimia_farma.branch_data` (
  branch_id INT64,
  branch_category STRING,
  branch_name STRING,
  kota STRING,
  provinsi STRING,
  rating FLOAT64
);

-- QUERRY ANALISIS
-- Statistik Dasar
SELECT
  COUNT(*) AS total_branches,
  AVG(rating) AS average_rating,
  MIN(rating) AS min_rating,
  MAX(rating) AS max_rating,
  STDDEV(rating) AS rating_stddev
FROM `rakaminkfanalytics-459512.kimia_farma.branch_data`;

-- Distribusi Rating berdasarkan Kategori Cabang
SELECT
  branch_category,
  COUNT(*) AS branch_count,
  AVG(rating) AS avg_rating,
  MIN(rating) AS min_rating,
  MAX(rating) AS max_rating
FROM `rakaminkfanalytics-459512.kimia_farma.branch_data`
GROUP BY branch_category
ORDER BY avg_rating DESC;

-- Provinsi dengan Performa Terbaik
SELECT
  provinsi,
  COUNT(*) AS branch_count,
  AVG(rating) AS avg_rating
FROM `rakaminkfanalytics-459512.kimia_farma.branch_data`
GROUP BY provinsi
ORDER BY avg_rating DESC
LIMIT 10;

-- Jumlah Cabang per Kota
SELECT
  kota,
  COUNT(*) AS branch_count
FROM `rakaminkfanalytics-459512.kimia_farma.branch_data`
GROUP BY kota
ORDER BY branch_count DESC;

-- Analisis Distribusi Rating
SELECT
  CASE
    WHEN rating >= 4.5 THEN 'Excellent (4.5-5.0)'
    WHEN rating >= 4.0 THEN 'Good (4.0-4.49)'
    WHEN rating >= 3.5 THEN 'Average (3.5-3.99)'
    ELSE 'Needs Improvement (<3.5)'
  END AS rating_category,
  COUNT(*) AS branch_count,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM `rakaminkfanalytics-459512.kimia_farma.branch_data`), 2) AS percentage
FROM `rakaminkfanalytics-459512.kimia_farma.branch_data`
GROUP BY rating_category
ORDER BY rating_category;