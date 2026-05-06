
CREATE DATABASE IF NOT EXISTS provider_network;
USE provider_network;

DROP TABLE IF EXISTS network_status;
DROP TABLE IF EXISTS providers;
DROP TABLE IF EXISTS payors;

CREATE TABLE providers (
    provider_id INT PRIMARY KEY,
    provider_name VARCHAR(100),
    specialty VARCHAR(50),
    city VARCHAR(50)
);


CREATE TABLE payors (
    payor_id INT PRIMARY KEY,
    payor_name VARCHAR(100)
);


CREATE TABLE network_status (
    provider_id INT,
    payor_id INT,
    status VARCHAR(20),
    FOREIGN KEY (provider_id) REFERENCES providers(provider_id),
    FOREIGN KEY (payor_id) REFERENCES payors(payor_id)
);


INSERT INTO providers VALUES
(101, "John Smith", "Cardiology", "New York"),
(102, "Emily Johnson", "Dermatology", "Los Angeles"),
(103, "Michael Brown", "Orthopedics", "Chicago"),
(104, "Sarah Davis", "Pediatrics", "Houston"),
(105, "David Wilson", "Neurology", "Phoenix");


INSERT INTO payors VALUES
(201, "UnitedHealthcare"),
(202, "Aetna"),
(203, "Cigna"),
(204, "Humana"),
(205, "Kaiser Permanente");


INSERT INTO network_status VALUES
(101, 201, 'IN-NETWORK'),
(102, 202, 'OUT-OF-NETWORK'),
(103, 203, 'IN-NETWORK'),
(104, 204, 'IN-NETWORK'),
(105, 205, 'OUT-OF-NETWORK');


SELECT p.provider_name, pa.payor_name, n.status
FROM network_status n
JOIN providers p ON n.provider_id = p.provider_id
JOIN payors pa ON n.payor_id = pa.payor_id
WHERE n.status = 'IN-NETWORK';


SELECT p.provider_name, pa.payor_name, n.status
FROM network_status n
JOIN providers p ON n.provider_id = p.provider_id
JOIN payors pa ON n.payor_id = pa.payor_id
WHERE n.status = 'OUT-OF-NETWORK';


SELECT pa.payor_name,
       COUNT(CASE WHEN n.status='IN-NETWORK' THEN 1 END) AS in_network,
       COUNT(CASE WHEN n.status='OUT-OF-NETWORK' THEN 1 END) AS out_network
FROM network_status n
JOIN payors pa ON n.payor_id = pa.payor_id
GROUP BY pa.payor_name;


SELECT p.provider_name,
       GROUP_CONCAT(pa.payor_name) AS insurance_network
FROM network_status n
JOIN providers p ON n.provider_id = p.provider_id
JOIN payors pa ON n.payor_id = pa.payor_id
GROUP BY p.provider_name;