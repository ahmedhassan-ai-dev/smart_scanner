import cv2
import numpy as np

def smart_crop(image):

    gray = (
        cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        if len(image.shape) == 3
        else image.copy()
    )

    h_img, w_img = gray.shape[:2]

    _, white_mask = cv2.threshold(
        gray,
        150,
        255,
        cv2.THRESH_BINARY
    )

    kernel = np.ones((15, 15), np.uint8)

    white_mask = cv2.morphologyEx(
        white_mask,
        cv2.MORPH_CLOSE,
        kernel
    )

    white_mask = cv2.morphologyEx(
        white_mask,
        cv2.MORPH_OPEN,
        kernel
    )

    contours, _ = cv2.findContours(
        white_mask,
        cv2.RETR_EXTERNAL,
        cv2.CHAIN_APPROX_SIMPLE
    )

    if contours:

        largest = max(
            contours,
            key=cv2.contourArea
        )

        if cv2.contourArea(largest) > (
            h_img * w_img * 0.15
        ):

            x, y, w, h = cv2.boundingRect(
                largest
            )

            pad = 5

            y1 = max(0, y - pad)
            y2 = min(h_img, y + h + pad)

            x1 = max(0, x - pad)
            x2 = min(w_img, x + w + pad)

            cropped = image[
                y1:y2,
                x1:x2
            ]

            if (
                cropped.shape[0]
                * cropped.shape[1]
                >= h_img * w_img * 0.2
            ):
                return cropped

    _, binary = cv2.threshold(
        gray,
        240,
        255,
        cv2.THRESH_BINARY_INV
    )

    binary = cv2.morphologyEx(
        binary,
        cv2.MORPH_CLOSE,
        np.ones((5, 5), np.uint8)
    )

    coords = cv2.findNonZero(binary)

    if coords is None:
        return image

    x, y, w, h = cv2.boundingRect(coords)

    pad = 10

    cropped = image[
        max(0, y - pad):min(h_img, y + h + pad),
        max(0, x - pad):min(w_img, x + w + pad)
    ]

    if (
        cropped.shape[0]
        * cropped.shape[1]
        >= h_img * w_img * 0.2
    ):
        return cropped

    return image