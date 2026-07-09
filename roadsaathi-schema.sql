CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    vehicle_type VARCHAR(10) NOT NULL CHECK (vehicle_type IN ('2W', '4W', 'EV_2W', 'EV_4W')),
    make VARCHAR(50),
    model VARCHAR(50),
    registration_number VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE services (
    service_id SERIAL PRIMARY KEY,
    service_name VARCHAR(50) UNIQUE NOT NULL,
    base_price NUMERIC(8,2) NOT NULL
);

CREATE TABLE providers (
    provider_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    rating NUMERIC(2,1) DEFAULT 5.0 CHECK (rating BETWEEN 0 AND 5),
    is_verified BOOLEAN DEFAULT FALSE,
    is_online BOOLEAN DEFAULT FALSE,
    current_location GEOGRAPHY(Point, 4326),
    last_location_update TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE provider_services (
    provider_id INT REFERENCES providers(provider_id) ON DELETE CASCADE,
    service_id INT REFERENCES services(service_id) ON DELETE CASCADE,
    handles_vehicle_type VARCHAR(10) NOT NULL CHECK (handles_vehicle_type IN ('2W', '4W', 'EV_2W', 'EV_4W', 'ALL')),
    PRIMARY KEY (provider_id, service_id, handles_vehicle_type)
);

CREATE TABLE jobs (
    job_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    vehicle_id INT REFERENCES vehicles(vehicle_id),
    service_id INT REFERENCES services(service_id),
    provider_id INT REFERENCES providers(provider_id),
    job_location GEOGRAPHY(Point, 4326) NOT NULL,
    status VARCHAR(20) DEFAULT 'requested' CHECK (status IN ('requested', 'assigned', 'en_route', 'in_progress', 'completed', 'cancelled')),
    quoted_price NUMERIC(8,2),
    requested_at TIMESTAMP DEFAULT NOW(),
    completed_at TIMESTAMP
);

CREATE INDEX idx_providers_location ON providers USING GIST (current_location);
CREATE INDEX idx_jobs_location ON jobs USING GIST (job_location);

INSERT INTO services (service_name, base_price) VALUES
    ('Jump Start', 149.00),
    ('Flat Tyre', 199.00),
    ('Fuel Delivery', 99.00),
    ('Towing', 499.00),
    ('EV Charging', 249.00),
    ('Lockout', 179.00);

INSERT INTO providers (full_name, phone_number, rating, is_verified, is_online, current_location, last_location_update) VALUES
    ('Ravi Kumar', '9900011111', 4.8, TRUE, TRUE, ST_GeogFromText('POINT(77.7500 12.9700)'), NOW()),
    ('Suresh Patil', '9900022222', 4.5, TRUE, TRUE, ST_GeogFromText('POINT(77.7600 12.9750)'), NOW()),
    ('Manoj EV Care', '9900033333', 4.9, TRUE, TRUE, ST_GeogFromText('POINT(77.7550 12.9800)'), NOW()),
    ('Anil Towing', '9900044444', 4.2, TRUE, FALSE, ST_GeogFromText('POINT(77.7400 12.9650)'), NOW());

INSERT INTO provider_services (provider_id, service_id, handles_vehicle_type) VALUES
    (1, 1, '2W'), (1, 2, '2W'),
    (2, 1, 'ALL'), (2, 3, 'ALL'),
    (3, 5, 'EV_2W'), (3, 5, 'EV_4W'), (3, 1, 'EV_2W'),
    (4, 4, 'ALL');

CREATE OR REPLACE FUNCTION find_best_provider(
    p_service_id INT,
    p_vehicle_type VARCHAR,
    p_job_location GEOGRAPHY,
    p_radius_km NUMERIC DEFAULT 5
)
RETURNS TABLE (
    provider_id INT,
    full_name VARCHAR,
    rating NUMERIC,
    distance_km NUMERIC
) AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM providers p
        JOIN provider_services ps ON ps.provider_id = p.provider_id
        WHERE ps.service_id = p_service_id
          AND (ps.handles_vehicle_type = p_vehicle_type OR ps.handles_vehicle_type = 'ALL')
          AND p.is_online = TRUE
          AND p.is_verified = TRUE
          AND ST_DWithin(p.current_location, p_job_location, p_radius_km * 1000)
          AND NOT EXISTS (
              SELECT 1 FROM jobs j
              WHERE j.provider_id = p.provider_id
                AND j.status IN ('assigned', 'en_route', 'in_progress')
          )
    ) THEN
        RAISE EXCEPTION 'No available provider found for service_id % within % km', p_service_id, p_radius_km;
    END IF;

    RETURN QUERY
    SELECT
        p.provider_id,
        p.full_name,
        p.rating,
        ROUND((ST_Distance(p.current_location, p_job_location) / 1000)::NUMERIC, 2) AS distance_km
    FROM providers p
    JOIN provider_services ps ON ps.provider_id = p.provider_id
    WHERE ps.service_id = p_service_id
      AND (ps.handles_vehicle_type = p_vehicle_type OR ps.handles_vehicle_type = 'ALL')
      AND p.is_online = TRUE
      AND p.is_verified = TRUE
      AND ST_DWithin(p.current_location, p_job_location, p_radius_km * 1000)
      AND NOT EXISTS (
          SELECT 1 FROM jobs j
          WHERE j.provider_id = p.provider_id
            AND j.status IN ('assigned', 'en_route', 'in_progress')
      )
    ORDER BY p.rating DESC, distance_km ASC
    LIMIT 5;
END;
$$ LANGUAGE plpgsql;

-- Sample calls to demo in your portfolio / interviews:

-- Case 1: Jump start for a 2-wheeler near Whitefield, Bengaluru (should return Ravi and Suresh)
-- SELECT * FROM find_best_provider(1, '2W', ST_GeogFromText('POINT(77.7520 12.9720)'), 5);

-- Case 2: EV charging for an EV 2-wheeler (should return Manoj)
-- SELECT * FROM find_best_provider(5, 'EV_2W', ST_GeogFromText('POINT(77.7520 12.9720)'), 5);

-- Case 3: Towing far outside any provider's radius (should RAISE EXCEPTION)
-- SELECT * FROM find_best_provider(4, '4W', ST_GeogFromText('POINT(78.5000 13.5000)'), 5);
