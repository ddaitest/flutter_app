import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_app/common/utils.dart';
import 'package:flutter_app/manager/beans.dart';
import 'package:flutter_app/manager/main_model.dart';
import 'package:flutter_app/common/common.dart';
import 'package:flutter_app/common/ItemView2.dart';
import 'package:flutter_app/pages/base_page.dart';
import 'package:flutter_app/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:url_launcher/url_launcher.dart';

class FirstTab extends BasePage {
  FirstTab() : super(PageType.FindPassenger);
}

class SecondTab extends BasePage {
  SecondTab() : super(PageType.FindVehicle);
}
