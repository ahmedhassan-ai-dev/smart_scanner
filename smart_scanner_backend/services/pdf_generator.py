import io


def generate_pdf(images):

    buffer = io.BytesIO()

    images = [
        img.convert("RGB")
        for img in images
    ]

    if len(images) == 1:

        images[0].save(
            buffer,
            format="PDF"
        )

    else:

        images[0].save(
            buffer,
            format="PDF",
            save_all=True,
            append_images=images[1:]
        )

    buffer.seek(0)

    return buffer