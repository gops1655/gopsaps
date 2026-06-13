-- ICEGATE BOE Checklist Maker Database Schema

-- Users Table
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  firstName VARCHAR(100),
  lastName VARCHAR(100),
  companyName VARCHAR(255),
  phoneNumber VARCHAR(20),
  userType ENUM('individual', 'importer', 'exporter', 'clearing_agent', 'customs_broker') DEFAULT 'individual',
  isVerified BOOLEAN DEFAULT FALSE,
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deletedAt TIMESTAMP NULL
);

-- Subscriptions Table
CREATE TABLE IF NOT EXISTS subscriptions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  userId INT NOT NULL,
  planType ENUM('free', 'basic', 'professional', 'enterprise') DEFAULT 'free',
  status ENUM('active', 'inactive', 'cancelled') DEFAULT 'inactive',
  startDate DATETIME,
  endDate DATETIME,
  autoRenew BOOLEAN DEFAULT TRUE,
  paymentId VARCHAR(255),
  amount DECIMAL(10, 2),
  currency VARCHAR(3) DEFAULT 'INR',
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
);

-- HS Codes Table (Indian Harmonized System)
CREATE TABLE IF NOT EXISTS hs_codes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(12) UNIQUE NOT NULL,
  description VARCHAR(500),
  gstRate DECIMAL(5, 2),
  customsDutyRate DECIMAL(5, 2),
  category VARCHAR(100),
  applicableFor ENUM('import', 'export', 'both') DEFAULT 'both',
  baseUnit VARCHAR(50),
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_code (code)
);

-- Ports Table
CREATE TABLE IF NOT EXISTS ports (
  id INT AUTO_INCREMENT PRIMARY KEY,
  portCode VARCHAR(10) UNIQUE NOT NULL,
  portName VARCHAR(255),
  portType ENUM('air', 'sea', 'rail', 'road') DEFAULT 'sea',
  state VARCHAR(100),
  customsCommissioner VARCHAR(255),
  specialRequirements TEXT,
  contactPhone VARCHAR(20),
  contactEmail VARCHAR(255),
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_port_code (portCode)
);

-- Checklists Table
CREATE TABLE IF NOT EXISTS checklists (
  id INT AUTO_INCREMENT PRIMARY KEY,
  userId INT NOT NULL,
  checklist_type ENUM('import', 'export') NOT NULL,
  status ENUM('draft', 'in_progress', 'completed', 'submitted') DEFAULT 'draft',
  referenceNumber VARCHAR(255),
  invoiceNumber VARCHAR(255),
  invoiceDate DATE,
  importer_exporter_name VARCHAR(255),
  importer_exporter_address TEXT,
  importerExporterIEC VARCHAR(20),
  consignee_consignor_name VARCHAR(255),
  consignee_consignor_address TEXT,
  portOfLoading VARCHAR(100),
  portOfDischarge VARCHAR(100),
  hsCode VARCHAR(12),
  description TEXT,
  quantity DECIMAL(15, 2),
  unit VARCHAR(50),
  invoiceValue DECIMAL(15, 2),
  currency VARCHAR(3) DEFAULT 'INR',
  shipmentDate DATE,
  expectedDeliveryDate DATE,
  complianceScore INT DEFAULT 0,
  completionPercentage INT DEFAULT 0,
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  submittedAt TIMESTAMP NULL,
  deletedAt TIMESTAMP NULL,
  FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (userId),
  INDEX idx_status (status)
);

-- Checklist Items Table
CREATE TABLE IF NOT EXISTS checklist_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  checklistId INT NOT NULL,
  itemName VARCHAR(255),
  category VARCHAR(100),
  isRequired BOOLEAN DEFAULT TRUE,
  isCompleted BOOLEAN DEFAULT FALSE,
  notes TEXT,
  documentUploadedAt TIMESTAMP NULL,
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (checklistId) REFERENCES checklists(id) ON DELETE CASCADE,
  INDEX idx_checklist_id (checklistId)
);

-- Documents Table
CREATE TABLE IF NOT EXISTS documents (
  id INT AUTO_INCREMENT PRIMARY KEY,
  checklistId INT NOT NULL,
  documentType VARCHAR(100),
  documentName VARCHAR(255),
  fileUrl VARCHAR(500),
  fileSize INT,
  mimeType VARCHAR(100),
  uploadedBy INT,
  verifiedBy INT,
  verificationStatus ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
  verificationNotes TEXT,
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (checklistId) REFERENCES checklists(id) ON DELETE CASCADE,
  FOREIGN KEY (uploadedBy) REFERENCES users(id) ON DELETE SET NULL,
  FOREIGN KEY (verifiedBy) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_checklist_id (checklistId)
);

-- BOE Forms Table
CREATE TABLE IF NOT EXISTS boe_forms (
  id INT AUTO_INCREMENT PRIMARY KEY,
  checklistId INT NOT NULL UNIQUE,
  boeNumber VARCHAR(50),
  icegateReferenceNumber VARCHAR(100),
  status ENUM('draft', 'generated', 'submitted', 'accepted', 'rejected') DEFAULT 'draft',
  generatedAt TIMESTAMP NULL,
  submittedAt TIMESTAMP NULL,
  responseFromICEGATE TEXT,
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (checklistId) REFERENCES checklists(id) ON DELETE CASCADE,
  INDEX idx_status (status)
);

-- Compliance Rules Table
CREATE TABLE IF NOT EXISTS compliance_rules (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ruleName VARCHAR(255),
  ruleDescription TEXT,
  ruleType ENUM('import', 'export', 'both') DEFAULT 'both',
  applicableToCategories VARCHAR(500),
  minComplianceItems INT,
  isActive BOOLEAN DEFAULT TRUE,
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Compliance Checks Table
CREATE TABLE IF NOT EXISTS compliance_checks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  checklistId INT NOT NULL,
  complianceRuleId INT NOT NULL,
  isCompliant BOOLEAN,
  remarks TEXT,
  checkedAt TIMESTAMP,
  checkedBy INT,
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (checklistId) REFERENCES checklists(id) ON DELETE CASCADE,
  FOREIGN KEY (complianceRuleId) REFERENCES compliance_rules(id) ON DELETE CASCADE,
  FOREIGN KEY (checkedBy) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_checklist_id (checklistId)
);

-- GST Calculations Table
CREATE TABLE IF NOT EXISTS gst_calculations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  checklistId INT NOT NULL,
  hsCode VARCHAR(12),
  baseValue DECIMAL(15, 2),
  customsDuty DECIMAL(15, 2),
  gstRate DECIMAL(5, 2),
  gstAmount DECIMAL(15, 2),
  totalValue DECIMAL(15, 2),
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (checklistId) REFERENCES checklists(id) ON DELETE CASCADE
);

-- Audit Logs Table
CREATE TABLE IF NOT EXISTS audit_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  userId INT,
  action VARCHAR(255),
  entityType VARCHAR(100),
  entityId INT,
  oldValues JSON,
  newValues JSON,
  ipAddress VARCHAR(45),
  userAgent VARCHAR(500),
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (userId) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_created_at (createdAt),
  INDEX idx_user_id (userId)
);

-- Create indexes for performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_subscriptions_user ON subscriptions(userId);
CREATE INDEX idx_checklists_user_type ON checklists(userId, checklist_type);
CREATE INDEX idx_compliance_checklist ON compliance_checks(checklistId);
