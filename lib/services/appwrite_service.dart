import 'package:appwrite/appwrite.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class AppwriteService {
  final Client client = Client();
  final Storage storage;

  AppwriteService()
      : storage = Storage(Client()) {
    client
        .setEndpoint('https://fra.cloud.appwrite.io/v1') // Replace with your Appwrite endpoint
        .setProject('68109a3900149fa4e09b'); // Replace with your project ID
  }


  Future<String?> uploadImage(String bucketId, String filePath) async {
    try {
      InputFile file;

      if (kIsWeb) {
        // For Flutter Web, read the file as bytes
        final uri = Uri.parse(filePath);
        final response = await http.get(uri);
        final Uint8List fileBytes = response.bodyBytes;

        file = InputFile.fromBytes(
          filename: filePath.split('/').last,
          bytes: fileBytes,
        );
      } else {
        // For mobile platforms, use the file path
        file = InputFile.fromPath(path: filePath);
      }

      final result = await storage.createFile(
        bucketId: bucketId,
        fileId: 'unique()',
        file: file,
      );
      return result.$id;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  String getImageUrl(String bucketId, String fileId) {
    return '${client.endPoint}/storage/buckets/$bucketId/files/$fileId/view';
  }
}