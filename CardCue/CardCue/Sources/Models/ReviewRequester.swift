import StoreKit
import UIKit

enum ReviewRequester {
    private static let hasRequestedKey = "review_has_requested"

    /// Call when the user views a real Quick Reference result — the moment
    /// the app has actually answered "which card do I use," not just when
    /// data was entered.
    static func requestReviewAfterQuickReferenceUse(cardCount: Int) {
        guard !UserDefaults.standard.bool(forKey: hasRequestedKey) else { return }
        guard cardCount >= 3 else { return }

        UserDefaults.standard.set(true, forKey: hasRequestedKey)
        guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }
        SKStoreReviewController.requestReview(in: scene)
    }
}
