from engcheck.checklist import generate_checklist


def test_generate_checklist():
    checklist = generate_checklist("electrical")
    assert any(item["id"] == "NEC-100" for item in checklist)
