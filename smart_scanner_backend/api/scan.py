from fastapi import (
    APIRouter,
    UploadFile,
    File,
    HTTPException
)

import os
import uuid
import cv2
import numpy as np
import time

from app.services.document_detector import detect_document
from app.services.smart_crop import smart_crop

from app.schemas.pdf_request import PDFRequest
from PIL import Image

from app.services.filters import (
    baseline_enhance,
    ALL_FILTERS
)

from app.services.metrics import (
    calc_sharpness,
    calc_contrast,
    calc_brightness
)

router = APIRouter(
    prefix="/scan",
    tags=["Scanner"]
)


@router.get("/health")
def health():
    return {"status": "ok"}


@router.post("/upload")
async def upload_image(
    file: UploadFile = File(...)
):

    try:
        content = await file.read()

        npimg = np.frombuffer(content, np.uint8)

        image = cv2.imdecode(npimg, cv2.IMREAD_COLOR)

        if image is None:
            raise HTTPException(
                status_code=400,
                detail="Invalid image"
            )

        # -----------------------------
        # Pipeline
        # -----------------------------

        detected = detect_document(image)
        if detected is None:
            detected = image.copy()

        cropped = smart_crop(detected)
        
        # Apply baseline enhancement to both original and cropped
        original_baseline = baseline_enhance(detected)
        cropped_baseline = baseline_enhance(cropped)

        page_id = str(uuid.uuid4())

        image_folder = os.path.join("outputs", page_id)
        os.makedirs(image_folder, exist_ok=True)

        results = {}
        metrics = {}

        # Organize results by variant (original and cropped)
        results["original"] = {}
        results["cropped"] = {}
        metrics["original"] = {}
        metrics["cropped"] = {}

        # ========================================
        # ORIGINAL IMAGE PROCESSING
        # ========================================
        
        # Save Original
        original_path = os.path.join(image_folder, "original.jpg")
        cv2.imwrite(original_path, detected)
        results["original"]["image"] = f"/outputs/{page_id}/original.jpg"

        # Save Original Baseline
        original_baseline_path = os.path.join(image_folder, "original_baseline.jpg")
        cv2.imwrite(original_baseline_path, original_baseline)
        results["original"]["baseline"] = f"/outputs/{page_id}/original_baseline.jpg"
        metrics["original"]["baseline"] = {
            "sharpness": calc_sharpness(original_baseline),
            "contrast": calc_contrast(original_baseline),
            "brightness": calc_brightness(original_baseline)
        }

        # Apply Filters to Original
        results["original"]["filters"] = {}
        metrics["original"]["filters"] = {}
        for name, func in ALL_FILTERS.items():
            filtered = func(detected)
            safe_name = name.lower().replace(" ", "_")
            filename = f"original_{safe_name}.jpg"
            path = os.path.join(image_folder, filename)
            cv2.imwrite(path, filtered)
            results["original"]["filters"][name] = f"/outputs/{page_id}/{filename}"
            metrics["original"]["filters"][name] = {
                "sharpness": calc_sharpness(filtered),
                "contrast": calc_contrast(filtered),
                "brightness": calc_brightness(filtered)
            }

        # ========================================
        # CROPPED IMAGE PROCESSING
        # ========================================
        
        # Save Cropped
        cropped_path = os.path.join(image_folder, "cropped.jpg")
        cv2.imwrite(cropped_path, cropped)
        results["cropped"]["image"] = f"/outputs/{page_id}/cropped.jpg"

        # Save Cropped Baseline
        cropped_baseline_path = os.path.join(image_folder, "cropped_baseline.jpg")
        cv2.imwrite(cropped_baseline_path, cropped_baseline)
        results["cropped"]["baseline"] = f"/outputs/{page_id}/cropped_baseline.jpg"
        metrics["cropped"]["baseline"] = {
            "sharpness": calc_sharpness(cropped_baseline),
            "contrast": calc_contrast(cropped_baseline),
            "brightness": calc_brightness(cropped_baseline)
        }

        # Apply Filters to Cropped
        results["cropped"]["filters"] = {}
        metrics["cropped"]["filters"] = {}
        for name, func in ALL_FILTERS.items():
            filtered = func(cropped)
            safe_name = name.lower().replace(" ", "_")
            filename = f"cropped_{safe_name}.jpg"
            path = os.path.join(image_folder, filename)
            cv2.imwrite(path, filtered)
            results["cropped"]["filters"][name] = f"/outputs/{page_id}/{filename}"
            metrics["cropped"]["filters"][name] = {
                "sharpness": calc_sharpness(filtered),
                "contrast": calc_contrast(filtered),
                "brightness": calc_brightness(filtered)
            }

        # ========================================
        # Recommendation Engine (based on cropped)
        # ========================================
        filter_scores = {}

        for filter_name, values in metrics["cropped"]["filters"].items():
            score = (
                values["sharpness"] * 0.5 +
                values["contrast"] * 0.4 +
                values["brightness"] * 0.1
            )
            filter_scores[filter_name] = score

        recommended_filter = max(
            filter_scores,
            key=filter_scores.get
        )

        sorted_scores = sorted(
            filter_scores.values(),
            reverse=True
        )

        if len(sorted_scores) > 1:
            best_score = sorted_scores[0]
            second_score = sorted_scores[1]
            confidence = round(
                (best_score / (second_score + 1e-6)) * 100,
                2
            )
        else:
            confidence = 100

        confidence = min(confidence, 99.9)

        # ========================================
        # Response
        # ========================================
        return {
            "status": "success",
            "filename": file.filename,
            "page_id": page_id,
            "images": results,
            "metrics": metrics,
            "recommended_filter": recommended_filter,
            "confidence": confidence,
            "filter_scores": filter_scores
        }

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=str(e)
        )


# ========================================
# PDF Generator
# ========================================
@router.post("/pdf")
async def generate_pdf(request: PDFRequest):

    if len(request.pages) == 0:
        raise HTTPException(
            status_code=400,
            detail="No pages selected"
        )

    images = []

    for page in request.pages:

        if request.use_single_filter:

            filter_name = request.filter_name
            variant = request.variant

            if not filter_name:
                raise HTTPException(
                    status_code=400,
                    detail="filter_name is required"
                )

            if not variant:
                raise HTTPException(
                    status_code=400,
                    detail="variant is required"
                )

        else:

            filter_name = page.filter_name
            variant = page.variant

            if not filter_name:
                raise HTTPException(
                    status_code=400,
                    detail=f"Missing filter_name for page {page.page_id}"
                )

            if not variant:
                raise HTTPException(
                    status_code=400,
                    detail=f"Missing variant for page {page.page_id}"
                )

        safe_filter = (
            filter_name
            .lower()
            .replace(" ", "_")
        )

        filename = f"{variant}_{safe_filter}.jpg"

        image_path = os.path.join(
            "outputs",
            page.page_id,
            filename
        )

        if not os.path.exists(image_path):

            raise HTTPException(
                status_code=404,
                detail=f"File not found: {filename}"
            )

        image = Image.open(
            image_path
        ).convert("RGB")

        images.append(image)

    os.makedirs(
        "outputs/pdfs",
        exist_ok=True
    )

    pdf_name = (
        f"document_{int(time.time())}.pdf"
    )

    pdf_path = os.path.join(
        "outputs",
        "pdfs",
        pdf_name
    )

    if len(images) == 1:

        images[0].save(
            pdf_path,
            "PDF"
        )

    else:

        images[0].save(
            pdf_path,
            save_all=True,
            append_images=images[1:]
        )

    return {
        "status": "success",
        "pdf_url": f"/outputs/pdfs/{pdf_name}"
    }