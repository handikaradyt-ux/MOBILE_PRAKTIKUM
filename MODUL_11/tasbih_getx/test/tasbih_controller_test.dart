import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tasbih_getx/viewmodel/tasbih_controller.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  group('TasbihController Unit Tests', () {
    test('Nilai awal counter dan progress harus bernilai 0', () {
      final controller = TasbihController();
      expect(controller.counter.value, 0.0);
      expect(controller.progress.value, 0.0);
      expect(controller.maxCount, 33.0);
    });

    test('Increment satu kali menambah counter menjadi 1 dan progress proporsional', () {
      final controller = TasbihController();
      controller.incrementCounter();
      expect(controller.counter.value, 1.0);
      expect(controller.progress.value, closeTo((1 / 33.0) * 100, 0.01));
    });

    test('17 ketukan menghasilkan nilai 17 dan progress sekitar 51.5%', () {
      final controller = TasbihController();
      for (int i = 0; i < 17; i++) {
        controller.incrementCounter();
      }
      expect(controller.counter.value, 17.0);
      expect(controller.progress.value, closeTo(51.515, 0.01));
    });

    test('33 ketukan mencapai batas maksimum 33 dan progress 100%', () {
      final controller = TasbihController();
      for (int i = 0; i < 33; i++) {
        controller.incrementCounter();
      }
      expect(controller.counter.value, 33.0);
      expect(controller.progress.value, 100.0);
    });

    test(
      'Ketukan setelah batas 33 tidak boleh menambah nilai (tetap 33 dan 100%)',
      () {
        final controller = TasbihController();
        for (int i = 0; i < 35; i++) {
          controller.incrementCounter();
        }
        expect(controller.counter.value, 33.0);
        expect(controller.progress.value, 100.0);
      },
    );

    test('Reset mengembalikan counter dan progress kembali ke 0', () {
      final controller = TasbihController();
      for (int i = 0; i < 20; i++) {
        controller.incrementCounter();
      }
      expect(controller.counter.value, 20.0);
      expect(controller.progress.value, greaterThan(0));

      controller.resetCounter();
      expect(controller.counter.value, 0.0);
      expect(controller.progress.value, 0.0);
    });
  });
}
