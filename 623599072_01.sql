USE hospitalDB;

/*<Q1 – 623599072>*/

CREATE VIEW Patient_Surgery_View AS
SELECT 
    p.Patient_ID,
    CONCAT(LEFT(p.Name, 1), '. ', SUBSTRING_INDEX(p.Name, ' ', -1)) AS Patient_Name,
    CONCAT('Bed ', l.Bed_No, ', Room ', l.Room_No) AS Location,
    s.Surgery_Name,
    s.Date AS Surgery_Date
FROM Patient p
JOIN Patient_Location pl ON p.Patient_ID = pl.Patient_ID
JOIN Location l ON pl.Location_ID = l.Location_ID
JOIN Surgery s ON p.Patient_ID = s.Patient_ID;

SELECT * FROM Patient_Surgery_View;

/* <Q2 – 623599072> */
/* Create MedInfo table */

DROP TABLE IF EXISTS MedInfo;

CREATE TABLE MedInfo (
    MedName VARCHAR(100) PRIMARY KEY,
    QuantityAvailable INT,
    ExpirationDate DATE
);

SELECT * FROM MedInfo;

/* Trigger to insert data into MedInfo after inserting into Medication */


DELIMITER $$

CREATE TRIGGER trg_med_after_insert
AFTER INSERT ON Medication
FOR EACH ROW
BEGIN
    INSERT INTO MedInfo (MedName, QuantityAvailable, ExpirationDate)
    VALUES (NEW.Name, NEW.Quantity_On_Hand, NEW.Expiration_Date);
END$$

DELIMITER ;

/* Trigger to update MedInfo after updating Medication */


DELIMITER $$

CREATE TRIGGER trg_med_after_update
AFTER UPDATE ON Medication
FOR EACH ROW
BEGIN
    UPDATE MedInfo
    SET QuantityAvailable = NEW.Quantity_On_Hand,
        ExpirationDate = NEW.Expiration_Date
    WHERE MedName = OLD.Name;
END$$

DELIMITER ;

/* Trigger to delete data from MedInfo after deleting from Medication */


DELIMITER $$

CREATE TRIGGER trg_med_after_delete
AFTER DELETE ON Medication
FOR EACH ROW
BEGIN
    DELETE FROM MedInfo
    WHERE MedName = OLD.Name;
END$$

DELIMITER ;

/*Test INSERT Trigger*/
INSERT INTO Medication VALUES
(5010, 'Ibuprofen', 60, 20, 15.00, '2026-03-15');

SELECT * FROM MedInfo;

/*Test UPDATE Trigger*/
UPDATE Medication
SET Quantity_On_Hand = 40
WHERE Medication_Code = 5010;


SELECT * FROM MedInfo;

/*Test DELETE Trigger*/
DELETE FROM Medication
WHERE Medication_Code = 5010;

SELECT * FROM MedInfo;


/*<Q3 – 623599072>*/

DELIMITER $$
CREATE PROCEDURE sp_GetPatientMedicationCount(
IN p_PatientID INT,
INOUT p_MedCount INT
)
BEGIN
SELECT COUNT(*)
INTO p_MedCount
FROM Patient_Medication
WHERE Patient_ID = p_PatientID;
END$$
DELIMITER ;


SET @medCount = 0;
CALL sp_GetPatientMedicationCount(2001, @medCount);
SELECT @medCount AS Medication_Count;

/*<Q4 – 623599072>*/

DELIMITER $$
CREATE FUNCTION fn_Days_To_Expire(exp_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
RETURN DATEDIFF(exp_date, CURDATE());
END$$
DELIMITER ;

SELECT
Medication_Code,
Name,
Quantity_On_Hand,
Expiration_Date,
fn_Days_To_Expire(Expiration_Date) AS Days_Remaining
FROM Medication
WHERE fn_Days_To_Expire(Expiration_Date) < 30;

/*<Q6 – 623599072>*/

LOAD XML INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/patient.xml'
INTO TABLE Patient
ROWS IDENTIFIED BY '<patient>';

SELECT * FROM Patient;


LOAD XML INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/staff.xml'
INTO TABLE Staff
ROWS IDENTIFIED BY '<staff>';

SELECT * FROM Staff;














