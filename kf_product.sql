-- Analisis Data Produk Farmasi
-- Membuat dataset 
CREATE SCHEMA IF NOT EXISTS `rakaminkfanalytics-459512.kimia_farma`;

-- Membuat tabel analisis
CREATE OR REPLACE TABLE `rakaminkfanalytics-459512.kimia_farma.analisis_produk` AS

WITH data_produk AS (
  SELECT
    product_id,
    product_name,
    -- Ekstrak kategori utama produk dari product_name
    CASE
      WHEN REGEXP_CONTAINS(product_name, r'Anti-inflammatory and antirheumatic') THEN 'Anti-inflamasi'
      WHEN REGEXP_CONTAINS(product_name, r'Other analgesics and antipyretics') THEN 'Analgesik/Antipiretik'
      WHEN REGEXP_CONTAINS(product_name, r'Psycholeptics drugs') THEN 
        CASE
          WHEN REGEXP_CONTAINS(product_name, r'Anxiolytic') THEN 'Psikoleptik - Anxiolitik'
          WHEN REGEXP_CONTAINS(product_name, r'Hypnotics and sedatives') THEN 'Psikoleptik - Hipnotik/Sedatif'
          ELSE 'Psikoleptik - Lainnya'
        END
      WHEN REGEXP_CONTAINS(product_name, r'Drugs for obstructive airway') THEN 'Obat Saluran Napas'
      WHEN REGEXP_CONTAINS(product_name, r'Antihistamines') THEN 'Antihistamin'
      ELSE 'Lainnya'
    END AS kategori_produk_utama,
    
    -- Ekstrak subkategori dari product_name
    CASE
      WHEN REGEXP_CONTAINS(product_name, r'Propionic acid derivatives') THEN 'Asam Propionat'
      WHEN REGEXP_CONTAINS(product_name, r'Acetic acid derivatives') THEN 'Asam Asetat'
      WHEN REGEXP_CONTAINS(product_name, r'Salicylic acid') THEN 'Asam Salisilat'
      WHEN REGEXP_CONTAINS(product_name, r'Pyrazolones and Anilides') THEN 'Pirazolon/Anilida'
      ELSE NULL
    END AS subkategori_produk,
    
    product_category,
    price
  FROM `rakaminkfanalytics-459512.kimia_farma.kf_product`
)

SELECT
  kategori_produk_utama,
  subkategori_produk,
  product_category,
  COUNT(DISTINCT product_id) AS jumlah_produk,
  COUNT(DISTINCT product_name) AS nama_produk_unik,
  ROUND(AVG(price), 2) AS harga_rata_rata,
  ROUND(MIN(price), 2) AS harga_minimum,
  ROUND(MAX(price), 2) AS harga_maksimum,
  ROUND(SUM(price), 2) AS total_nilai,
  ROUND(STDDEV(price), 2) AS deviasi_harga
FROM data_produk
GROUP BY kategori_produk_utama, subkategori_produk, product_category
ORDER BY total_nilai DESC;

-- Produk Teratas Berdasarkan Nilai
CREATE OR REPLACE TABLE `rakaminkfanalytics-459512.kimia_farma.produk_teratas` AS

SELECT
  product_id,
  product_name,
  product_category,
  price,
  ROUND(price / SUM(price) OVER(), 4) * 100 AS persen_dari_total_nilai
FROM `rakaminkfanalytics-459512.kimia_farma.kf_product`
ORDER BY price DESC
LIMIT 20;

-- Distribusi Harga Berdasarkan Kategori Produk
CREATE OR REPLACE TABLE `rakaminkfanalytics-459512.kimia_farma.distribusi_harga` AS

SELECT
  product_category,
  COUNT(*) AS jumlah_produk,
  ROUND(AVG(price), 2) AS harga_rata_rata,
  ROUND(APPROX_QUANTILES(price, 100)[OFFSET(50)], 2) AS harga_median,
  ROUND(MIN(price), 2) AS harga_minimum,
  ROUND(MAX(price), 2) AS harga_maksimum,
  ROUND(STDDEV(price), 2) AS deviasi_harga
FROM `rakaminkfanalytics-459512.kimia_farma.kf_product`
GROUP BY product_category
ORDER BY harga_rata_rata DESC;