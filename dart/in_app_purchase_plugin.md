To implement Google Play Billing for a one-time consumable product using Flutter and the `in_app_purchase` plugin, you'll need to follow these steps:

1. Add the `in_app_purchase` plugin to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  in_app_purchase: ^latest_version
```

Replace `latest_version` with the latest version of the plugin.

2. Import the required package in your Dart code where you want to handle the purchase:

```dart
import 'package:in_app_purchase/in_app_purchase.dart';
```

3. Initialize the plugin and query past purchases at the starting of your app:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  InAppPurchase.instance
      .isAvailable()
      .then((bool available) => available ? initStoreInfo() : null);
  runApp(MyApp());
}
```

4. Define a method to initialize and query products:

```dart
const String _kConsumableId = 'consumable_product_id'; // Replace with your actual product ID

Future<void> initStoreInfo() async {
  final bool available = await InAppPurchase.instance.isAvailable();
  if (!available) {
    // The store cannot be reached or accessed. Update the UI accordingly.
    return;
  }

  final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(
      {_kConsumableId}.toSet());

  if (response.notFoundIDs.isNotEmpty) {
    // Handle the error if any product IDs were not found.
  }

  List<ProductDetails> products = response.productDetails;
  // Store the products for displaying to users.
}

```

5. Create a method to handle purchase logic including buying a product:

```dart
Future<void> buyConsumable(ProductDetails productDetails) async {
  final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
  await InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
}

// This will be called after the user decides to buy the consumable
void onBuyConsumable() async {
  try {
    ProductDetails productDetails = // Get the product details for the consumable
    await buyConsumable(productDetails);
  } on Exception catch (e) {
    // Handle errors, such as failed purchase, connectivity issues, etc.
  }
}

```

6. Listen to the purchase stream to update your UI or deliver the product when the purchase flow finishes:

```dart
void listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
  purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      // Show some UI to inform your user the purchase is pending
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        // Handle error or show an error message
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // Deliver the product and mark the purchase as complete
        bool valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        } else {
          // Handle invalid purchase
        }
      }
    }
  });
}

@override
void initState() {
  super.initState();
  final Stream<List<PurchaseDetails>> purchaseUpdated = 
      InAppPurchase.instance.purchaseStream;
  _subscription = purchaseUpdated.listen(
    (purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    },
    onDone: () {
      _subscription.cancel();
    },
    onError: (error) {
      // handle error here.
    },
  );
}

```

7. Optionally, verify the purchase with your backend server or using Google Play's servers.

```dart
Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
  // IMPORTANT: Always verify a purchase before delivering the product
  // Implement your own verification logic using purchaseDetails
  return true; // return 'true' only if verified successfully.
}
```

8. Remember to dispose of the purchase stream subscription when the state object is disposed:

```dart
@override
void dispose() {
  _subscription?.cancel();
  super.dispose();
}
```

9. Next, set up your main UI to call `onBuyConsumable` when a user hits the "buy" button for your consumable.

This is a high-level overview, and details may vary based on your product requirements and app architecture. Always follow the best practices from the official `in_app_purchase` plugin documentation and test your purchase flows thoroughly.

Remember to handle all possible edge cases, such as purchase cancellations, interruptions, and network errors. Ensure user data is secure, and verify purchases to prevent fraud.
