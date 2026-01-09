import requests

def test_health_endpoint(base_url):
    r = requests.get(f"{base_url}")
    assert r.status_code == 200
