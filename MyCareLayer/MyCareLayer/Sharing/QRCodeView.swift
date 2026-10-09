import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

/// QR code for the emergency card. Payload is exactly the same plain
/// text as the text share (see ShareComposer.emergencyCardText) — no
/// separate, hidden data format. Anyone who scans it can read it,
/// and the UI says so plainly before the code is shown.
struct QRCodeView: View {
    let payload: String

    private var qrImage: UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(payload.utf8)
        filter.correctionLevel = "M"
        guard let output = filter.outputImage else { return nil }
        let scaled = output.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Label("Anyone who scans this can read it", systemImage: "exclamationmark.triangle.fill")
                    .font(.headline)
                    .foregroundStyle(CarePalette.warning)
                    .multilineTextAlignment(.center)
                Text("This QR code contains the same text as your Medical Alert Card. Only show it to people you want to have that information.")
                    .font(.body)
                    .foregroundStyle(CarePalette.bodyTextSoft)
                    .multilineTextAlignment(.center)

                if let qrImage {
                    Image(uiImage: qrImage)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 260, height: 260)
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .accessibilityLabel("QR code containing your Medical Alert Card text")

                    ShareLink(item: Image(uiImage: qrImage),
                              preview: SharePreview("CareLayer QR Code", image: Image(uiImage: qrImage))) {
                        Label("Share QR Image", systemImage: "square.and.arrow.up")
                            .frame(minHeight: CareSpacing.minTouchTarget)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(CarePalette.primary)
                } else {
                    Text("Could not create a QR code for this card.")
                        .font(.body)
                }
            }
            .padding(CareSpacing.large)
        }
        .background(CarePalette.background)
        .navigationTitle("Emergency Card QR")
        .navigationBarTitleDisplayMode(.inline)
    }
}
