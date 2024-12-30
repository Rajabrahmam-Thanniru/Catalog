import 'dart:convert';
import 'dart:io';

Future<Map<String, dynamic>> readJsonFile(String path) async {
  final file = File(path);
  final contents = await file.readAsString();
  return jsonDecode(contents);
}

BigInt decodeValue(String value, int base) {
  return BigInt.parse(value, radix: base);
}

Map<int, BigInt> decodeRoots(Map<String, dynamic> json) {
  Map<int, BigInt> roots = {};
  json.forEach((key, value) {
    if (key != "keys") {
      int x = int.parse(key);
      int base = int.parse(value["base"]);
      BigInt y = decodeValue(value["value"], base);
      roots[x] = y;
    }
  });
  return roots;
}

BigInt lagrangeInterpolation(Map<int, BigInt> roots, int k) {
  List<int> xValues = roots.keys.toList().sublist(0, k);
  List<BigInt> yValues = roots.values.toList().sublist(0, k);

  BigInt c = BigInt.zero;
  for (int j = 0; j < k; j++) {
    BigInt term = yValues[j];
    for (int i = 0; i < k; i++) {
      if (i != j) {
        BigInt numerator = BigInt.from(-xValues[i]);
        BigInt denominator = BigInt.from(xValues[j] - xValues[i]);
        term = term * numerator ~/ denominator;
      }
    }
    c += term;
  }
  return c;
}

Future<void> main() async {
  final filePath1 = 'TestCase 01.json';
  final filePath2 = 'TestCase 02.json';

  final json1 = await readJsonFile(filePath1);
  final json2 = await readJsonFile(filePath2);

  // Decode roots
  Map<int, BigInt> roots1 = decodeRoots(json1);
  Map<int, BigInt> roots2 = decodeRoots(json2);

  // Extract k from the keys
  int k1 = json1["keys"]["k"];
  int k2 = json2["keys"]["k"];

  // Calculate the constant term (c) for each test case
  BigInt c1 = lagrangeInterpolation(roots1, k1);
  BigInt c2 = lagrangeInterpolation(roots2, k2);

  // Print the results
  print("Secret for Test Case 1: $c1");
  print("Secret for Test Case 2: $c2");
}
