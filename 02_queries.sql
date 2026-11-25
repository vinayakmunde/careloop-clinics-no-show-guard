USE noshowguard;

SELECT
    c.clinic_name,
    c.city,
    COUNT(a.appointment_id) AS total_appointments,
    SUM(a.no_show) AS total_no_shows,
    ROUND(
        SUM(a.no_show) * 100.0 / COUNT(a.appointment_id),
        1
    ) AS no_show_rate_pct

FROM clinics c

INNER JOIN appointments a
    ON c.clinic_id = a.clinic_id

GROUP BY
    c.clinic_id,
    c.clinic_name,
    c.city

HAVING COUNT(a.appointment_id) >= 95

ORDER BY no_show_rate_pct DESC;



SELECT
    CASE
        WHEN lead_days BETWEEN 1 AND 7 THEN '1-7 days'
        WHEN lead_days BETWEEN 8 AND 14 THEN '8-14 days'
        WHEN lead_days BETWEEN 15 AND 30 THEN '15-30 days'
        ELSE '31+ days'
    END AS lead_time_group,

    COUNT(*) AS total_appointments,

    SUM(no_show) AS total_no_shows,

    ROUND(
        SUM(no_show) * 100.0 / COUNT(*),
        1
    ) AS no_show_rate_pct

FROM appointments

GROUP BY lead_time_group

ORDER BY MIN(lead_days);




WITH monthly_data AS (

    SELECT
        DATE_FORMAT(appt_date, '%Y-%m') AS month,

        COUNT(*) AS total_appointments,

        SUM(no_show) AS total_no_shows,

        ROUND(
            SUM(no_show) * 100.0 / COUNT(*),
            1
        ) AS no_show_rate

    FROM appointments

    GROUP BY DATE_FORMAT(appt_date, '%Y-%m')

),

previous_month AS (

    SELECT
        month,
        total_appointments,
        total_no_shows,
        no_show_rate,

        LAG(no_show_rate) OVER (
            ORDER BY month
        ) AS previous_rate

    FROM monthly_data

)

SELECT
    month,
    total_appointments,
    total_no_shows,
    no_show_rate,

    ROUND(no_show_rate - previous_rate, 1)
        AS change_from_previous_month

FROM previous_month

ORDER BY month;











WITH clinic_rates AS (

    SELECT
        c.clinic_name,
        c.city,

        COUNT(a.appointment_id) AS total_appointments,

        SUM(a.no_show) AS total_no_shows,

        ROUND(
            SUM(a.no_show) * 100.0 /
            COUNT(a.appointment_id),
            1
        ) AS no_show_rate

    FROM clinics c

    INNER JOIN appointments a
        ON c.clinic_id = a.clinic_id

    GROUP BY
        c.clinic_id,
        c.clinic_name,
        c.city

),


ranked_clinics AS (

    SELECT
        clinic_name,
        city,
        total_appointments,
        total_no_shows,
        no_show_rate,

        RANK() OVER (
            PARTITION BY city
            ORDER BY no_show_rate DESC
        ) AS city_rank

    FROM clinic_rates

)

SELECT
    clinic_name,
    city,
    total_appointments,
    total_no_shows,
    no_show_rate,
    city_rank,

    CASE
        WHEN no_show_rate > 22.02 THEN 'Above Overall'
        ELSE 'Below Overall'
    END AS comparison_with_overall

FROM ranked_clinics

ORDER BY city, city_rank;