-- Create Table
CREATE TABLE `rakaminkfanalytics-459512.kimia_farma.analisa_penjualan` (
  product_id STRING,
  product_name STRING,
  harga FLOAT64,
  diskon FLOAT64,
  nett_sales FLOAT64,
  persentase_gross_laba FLOAT64,
  nett_profit FLOAT64,
  rating_transaksi FLOAT64
);

-- Query untuk Menghitung Kolom Turunan
SELECT
  product_id,
  product_name,
  harga,
  diskon,
  harga * (1 - diskon) AS nett_sales,
  CASE
    WHEN harga <= 50000 THEN 0.10
    WHEN harga <= 100000 THEN 0.15
    WHEN harga <= 300000 THEN 0.20
    WHEN harga <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,
  (harga * (1 - diskon)) * 
    CASE
      WHEN harga <= 50000 THEN 0.10
      WHEN harga <= 100000 THEN 0.15
      WHEN harga <= 300000 THEN 0.20
      WHEN harga <= 500000 THEN 0.25
      ELSE 0.30
    END AS nett_profit,
  rating_transaksi
FROM
  `rakaminkfanalytics-459512.kimia_farma.penjualan_produk`;
