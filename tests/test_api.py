from fastapi.testclient import TestClient

from automation_hub.app import create_app
from automation_hub.config import Settings

SECRET = "a-test-secret-that-has-more-than-32-characters"
PAYLOAD = {"task_type": "summarize", "input": "This is a test."}


def client(**changes):
    settings = Settings(hub_api_key=SECRET, **changes)
    return TestClient(create_app(settings))


def test_health():
    assert client().get("/health").json() == {"status": "ok"}


def test_missing_authentication_rejected():
    response = client().post("/v1/tasks/execute", json=PAYLOAD)
    assert response.status_code == 401


def test_unconfigured_secret_blocks_requests():
    response = TestClient(create_app(Settings())).post(
        "/v1/tasks/execute", json=PAYLOAD, headers={"X-Hub-Key": SECRET}
    )
    assert response.status_code == 503


def test_dry_run_does_not_call_provider():
    response = client().post(
        "/v1/tasks/execute", json=PAYLOAD, headers={"X-Hub-Key": SECRET}
    )
    assert response.status_code == 200
    assert response.json()["status"] == "simulated"
    assert response.json()["billable_request_sent"] is False


def test_live_disabled_by_default():
    response = client().post(
        "/v1/tasks/execute", json={**PAYLOAD, "dry_run": False},
        headers={"X-Hub-Key": SECRET},
    )
    assert response.status_code == 403


def test_token_allowance_applies_before_gateway():
    response = client(max_estimated_total_tokens=100).post(
        "/v1/tasks/execute", json=PAYLOAD, headers={"X-Hub-Key": SECRET}
    )
    assert response.status_code == 422


def test_invalid_task_rejected():
    response = client().post(
        "/v1/tasks/execute",
        json={"task_type": "execute_shell", "input": "whoami"},
        headers={"X-Hub-Key": SECRET},
    )
    assert response.status_code == 422

def test_placeholder_key_rejected():
    from automation_hub.config import Settings
    placeholder = "REPLACE_WITH_A_RANDOM_32_CHAR_OR_LONGER_SECRET"
    response = TestClient(create_app(Settings(hub_api_key=placeholder))).post(
        "/v1/tasks/execute", json=PAYLOAD, headers={"X-Hub-Key": placeholder}
    )
    assert response.status_code == 503
