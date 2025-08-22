-- This script provides a series of intelligent MySQL queries designed to uncover actionable insights
-- from a comprehensive cryptocurrency and traditional market dataset.
-- Note on table names: Using 'bitcoin1' and 'merged' as provided.

-- BLOCK 1: FOUNDATIONAL CRYPTOCURRENCY PERFORMANCE & VOLUME.


-- Query 1: Daily Average Trading Range for Major Cryptocurrencies
-- Question: What is the average daily trading range (high minus low) for each of the listed cryptocurrencies (BNB, BTC, DOGE, ETH, SOL, XRP)?
SELECT
    DATE(timestamp) AS day,
    AVG(BNB_USDT_1h_high - BNB_USDT_1h_low) AS avg_bnb_range,
    AVG(BTC_USDT_1h_high - BTC_USDT_1h_low) AS avg_btc_range,
    AVG(DOGE_USDT_1h_high - DOGE_USDT_1h_low) AS avg_doge_range,
    AVG(ETH_USDT_1h_high - ETH_USDT_1h_low) AS avg_eth_range,
    AVG(SOL_USDT_1h_high - SOL_USDT_1h_low) AS avg_sol_range,
    AVG(XRP_USDT_1h_high - XRP_USDT_1h_low) AS avg_xrp_range
FROM
    bitcoin1
GROUP BY
    DATE(timestamp)
ORDER BY
    day;


-- Query 2: Cryptocurrency with the Lowest Total Trading Volume (Overall)
-- Question: Across the entire dataset, which cryptocurrency had the lowest total trading volume?
SELECT
    CASE
        WHEN SUM(BNB_USDT_1h_volume) < SUM(BTC_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) < SUM(DOGE_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) < SUM(ETH_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) < SUM(SOL_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) < SUM(XRP_USDT_1h_volume) THEN 'BNB'
        WHEN SUM(BTC_USDT_1h_volume) < SUM(DOGE_USDT_1h_volume) AND SUM(BTC_USDT_1h_volume) < SUM(ETH_USDT_1h_volume) AND SUM(BTC_USDT_1h_volume) < SUM(SOL_USDT_1h_volume) AND SUM(BTC_USDT_1h_volume) < SUM(XRP_USDT_1h_volume) THEN 'BTC'
        WHEN SUM(DOGE_USDT_1h_volume) < SUM(ETH_USDT_1h_volume) AND SUM(DOGE_USDT_1h_volume) < SUM(SOL_USDT_1h_volume) AND SUM(DOGE_USDT_1h_volume) < SUM(XRP_USDT_1h_volume) THEN 'DOGE'
        WHEN SUM(ETH_USDT_1h_volume) < SUM(SOL_USDT_1h_volume) AND SUM(ETH_USDT_1h_volume) < SUM(XRP_USDT_1h_volume) THEN 'ETH'
        WHEN SUM(SOL_USDT_1h_volume) < SUM(XRP_USDT_1h_volume) THEN 'SOL'
        ELSE 'XRP'
    END AS lowest_volume_coin
FROM
    bitcoin1;


-- Query 3: Cryptocurrency with the Highest Average Hourly Volume on Weekends
-- Question: Which cryptocurrency (among BNB, BTC, DOGE, ETH, SOL, XRP) typically sees the highest average hourly trading volume on weekends (Saturday and Sunday)?
SELECT
    CASE
        WHEN DAYOFWEEK(timestamp) IN (1,7) THEN 'Weekend' -- 1=Sunday, 7=Saturday
        ELSE 'Weekday'
    END AS day_type,
    CASE
        WHEN AVG(BNB_USDT_1h_volume) = (SELECT MAX(v) FROM (SELECT AVG(BNB_USDT_1h_volume) AS v FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(BTC_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(DOGE_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(ETH_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(SOL_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(XRP_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7)) AS sub) THEN 'BNB'
        WHEN AVG(BTC_USDT_1h_volume) = (SELECT MAX(v) FROM (SELECT AVG(BNB_USDT_1h_volume) AS v FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(BTC_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(DOGE_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(ETH_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(SOL_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(XRP_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7)) AS sub) THEN 'BTC'
        WHEN AVG(DOGE_USDT_1h_volume) = (SELECT MAX(v) FROM (SELECT AVG(BNB_USDT_1h_volume) AS v FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(BTC_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(DOGE_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(ETH_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(SOL_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(XRP_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7)) AS sub) THEN 'DOGE'
        WHEN AVG(ETH_USDT_1h_volume) = (SELECT MAX(v) FROM (SELECT AVG(BNB_USDT_1h_volume) AS v FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(BTC_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(DOGE_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(ETH_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(SOL_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(XRP_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7)) AS sub) THEN 'ETH'
        WHEN AVG(SOL_USDT_1h_volume) = (SELECT MAX(v) FROM (SELECT AVG(BNB_USDT_1h_volume) AS v FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(BTC_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(DOGE_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(ETH_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(SOL_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7) UNION ALL SELECT AVG(XRP_USDT_1h_volume) FROM bitcoin1 WHERE DAYOFWEEK(timestamp) IN (1,7)) AS sub) THEN 'SOL'
        ELSE 'XRP'
    END AS highest_avg_volume_coin,
    GREATEST(AVG(BNB_USDT_1h_volume), AVG(BTC_USDT_1h_volume), AVG(DOGE_USDT_1h_volume), AVG(ETH_USDT_1h_volume), AVG(SOL_USDT_1h_volume), AVG(XRP_USDT_1h_volume)) AS average_volume
FROM
    bitcoin1
WHERE
    DAYOFWEEK(timestamp) IN (1, 7) -- 1 for Sunday, 7 for Saturday
GROUP BY
    day_type;

-- Query 4: Hourly Average Trading Volume for All Cryptocurrencies
-- Question: Which hour of the day (UTC) typically sees the highest average trading volume across all listed cryptocurrencies?
SELECT
    HOUR(timestamp) AS hour_of_day_utc,
    AVG(BNB_USDT_1h_volume + BTC_USDT_1h_volume + DOGE_USDT_1h_volume + ETH_USDT_1h_volume + SOL_USDT_1h_volume + XRP_USDT_1h_volume) AS avg_total_crypto_volume
FROM
    bitcoin1
GROUP BY
    hour_of_day_utc
ORDER BY
    avg_total_crypto_volume DESC
LIMIT 5;


-- BLOCK 2: TIME-BASED TREND AND PATTERNS
 
-- Query 5: Weekly Average Closing Price for Bitcoin
-- Question: What was the average weekly closing price for Bitcoin, providing a smoothed trend view?
SELECT
    YEARWEEK(timestamp, 1) AS year_week, -- 1 means week starts on Monday
    AVG(BTC_USDT_1h_close) AS avg_btc_weekly_close
FROM
    bitcoin1
GROUP BY
    year_week
ORDER BY
    year_week;


-- Query 6: Day of the Week with Highest Average Bitcoin Volume
-- Question: On which day of the week does Bitcoin typically experience its highest average trading volume?
SELECT
    DAYNAME(timestamp) AS day_of_week,
    AVG(BTC_USDT_1h_volume) AS avg_btc_volume
FROM
    bitcoin1
GROUP BY
    day_of_week
ORDER BY
    avg_btc_volume DESC
LIMIT 3;



-- BLOCK 3: SENTIMENT AND CRYPTOCURRENCY MARKET DYNAMICS

-- Query 7: Cryptocurrency with Lowest Total Trading Volume During High Greed
-- Question: What is the cryptocurrency with the lowest total trading volume during periods of high greed (fear_greed_index > 75)?
SELECT
    CASE
        WHEN SUM(BNB_USDT_1h_volume) < SUM(BTC_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) < SUM(DOGE_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) < SUM(ETH_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) < SUM(SOL_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) < SUM(XRP_USDT_1h_volume) THEN 'BNB'
        WHEN SUM(BTC_USDT_1h_volume) < SUM(DOGE_USDT_1h_volume) AND SUM(BTC_USDT_1h_volume) < SUM(ETH_USDT_1h_volume) AND SUM(BTC_USDT_1h_volume) < SUM(SOL_USDT_1h_volume) AND SUM(BTC_USDT_1h_volume) < SUM(XRP_USDT_1h_volume) THEN 'BTC'
        WHEN SUM(DOGE_USDT_1h_volume) < SUM(ETH_USDT_1h_volume) AND SUM(DOGE_USDT_1h_volume) < SUM(SOL_USDT_1h_volume) AND SUM(DOGE_USDT_1h_volume) < SUM(XRP_USDT_1h_volume) THEN 'DOGE'
        WHEN SUM(ETH_USDT_1h_volume) < SUM(SOL_USDT_1h_volume) AND SUM(ETH_USDT_1h_volume) < SUM(XRP_USDT_1h_volume) THEN 'ETH'
        WHEN SUM(SOL_USDT_1h_volume) < SUM(XRP_USDT_1h_volume) THEN 'SOL'
        ELSE 'XRP'
    END AS lowest_volume_coin
FROM
    bitcoin1
WHERE
    fear_greed_index > 75;


-- Query 8: Cryptocurrency with Highest Total Trading Volume During High Greed
-- Question: What is the cryptocurrency with the highest total trading volume during periods of high greed (fear_greed_index > 75)?
SELECT
    CASE
        WHEN SUM(BNB_USDT_1h_volume) > SUM(BTC_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) > SUM(DOGE_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) > SUM(ETH_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) > SUM(SOL_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) > SUM(XRP_USDT_1h_volume) THEN 'BNB'
        WHEN SUM(BTC_USDT_1h_volume) > SUM(DOGE_USDT_1h_volume) AND SUM(BTC_USDT_1h_volume) > SUM(ETH_USDT_1h_volume) AND SUM(BTC_USDT_1h_volume) > SUM(SOL_USDT_1h_volume) AND SUM(BTC_USDT_1h_volume) > SUM(XRP_USDT_1h_volume) THEN 'BTC'
        WHEN SUM(DOGE_USDT_1h_volume) > SUM(ETH_USDT_1h_volume) AND SUM(DOGE_USDT_1h_volume) > SUM(SOL_USDT_1h_volume) AND SUM(DOGE_USDT_1h_volume) > SUM(XRP_USDT_1h_volume) THEN 'DOGE'
        WHEN SUM(ETH_USDT_1h_volume) > SUM(SOL_USDT_1h_volume) AND SUM(ETH_USDT_1h_volume) > SUM(XRP_USDT_1h_volume) THEN 'ETH'
        WHEN SUM(SOL_USDT_1h_volume) > SUM(XRP_USdt_1h_volume) THEN 'SOL'
        ELSE 'XRP'
    END AS highest_volume_crypto
FROM
    bitcoin1
WHERE
    fear_greed_index > 75;


-- Query 9: Cryptocurrency with Lowest Total Trading Volume During Low Greed
-- Question: What was the cryptocurrency with the lowest total trading volume during periods of low greed (fear_greed_index < 30)?
SELECT
    CASE
        WHEN SUM(BNB_USDT_1h_volume) < SUM(BTC_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) < SUM(DOGE_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) < SUM(ETH_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) < SUM(SOL_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) < SUM(XRP_USDT_1h_volume) THEN 'BNB'
        WHEN SUM(BTC_USDT_1h_volume) < SUM(DOGE_USDT_1h_volume) AND SUM(BTC_USDT_1h_volume) < SUM(ETH_USDT_1h_volume) AND SUM(BTC_USDT_1h_volume) < SUM(SOL_USDT_1h_volume) AND SUM(BTC_USDT_1h_volume) < SUM(XRP_USDT_1h_volume) THEN 'BTC'
        WHEN SUM(DOGE_USDT_1h_volume) < SUM(ETH_USDT_1h_volume) AND SUM(DOGE_USDT_1h_volume) < SUM(SOL_USDT_1h_volume) AND SUM(DOGE_USDT_1h_volume) < SUM(XRP_USDT_1h_volume) THEN 'DOGE'
        WHEN SUM(ETH_USDT_1h_volume) < SUM(SOL_USDT_1h_volume) AND SUM(ETH_USDT_1h_volume) < SUM(XRP_USDT_1h_volume) THEN 'ETH'
        WHEN SUM(SOL_USDT_1h_volume) < SUM(XRP_USDT_1h_volume) THEN 'SOL'
        ELSE 'XRP'
    END AS lowest_volume_crypto
FROM
    bitcoin1
WHERE
    fear_greed_index < 30;


-- Query 10: Cryptocurrency with Highest Total Trading Volume During Low Greed
-- Question: What was the cryptocurrency with the highest total trading volume during periods of low greed (fear_greed_index < 30)?
SELECT
    CASE
        WHEN SUM(BNB_USDT_1h_volume) > SUM(BTC_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) > SUM(DOGE_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) > SUM(ETH_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) > SUM(SOL_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) > SUM(XRP_USDT_1h_volume) THEN 'BNB'
        WHEN SUM(BTC_USDT_1h_volume) > SUM(DOGE_USDT_1h_volume) AND SUM(BTC_USDT_1h_volume) > SUM(ETH_USDT_1h_volume) AND SUM(BTC_USDT_1h_volume) > SUM(SOL_USDT_1h_volume) AND SUM(BTC_USDT_1h_volume) > SUM(XRP_USDT_1h_volume) THEN 'BTC'
        WHEN SUM(DOGE_USDT_1h_volume) > SUM(ETH_USDT_1h_volume) AND SUM(DOGE_USDT_1h_volume) > SUM(SOL_USDT_1h_volume) AND SUM(DOGE_USDT_1h_volume) > SUM(XRP_USDT_1h_volume) THEN 'DOGE'
        WHEN SUM(ETH_USDT_1h_volume) > SUM(SOL_USDT_1h_volume) AND SUM(ETH_USDT_1h_volume) > SUM(XRP_USDT_1h_volume) THEN 'ETH'
        WHEN SUM(SOL_USDT_1h_volume) > SUM(XRP_USDT_1h_volume) THEN 'SOL'
        ELSE 'XRP'
    END AS Highest_volume_crypto
FROM
    bitcoin1
WHERE
    fear_greed_index < 30;


--- Query 11: Top 5 Hours with Highest Bitcoin Trading Volume (Overall)
-- Question: Which 5 specific hours (timestamp) recorded the absolute highest Bitcoin trading volumes across the entire dataset?
SELECT
    timestamp,
    BTC_USDT_1h_volume
FROM
    bitcoin1
ORDER BY
    BTC_USDT_1h_volume DESC
LIMIT 5;


-- Query 12: Highest Average Hourly Trading Volume During Low Greed (Rounded)
-- Question: During periods of low greed (fear and greed index below 30), which cryptocurrency had the highest average hourly trading volume (rounded to 3 decimal places)?
SELECT
    CASE
        WHEN ROUND(SUM(BNB_USDT_1h_volume), 3) > ROUND(SUM(BTC_USDT_1h_volume), 3) AND ROUND(SUM(BNB_USDT_1h_volume), 3) > ROUND(SUM(DOGE_USDT_1h_volume), 3) AND ROUND(SUM(BNB_USDT_1h_volume), 3) > ROUND(SUM(ETH_USDT_1h_volume), 3) AND ROUND(SUM(BNB_USDT_1h_volume), 3) > ROUND(SUM(SOL_USDT_1h_volume), 3) AND ROUND(SUM(BNB_USDT_1h_volume), 3) > ROUND(SUM(XRP_USDT_1h_volume), 3) THEN 'BNB'
        WHEN ROUND(SUM(BTC_USDT_1h_volume), 3) > ROUND(SUM(DOGE_USDT_1h_volume), 3) AND ROUND(SUM(BTC_USDT_1h_volume), 3) > ROUND(SUM(ETH_USDT_1h_volume), 3) AND ROUND(SUM(BTC_USDT_1h_volume), 3) > ROUND(SUM(SOL_USDT_1h_volume), 3) AND ROUND(SUM(BTC_USDT_1h_volume), 3) > ROUND(SUM(XRP_USDT_1h_volume), 3) THEN 'BTC'
        WHEN ROUND(SUM(DOGE_USDT_1h_volume), 3) > ROUND(SUM(ETH_USDT_1h_volume), 3) AND ROUND(SUM(DOGE_USDT_1h_volume), 3) > ROUND(SUM(SOL_USDT_1h_volume), 3) AND ROUND(SUM(DOGE_USDT_1h_volume), 3) > ROUND(SUM(XRP_USDT_1h_volume), 3) THEN 'DOGE'
        WHEN ROUND(SUM(ETH_USDT_1h_volume), 3) > ROUND(SUM(SOL_USDT_1h_volume), 3) AND ROUND(SUM(ETH_USDT_1h_volume), 3) > ROUND(SUM(XRP_USDT_1h_volume), 3) THEN 'ETH'
        WHEN ROUND(SUM(SOL_USDT_1h_volume), 3) > ROUND(SUM(XRP_USDT_1h_volume), 3) THEN 'SOL'
        ELSE 'XRP'
    END AS highest_volume_coin_low_greed,
    ROUND(SUM(BNB_USDT_1h_volume), 3) AS bnb_volume_low_greed,
    ROUND(SUM(BTC_USDT_1h_volume), 3) AS btc_volume_low_greed,
    ROUND(SUM(DOGE_USDT_1h_volume), 3) AS doge_volume_low_greed,
    ROUND(SUM(ETH_USDT_1h_volume), 3) AS eth_volume_low_greed,
    ROUND(SUM(SOL_USDT_1h_volume), 3) AS sol_volume_low_greed,
    ROUND(SUM(XRP_USDT_1h_volume), 3) AS xrp_volume_low_greed
FROM
    bitcoin1
WHERE
    fear_greed_index < 30;

-- Query 13: Daily Highest Volume Cryptocurrency During Low Greed
-- Question: During periods of low market greed (fear and greed index below 30), which cryptocurrency had the highest total trading volume for each day of the week?
SELECT
    DAYOFWEEK(timestamp) AS day_of_week_num,
    DAYNAME(timestamp) AS Day_Of_Week,
    CASE
        WHEN SUM(BNB_USDT_1h_volume) > SUM(BTC_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) > SUM(DOGE_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) > SUM(ETH_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) > SUM(SOL_USDT_1h_volume) AND SUM(BNB_USDT_1h_volume) > SUM(XRP_USDT_1h_volume) THEN 'BNB'
        WHEN SUM(BTC_USDT_1h_volume) > SUM(DOGE_USDT_1h_volume) AND SUM(BTC_USDT_1h_volume) > SUM(ETH_USDT_1h_volume) AND SUM(BTC_USDT_1h_volume) > SUM(SOL_USDT_1h_volume) AND SUM(BTC_USDT_1h_volume) > SUM(XRP_USDT_1h_volume) THEN 'BTC'
        WHEN SUM(DOGE_USDT_1h_volume) > SUM(ETH_USDT_1h_volume) AND SUM(DOGE_USDT_1h_volume) > SUM(SOL_USDT_1h_volume) AND SUM(DOGE_USDT_1h_volume) > SUM(XRP_USDT_1h_volume) THEN 'DOGE'
        WHEN SUM(ETH_USDT_1h_volume) > SUM(SOL_USDT_1h_volume) AND SUM(ETH_USDT_1h_volume) > SUM(XRP_USDT_1h_volume) THEN 'ETH'
        WHEN SUM(SOL_USDT_1h_volume) > SUM(XRP_USDT_1h_volume) THEN 'SOL'
        ELSE 'XRP'
    END AS highest_volume_coin
FROM
    bitcoin1
WHERE
    fear_greed_index < 30
GROUP BY
    DAYOFWEEK(timestamp),
    DAYNAME(timestamp)
ORDER BY
    day_of_week_num;



-- BLOCK 4:

-- Query 14: Google Trends 'Bitcoin' vs. BTC Trading Volume
-- Question: What is the relationship between Google search interest for 'bitcoin' and its hourly trading volume?
SELECT
    b.timestamp,
    b.google_trends_bitcoin,
    b.BTC_USDT_1h_volume
FROM
    bitcoin1 AS b
WHERE
    b.google_trends_bitcoin IS NOT NULL
ORDER BY
    b.timestamp;

-- Query 15: 'Buy Crypto' Google Trends vs. Altcoin Market Cap
-- Question: How does the Google search trend for 'buy crypto' correlate with the total altcoin market capitalization?
SELECT
    b.timestamp,
    b.google_trends_buy_crypto,
    b.altcoin_market_cap
FROM
    bitcoin1 AS b
WHERE
    b.google_trends_buy_crypto IS NOT NULL
ORDER BY
    b.timestamp;


-- Query 16: Correlation between Dow Jones Volume and Bitcoin Volume
-- Question: Is there any observable relationship between the daily trading volume of the Dow Jones Industrial Average and Bitcoin?
SELECT
    DATE(b.timestamp) AS trading_day,
    SUM(b.BTC_USDT_1h_volume) AS total_btc_volume,
    SUM(m.`Dow_Volume ^DJI`) AS total_dow_volume
FROM
    bitcoin1 AS b
JOIN
    merged AS m ON b.timestamp = m.Datetime
GROUP BY
    trading_day
ORDER BY
    trading_day;




-- BLOCK 5: CRYPTOCURRENCY AND COMMODITIES (using JOIN)

-- Query 17: Average Bitcoin Volume During High Crude Oil Volume
-- Question: What is the average Bitcoin trading volume when Crude Oil futures (CL=F) also experience high trading volume?
SELECT
    AVG(b.BTC_USDT_1h_volume) AS avg_btc_volume_high_crude_volume
FROM
    bitcoin1 AS b
JOIN
    merged AS m ON b.timestamp = m.Datetime
WHERE
    m.`crude_Volume CL=F` > (SELECT AVG(`crude_Volume CL=F`) * 1.5 FROM merged WHERE `crude_Volume CL=F` IS NOT NULL); -- Example: 1.5x average volume


-- Query 18: Relationship Between Gold Prices and Bitcoin Prices
-- Question: How do the hourly closing prices of Gold futures (GC=F) and Bitcoin (BTC) move in relation to each other?
SELECT
    b.timestamp,
    b.BTC_USDT_1h_close,
    m.`gold_Close GC=F`
FROM
    bitcoin1 AS b
JOIN
    merged AS m ON b.timestamp = m.Datetime
WHERE
    m.`gold_Close GC=F` IS NOT NULL
ORDER BY
    b.timestamp;

-- Query 19: Daily Average Price of Corn vs. Bitcoin Dominance
-- Question: Is there any noticeable relationship between the daily average price of Corn futures (ZC=F) and Bitcoin's market dominance?
SELECT
    DATE(b.timestamp) AS trading_day,
    AVG(m.`corn_Close ZC=F`) AS avg_corn_close,
    AVG(b.btc_dominance) AS avg_btc_dominance
FROM
    bitcoin1 AS b
JOIN
    merged AS m ON b.timestamp = m.Datetime
WHERE
    m.`corn_Close ZC=F` IS NOT NULL
GROUP BY
    trading_day
ORDER BY
    trading_day;


-- Query 20: Daily Average Bitcoin Google Trends vs. S&P 500 Close
-- Question: What was the daily average Google Trends score for 'bitcoin' alongside the daily average closing price of the S&P 500?
SELECT
    DATE(b.timestamp) AS Trading_day,
    AVG(b.google_trends_bitcoin) AS AVG_bitcoin_trends,
    AVG(m.`S&P_Close ^GSPC`) AS AVG_sp500_close
FROM
    bitcoin1 AS b
JOIN
    merged AS m ON DATE(b.timestamp) = DATE(m.Datetime)
GROUP BY
    Trading_day
ORDER BY
    Trading_day;


-- Query 21: Daily Average Fear & Greed Index vs. Bitcoin Daily Trading Range
-- Question: What was the daily average fear and greed index alongside the average daily trading range of Bitcoin?
SELECT
    DATE(b.timestamp) AS trading_day,
    AVG(b.fear_greed_index) AS avg_fear_greed,
    AVG(b.BTC_USDT_1h_high - b.BTC_USDT_1h_low) AS avg_btc_daily_range
FROM
    bitcoin1 AS b
JOIN
    merged AS m ON DATE(b.timestamp) = DATE(m.Datetime)
GROUP BY
    trading_day
ORDER BY
    trading_day;


-- Query 22: Day of Week with Highest Bitcoin High Volume Instances
-- Question: On which day of the week did the highest number of instances occur where the hourly trading volume of Bitcoin (BTC) exceeded 5000, and what was that count?
SELECT
    DAYNAME(b.timestamp) AS Day_of_week,
    COUNT(*) AS High_volume_count
FROM
    bitcoin1 AS b
JOIN
    merged AS m ON b.timestamp = m.Datetime
WHERE
    b.BTC_USDT_1h_volume > 5000
GROUP BY
    Day_of_week
ORDER BY
    High_volume_count DESC;


-- Query 23: Hours with Positive Funding Rate and High 'Buy Crypto' Google Trends
-- Question: What is the total number of hours where the funding rate of cryptocurrency futures remained positive when the hourly Google Trends score for "buy crypto" was above 70?
SELECT
    COUNT(*) AS Hours_Positive_Funding_High_Search
FROM
    bitcoin1 AS b
JOIN
    merged AS m ON b.timestamp = m.Datetime
WHERE
    m.funding_rate > 0
    AND b.google_trends_buy_crypto > 70;




