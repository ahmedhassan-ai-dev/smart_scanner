
from pydantic import BaseModel


class PdfPage(BaseModel):
    page_id: str
    filter_name: str | None = None
    variant: str | None = None


class PDFRequest(BaseModel):

    use_single_filter: bool = True

    filter_name: str | None = None

    variant: str | None = None

    pages: list[PdfPage]