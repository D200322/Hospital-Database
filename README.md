# Hospital-Database - (December 2025 )
Hospital management system - database

Overview:
A MySQL database system for managing hospital operations including patients, staff, medications, surgeries, and locations.

Database Name:
hospitalDB

Database Structure:
Main Tables:
Staff – Hospital employees
Doctor – Specialized doctors
Surgeon – Surgeons with contract details
Nurse – Nursing staff with skills
Patient – Patient information
Location – Bed/room assignments
Medication – Medicine inventory
Surgery – Surgical procedures
Allergy – Allergy types

Relationship Tables:
Patient_Location – Links patients to beds/rooms
Patient_Allergy – Links patients to allergies
Patient_Medication – Links patients to medicines
Surgery_Nurse – Links surgeries to nurses
Medicine_Interaction – Medicine interaction details

Features Implemented
1. View (Patient_Surgery_View)
Shows patient details with surgery info
Formats names and locations

2. Triggers (MedInfo table)
Automatically syncs Medication table changes
Handles INSERT, UPDATE, DELETE operations

3. Stored Procedure (sp_GetPatientMedicationCount)
Returns count of medications for a patient

4. Function (fn_Days_To_Expire)
Calculates days until medicine expiration
Returns medicines expiring in <30 days

5. XML Import
Loads data from XML files into tables
