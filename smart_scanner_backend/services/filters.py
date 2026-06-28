import cv2
import numpy as np


def to_gray(img):
    return cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)


def pure_white(img):
    _, bw = cv2.threshold(
        to_gray(img),
        180,
        255,
        cv2.THRESH_BINARY
    )
    return bw


def dark_text(img):
    return cv2.convertScaleAbs(
        to_gray(img),
        alpha=1.5
    )


def smooth_scan(img):
    return cv2.GaussianBlur(
        to_gray(img),
        (5, 5),
        0
    )


def ocr_mode(img):
    return cv2.adaptiveThreshold(
        to_gray(img),
        255,
        cv2.ADAPTIVE_THRESH_MEAN_C,
        cv2.THRESH_BINARY,
        11,
        2
    )


def notebook_mode(img):
    return cv2.createCLAHE(
        4,
        (8, 8)
    ).apply(
        to_gray(img)
    )


def sharp_text(img):

    kernel = np.array(
        [
            [0, -1, 0],
            [-1, 5, -1],
            [0, -1, 0]
        ]
    )

    return cv2.filter2D(
        to_gray(img),
        -1,
        kernel
    )


def warm_paper(img):
    x = img.copy()
    x[:, :, 2] = cv2.add(
        x[:, :, 2],
        20
    )
    return x


def cool_paper(img):
    x = img.copy()
    x[:, :, 0] = cv2.add(
        x[:, :, 0],
        20
    )
    return x


def pencil_scan(img):

    gray = to_gray(img)

    return cv2.divide(
        gray,
        255 - cv2.GaussianBlur(
            255 - gray,
            (21, 21),
            0
        ),
        scale=256
    )


def hd_scan(img):

    return cv2.detailEnhance(
        img,
        sigma_s=20,
        sigma_r=0.2
    )


def text_bold(img):

    _, bw = cv2.threshold(
        to_gray(img),
        160,
        255,
        cv2.THRESH_BINARY
    )

    return cv2.erode(
        bw,
        np.ones((2, 2), np.uint8),
        iterations=1
    )


def high_contrast(img):

    return cv2.convertScaleAbs(
        to_gray(img),
        alpha=1.8
    )


def light_paper(img):

    return cv2.convertScaleAbs(
        to_gray(img),
        alpha=1,
        beta=35
    )


def anti_shadow(img):

    gray = to_gray(img)

    return cv2.divide(
        gray,
        cv2.GaussianBlur(
            gray,
            (51, 51),
            0
        ),
        scale=255
    )


def premium_mode(img):

    x = cv2.createCLAHE(
        3,
        (8, 8)
    ).apply(
        to_gray(img)
    )

    return cv2.adaptiveThreshold(
        x,
        255,
        cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
        cv2.THRESH_BINARY,
        15,
        8
    )


def doc_white(img):

    gray = to_gray(img)

    normalized = cv2.divide(
        gray,
        cv2.GaussianBlur(
            gray,
            (35, 35),
            0
        ),
        scale=255
    )

    return cv2.adaptiveThreshold(
        normalized,
        255,
        cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
        cv2.THRESH_BINARY,
        21,
        10
    )


def ultra_clean(img):

    _, bw = cv2.threshold(
        to_gray(img),
        0,
        255,
        cv2.THRESH_BINARY + cv2.THRESH_OTSU
    )

    return bw


def ink_boost(img):

    gray = to_gray(img)

    return cv2.convertScaleAbs(
        gray - 0.8 * cv2.Laplacian(
            gray,
            cv2.CV_64F
        )
    )


def baseline_enhance(img):

    return cv2.createCLAHE(
        clipLimit=2.0,
        tileGridSize=(8, 8)
    ).apply(
        to_gray(img)
    )


ALL_FILTERS = {
    "Doc White": doc_white,
    "Anti Shadow": anti_shadow,
    "Premium Scanner": premium_mode,
    "Notebook Mode": notebook_mode,
    "HD Scan": hd_scan,
    "OCR Mode": ocr_mode,
    "Ink Boost": ink_boost,
    "Ultra Clean": ultra_clean,
     "Pure White": pure_white,
    "Dark Text": dark_text,
    "Smooth Scan": smooth_scan,
    "Sharp Text": sharp_text,
    "High Contrast": high_contrast,
    "Warm Paper": warm_paper,
    "Cool Paper": cool_paper,
    "Pencil Scan": pencil_scan,
    "Text Bold": text_bold,
    "Light Paper": light_paper,
  
}