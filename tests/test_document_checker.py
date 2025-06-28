from PyPDF2 import PdfWriter

from engcheck.checklist import generate_checklist
from engcheck.document_checker import check_document


def test_check_document(tmp_path):
    # create a simple PDF without the required keywords
    pdf_file = tmp_path / "sample.pdf"
    writer = PdfWriter()
    writer.add_blank_page(width=72, height=72)
    with open(pdf_file, "wb") as fh:
        writer.write(fh)
    checklist = generate_checklist("electrical")
    flags = check_document(pdf_file, checklist)
    assert flags, "Should flag missing keywords"
