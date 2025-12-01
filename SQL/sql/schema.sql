-- schema.sql
-- Logical schema for the delivery centers and operators dataset.

-- Delivery centers (DC = Distribution Center)
CREATE TABLE DeliveryCenter (
    DCID          INTEGER PRIMARY KEY,
    CenterName    VARCHAR(100),
    City          VARCHAR(100),
    IsCityCenter  BOOLEAN
);

-- Operators (drivers) and their deliveries
CREATE TABLE DeliveryRecord (
    OperatorID    INTEGER,
    FullName      VARCHAR(100),
    DCID          INTEGER,
    Phone         VARCHAR(50),
    Product       VARCHAR(100),
    UnitPrice     DECIMAL(10,2),
    Quantity      INTEGER,
    TotalValue    DECIMAL(10,2),
    -- optional extra columns in a real DB:
    -- DeliveryDate DATE,
    -- OrderID      INTEGER,
    PRIMARY KEY (OperatorID, DCID, Product),
    FOREIGN KEY (DCID) REFERENCES DeliveryCenter(DCID)
);
