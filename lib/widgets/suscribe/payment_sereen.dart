import 'package:flutter/material.dart';
import 'package:cc_avenue/cc_avenue.dart';
import 'package:flutter/services.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Future<void> initiatePayment() async {
    try {
      debugPrint('Initiating payment with the following details:');
      debugPrint(
          'Transaction URL: https://test.ccavenue.com/transaction/initTrans');
      debugPrint('Cancel URL: https://emaryam.com/api/Payment/Cancel');
      debugPrint('Redirect URL: https://emaryam.com/api/Payment/Response');
      debugPrint('RSA Key URL: https://yourwebsite.com/getRSAKey');

      await CcAvenue.cCAvenueInit(
        transUrl:
            'https://secure.ccavenue.com/transaction/transaction.do?command=initiateTransaction', // For testing
        accessCode: 'AVNW31LK23AN41WNNA',
        merchantId: '3935159',
        orderId: '123456',
        amount: '1',
        currencyType: 'INR',
        cancelUrl: 'https://emaryam.com/api/Payment/Cancel',
        redirectUrl: 'https://emaryam.com/api/Payment/Response',
        rsaKeyUrl: '8AC95CB76C8E40961BAA51CADA151651',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment initiated successfully')),
      );
    } on PlatformException catch (e) {
      final errorMessage = e.message ?? 'Unknown platform error';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Failed: $errorMessage')),
      );
      debugPrint('PlatformException: $errorMessage');
    } catch (e, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
      debugPrint('Unexpected error: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CCAvenue Payment')),
      body: Center(
        child: ElevatedButton(
          onPressed: initiatePayment,
          child: const Text('Pay Now'),
        ),
      ),
    );
  }
}
