/*
Copyright 2019 The dahliaOS Authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

//credits: @HrX03 for basic UI https://github.com/HrX03/Flux

import 'package:files/backend/providers.dart';
import 'package:files/files_app.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // probably move init in FilesApp constructor, for creating this app from Pangolin Desktop
  initProvidersSync();
  runApp(const FilesApp());
}
