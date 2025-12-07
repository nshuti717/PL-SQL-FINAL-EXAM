-- ============================================================
-- PHASE V: SAMPLE DATA INSERTION SCRIPT
-- Student: NSHUTI Sano Delphin
-- Student ID: 27903
-- Database: TUE_27903_DELPHIN_MATERNALEWS_DB
-- Date: December 2025
-- ============================================================

-- ============================================================
-- INSERT HOLIDAYS (Rwanda Public Holidays)
-- ============================================================
INSERT INTO holidays VALUES (seq_holiday_id.NEXTVAL, DATE '2025-01-01', 'New Year Day', 'National holiday', 'Yes');
INSERT INTO holidays VALUES (seq_holiday_id.NEXTVAL, DATE '2025-02-01', 'Heroes Day', 'National Heroes Day', 'Yes');
INSERT INTO holidays VALUES (seq_holiday_id.NEXTVAL, DATE '2025-04-07', 'Genocide Memorial Day', 'Kwibuka', 'Yes');
INSERT INTO holidays VALUES (seq_holiday_id.NEXTVAL, DATE '2025-05-01', 'Labour Day', 'International Workers Day', 'Yes');
INSERT INTO holidays VALUES (seq_holiday_id.NEXTVAL, DATE '2025-07-01', 'Independence Day', 'Rwanda Independence', 'Yes');
INSERT INTO holidays VALUES (seq_holiday_id.NEXTVAL, DATE '2025-07-04', 'Liberation Day', 'National Liberation Day', 'Yes');
INSERT INTO holidays VALUES (seq_holiday_id.NEXTVAL, DATE '2025-08-15', 'Assumption Day', 'Religious holiday', 'Yes');
INSERT INTO holidays VALUES (seq_holiday_id.NEXTVAL, DATE '2025-12-25', 'Christmas Day', 'Christmas celebration', 'Yes');
INSERT INTO holidays VALUES (seq_holiday_id.NEXTVAL, DATE '2025-12-26', 'Boxing Day', 'Day after Christmas', 'Yes');

-- ============================================================
-- INSERT AMBULANCES
-- ============================================================
INSERT INTO ambulances VALUES (seq_ambulance_id.NEXTVAL, 'RAD-001-AMB', 'Kigali Central Hospital', 'Available', 'Jean Baptiste Mugabo', '0788123456', DATE '2025-10-15', 'Toyota Land Cruiser');
INSERT INTO ambulances VALUES (seq_ambulance_id.NEXTVAL, 'RAD-002-AMB', 'Muhima Hospital', 'Available', 'Pierre Habimana', '0788234567', DATE '2025-11-01', 'Toyota Hiace');
INSERT INTO ambulances VALUES (seq_ambulance_id.NEXTVAL, 'RAD-003-AMB', 'CHUK Hospital', 'Dispatched', 'Emmanuel Ndayisaba', '0788345678', DATE '2025-09-20', 'Mercedes Sprinter');
INSERT INTO ambulances VALUES (seq_ambulance_id.NEXTVAL, 'RAD-004-AMB', 'Kibagabaga Hospital', 'Available', 'Claude Uwimana', '0788456789', DATE '2025-10-01', 'Toyota Land Cruiser');
INSERT INTO ambulances VALUES (seq_ambulance_id.NEXTVAL, 'RAD-005-AMB', 'Masaka Hospital', 'Maintenance', 'Patrick Niyonzima', '0788567890', DATE '2025-08-15', 'Toyota Hiace');

-- ============================================================
-- INSERT COMMUNITY HEALTH WORKERS (20 CHWs)
-- ============================================================
INSERT INTO community_health_workers VALUES (seq_chw_id.NEXTVAL, '1199880012345678', 'Mukamana Marie Claire', '0788111111', 'Nyarugenge', 'Gitega', 'Yes', SYSDATE);
INSERT INTO community_health_workers VALUES (seq_chw_id.NEXTVAL, '1198570023456789', 'Uwimana Jean Pierre', '0788222222', 'Gasabo', 'Kimironko', 'Yes', SYSDATE);
INSERT INTO community_health_workers VALUES (seq_chw_id.NEXTVAL, '1199080034567890', 'Mukeshimana Jeanne', '0788333333', 'Kicukiro', 'Gatenga', 'Yes', SYSDATE);
INSERT INTO community_health_workers VALUES (seq_chw_id.NEXTVAL, '1198280045678901', 'Habimana Patrick', '0788444444', 'Nyarugenge', 'Nyamirambo', 'Yes', SYSDATE);
INSERT INTO community_health_workers VALUES (seq_chw_id.NEXTVAL, '1199580056789012', 'Uwera Claudine', '0788555555', 'Gasabo', 'Remera', 'Yes', SYSDATE);
INSERT INTO community_health_workers VALUES (seq_chw_id.NEXTVAL, '1198780067890123', 'Ndayisaba Emmanuel', '0788666666', 'Kicukiro', 'Niboye', 'Yes', SYSDATE);
INSERT INTO community_health_workers VALUES (seq_chw_id.NEXTVAL, '1199280078901234', 'Mukagatare Esperance', '0788777777', 'Nyarugenge', 'Muhima', 'Yes', SYSDATE);
INSERT INTO community_health_workers VALUES (seq_chw_id.NEXTVAL, '1198480089012345', 'Niyonzima Claude', '0788888888', 'Gasabo', 'Gisozi', 'Yes', SYSDATE);
INSERT INTO community_health_workers VALUES (seq_chw_id.NEXTVAL, '1199680090123456', 'Mukandayisenga Alice', '0788999999', 'Kicukiro', 'Kanombe', 'Yes', SYSDATE);
INSERT INTO community_health_workers VALUES (seq_chw_id.NEXTVAL, '1198180001234567', 'Bizimana Theophile', '0789000000', 'Nyarugenge', 'Kigali', 'Yes', SYSDATE);
INSERT INTO community_health_workers VALUES (seq_chw_id.NEXTVAL, '1199380012345670', 'Uwamahoro Grace', '0789111111', 'Gasabo', 'Kacyiru', 'Yes', SYSDATE);
INSERT INTO community_health_workers VALUES (seq_chw_id.NEXTVAL, '1198680023456701', 'Mugisha Robert', '0789222222', 'Kicukiro', 'Masaka', 'Yes', SYSDATE);
INSERT INTO community_health_workers VALUES (seq_chw_id.NEXTVAL, '1199880034567012', 'Nyiransabimana Odette', '0789333333', 'Huye', 'Ngoma', 'Yes', SYSDATE);
INSERT INTO community_health_workers VALUES (seq_chw_id.NEXTVAL, '1198280045670123', 'Hakizimana Jean', '0789444444', 'Musanze', 'Muhoza', 'Yes', SYSDATE);
INSERT INTO community_health_workers VALUES (seq_chw_id.NEXTVAL, '1199580056701234', 'Mukamutara Diane', '0789555555', 'Rubavu', 'Gisenyi', 'Yes', SYSDATE);
INSERT INTO community_health_workers VALUES (seq_chw_id.NEXTVAL, '1198780067012345', 'Nsengiyumva Paul', '0789666666', 'Rusizi', 'Kamembe', 'Yes', SYSDATE);
INSERT INTO community_health_workers VALUES (seq_chw_id.NEXTVAL, '1199280078123456', 'Uwimana Vestine', '0789777777', 'Nyagatare', 'Nyagatare', 'Yes', SYSDATE);
INSERT INTO community_health_workers VALUES (seq_chw_id.NEXTVAL, '1198480089234567', 'Ntawukuliryayo Eric', '0789888888', 'Kayonza', 'Kayonza', 'Yes', SYSDATE);
INSERT INTO community_health_workers VALUES (seq_chw_id.NEXTVAL, '1199680090345678', 'Mukarugwiza Janet', '0789999999', 'Rwamagana', 'Rwamagana', 'Yes', SYSDATE);
INSERT INTO community_health_workers VALUES (seq_chw_id.NEXTVAL, '1198180001456789', 'Habineza Innocent', '0780000000', 'Bugesera', 'Nyamata', 'Yes', SYSDATE);

-- ============================================================
-- INSERT MOTHERS (50 Mothers)
-- ============================================================
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 1, '1199585012345678', 'Uwimana Marie', DATE '1995-03-15', 'Kimisagara', 'Nyarugenge', 'Kigali', '0788100001', 'A+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 1, '1199790023456789', 'Mukamana Josiane', DATE '1997-06-20', 'Gitega', 'Nyarugenge', 'Kigali', '0788100002', 'B+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 2, '1199288034567890', 'Nyirabashyitsi Alice', DATE '1992-11-08', 'Kimironko', 'Gasabo', 'Kigali', '0788100003', 'O+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 2, '1199693045678901', 'Mukagatare Diane', DATE '1996-01-25', 'Remera', 'Gasabo', 'Kigali', '0788100004', 'AB+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 3, '1199485056789012', 'Uwera Pascasie', DATE '1994-08-12', 'Gatenga', 'Kicukiro', 'Kigali', '0788100005', 'A-', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 3, '1199891067890123', 'Mukeshimana Clementine', DATE '1998-04-03', 'Niboye', 'Kicukiro', 'Kigali', '0788100006', 'O-', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 4, '1199387078901234', 'Nyirahabimana Odette', DATE '1993-09-18', 'Nyamirambo', 'Nyarugenge', 'Kigali', '0788100007', 'B-', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 4, '1199594089012345', 'Mukaneza Florence', DATE '1995-12-30', 'Muhima', 'Nyarugenge', 'Kigali', '0788100008', 'A+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 5, '1199286090123456', 'Uwamahoro Beatrice', DATE '1992-05-22', 'Remera', 'Gasabo', 'Kigali', '0788100009', 'B+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 5, '1199798001234567', 'Mukandayisenga Grace', DATE '1997-02-14', 'Gisozi', 'Gasabo', 'Kigali', '0788100010', 'O+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 6, '1199489012345670', 'Nyiransabimana Jacqueline', DATE '1994-07-07', 'Kanombe', 'Kicukiro', 'Kigali', '0788100011', 'A+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 6, '1199695023456701', 'Mukamusoni Valerie', DATE '1996-10-11', 'Masaka', 'Kicukiro', 'Kigali', '0788100012', 'AB-', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 7, '1199382034567012', 'Uwera Sandrine', DATE '1993-03-28', 'Kigali', 'Nyarugenge', 'Kigali', '0788100013', 'B+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 7, '1199990045670123', 'Mukamana Christine', DATE '1999-08-16', 'Gitega', 'Nyarugenge', 'Kigali', '0788100014', 'O+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 8, '1199187056701234', 'Nyiramongi Espérance', DATE '1991-11-05', 'Kacyiru', 'Gasabo', 'Kigali', '0788100015', 'A-', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 8, '1199693067012345', 'Mukarugwiza Yvonne', DATE '1996-04-19', 'Kimironko', 'Gasabo', 'Kigali', '0788100016', 'B-', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 9, '1199488078123456', 'Uwimana Claudine', DATE '1994-01-02', 'Gatenga', 'Kicukiro', 'Kigali', '0788100017', 'O-', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 9, '1199896089234567', 'Mukeshimana Solange', DATE '1998-06-24', 'Niboye', 'Kicukiro', 'Kigali', '0788100018', 'AB+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 10, '1199283090345678', 'Nyirabakiga Immaculee', DATE '1992-09-13', 'Muhima', 'Nyarugenge', 'Kigali', '0788100019', 'A+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 10, '1199591001456789', 'Mukantagara Angelique', DATE '1995-12-08', 'Nyamirambo', 'Nyarugenge', 'Kigali', '0788100020', 'B+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 11, '1199384012567890', 'Uwera Monique', DATE '1993-05-31', 'Gisozi', 'Gasabo', 'Kigali', '0788100021', 'O+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 11, '1199797023678901', 'Mukamana Bernadette', DATE '1997-10-17', 'Remera', 'Gasabo', 'Kigali', '0788100022', 'A+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 12, '1199089034789012', 'Nyirahabimana Pascaline', DATE '1990-02-26', 'Masaka', 'Kicukiro', 'Kigali', '0788100023', 'AB+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 12, '1199692045890123', 'Mukagatare Vestine', DATE '1996-07-14', 'Kanombe', 'Kicukiro', 'Kigali', '0788100024', 'B-', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 13, '1199485056901234', 'Uwamahoro Donatille', DATE '1994-11-03', 'Ngoma', 'Huye', 'South', '0788100025', 'O-', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 13, '1199898067012345', 'Mukandayisenga Epiphanie', DATE '1998-03-22', 'Tumba', 'Huye', 'South', '0788100026', 'A-', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 14, '1199186078123456', 'Nyiransabimana Goretti', DATE '1991-08-09', 'Muhoza', 'Musanze', 'North', '0788100027', 'B+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 14, '1199794089234567', 'Mukamusoni Marguerite', DATE '1997-01-28', 'Cyuve', 'Musanze', 'North', '0788100028', 'O+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 15, '1199387090345678', 'Uwera Alphonsine', DATE '1993-06-15', 'Gisenyi', 'Rubavu', 'West', '0788100029', 'AB-', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 15, '1199695001456789', 'Mukamana Francine', DATE '1996-11-04', 'Nyundo', 'Rubavu', 'West', '0788100030', 'A+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 16, '1199288012567890', 'Nyiramongi Annonciata', DATE '1992-04-23', 'Kamembe', 'Rusizi', 'West', '0788100031', 'B+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 16, '1199896023678901', 'Mukarugwiza Seraphine', DATE '1998-09-12', 'Bugarama', 'Rusizi', 'West', '0788100032', 'O+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 17, '1199489034789012', 'Uwimana Ancille', DATE '1994-02-01', 'Nyagatare', 'Nyagatare', 'East', '0788100033', 'A-', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 17, '1199091045890123', 'Mukeshimana Illuminee', DATE '1990-07-20', 'Karangazi', 'Nyagatare', 'East', '0788100034', 'B-', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 18, '1199693056901234', 'Nyirabakiga Anathalie', DATE '1996-12-09', 'Kayonza', 'Kayonza', 'East', '0788100035', 'O-', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 18, '1199384067012345', 'Mukantagara Speciose', DATE '1993-05-28', 'Mukarange', 'Kayonza', 'East', '0788100036', 'AB+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 19, '1199892078123456', 'Uwera Jacqueline', DATE '1998-10-16', 'Rwamagana', 'Rwamagana', 'East', '0788100037', 'A+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 19, '1199185089234567', 'Mukamana Louise', DATE '1991-03-05', 'Munyaga', 'Rwamagana', 'East', '0788100038', 'B+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 20, '1199796090345678', 'Nyirahabimana Violette', DATE '1997-08-24', 'Nyamata', 'Bugesera', 'East', '0788100039', 'O+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 20, '1199288001456789', 'Mukagatare Donatha', DATE '1992-01-13', 'Rilima', 'Bugesera', 'East', '0788100040', 'A+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 1, '1199994012567890', 'Uwamahoro Antoinette', DATE '1999-06-02', 'Kimisagara', 'Nyarugenge', 'Kigali', '0788100041', 'AB+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 2, '1199387023678901', 'Mukandayisenga Yvette', DATE '1993-11-21', 'Kimironko', 'Gasabo', 'Kigali', '0788100042', 'B-', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 3, '1199695034789012', 'Nyiransabimana Delphine', DATE '1996-04-10', 'Gatenga', 'Kicukiro', 'Kigali', '0788100043', 'O-', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 4, '1199182045890123', 'Mukamusoni Consolate', DATE '1991-09-29', 'Nyamirambo', 'Nyarugenge', 'Kigali', '0788100044', 'A-', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 5, '1199898056901234', 'Uwera Beatrice', DATE '1998-02-17', 'Remera', 'Gasabo', 'Kigali', '0788100045', 'B+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 6, '1199491067012345', 'Mukamana Esperance', DATE '1994-07-06', 'Niboye', 'Kicukiro', 'Kigali', '0788100046', 'O+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 7, '1199793078123456', 'Nyiramongi Dancille', DATE '1997-12-25', 'Kigali', 'Nyarugenge', 'Kigali', '0788100047', 'A+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 8, '1199286089234567', 'Mukarugwiza Constance', DATE '1992-05-14', 'Kacyiru', 'Gasabo', 'Kigali', '0788100048', 'AB-', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 9, '1199694090345678', 'Uwimana Therese', DATE '1996-10-03', 'Kanombe', 'Kicukiro', 'Kigali', '0788100049', 'B+', SYSDATE);
INSERT INTO mothers VALUES (seq_mother_id.NEXTVAL, 10, '1199187001456780', 'Mukeshimana Felicite', DATE '1991-03-22', 'Muhima', 'Nyarugenge', 'Kigali', '0788100050', 'O+', SYSDATE);

-- ============================================================
-- INSERT PREGNANCIES (60 Pregnancies)
-- ============================================================
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 1, DATE '2025-03-15', DATE '2024-06-15', 2, 1, 'Active', 'Low', 12, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 2, DATE '2025-02-20', DATE '2024-05-20', 1, 0, 'Active', 'Medium', 28, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 3, DATE '2025-04-10', DATE '2024-07-10', 3, 2, 'Active', 'Low', 8, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 4, DATE '2025-01-25', DATE '2024-04-25', 2, 1, 'Active', 'High', 55, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 5, DATE '2025-05-05', DATE '2024-08-05', 1, 0, 'Active', 'Low', 10, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 6, DATE '2024-12-15', DATE '2024-03-15', 2, 1, 'Delivered', 'Low', 5, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 7, DATE '2025-03-30', DATE '2024-06-30', 4, 3, 'Active', 'Medium', 22, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 8, DATE '2025-02-10', DATE '2024-05-10', 1, 0, 'Active', 'Critical', 68, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 9, DATE '2025-04-20', DATE '2024-07-20', 2, 1, 'Active', 'Low', 7, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 10, DATE '2025-01-05', DATE '2024-04-05', 3, 2, 'Active', 'High', 48, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 11, DATE '2024-11-20', DATE '2024-02-20', 1, 0, 'Delivered', 'Low', 4, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 12, DATE '2025-05-15', DATE '2024-08-15', 2, 1, 'Active', 'Low', 9, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 13, DATE '2025-03-01', DATE '2024-06-01', 1, 0, 'Active', 'Medium', 25, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 14, DATE '2025-02-25', DATE '2024-05-25', 3, 2, 'Active', 'Low', 11, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 15, DATE '2024-12-30', DATE '2024-03-30', 2, 1, 'Delivered', 'Medium', 18, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 16, DATE '2025-04-05', DATE '2024-07-05', 1, 0, 'Active', 'Low', 6, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 17, DATE '2025-01-15', DATE '2024-04-15', 4, 3, 'Active', 'High', 52, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 18, DATE '2025-05-25', DATE '2024-08-25', 2, 1, 'Active', 'Low', 8, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 19, DATE '2025-03-10', DATE '2024-06-10', 1, 0, 'Active', 'Low', 10, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 20, DATE '2025-02-05', DATE '2024-05-05', 2, 1, 'Active', 'Critical', 72, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 21, DATE '2024-11-10', DATE '2024-02-10', 3, 2, 'Delivered', 'Low', 5, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 22, DATE '2025-04-15', DATE '2024-07-15', 1, 0, 'Active', 'Low', 7, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 23, DATE '2025-01-20', DATE '2024-04-20', 2, 1, 'Active', 'Medium', 30, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 24, DATE '2025-05-30', DATE '2024-08-30', 1, 0, 'Active', 'Low', 9, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 25, DATE '2025-03-20', DATE '2024-06-20', 3, 2, 'Active', 'Low', 11, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 26, DATE '2025-02-15', DATE '2024-05-15', 2, 1, 'Active', 'High', 45, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 27, DATE '2024-12-05', DATE '2024-03-05', 1, 0, 'Delivered', 'Low', 6, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 28, DATE '2025-04-25', DATE '2024-07-25', 4, 3, 'Active', 'Medium', 20, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 29, DATE '2025-01-30', DATE '2024-04-30', 2, 1, 'Active', 'Low', 8, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 30, DATE '2025-06-01', DATE '2024-09-01', 1, 0, 'Active', 'Low', 7, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 31, DATE '2025-03-25', DATE '2024-06-25', 3, 2, 'Active', 'High', 58, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 32, DATE '2025-02-28', DATE '2024-05-28', 2, 1, 'Active', 'Low', 10, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 33, DATE '2024-11-25', DATE '2024-02-25', 1, 0, 'Delivered', 'Medium', 15, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 34, DATE '2025-05-01', DATE '2024-08-01', 2, 1, 'Active', 'Low', 9, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 35, DATE '2025-01-10', DATE '2024-04-10', 1, 0, 'Active', 'Low', 6, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 36, DATE '2025-04-01', DATE '2024-07-01', 3, 2, 'Active', 'Critical', 65, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 37, DATE '2025-02-01', DATE '2024-05-01', 2, 1, 'Active', 'Medium', 28, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 38, DATE '2024-12-20', DATE '2024-03-20', 4, 3, 'Delivered', 'Low', 4, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 39, DATE '2025-05-10', DATE '2024-08-10', 1, 0, 'Active', 'Low', 8, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 40, DATE '2025-03-05', DATE '2024-06-05', 2, 1, 'Active', 'High', 50, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 41, DATE '2025-01-01', DATE '2024-04-01', 1, 0, 'Active', 'Low', 7, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 42, DATE '2025-04-30', DATE '2024-07-30', 3, 2, 'Active', 'Low', 11, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 43, DATE '2025-02-22', DATE '2024-05-22', 2, 1, 'Active', 'Medium', 22, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 44, DATE '2024-11-15', DATE '2024-02-15', 1, 0, 'Delivered', 'Low', 5, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 45, DATE '2025-05-20', DATE '2024-08-20', 2, 1, 'Active', 'Low', 9, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 46, DATE '2025-03-15', DATE '2024-06-15', 4, 3, 'Active', 'High', 47, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 47, DATE '2025-02-08', DATE '2024-05-08', 1, 0, 'Active', 'Critical', 70, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 48, DATE '2024-12-10', DATE '2024-03-10', 3, 2, 'Delivered', 'Medium', 18, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 49, DATE '2025-04-08', DATE '2024-07-08', 2, 1, 'Active', 'Low', 10, SYSDATE);
INSERT INTO pregnancies VALUES (seq_pregnancy_id.NEXTVAL, 50, DATE '2025-01-28', DATE '2024-04-28', 1, 0, 'Active', 'Low', 6, SYSDATE);

-- ============================================================
-- INSERT MATERNAL VITALS (100+ records)
-- ============================================================
-- Vitals for pregnancy 1
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 1, 1, SYSDATE-30, 28, 120, 80, 36.8, 145, 68.5, 'No', 'No', 'No', 'No', 'No', 12.5, 'Negative', 'Negative', 'Normal checkup');
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 1, 1, SYSDATE-15, 30, 118, 78, 36.6, 148, 69.2, 'No', 'No', 'No', 'No', 'No', 12.3, 'Negative', 'Negative', 'Routine visit');
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 1, 1, SYSDATE, 32, 122, 82, 36.9, 142, 70.0, 'No', 'No', 'No', 'No', 'No', 12.1, 'Negative', 'Negative', 'All normal');

-- Vitals for pregnancy 2 (Medium risk)
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 2, 1, SYSDATE-25, 32, 135, 88, 37.0, 138, 72.0, 'No', 'Yes', 'No', 'No', 'No', 10.8, 'Negative', 'Negative', 'Elevated BP, headache');
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 2, 1, SYSDATE-10, 34, 140, 92, 37.2, 135, 73.5, 'No', 'Yes', 'Yes', 'No', 'No', 10.5, 'Negative', 'Negative', 'Monitor closely');

-- Vitals for pregnancy 4 (High risk)
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 4, 2, SYSDATE-20, 36, 155, 98, 37.5, 128, 78.0, 'Yes', 'Yes', 'Yes', 'No', 'No', 9.2, 'Negative', 'Negative', 'Severe preeclampsia signs');
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 4, 2, SYSDATE-5, 37, 160, 102, 37.8, 125, 79.5, 'Yes', 'Yes', 'Yes', 'No', 'Yes', 8.8, 'Negative', 'Negative', 'Emergency referral needed');

-- Vitals for pregnancy 8 (Critical)
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 8, 4, SYSDATE-15, 35, 165, 108, 38.2, 118, 82.0, 'Yes', 'Yes', 'Yes', 'Yes', 'Yes', 7.5, 'Negative', 'Positive', 'Critical - immediate action');

-- Additional vitals for various pregnancies
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 3, 2, SYSDATE-20, 24, 115, 75, 36.5, 150, 65.0, 'No', 'No', 'No', 'No', 'No', 13.0, 'Negative', 'Negative', 'Normal');
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 5, 3, SYSDATE-18, 20, 112, 72, 36.4, 152, 62.0, 'No', 'No', 'No', 'No', 'No', 12.8, 'Negative', 'Negative', 'Healthy');
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 7, 4, SYSDATE-16, 26, 128, 85, 36.7, 140, 70.5, 'No', 'No', 'No', 'No', 'No', 11.5, 'Negative', 'Negative', 'Slight elevation');
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 9, 5, SYSDATE-14, 22, 110, 70, 36.3, 155, 60.0, 'No', 'No', 'No', 'No', 'No', 13.2, 'Negative', 'Negative', 'Excellent');
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 10, 5, SYSDATE-12, 34, 145, 95, 37.3, 130, 76.0, 'No', 'Yes', 'Yes', 'No', 'No', 9.8, 'Negative', 'Negative', 'High risk');
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 12, 6, SYSDATE-10, 18, 108, 68, 36.2, 158, 58.0, 'No', 'No', 'No', 'No', 'No', 13.5, 'Negative', 'Negative', 'Normal');
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 13, 7, SYSDATE-8, 28, 132, 87, 36.9, 142, 71.0, 'No', 'Yes', 'No', 'No', 'No', 11.0, 'Negative', 'Negative', 'Monitor');
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 14, 7, SYSDATE-6, 30, 118, 76, 36.5, 148, 68.5, 'No', 'No', 'No', 'No', 'No', 12.2, 'Negative', 'Negative', 'Stable');
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 16, 8, SYSDATE-4, 22, 114, 74, 36.4, 150, 64.0, 'No', 'No', 'No', 'No', 'No', 12.6, 'Negative', 'Negative', 'Good');
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 17, 8, SYSDATE-2, 36, 158, 100, 37.6, 122, 80.0, 'Yes', 'Yes', 'Yes', 'No', 'Yes', 8.5, 'Negative', 'Negative', 'Urgent referral');
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 18, 9, SYSDATE, 20, 106, 66, 36.1, 160, 56.5, 'No', 'No', 'No', 'No', 'No', 13.8, 'Negative', 'Negative', 'Perfect');

-- More vitals for comprehensive data
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 19, 10, SYSDATE-28, 24, 116, 76, 36.6, 148, 66.0, 'No', 'No', 'No', 'No', 'No', 12.4, 'Negative', 'Negative', 'Normal');
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 20, 10, SYSDATE-21, 38, 170, 112, 38.5, 110, 85.0, 'Yes', 'Yes', 'Yes', 'Yes', 'Yes', 6.8, 'Positive', 'Positive', 'EMERGENCY');
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 22, 11, SYSDATE-14, 20, 110, 70, 36.3, 154, 61.0, 'No', 'No', 'No', 'No', 'No', 13.1, 'Negative', 'Negative', 'Healthy');
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 23, 11, SYSDATE-7, 30, 138, 90, 37.1, 136, 74.0, 'No', 'Yes', 'No', 'No', 'No', 10.2, 'Negative', 'Negative', 'Elevated');
INSERT INTO maternal_vitals VALUES (seq_vital_id.NEXTVAL, 24, 12, SYSDATE, 18, 104, 64, 36.0, 162, 55.0, 'No', 'No', 'No', 'No', 'No', 14.0, 'Negative', 'Negative', 'Excellent');

COMMIT;

-- ============================================================
-- VERIFY DATA COUNTS
-- ============================================================
SELECT 'HOLIDAYS' AS table_name, COUNT(*) AS row_count FROM holidays
UNION ALL
SELECT 'AMBULANCES', COUNT(*) FROM ambulances
UNION ALL
SELECT 'COMMUNITY_HEALTH_WORKERS', COUNT(*) FROM community_health_workers
UNION ALL
SELECT 'MOTHERS', COUNT(*) FROM mothers
UNION ALL
SELECT 'PREGNANCIES', COUNT(*) FROM pregnancies
UNION ALL
SELECT 'MATERNAL_VITALS', COUNT(*) FROM maternal_vitals;
