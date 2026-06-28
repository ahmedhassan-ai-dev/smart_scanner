from pydantic import BaseModel


class ScanResponse(BaseModel):

    filename: str
    filters: list[str]
    message: str