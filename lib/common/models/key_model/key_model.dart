// ignore_for_file: public_member_api_docs, sort_constructors_first
class KeyModel {
  final String label;
  final int offset;

  KeyModel({
    required this.label,
    this.offset = 1,
  });

  factory KeyModel.fromLabel(String label) {
    int index = label.indexOf('(');
    int offset = (index != -1 && label.length > 1) ? index + 1 : label.length;

    return KeyModel(label: label, offset: offset);
  }

  @override
  String toString() => 'KeyModel(label: $label, offset: $offset)';
}
