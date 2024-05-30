// To parse this JSON data, do
//
//     final textOnlyInputReq = textOnlyInputReqFromJson(jsonString);

import 'dart:convert';

TextOnlyInputReq textOnlyInputReqFromJson(String str) => TextOnlyInputReq.fromJson(json.decode(str));

String textOnlyInputReqToJson(TextOnlyInputReq data) => json.encode(data.toJson());

class TextOnlyInputReq {
  List<Content> contents;

  TextOnlyInputReq({
    required this.contents,
  });

  factory TextOnlyInputReq.fromJson(Map<String, dynamic> json) => TextOnlyInputReq(
    contents: List<Content>.from(json["contents"].map((x) => Content.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "contents": List<dynamic>.from(contents.map((x) => x.toJson())),
  };
}

class Content {
  List<Part> parts;

  Content({
    required this.parts,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    parts: List<Part>.from(json["parts"].map((x) => Part.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "parts": List<dynamic>.from(parts.map((x) => x.toJson())),
  };
}

class Part {
  String text;

  Part({
    required this.text,
  });

  factory Part.fromJson(Map<String, dynamic> json) => Part(
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
  };
}
