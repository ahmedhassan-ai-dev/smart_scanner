import cv2
import numpy as np
from rembg import remove


def order_points(pts):
    rect = np.zeros((4, 2), dtype="float32")

    s = pts.sum(axis=1)
    rect[0] = pts[np.argmin(s)]
    rect[2] = pts[np.argmax(s)]

    diff = np.diff(pts, axis=1)
    rect[1] = pts[np.argmin(diff)]
    rect[3] = pts[np.argmax(diff)]

    return rect


def perspective_transform(image, pts):
    rect = order_points(pts)

    (tl, tr, br, bl) = rect

    maxW = int(
        max(
            np.linalg.norm(br - bl),
            np.linalg.norm(tr - tl)
        )
    )

    maxH = int(
        max(
            np.linalg.norm(tr - br),
            np.linalg.norm(tl - bl)
        )
    )

    if maxW < 10 or maxH < 10:
        return image

    dst = np.array(
        [
            [0, 0],
            [maxW - 1, 0],
            [maxW - 1, maxH - 1],
            [0, maxH - 1]
        ],
        dtype="float32"
    )

    matrix = cv2.getPerspectiveTransform(
        rect,
        dst
    )

    return cv2.warpPerspective(
        image,
        matrix,
        (maxW, maxH)
    )


def detect_document(image):

    ratio = image.shape[0] / 500.0

    original = image.copy()

    resized = cv2.resize(
        image,
        (
            int(image.shape[1] / ratio),
            500
        )
    )

    mask = remove(
        resized,
        only_mask=True
    )

    _, mask_bin = cv2.threshold(
        mask,
        127,
        255,
        cv2.THRESH_BINARY
    )

    kernel = np.ones((9, 9), np.uint8)

    mask_bin = cv2.morphologyEx(
        mask_bin,
        cv2.MORPH_CLOSE,
        kernel
    )

    mask_bin = cv2.morphologyEx(
        mask_bin,
        cv2.MORPH_OPEN,
        kernel
    )

    contours, _ = cv2.findContours(
        mask_bin,
        cv2.RETR_EXTERNAL,
        cv2.CHAIN_APPROX_SIMPLE
    )

    if not contours:
        return None

    contour = max(
        contours,
        key=cv2.contourArea
    )

    if cv2.contourArea(contour) < (
        resized.shape[0]
        * resized.shape[1]
        * 0.05
    ):
        return None

    hull = cv2.convexHull(contour)

    perimeter = cv2.arcLength(
        hull,
        True
    )

    screenCnt = None

    for eps in np.linspace(
        0.01,
        0.1,
        30
    ):

        approx = cv2.approxPolyDP(
            hull,
            eps * perimeter,
            True
        )

        if len(approx) == 4:
            screenCnt = approx
            break

    if screenCnt is None:

        rect = cv2.minAreaRect(hull)

        box = cv2.boxPoints(rect)

        screenCnt = np.array(
            box,
            dtype="int32"
        ).reshape(4, 1, 2)

    return perspective_transform(
        original,
        screenCnt.reshape(4, 2) * ratio
    )