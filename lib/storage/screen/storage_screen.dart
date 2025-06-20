import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listin/authentication/component/show_snackbar.dart';
import 'package:listin/storage/services/storage_service.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  String? urlPhoto;
  List<String> listFiles = [];

  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Foto de Perfil"),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () => uploadImage(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => reload(),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(32),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            (urlPhoto != null)
                ? Image.network(urlPhoto!)
                : const CircleAvatar(radius: 64, child: Icon(Icons.person)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Divider(color: Colors.black),
            ),
            Text(
              "Histórico de Imagens",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Column(
              children: List.generate(listFiles.length, (index) {
                String url = listFiles[index];
                return Image.network(url);
              }),
            ),
          ],
        ),
      ),
    );
  }

  uploadImage() {
    ImagePicker imagePicker = ImagePicker();
    imagePicker
        .pickImage(
          source: ImageSource.gallery,
          maxHeight: 2000,
          maxWidth: 2000,
          imageQuality: 50,
        )
        .then((XFile? image) {
          if (image != null) {
            _storageService
                .upload(file: File(image.path), fileName: "user_photo")
                .then((value) => reload());
          } else {
            showSnackBar(
              context: context,
              mensagem: "Nenhuma imagem não selecionada.",
            );
          }
        });
  }

  reload() {
    _storageService.getDownloadUrlByFileName(fileName: "user_photo").then((
      urlDownload,
    ) {
      setState(() {
        urlPhoto = urlDownload;
      });
    });
  }
}
