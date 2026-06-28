import cv2


def calc_sharpness(image):

    if len(image.shape) == 3:
        image = cv2.cvtColor(
            image,
            cv2.COLOR_BGR2GRAY
        )

    return round(
        cv2.Laplacian(
            image,
            cv2.CV_64F
        ).var(),
        2
    )


def calc_contrast(image):

    if len(image.shape) == 3:
        image = cv2.cvtColor(
            image,
            cv2.COLOR_BGR2GRAY
        )

    return round(
        image.std(),
        2
    )


def calc_brightness(image):

    if len(image.shape) == 3:
        image = cv2.cvtColor(
            image,
            cv2.COLOR_BGR2GRAY
        )

    return round(
        image.mean(),
        2
    )