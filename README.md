# ICEGATE BOE Checklist Maker

A comprehensive SaaS platform for Indian Customs filing assistance and BOE (Bill of Entry) generation for ICEGATE submissions.

## Features

- ✅ Import & Export BOE Checklist Validation
- ✅ HS Code & GST Calculation
- ✅ Document Requirement Tracking
- ✅ BOE Form Pre-filling
- ✅ Compliance Checking
- ✅ PDF/Excel Export
- ✅ ICEGATE API Integration
- ✅ Port-Specific Requirements
- ✅ Multi-user Subscription Management
- ✅ Audit Logs & Compliance Tracking

## Tech Stack

- **Frontend**: React.js with Redux
- **Backend**: Node.js + Express
- **Database**: MySQL
- **Authentication**: JWT
- **Payment**: Razorpay Integration
- **Export**: PDFKit, ExcelJS
- **Hosting**: Docker-ready, AWS/DigitalOcean compatible

## Project Structure

```
icegate-boe-checklist/
├── backend/
│   ├── config/
│   ├── controllers/
│   ├── models/
│   ├── routes/
│   ├── middleware/
│   ├── utils/
│   ├── database/
│   └── server.js
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── redux/
│   │   ├── services/
│   │   └── App.js
│   └── package.json
├── docker-compose.yml
├── .env.example
└── README.md
```

## Installation & Deployment

See individual README files in `backend/` and `frontend/` directories.
