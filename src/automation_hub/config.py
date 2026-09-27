"""Settings read from environment; never store credentials in source control."""
import os
from dataclasses import dataclass


@dataclass(frozen=True)
class Settings:
    hub_api_key: str = ""
    enable_live: bool = False
    max_estimated_total_tokens: int = 4096
    llm_base_url: str = ""
    llm_api_key: str = ""
    llm_model: str = ""

    @classmethod
    def from_env(cls) -> "Settings":
        return cls(
            hub_api_key=os.getenv("HUB_API_KEY", ""),
            enable_live=os.getenv("ENABLE_LIVE", "false").lower() == "true",
            max_estimated_total_tokens=int(os.getenv("MAX_ESTIMATED_TOTAL_TOKENS", "4096")),
            llm_base_url=os.getenv("LLM_BASE_URL", ""),
            llm_api_key=os.getenv("LLM_API_KEY", ""),
            llm_model=os.getenv("LLM_MODEL", ""),
        )
