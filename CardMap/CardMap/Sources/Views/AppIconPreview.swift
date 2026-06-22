import SwiftUI

struct AppIconPreview: View {
    var body: some View {
        VStack(spacing: 24) {
            AppIconShape()
                .frame(width: 256, height: 256)
                .clipShape(RoundedRectangle(cornerRadius: 256 * 0.2237, style: .continuous))

            AppIconShape()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 120 * 0.2237, style: .continuous))

            AppIconShape()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 60 * 0.2237, style: .continuous))
        }
        .padding(32)
        .background(Color(white: 0.15))
    }
}

struct AppIconShape: View {
    var body: some View {
        GeometryReader { geo in
            let s = geo.size.width

            ZStack {
                // Background
                Rectangle()
                    .fill(Color(hex: "#1C3A5E"))

                // Map pin
                MapPinShape()
                    .fill(Color(hex: "#2C6FBF"))
                    .frame(width: s * 0.56, height: s * 0.68)
                    .offset(y: -s * 0.04)

                // Card
                CardShape(size: s)
                    .offset(y: -s * 0.13)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Map Pin

struct MapPinShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let r = w / 2                  // circle radius
        let cx = rect.midX
        let circleBottom = r * 2       // bottom of circle

        // Circle portion (top)
        path.addArc(
            center: CGPoint(x: cx, y: r),
            radius: r,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )

        // Right side down to tip
        path.addQuadCurve(
            to: CGPoint(x: cx, y: h),
            control: CGPoint(x: cx + r, y: circleBottom + (h - circleBottom) * 0.5)
        )

        // Left side back up
        path.addQuadCurve(
            to: CGPoint(x: cx - r, y: r),
            control: CGPoint(x: cx - r, y: circleBottom + (h - circleBottom) * 0.5)
        )

        path.closeSubpath()
        return path
    }
}

// MARK: - Credit Card inside pin

struct CardShape: View {
    let size: CGFloat

    private var cardW: CGFloat { size * 0.40 }
    private var cardH: CGFloat { size * 0.26 }
    private var corner: CGFloat { size * 0.03 }

    private var chipW: CGFloat { size * 0.09 }
    private var chipH: CGFloat { size * 0.065 }
    private var chipCorner: CGFloat { size * 0.015 }

    private var stripeW: CGFloat { size * 0.13 }
    private var stripeH: CGFloat { size * 0.018 }

    var body: some View {
        ZStack {
            // Card body
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .fill(Color.white)
                .frame(width: cardW, height: cardH)

            // Chip
            RoundedRectangle(cornerRadius: chipCorner, style: .continuous)
                .fill(Color(hex: "#F0C040"))
                .frame(width: chipW, height: chipH)
                .offset(x: -cardW * 0.24, y: cardH * 0.02)

            // Stripe 1
            Capsule()
                .fill(Color(hex: "#CCCCCC"))
                .frame(width: stripeW, height: stripeH)
                .offset(x: cardW * 0.18, y: -cardH * 0.1)

            // Stripe 2
            Capsule()
                .fill(Color(hex: "#CCCCCC"))
                .frame(width: stripeW, height: stripeH)
                .offset(x: cardW * 0.18, y: cardH * 0.1)
        }
    }
}

// MARK: - Hex color helper

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    AppIconPreview()
}
