import cv2
from PIL import Image


def to_rgb(image):

    if len(image.shape) == 2:
        return cv2.cvtColor(
            image,
            cv2.COLOR_GRAY2RGB
        )

    return cv2.cvtColor(
        image,
        cv2.COLOR_BGR2RGB
    )


def to_pil(image):

    if len(image.shape) == 2:
        return Image.fromarray(
            image
        ).convert("RGB")

    return Image.fromarray(
        cv2.cvtColor(
            image,
            cv2.COLOR_BGR2RGB
        )
    )