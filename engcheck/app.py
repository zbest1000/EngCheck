from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="EngCheck Compliance Service")

class ComplianceRequest(BaseModel):
    document: str

class ComplianceResponse(BaseModel):
    compliant: bool
    details: str

@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.post("/check", response_model=ComplianceResponse)
def check_compliance(req: ComplianceRequest):
    # Placeholder: implement real compliance logic
    compliant = "safe" in req.document.lower()
    details = "Document contains 'safe'" if compliant else "Missing 'safe' keyword"
    return ComplianceResponse(compliant=compliant, details=details)
