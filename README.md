# 📄 Smart Scanner AI

An AI-powered document scanner application that transforms ordinary document photos into high-quality scanned PDFs using Image Processing, OCR, and AI-enhanced document enhancement techniques.

---

# ✨ Features

- 📷 Scan documents using Camera
- 🖼 Import images from Gallery
- ✂️ Automatic Document Detection
- 📐 Perspective Correction
- 🎨 Multiple AI Enhancement Filters
- 📝 OCR Text Extraction
- 📄 Multi-page PDF Generation
- 📂 Local Document History
- 📥 Download & Share PDFs
- 📱 Modern Flutter UI

---

# 🏗 Project Architecture

```
smart_scanner/
│
├── backend/        # FastAPI Backend
│
└── mobile/         # Flutter Application
```

---

# 📱 Mobile Application

Built using **Flutter** with a clean and modular architecture.

### Main Screens

- Splash Screen
- Introduction
- Home
- Camera Scanner
- Filter Selection
- PDF Preview
- OCR Result
- Document History
- Settings

### Mobile Features

- Capture documents
- Import from gallery
- Preview processed images
- OCR recognition
- PDF generation
- Local storage using Hive
- Modern Material Design UI

---

# ⚙ Backend

The backend is developed using **FastAPI**.

It is responsible for:

- Receiving uploaded images
- Processing images
- Applying enhancement filters
- Running document detection
- Generating processed images
- Creating PDF-ready outputs

---

# 🤖 AI & Image Processing

The document enhancement pipeline combines multiple computer vision techniques to produce scanner-quality outputs.

## Processing Pipeline

1. Image Upload
2. Grayscale Conversion
3. Noise Reduction
4. Adaptive Thresholding
5. Edge Detection
6. Contour Detection
7. Perspective Transformation
8. Image Enhancement
9. Filter Generation
10. PDF Generation

---

# 🧠 Image Processing Techniques

The project was developed through several experiments until reaching the final pipeline.

### Basic Preprocessing

- Grayscale Conversion
- Global Thresholding

### Noise Reduction

- Gaussian Blur

### Adaptive Enhancement

- Adaptive Thresholding

### Document Detection

- Edge Detection
- Contour Extraction

### Perspective Correction

- Four Point Transform
- Bird-eye View

### Final Enhancement

- Contrast Enhancement
- Sharpening
- Multiple Scanner Filters

The final pipeline combines all previous techniques to generate clean, readable documents similar to professional scanner applications.

---

# 🔍 OCR

Optical Character Recognition is integrated to extract text from scanned images.

Features:

- Text Extraction
- Editable Result
- Fast Recognition

---

# 🛠 Technologies Used

## Mobile

- Flutter
- Dart
- Dio
- Hive
- Image Picker
- Shared Preferences
- Syncfusion PDF Viewer

## Backend

- FastAPI
- Python
- OpenCV
- NumPy
- Pillow

---

# 📂 Project Structure

```
mobile/
│
├── features/
│   ├── scanner/
│   ├── pdf/
│   ├── history/
│   ├── ocr/
│
├── shared/
│
├── screens/
│
└── main.dart
```

---

# 🚀 How to Run

## Backend

```bash
cd backend

pip install -r requirements.txt

uvicorn main:app --reload
```

---

## Mobile

```bash
cd mobile

flutter pub get

flutter run
```

---

# 📸 Screenshots

> Add screenshots here

- Splash Screen
- Home
- Scan Screen
- Filter Screen
- OCR
- PDF Preview
- History

---

# 📈 Future Improvements

- Cloud Storage
- User Authentication
- AI-based Document Classification
- Handwriting Recognition
- Real-time Camera Scanner
- Export to Word
- Dark Mode

---

# 👨‍💻 Author

Ahmed Hassan

Computer Science Student

AI & Mobile Developer

GitHub:
https://github.com/ahmedhassan-ai-dev
