import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() =>
      _CameraScreenState();
}

class _CameraScreenState
    extends State<CameraScreen> {

  List<CameraDescription> cameras = [];

  CameraController? controller;

  int selectedCameraIndex = 0;

  FlashMode flashMode = FlashMode.off;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {

    cameras = await availableCameras();

    controller = CameraController(
      cameras[selectedCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller!.initialize();

    setState(() {
      loading = false;
    });
  }

  Future<void> switchCamera() async {

    selectedCameraIndex =
        selectedCameraIndex == 0
            ? 1
            : 0;

    await controller?.dispose();

    controller = CameraController(
      cameras[selectedCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller!.initialize();

    setState(() {});
  }

  Future<void> toggleFlash() async {

    if (flashMode == FlashMode.off) {

      flashMode = FlashMode.torch;

    } else {

      flashMode = FlashMode.off;
    }

    await controller?.setFlashMode(
      flashMode,
    );

    setState(() {});
  }

  Future<void> capture() async {

    if (controller == null) return;

    final image =
        await controller!.takePicture();

    if (!mounted) return;

    Navigator.pop(
      context,
      image.path,
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (loading ||
        controller == null ||
        !controller!.value.isInitialized) {

      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [

                IconButton(
                  onPressed: toggleFlash,
                  icon: Icon(
                    flashMode == FlashMode.off
                        ? Icons.flash_off
                        : Icons.flash_on,
                  ),
                ),

                IconButton(
                  onPressed: switchCamera,
                  icon: const Icon(
                    Icons.cameraswitch,
                  ),
                ),
              ],
            ),

            Expanded(
              child: CameraPreview(
                controller!,
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.all(20),

              child: FloatingActionButton(
                onPressed: capture,
                child: const Icon(
                  Icons.camera_alt,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
