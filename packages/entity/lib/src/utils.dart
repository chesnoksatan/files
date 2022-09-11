import 'dart:io' show Platform;

import 'package:flutter/material.dart' show Icons, IconData;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mime/mime.dart' show lookupMimeType;

const Map<String, IconData> iconsPerMime = {
  "application/java-archive": MdiIcons.languageJava,
  "application/json": MdiIcons.codeBraces,
  "application/msword": MdiIcons.fileWordOutline,
  "application/octet-stream": MdiIcons.fileDocumentOutline,
  "application/pdf": MdiIcons.fileDocumentOutline,
  "application/vnd.microsoft.portable-executable": MdiIcons.microsoftWindows,
  "application/vnd.ms-excel": MdiIcons.fileExcelOutline,
  "application/vnd.ms-powerpoint": MdiIcons.filePowerpointOutline,
  "application/vnd.openxmlformats-officedocument.presentationml.presentation":
      MdiIcons.filePowerpointOutline,
  "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet":
      MdiIcons.fileExcelOutline,
  "application/vnd.openxmlformats-officedocument.wordprocessingml.document":
      MdiIcons.fileWordOutline,
  "application/vnd.rar": MdiIcons.zipBoxOutline,
  "application/x-7z-compressed": MdiIcons.zipBoxOutline,
  "application/x-iso9660-image": MdiIcons.disc,
  "application/x-msdownload": MdiIcons.microsoftWindows,
  "application/x-rar-compressed": MdiIcons.zipBoxOutline,
  "application/x-sql": MdiIcons.databaseOutline,
  "application/zip": MdiIcons.zipBoxOutline,
  "audio/mpeg": MdiIcons.fileMusicOutline,
  "audio/ogg": MdiIcons.fileMusicOutline,
  "image/gif": Icons.animation,
  "image/jpeg": MdiIcons.fileImageOutline,
  "image/png": MdiIcons.fileImageOutline,
  "image/svg+xml": MdiIcons.svg,
  "text/css": MdiIcons.fileCodeOutline,
  "text/csv": MdiIcons.fileDocumentOutline,
  "text/javascript": MdiIcons.languageJavascript,
  "text/html": MdiIcons.languageHtml5,
  "text/plain": MdiIcons.fileDocumentOutline,
  "video/mp4": MdiIcons.fileVideoOutline,
  "video/ogg": MdiIcons.fileVideoOutline,
};

class Utils {
  Utils._();

  static IconData getIconForPath(String path) {
    return iconsPerMime[getMimeType(path)] ?? Icons.insert_drive_file_outlined;
  }

  static IconData getIconForMimeType(String mimeType) {
    return iconsPerMime[mimeType] ?? Icons.insert_drive_file_outlined;
  }

  // The "octet-stream" subtype is used to indicate that a body contains arbitrary binary data.
  static String getMimeType(String path) {
    return lookupMimeType(path) ?? "application/octet-stream";
  }

  static String getEntityName(String path) {
    return path.split(Platform.pathSeparator).last;
  }
}
