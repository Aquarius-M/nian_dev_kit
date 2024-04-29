import 'dart:convert';

const iconData =
    r'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';

final iconBytes = base64Decode(iconData);