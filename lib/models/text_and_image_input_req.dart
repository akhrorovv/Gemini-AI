// To parse this JSON data, do
//
//     final textAndImageInputReq = textAndImageInputReqFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

TextAndImageInputReq textAndImageInputReqFromJson(String str) =>
    TextAndImageInputReq.fromJson(json.decode(str));

String textAndImageInputReqToJson(TextAndImageInputReq data) =>
    json.encode(data.toJson());

class TextAndImageInputReq {
  List<Content2> contents;

  TextAndImageInputReq({
    required this.contents,
  });

  factory TextAndImageInputReq.fromJson(Map<String, dynamic> json) =>
      TextAndImageInputReq(
        contents: List<Content2>.from(
            json["contents"].map((x) => Content2.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "contents": List<dynamic>.from(contents.map((x) => x.toJson())),
      };
}

class Content2 {
  List<Part2> parts;

  Content2({
    required this.parts,
  });

  factory Content2.fromJson(Map<String, dynamic> json) => Content2(
        parts: List<Part2>.from(json["parts"].map((x) => Part2.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "parts": List<dynamic>.from(parts.map((x) => x.toJson())),
      };
}

class Part2 {
  String text;
  InlineData? inline_data;

  Part2({
    required this.text,
    required this.inline_data,
  });

  factory Part2.fromJson(Map<String, dynamic> json) => Part2(
        text: "text",
        inline_data: InlineData.fromJson(json["inline_data"]),
      );

  Map<String, dynamic> toJson() => inline_data != null
      ? {
          "text": text,
          "inline_data": inline_data!.toJson(),
        }
      : {
          "text": text,
        };
}

class InlineData {
  String mime_type;
  String data;

  InlineData({
    required this.mime_type,
    required this.data,
  });

  factory InlineData.fromJson(Map<String, dynamic> json) => InlineData(
        mime_type: json["mime_type"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "mime_type": mime_type,
        "data": data,
      };
}
