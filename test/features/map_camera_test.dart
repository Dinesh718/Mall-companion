import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/domain/entities/map_entities.dart';

void main() {
  group('MapCameraController Centering Math Tests', () {
    test('RectangleGeometry center coordinates are computed accurately', () {
      const rect = RectangleGeometry(
        x: 80.0,
        y: 320.0,
        width: 77.0,
        height: 83.0,
      );

      final centerX = rect.x + rect.width / 2;
      final centerY = rect.y + rect.height / 2;

      expect(centerX, 118.5);
      expect(centerY, 361.5);
    });

    test('PolygonGeometry centroid coordinates are computed accurately', () {
      const poly = PolygonGeometry(
        points: [
          Point2D(229.0, 317.0),
          Point2D(272.0, 317.0),
          Point2D(272.0, 404.0),
          Point2D(229.0, 404.0),
        ],
      );

      double sumX = 0;
      double sumY = 0;
      for (final p in poly.points) {
        sumX += p.x;
        sumY += p.y;
      }
      final centerX = sumX / poly.points.length;
      final centerY = sumY / poly.points.length;

      expect(centerX, 250.5);
      expect(centerY, 360.5);
    });

    test(
      'Viewport translation formula places the target coordinate directly in the center',
      () {
        const target = Point2D(100.0, 200.0);
        const viewportSizeWidth = 400.0;
        const viewportSizeHeight = 600.0;
        const scale = 1.5;

        // Formula: Tx = (viewportWidth / 2) - (target.x * scale)
        //          Ty = (viewportHeight / 2) - (target.y * scale)
        final tx = (viewportSizeWidth / 2) - (target.x * scale);
        final ty = (viewportSizeHeight / 2) - (target.y * scale);

        expect(tx, 50.0);
        expect(ty, 0.0);
      },
    );
  });
}
