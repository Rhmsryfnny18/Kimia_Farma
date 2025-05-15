-- Membuat Tabel Analisa
CREATE OR REPLACE TABLE `rakaminkfanalytics-459512.kimia_farma.analisa_transaksi` AS
SELECT
  *,
  
  -- Persentase Laba Sesuai Ketentuan
  CASE 
    WHEN price <= 50000 THEN 0.10
    WHEN price > 50000 AND price <= 100000 THEN 0.15
    WHEN price > 100000 AND price <= 300000 THEN 0.20
    WHEN price > 300000 AND price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,

  -- Nett Sales = total_price - discount
  (price - discount_percentage) AS nett_sales,

  -- Nett Profit = nett_sales * persentase laba
  ((price - discount_percentage) *
    CASE 
      WHEN price <= 50000 THEN 0.10
      WHEN price > 50000 AND price <= 100000 THEN 0.15
      WHEN price > 100000 AND price <= 300000 THEN 0.20
      WHEN price > 300000 AND price <= 500000 THEN 0.25
      ELSE 0.30
    END
  ) AS nett_profit,

  -- Rating transaksi (jika tidak tersedia, set NULL atau buat dummy)
  NULL AS rating_transaksi

FROM `rakaminkfanalytics-459512.kimia_farma.kf_final_transaction`;

-- Melihat Struktur Kolom dan Data
SELECT 
  column_name, 
  data_type
FROM `rakaminkfanalytics-459512.kimia_farma.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'kf_final_transaction';

-- 10 Cabang dengan Penjualan Tertinggi
SELECT 
  branch_id,
  customer_name,
  SUM(price) AS total_penjualan
FROM `rakaminkfanalytics-459512.kimia_farma.kf_final_transaction`
GROUP BY branch_id,customer_name
ORDER BY total_penjualan DESC
LIMIT 10;
