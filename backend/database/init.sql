-- Initial database setup script
CREATE DATABASE IF NOT EXISTS icegate_boe;
USE icegate_boe;

-- Source the main schema
SOURCE schema.sql;

-- Insert sample ports data
INSERT INTO ports (portCode, portName, portType, state, customsCommissioner, contactPhone, contactEmail) VALUES
('INMAA1', 'Jawaharlal Nehru Port Authority, Mumbai', 'sea', 'Maharashtra', 'Principal Commissioner of Customs', '+91-22-2161-0000', 'jnpt.customs@gmail.com'),
('INBLR1', 'Port Trust, Chennai', 'sea', 'Tamil Nadu', 'Principal Commissioner of Customs', '+91-44-2561-5000', 'ports.customs@gmail.com'),
('INCCN1', 'Cochin Port Authority', 'sea', 'Kerala', 'Principal Commissioner of Customs', '+91-484-2661-211', 'cochin.customs@gmail.com'),
('INDEL1', 'Indira Gandhi International Airport, Delhi', 'air', 'Delhi', 'Principal Commissioner of Customs', '+91-11-2569-6000', 'delhi.customs@gmail.com'),
('INBOM1', 'Bombay High Sea Port', 'sea', 'Maharashtra', 'Principal Commissioner of Customs', '+91-22-2161-0000', 'bombay.customs@gmail.com');

-- Insert sample HS codes
INSERT INTO hs_codes (code, description, gstRate, customsDutyRate, category, applicableFor, baseUnit) VALUES
('0201', 'Beef meat, fresh or chilled', 5, 0, 'Animal Products', 'import', 'KG'),
('0702', 'Tomatoes, fresh or chilled', 5, 0, 'Vegetables', 'import', 'KG'),
('1005', 'Maize (corn)', 5, 0, 'Cereals', 'both', 'KG'),
('2710', 'Petroleum oils', 5, 5, 'Mineral Products', 'both', 'KG'),
('6204', 'Women\'s or girls\' suits', 12, 15, 'Textiles', 'both', 'PCS'),
('8517', 'Telephone apparatus', 12, 20, 'Electronics', 'import', 'PCS'),
('9403', 'Other furniture', 12, 20, 'Wood Products', 'both', 'PCS'),
('7208', 'Flat-rolled products of iron', 5, 7.5, 'Base Metals', 'import', 'KG');

-- Insert sample compliance rules
INSERT INTO compliance_rules (ruleName, ruleDescription, ruleType, applicableToCategories, minComplianceItems, isActive) VALUES
('Invoice Documentation', 'Original invoice must be attached with BOE', 'both', 'all', 1, TRUE),
('Packing List', 'Detailed packing list required', 'both', 'all', 1, TRUE),
('Bill of Lading', 'Original or copy of Bill of Lading', 'import', 'all', 1, TRUE),
('Certificate of Origin', 'Certificate of Origin for preferential imports', 'import', 'Textiles,Electronics', 1, TRUE),
('IEC Verification', 'Importer/Exporter Code must be valid and active', 'both', 'all', 1, TRUE),
('GST Compliance', 'GST calculation must match invoice', 'both', 'all', 1, TRUE),
('Prohibited Items Check', 'Verify items are not in prohibited list', 'both', 'all', 1, TRUE),
('Port Specific Documents', 'Submit port-specific required documents', 'import', 'all', 1, TRUE);
