# Delivery & Operator Performance Analytics

This project started as a database homework assignment I built in MS Access.  
I turned it into a portfolio project that shows how I:

- structure **delivery center + operator** data,
- design a simple **SQL schema**,
- analyze performance using **Excel pivot tables and charts**,
- and present insights about **which centers and operators drive the most value**.

**Target roles:** Data / Business Analyst · Operations / Supply Chain / Logistics Analyst  
**Industries:** Logistics, e-commerce, retail distribution, last-mile delivery

---

## 1. Business Context

The dataset represents a simplified delivery network:

- multiple **distribution centers (DCs)**,
- several **operators (drivers)**,
- different **products** being delivered,
- for each record we know the **unit price**, **quantity**, and **total value** of deliveries.

The kind of questions an operations or logistics manager would ask:

1. **Which delivery centers contribute the most total delivery value?**
2. **Which operators are the most important in terms of value delivered?**
3. **How does performance differ across centers and products?**

This project answers those questions using **Excel pivots & charts** on top of a simple SQL-style schema.

---

## 2. Repo Structure

```text
delivery-operator-performance-analytics/
├─ data/           # data files (CSV / Excel exported from Access)
├─ Excel/          # original Excel workbook with pivots & charts
├─ Images/         # PNG charts used in this README
├─ SQL/            # schema and example queries
└─ README.md       # this file
````

Key assets:

* `Excel/Excel workbook with pivots and charts.xlsx` – the workbook exported from Access, containing the pivots & charts.
* `Images/Important Delivery Operators.png` – top operators by total value.
* `Images/Total Delivery Value by Center.png` – total value by distribution center.
* `Images/Top Delivery By Operator.png` – alternative operator view.
* `SQL/schema.sql` – logical schema for delivery centers and delivery records.

---

## 3. Data

The core table (exported to Excel) looks like this conceptually:

* `OperatorID` – unique ID for each operator
* `FullName` – operator name (e.g. *Alice Johnson*)
* `DCID` – distribution center ID
* `Phone` – operator contact
* `Product` – product category (Electronics, Books, Clothing, Furniture, etc.)
* `UnitPrice` – price per unit
* `Quantity` – units delivered
* `TotalValue` – `UnitPrice × Quantity` (total delivery value for that row)

In a fuller database, we would also have a **DeliveryCenter** table with:

* `DCID`, `CenterName`, `City`, `IsCityCenter` (TRUE/FALSE)

The file lives in the **Excel** workbook and can also be exported as CSV into the `data/` folder if needed.

---

## 4. SQL Schema (Design)

In [`SQL/schema.sql`](SQL/schema.sql) I defined a simple schema for this data:

* `DeliveryCenter(DCID, CenterName, City, IsCityCenter)`
* `DeliveryRecord(OperatorID, FullName, DCID, Phone, Product, UnitPrice, Quantity, TotalValue, …)`

Example:

```sql
CREATE TABLE DeliveryCenter (
    DCID          INTEGER PRIMARY KEY,
    CenterName    VARCHAR(100),
    City          VARCHAR(100),
    IsCityCenter  BOOLEAN
);

CREATE TABLE DeliveryRecord (
    OperatorID    INTEGER,
    FullName      VARCHAR(100),
    DCID          INTEGER,
    Phone         VARCHAR(50),
    Product       VARCHAR(100),
    UnitPrice     DECIMAL(10,2),
    Quantity      INTEGER,
    TotalValue    DECIMAL(10,2),
    PRIMARY KEY (OperatorID, DCID, Product),
    FOREIGN KEY (DCID) REFERENCES DeliveryCenter(DCID)
);
```

This shows how I would structure the data if I were putting it into **Oracle / PostgreSQL / any relational DB** for a real logistics team.

---

## 5. Excel Pivots & Visuals

Most of the analysis was done in Excel using pivot tables and charts.
The workbook is in:
[`Excel/Excel workbook with pivots and charts.xlsx`](Excel/Excel%20workbook%20with%20pivots%20and%20charts.xlsx)

### 5.1 Total Delivery Value by Center

To understand **which distribution centers matter most**, I built a pivot:

* Rows: `DCID` / Center
* Values: `Sum of TotalValue`
* Optional filters: `Product`

Chart example:

![Total Delivery Value by Center](Images/Total%20Delivery%20Value%20by%20Center.png)

This answers:

* “Which centers drive the highest delivery value?”
* “Are a few hubs responsible for most of the volume/value?”

### 5.2 Important Delivery Operators

To see **which operators are most important**, I built another pivot:

* Rows: `FullName` (operator)
* Values: `Sum of TotalValue`
* Optional filters: `Product`, `DCID`

Chart example:

![Important Delivery Operators](Images/Important%20Delivery%20Operators.png)

This makes it easy to see:

* Top operators overall
* Top operators for a specific product category
* Imbalances (for example, if one operator carries much more value than others)

### 5.3 Alternative Operator View

I also created a second operator chart layout:

![Top Delivery By Operator](Images/Top%20Delivery%20By%20Operator.png)

This view is useful for presentations and gives a clear ranking of operators by `TotalValue`.

---

## 6. Example Insights

Some typical insights a manager could get from this analysis:

* A small number of **centers** contribute a large share of total value
  → these centers are critical and may need more capacity, stronger processes, or backup plans.

* A handful of **operators** consistently deliver the highest total value
  → they might be candidates for recognition, training others, or ensuring coverage if they are absent.

* Filtering by **Product** can reveal:

  * which products rely heavily on certain centers,
  * where specialization (e.g., certain centers for electronics) is happening.

Even though this started as a homework dataset, the analysis pattern is the same as in a real logistics or e-commerce company.

---

## 7. How to Use / Reproduce

### Excel

1. Open [`Excel/Excel workbook with pivots and charts.xlsx`](Excel/Excel%20workbook%20with%20pivots%20and%20charts.xlsx).
2. Go to the pivot table sheets (e.g., **Centers**, **Operators**).
3. Use filters/slicers for:

   * `Product`
   * `DCID` (if present)
4. Explore:

   * which centers have the highest **TotalValue**,
   * which operators are top performers.

### SQL (optional if loaded into a database)

1. Create the tables using [`SQL/schema.sql`](SQL/schema.sql).
2. Import the data from Excel/CSV into `DeliveryCenter` and `DeliveryRecord`.
3. Run queries such as:

   ```sql
   -- Total value by center
   SELECT
       dc.CenterName,
       SUM(dr.TotalValue) AS TotalValue
   FROM DeliveryRecord dr
   JOIN DeliveryCenter dc ON dr.DCID = dc.DCID
   GROUP BY dc.CenterName
   ORDER BY TotalValue DESC;
   ```

   ```sql
   -- Top operators by total value
   SELECT
       dr.FullName,
       SUM(dr.TotalValue) AS TotalValue
   FROM DeliveryRecord dr
   GROUP BY dr.FullName
   ORDER BY TotalValue DESC;
   ```

---

## 8. Why This Project Is in My Portfolio

I included this project because it shows how I:

* take a small operational dataset (delivery centers & operators),
* design a reasonable **relational schema** for it,
* use **Excel pivots and charts** to create manager-friendly views,
* and answer core operations questions like:

> “Which centers and operators drive the most delivery value?”

This is directly relevant for:

* **Operations / Logistics / Supply Chain Analyst** roles
* **Data / Business Analyst** roles in e-commerce, retail, transportation, or delivery companies

and complements my other projects on A/B testing, risk analytics, and customer/order data.
